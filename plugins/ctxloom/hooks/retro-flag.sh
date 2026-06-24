#!/bin/bash
# ctxloom PostToolUse hook — 文件写入时设置标记，供 Stop hook 读取
input=$(cat)

# 探测可用的 python：优先 python3，回退 python（Windows 官方装的常叫 python）。
# 都没有就静默退出——hook 是锦上添花，缺 python 不该阻断会话。
PY=$(command -v python3 || command -v python)
[[ -z "$PY" ]] && exit 0

# 提取文件路径
file=$(echo "$input" | "$PY" -c "
import json, sys
ti = json.load(sys.stdin).get('tool_input', {})
print(ti.get('file_path', ti.get('path', '')))
" 2>/dev/null)

# 无路径或无意义文件，跳过
[[ -z "$file" ]] && exit 0
[[ "$file" == *".git/"* ]] && exit 0
[[ "$file" == *"node_modules/"* ]] && exit 0
[[ "$file" == *"/.claude/projects/"*"/memory/"* ]] && exit 0

# 读取 session_id，用于隔离多个并发会话
session_id=$(echo "$input" | "$PY" -c "
import json, sys
print(json.load(sys.stdin).get('session_id', 'default'))
" 2>/dev/null)

# 标记文件定位：优先用 Claude Code 注入的 CLAUDE_PROJECT_DIR（两个 hook 都能拿到、路径固定，
# 比 TMPDIR 在 Windows 上跨 hook 更可靠），回退到 TMPDIR/tmp。
if [[ -n "$CLAUDE_PROJECT_DIR" ]]; then
  flag_dir="$CLAUDE_PROJECT_DIR/.claude"
  mkdir -p "$flag_dir" 2>/dev/null
else
  flag_dir="${TMPDIR:-/tmp}"
fi

# 标记文件同时充当「本轮改动路径清单」：每行一个被改文件的路径，
# 供 Stop hook 读取以判断是否动了需求/设计文档、需不需要校验评审小节。
echo "$file" >> "${flag_dir}/.ctxloom-dirty-${session_id}"
