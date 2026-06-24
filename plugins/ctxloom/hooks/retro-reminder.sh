#!/bin/bash
# ctxloom Stop hook — 本轮有文件修改时提醒运行 6-retrospective
input=$(cat)

# 探测可用的 python：优先 python3，回退 python（Windows 官方装的常叫 python）。
# 都没有就静默退出——hook 是锦上添花，缺 python 不该阻断会话。
PY=$(command -v python3 || command -v python)
[[ -z "$PY" ]] && exit 0

# 防死循环：hook 触发的停止直接退出
active=$(echo "$input" | "$PY" -c "
import json, sys
print(json.load(sys.stdin).get('stop_hook_active', False))
" 2>/dev/null)
[[ "$active" == "True" ]] && exit 0

# 读取 session_id
session_id=$(echo "$input" | "$PY" -c "
import json, sys
print(json.load(sys.stdin).get('session_id', 'default'))
" 2>/dev/null)

FLAG_DIR="${TMPDIR:-/tmp}"
[[ -n "$CLAUDE_PROJECT_DIR" ]] && FLAG_DIR="$CLAUDE_PROJECT_DIR/.claude"
FLAG="${FLAG_DIR}/.ctxloom-dirty-${session_id}"

# 本轮没有文件修改，静默退出
[[ ! -f "$FLAG" ]] && exit 0

# 校验本轮改过的需求/设计文档是否已追加评审小节（评审报告/评审记录）。
# 这是把「评审是交付前置」这条软约束做成可机械校验的硬提醒：评审能不能写得好 hook 管不了，
# 但「改了需求/设计文档却没有评审小节」是文件系统可观测的状态，缺了就报出来。
missing=$(echo "$FLAG" | "$PY" -c "
import sys, os, re
flag = sys.stdin.read().strip()
seen, bad = set(), []
try:
    paths = open(flag, encoding='utf-8').read().splitlines()
except OSError:
    paths = []
for p in paths:
    p = p.strip()
    if not p or p in seen:
        continue
    seen.add(p)
    norm = p.replace('\\\\', '/')
    # 只校验 .context/requirements 或 .context/designs 下的 .md 活文档
    if not re.search(r'/\.context/(requirements|designs)/', norm):
        continue
    if not norm.endswith('.md') or norm.endswith('/README.md'):
        continue
    try:
        body = open(p, encoding='utf-8').read()
    except OSError:
        continue
    if ('评审报告' not in body) and ('评审记录' not in body):
        bad.append(os.path.basename(p))
print('|'.join(bad))
" 2>/dev/null)

# 清除标记
rm -f "$FLAG"

# 注意：Stop hook 的「纯 stdout + 退出码 0」只会进 debug log，用户和 Claude 都看不到。
# 必须用 hookSpecificOutput.additionalContext 把提醒注入到 Claude 上下文，它才能看到并据此判断
# （additionalContext 为非阻断方式；配合开头的 stop_hook_active 判断，不会造成死循环）。
msg="[ctxloom] 本轮修改了文件。请判断是否需要调用 6-retrospective，将规则或经验沉淀到 .context/ 或 memory；若本次没有值得沉淀的内容，直接结束即可，不必强凑。"
if [[ -n "$missing" ]]; then
  msg="[ctxloom] 注意：本轮改动的需求/设计活文档（${missing}）末尾未发现评审小节（需求评审报告 / 设计评审记录）。按 1-requirements-analysis / 2-technical-design 的硬性规则，文档落盘后必须经独立评审并追加评审小节才算定稿——请确认是否漏掉了评审步骤。${msg}"
fi

# 用 python 生成转义安全的 JSON，避免文件名里出现引号等字符破坏 JSON。
echo "$msg" | "$PY" -c "
import json, sys
m = sys.stdin.read().rstrip('\n')
print(json.dumps({'hookSpecificOutput': {'hookEventName': 'Stop', 'additionalContext': m}}, ensure_ascii=False))
"
