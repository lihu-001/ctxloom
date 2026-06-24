#!/bin/bash
# ctxloom PostToolUse hook — 文件写入时设置标记，供 Stop hook 读取
input=$(cat)

# 提取文件路径
file=$(echo "$input" | python3 -c "
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
session_id=$(echo "$input" | python3 -c "
import json, sys
print(json.load(sys.stdin).get('session_id', 'default'))
" 2>/dev/null)

touch "${TMPDIR:-/tmp}/.ctxloom-dirty-${session_id}"
