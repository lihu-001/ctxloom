# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> 项目介绍见 [README.md](./README.md)。

## 仓库结构

```
ctxloom/
├── .claude-plugin/
│   └── marketplace.json          # 市场清单（列出本仓库发布的插件）
└── plugins/
    └── ctxloom/                  # 插件本体
        ├── .claude-plugin/
        │   └── plugin.json       # 插件元信息（name、version、keywords 等）
        ├── agents/               # 跨技能共用的子智能体协议
        │   └── doc-reviewer/     # 独立文档评审，1/2 技能共用
        └── skills/               # 9 个技能，各含一个 SKILL.md
            ├── init-project-context/
            │   └── agents/       # 本技能私有的 4 个探索子智能体（stack/convention/buildtest/security-explorer）
            ├── 1-requirements-analysis/
            │   └── agents/       # 本技能私有：prd-digester（大 PRD/原型消化，抽取+标疑点）
            ├── 2-technical-design/
            ├── 3-writing-plan/
            ├── 4-executing-plan/
            ├── 5-committing-changes/
            │   └── agents/       # 本技能私有：diff-reviewer（大 diff 质量审查，出定级问题清单）
            ├── 6-retrospective/
            ├── bugfix/           # bug 修复并行线
            └── dev/              # 功能开发统一入口（默认走完整流程，每步按基线档简繁自适应）
```

没有构建步骤、测试命令或依赖安装——本仓库是纯 Markdown 技能定义，无代码产物。

## 修改本仓库时的注意事项

- **目录结构契约**：`.ctxloom/` 的标准目录树定义在 `init-project-context/SKILL.md` 的「目录结构」节，是 1–6 所有技能引用路径的**单一来源**。若调整目录结构，必须同步更新所有引用该路径的技能。
- **版本维护**：插件版本号在 `plugins/ctxloom/.claude-plugin/plugin.json` 与 `.claude-plugin/marketplace.json` 两处同步维护。
- **Frontmatter 规范**：规范定义在 `init-project-context/SKILL.md` 的「Frontmatter 规范」节，下游技能写文档时按此填写。消费时必须宽容（容忍缺字段、未知 `type`）。
- **代码探索契约（CodeGraph 可用时必用）**：凡需要理解现有代码的技能（`init`、`1`、`2`、`3`、`4`、`bugfix`、`dev`）统一遵循「结构化检索强制」口径——**只要项目配置了 CodeGraph，一切结构性查询（定位符号、查签名、理清调用链、看改动波及面）就必须走 `codegraph_*`（`context`/`files`/`search`/`node`/`callers`/`callees`/`impact`/`trace`），不得用 `grep`/`find`/`cat` 代替**；`grep`/`find`/`cat` 的合法用途仅剩两类：查字面文本（注释、日志、配置字符串），以及已用 codegraph 定位到文件后的细看。**只有在 CodeGraph 确实未启用（`codegraph_status`/首个 `codegraph_*` 调用报「未初始化 / 工具不可用」）时，才退回 grep/读文件兜底**——这是降级，不是平级备选。新增或改写探索类技能时必须沿用此口径，**绝不让技能在 CodeGraph 可用时仍默认 `find | grep`**。其中 `dev` 的极简档逃生口会自己内联探索代码，该口径写在其「代码探索原则」节；标准/深度档委派给 `1`/`2`/`4`，由各技能自带的同款指引覆盖。`init` 因是**整库多维度普查**，单靠 CodeGraph 降单次成本不足以防主上下文膨胀，故第 2/3 步把探索**委派给 `skills/init-project-context/agents/` 下的 4 个 explorer 子智能体**（在独立上下文摸代码、只回传提炼结论），主智能体只指挥 + 落盘——这套「委派防膨胀 + 落盘防丢失」写在其「上下文管理」节，是 init 技能改写时必须保持的口径。
