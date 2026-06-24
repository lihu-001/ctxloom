#!/bin/bash
# ctxloom Stop hook — 本轮有文件修改时提醒运行 6-retrospective
input=$(cat)

# 防死循环：hook 触发的停止直接退出
active=$(echo "$input" | python3 -c "
import json, sys
print(json.load(sys.stdin).get('stop_hook_active', False))
" 2>/dev/null)
[[ "$active" == "True" ]] && exit 0

# 读取 session_id
session_id=$(echo "$input" | python3 -c "
import json, sys
print(json.load(sys.stdin).get('session_id', 'default'))
" 2>/dev/null)

FLAG="${TMPDIR:-/tmp}/.ctxloom-dirty-${session_id}"

# 本轮没有文件修改，静默退出
[[ ! -f "$FLAG" ]] && exit 0

# 清除标记
rm -f "$FLAG"

echo "[ctxloom] 本轮修改了文件。请判断是否需要调用 6-retrospective，将规则或经验沉淀到 .context/ 或 memory。"
