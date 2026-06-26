# .ctxloom/ 目录结构详解

`.ctxloom/` 的标准结构如下。**带 `.md` 后缀的是文件，其余都是文件夹**。除 `README.md` 外，每个 `.md` 文件头部都带一段 YAML frontmatter 标明身份（见 `frontmatter.md`）：

```
.ctxloom/
    README.md                        # 文件：本目录的导览与使用约定（含 Frontmatter 规范，唯一可带 okf_version 的文件）
    log.md                           # 文件：上下文目录的演进日志（可选，记结构与架构级变更，最新在前）
    project.md                       # 文件：项目背景、技术栈、整体架构（架构权威来源）
    learnings.md                     # 文件：踩坑经验与临时约定的沉淀（经验回流，6 追加）
    pending.md                       # 文件：待确认问题的暂存区（开放问题，确认后清理）
    rules/                           # 文件夹：编码前参考的规则基线
        README.md                    # 文件：本目录用途说明 + 各规则文件导引
        code-style.md                # 文件：命名 / 格式 / 注释等外观风格
        coding.md                    # 文件：分层职责 / 异常 / 日志 / 事务 / DTO 转换等工程约定
        build.md                     # 文件：构建命令（下游 3/4/5 强依赖）
        testing.md                   # 文件：测试框架与命令、难测部分的手动验证（下游 3/4/5 强依赖）
        security.md                  # 文件：本项目技术栈的安全高危点（下游 2/5 强依赖）
        other.md                     # 文件：其他项目特有约定（提交格式、命名前缀等）
    requirements/                    # 文件夹：各功能的需求活文档
        README.md                    # 文件：本目录用途说明 + 功能需求索引（OKF index 风格）
        <功能>.md                    # 文件：某功能的需求活文档（一功能一份，无日期戳）
    designs/                         # 文件夹：各功能的技术设计活文档
        README.md                    # 文件：本目录用途说明 + 索引
        <功能>.md                   # 文件：某功能的技术设计活文档
    tasks/                           # 文件夹：执行阶段的任务活文档
        README.md                    # 文件：本目录用途说明
        current.md                   # 文件：当前在做什么、走到哪一步、下一步是什么
        <功能>.md                    # 文件：某功能的实现计划与执行进度活文档
```

## 活文档模型

`requirements/`、`designs/`、`tasks/` 下的 `<功能>.md` 是按功能纵切的**活文档**：同一个功能从需求到设计到执行用**同名文件**贯穿（如 `requirements/coupon.md` → `designs/coupon.md` → `tasks/coupon.md`），顺着同名文件就能看清一个功能的全貌。

**活文档模型（取代日期戳快照）**：过程文档不再用 `<标题>-需求分析-yyyyMMdd.md` 这种带日期戳的历史快照，而是一个功能一份**活文档**，始终反映该功能的当前事实。澄清/设计/执行过程中的决策**直接写进活文档**（不再单开 `-草稿-yyyyMMdd` 文件）；多数时候团队要的是最新版，不是版本堆。需要回看历史时，靠 git 历史，而非堆文件。

## 功能完成标记

功能交付后，由 `5-committing-changes` 把该功能从 `tasks/current.md` 移除，并将 `requirements/<功能>.md`、`designs/<功能>.md`、`tasks/<功能>.md` 的 frontmatter `status` 改为 `delivered`——活文档本身留在原处供后续参考，git history 记录完整演进过程。

## 目录契约的单一来源

上面这棵目录树是整套 0–6 技能流程的**权威定义**。后续技能（`1-requirements-analysis` 到 `6-retrospective`）在落盘、读取规则与记忆时会引用其中的具体路径（如 `requirements/<功能>.md`、`rules/build.md`、`rules/security.md`、`learnings.md`）。若要调整结构（重命名或移动目录），**以这里为准**，并同步更新引用这些路径的技能，避免契约在多处漂移。
