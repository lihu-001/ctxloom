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

## 修改本仓库时的注意事项

- **目录结构契约**：`.context/` 的标准目录树定义在 `0-init-project-context/SKILL.md` 的「目录结构」节，是 1–6 所有技能引用路径的**单一来源**。若调整目录结构，必须同步更新所有引用该路径的技能。
- **版本维护**：插件版本号在 `plugins/ctxloom/.claude-plugin/plugin.json` 与 `.claude-plugin/marketplace.json` 两处同步维护。
- **Frontmatter 规范**：规范定义在 `0-init-project-context/SKILL.md` 的「Frontmatter 规范」节，下游技能写文档时按此填写。消费时必须宽容（容忍缺字段、未知 `type`）。
