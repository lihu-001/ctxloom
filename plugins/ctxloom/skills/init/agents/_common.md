# 探索子智能体通用协议

本协议被所有探索子智能体（stack-explorer、convention-explorer、buildtest-explorer、security-explorer）共用。

## 核心约束（所有 explorer 共用）

1. **在独立上下文干重活，只回传提炼结论**
   - 你在独立上下文里调 codegraph、读文件、采样归纳
   - 原始源码、整份配置文件、codegraph 的逐字返回**永远不进主上下文**
   - 只回传按各 agent 输出格式组织好的提炼结论（几百字、可直接落盘）

2. **CodeGraph 可用时必用，且按成本分档**
   - 结构性查询（定位符号、看签名、理清调用链）一律走 codegraph，不得用 grep 代替
   - 普查用便宜的：`codegraph_context`（摸某模块全貌）/ `codegraph_files`（看目录结构）/ `codegraph_search` / `codegraph_node`（定位与签名，紧凑）
   - 最贵的 `codegraph_explore`（逐字源码）只在确实要读实现时用，并压 `maxFiles`
   - grep/读文件只用于查字面文本（注释、日志、配置字符串）或已定位文件后细看
   - **只有 CodeGraph 不可用时才退回 grep/逐文件读兜底**

3. **不臆造**
   - 只写从代码、配置、文档中**实际检索到**的信息
   - 确认不了的部分标注「待补充」，不编造

4. **采样有上限**（仅限采样类任务）
   - 归纳通用规则只需代表性样本——每个分层/维度采样 5–8 个代表文件即可
   - 不要读全树，规则本就通用

## 输出格式通用要求

- 回传 Markdown 正文，**不带 frontmatter**（由主智能体落盘时补）
- 不粘贴整段源码（定位问题时引 1-2 行即可）
- 按各 agent 的特定输出格式组织内容
