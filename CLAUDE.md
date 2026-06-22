# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

ctxloom 是一个 Claude Code **插件市场仓库**，发布名为 `ctxloom` 的插件。该插件提供 8 个技能（skills），构成以 `.context/` 上下文工程为核心的完整研发工作流（0–6 流水线 + bugfix 并行线）。

## 仓库结构

```
ctxloom/
├── .claude-plugin/
│   └── marketplace.json          # 市场清单（列出本仓库发布的插件）
└── plugins/
    └── ctxloom/                  # 插件本体
        ├── .claude-plugin/
        │   └── plugin.json       # 插件元信息（name、version、keywords 等）
        └── skills/               # 8 个技能，各含一个 SKILL.md
            ├── 0-init-project-context/
            ├── 1-requirements-analysis/
            ├── 2-technical-design/
            ├── 3-writing-plan/
            ├── 4-executing-plan/
            ├── 5-committing-changes/
            ├── 6-retrospective/
            └── bugfix/
```

没有构建步骤、测试命令或依赖安装——本仓库是纯 Markdown 技能定义，无代码产物。

## 技能体系架构

### 核心概念：`.context/` 活文档目录

这 8 个技能的核心产物是**目标项目**根目录下的 `.context/` 目录（不在本仓库内）。它的标准子结构由 `0-init-project-context/SKILL.md` 定义，是整套技能的**权威契约**：

```
.context/
├── project.md          # 项目背景与架构（权威来源）
├── learnings.md        # 经验沉淀（6-retrospective 追加）
├── pending.md          # 待确认问题暂存
├── rules/              # 编码前规则基线（下游技能强依赖）
│   ├── build.md        # 构建命令（技能 3/4/5 强依赖）
│   ├── testing.md      # 测试方式（技能 3/4/5 强依赖）
│   ├── security.md     # 安全高危点（技能 2/5 强依赖）
│   ├── code-style.md
│   ├── coding.md
│   └── other.md
├── requirements/       # 需求活文档（1 产出）
├── designs/            # 技术设计活文档（2 产出）
├── tasks/              # 执行计划活文档（3/4 产出）
│   └── current.md      # 当前在途功能的轻量索引
└── archive/            # 已交付功能的提炼归档（5 产出）
```

### 活文档模型

- 同一功能从需求到归档用**同名文件**贯穿（如 `requirements/coupon.md` → `designs/coupon.md` → `tasks/coupon.md` → `archive/coupon.md`）
- 不带日期戳，历史靠 git 追溯
- 每份 `.md`（README 除外）头部带 YAML frontmatter，必需字段 `type`（见规范）
- 活文档开头放 bundle-relative 交叉链接行，坏链是合法的（表示尚未写的知识）

### 0–6 流水线与 bugfix 并行线

| 技能 | 产出 | 上游依赖 |
|---|---|---|
| `0-init-project-context` | `.context/` 目录骨架 + 规则文件 | 无 |
| `1-requirements-analysis` | `requirements/<功能>.md` | `.context/`（可降级） |
| `2-technical-design` | `designs/<功能>.md` | 需求文档 + `rules/` |
| `3-writing-plan` | `tasks/<功能>.md` | 设计文档 + `rules/build.md` + `rules/testing.md` |
| `4-executing-plan` | 编码 + 进度回写 | 任务活文档 |
| `5-committing-changes` | `archive/<功能>.md` + git commit | 全量代码 + 活文档 |
| `6-retrospective` | `learnings.md` + 候选规则 | 任意已完成工作 |
| `bugfix` | 修复 + `learnings.md` | 无（可降级） |

**每步可独立运行**，缺上游产物不阻塞，但会降级。

### 语言无关原则

技能定义本身不写死任何语言专属内容（不硬编码 `mvn`、`npm` 等命令）。语言相关的内容全部固化在目标项目的 `.context/rules/` 里，由下游技能按需读取。

## 修改本仓库时的注意事项

- **目录结构契约**：`.context/` 的标准目录树定义在 `0-init-project-context/SKILL.md` 的「目录结构」节，是 1–6 所有技能引用路径的**单一来源**。若调整目录结构，必须同步更新所有引用该路径的技能。
- **版本维护**：插件版本号在 `plugins/ctxloom/.claude-plugin/plugin.json` 与 `.claude-plugin/marketplace.json` 两处同步维护。
- **Frontmatter 规范**：规范定义在 `0-init-project-context/SKILL.md` 的「Frontmatter 规范」节，下游技能写文档时按此填写。消费时必须宽容（容忍缺字段、未知 `type`）。
