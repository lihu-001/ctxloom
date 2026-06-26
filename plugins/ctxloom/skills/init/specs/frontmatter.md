# Frontmatter 规范

`.ctxloom/` 是一个**自描述的知识目录**：除 `README.md` 外，每个 `.md` 文件头部都带一段 YAML frontmatter，让人和 AI 不必读技能定义就知道这份文档是什么、属于哪个功能、处于什么阶段。本文档是这套规范的**权威定义**——下游技能写文档时按此填写，init 技能新建/刷新文档时也按此填写，并把同一份规范写进 `.ctxloom/README.md` 供仓库浏览者就地查阅。

**这套规范是叠加增强，不是门禁。** 写文档时按规范填，但读文档时容忍缺字段、未知 `type`、坏链——绝不因 frontmatter 不全而拒绝处理。

## 字段定义

frontmatter 用 `---` 成对包裹，置于文件最顶部。字段分三档：

### 全局必需（唯一硬要求）

- `type` —— 标明这份文档的种类，供路由与过滤。取值见下表，**不集中注册**，未知取值按"通用文档"宽容处理。

### 全局推荐

- `title` —— 人类可读标题。缺省时可由文件名推导。
- `timestamp` —— 最后一次有意义改动的时间，精确到秒，用年月日时分秒格式 `YYYY-MM-DD HH:MM:SS`（如 `2026-06-22 14:30:05`）。

### 按 `type` 的专属字段

仅在解决实际需要时填，不强求：

| 文件 | `type` | 专属字段 | 含义 |
|---|---|---|---|
| `project.md` | `Project` | —— | 项目背景与架构权威源 |
| `rules/*.md` | `Rule` | `downstream`（可选，如 `[3, 4, 5]`） | 标明此规则是下游哪些技能的强依赖，便于精确定位 |
| `learnings.md` | `Learnings` | —— | 经验沉淀区 |
| `pending.md` | `Pending` | —— | 待确认问题暂存 |
| `requirements/<功能>.md` | `Requirement` | `feature`、`status`、`resource` | 见下 |
| `designs/<功能>.md` | `Design` | `feature`、`status` | 见下 |
| `tasks/<功能>.md` | `Task` | `feature`、`status`、`branch` | 见下 |
| `archive/<功能>.md` | `Archive` | `feature`、`status` | 见下 |

### 活文档专属字段

- `feature` —— 该文档所属功能的简短英文/拼音名（如 `coupon`），与文件名一致。它把原本只靠"文件同名"的隐式串联变成**可被聚合查询的显式关系**——按 `feature` 就能把一个功能的 需求/设计/任务/归档 全部捞出来。
- `status` —— 该功能当前所处阶段，取值：`draft`（草稿）｜`in-progress`（进行中）｜`reviewing`（评审中）｜`delivered`（已交付）。让消费方一眼分清在做/已交付，不必去翻 README 索引表。
- `resource` —— 仅 `Requirement` 用：指向 PRD / 原型的**链接或相对路径**（只存引用、不搬原件，呼应「提炼不是复制」）。无外部材料时省略。
- `branch` —— 仅 `Task` 用：执行阶段关联的 git 分支名（如 `feat/coupon`）。计划阶段可留占位、执行阶段(4)回填。

## 示例

### 需求活文档（绑定 PRD 资源）

```yaml
---
type: Requirement
title: 优惠券发放与核销
feature: coupon
status: in-progress
resource: https://lanhuapp.com/web/#/item/project/...   # 只存引用
timestamp: 2026-06-22 14:30:05
---
```

### 规则文件（标注下游强依赖）

```yaml
---
type: Rule
title: 构建命令
downstream: [3, 4, 5]
---
```

### 特殊说明

`.ctxloom/README.md` 是唯一可声明 bundle 版本的文件，其 frontmatter 可含 `okf_version: "0.1"`（其余 `README.md` 不带 frontmatter）。
