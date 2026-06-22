# ctxloom

**上下文工程驱动的完整研发工作流** —— 一套 Claude Code 技能（skills），把「从需求到交付」的开发全流程结构化，并以 `.context/` 上下文工程为核心，让项目知识随每次开发滚动沉淀、越做越聪明。

## 它解决什么

普通 AI 辅助开发的痛点是：每次会话从零开始、决策散落在对话里、经验留不下来。ctxloom 用两条主线解决这件事：

- **完整开发流程（0–6）**：把一次开发拆成有序、每步可独立运行、关键节点都让你确认的阶段，避免一路跑偏到实现才暴露。
- **bugfix 并行线**：bug 修复不套重流程——先坐实复现、用证据定位根因，简单 bug 一气呵成，复杂 bug 才升级复用 2/3/4。
- **上下文工程飞轮**：需求/设计/计划/执行的产物落成 `.context/` 活文档，规则库 + 经验库 + 复盘回流让项目越用越懂自己。

## 包含的技能

| 技能 | 作用 |
|---|---|
| `0-init-project-context` | 初始化/刷新项目上下文目录（`.context/`），建立背景、架构与规则基线 |
| `1-requirements-analysis` | 从开发视角逐步澄清需求，产出可落地的需求分析（只做需求、不做设计），经独立评审把关 |
| `2-technical-design` | 把需求转成技术设计（方案选型/分层/数据库/接口/流程），经独立评审 |
| `3-writing-plan` | 把设计拆成有序、可验证的实现步骤 |
| `4-executing-plan` | 按计划落地编码，按测试策略验证、回写进度、汇总执行报告 |
| `5-committing-changes` | 收尾的质量清单检查、过程文档归档、按惯例提交 |
| `6-retrospective` | 复盘：把坑、反复打回的问题、临时约定沉淀回规则库/经验库 |
| `bugfix` | bug 修复/线上排查的轻量流程：复现 → 根因 → 分流 → 修复 → 验证 → 沉淀 |

技能会被 Claude 根据任务上下文**自动触发**；也可显式调用，如 `/ctxloom:bugfix`、`/ctxloom:1-requirements-analysis`。

## 安装

```bash
# 1. 添加本市场（GitHub）
/plugin marketplace add lihu-001/ctxloom

# 也支持完整 git 地址：
# /plugin marketplace add https://github.com/lihu-001/ctxloom.git

# 2. 安装插件
/plugin install ctxloom@ctxloom
```

安装时可选作用域：`User`（个人全局，跨所有项目）、`Project`（写入项目 `.claude/settings.json`，随仓库共享给协作者）、`Local`（仅当前项目、仅自己）。

## 更新

```bash
/plugin marketplace update ctxloom
```

推送新版本后，使用方执行上面命令即可拉取最新。版本号在 `plugins/ctxloom/.claude-plugin/plugin.json` 与本仓库 `.claude-plugin/marketplace.json` 维护。

## 目录结构

```
ctxloom/
├── .claude-plugin/
│   └── marketplace.json          # 市场清单
├── plugins/
│   └── ctxloom/                  # 插件本体
│       ├── .claude-plugin/
│       │   └── plugin.json       # 插件清单
│       └── skills/               # 8 个技能
│           ├── 0-init-project-context/SKILL.md
│           ├── 1-requirements-analysis/SKILL.md
│           ├── 2-technical-design/SKILL.md
│           ├── 3-writing-plan/SKILL.md
│           ├── 4-executing-plan/SKILL.md
│           ├── 5-committing-changes/SKILL.md
│           ├── 6-retrospective/SKILL.md
│           └── bugfix/SKILL.md
└── README.md
```

## 许可

MIT © lihu
