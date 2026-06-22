# ctxloom

**让 AI 开发协作有记忆、有流程、越用越聪明。**

普通 AI 辅助开发有三个根本痛点：每次会话从零开始、决策散落在对话里、经验永远留不下来。ctxloom 用一套 Claude Code 技能插件正面解决这三件事。

## 它和其他 AI 编程工具有什么不同

| | 普通 AI 编程工具 | ctxloom |
|---|---|---|
| **项目记忆** | 每次会话从零 | `.context/` 持久化项目背景、架构、规则 |
| **开发流程** | 自由发挥，容易跑偏 | 0–6 有序流水线，关键节点人工确认 |
| **经验沉淀** | 对话结束即消失 | 复盘自动回写规则库与经验库 |
| **语言适配** | 内置特定语言规范 | 规则存在项目里，技能本身语言无关 |
| **评审把关** | 无 | 需求、设计阶段各有独立评审智能体 |

## 核心：`.context/` 知识飞轮

ctxloom 在你的项目根目录维护一套 `.context/` 活文档系统。每次开发的产出——需求决策、技术方案、执行计划、踩的坑、定的约定——都沉淀进来，下一次开发直接复用，不再重来。

```
.context/
├── project.md          # 项目背景、技术栈、整体架构（权威来源）
├── learnings.md        # 踩坑经验与临时约定（复盘后滚动追加）
├── pending.md          # 待确认问题的暂存区
├── rules/              # 编码前的规则基线（语言无关，按项目填写）
│   ├── build.md        # 构建命令（计划/执行/提交阶段强依赖）
│   ├── testing.md      # 测试框架与命令（计划/执行/提交阶段强依赖）
│   ├── security.md     # 本项目安全高危点（设计/提交阶段强依赖）
│   ├── code-style.md   # 命名/格式等外观风格
│   ├── coding.md       # 分层/异常/事务等工程约定
│   └── other.md        # 其他项目特有约定
├── requirements/       # 需求活文档（每功能一份，贯穿全生命周期）
├── designs/            # 技术设计活文档
├── tasks/              # 执行计划活文档
│   └── current.md      # 当前在途功能的轻量索引
└── archive/            # 已交付功能的提炼归档
```

**活文档而非快照。** 同一功能的需求、设计、执行用同名文件贯穿（`coupon.md` 从 `requirements/` 走到 `archive/`），始终反映当前事实，历史靠 git 追溯，不堆日期戳文件。

**规则库与经验库分工。** `rules/` 存放能指导未来任意新代码的通用规则；`learnings.md` 存放偶发教训。每次复盘后，够格的经验提炼进规则，不够格的留在经验库——项目越做规则越准。

**语言无关。** 技能本身不写死任何语言命令，所有项目特有的构建/测试/安全内容固化在 `rules/` 里，技能按需读取，可复用到 Java、Vue、Go 等任何项目。

## 开发流水线：0–6 + bugfix

```
0-init          → 建立 .context/ 知识地基
1-requirements  → 需求澄清（独立评审把关）
2-design        → 技术设计（独立评审 + 防过度设计）
3-plan          → 拆解实现步骤（含测试策略）
4-execute       → 落地编码（按计划、按步验证）
5-commit        → 质量清单 + 归档 + 提交
6-retrospective → 复盘回写规则库与经验库
```

`bugfix` 是并行的独立主线：小 bug 复现→根因→修复一气呵成，复杂 bug 才升级走 2/3/4，不为简单问题套重流程。每个技能都可**单独运行**，不强制走完整流水线。

## 包含的技能

| 技能 | 作用 |
|---|---|
| `0-init-project-context` | 初始化/刷新 `.context/`，提炼项目背景、架构与规则基线 |
| `1-requirements-analysis` | 逐步澄清需求，产出可落地的需求分析，经独立评审把关 |
| `2-technical-design` | 把需求转成技术设计（方案/分层/数据库/接口），经独立评审 |
| `3-writing-plan` | 把设计拆成有序、可验证的实现步骤，内置分层 TDD 策略 |
| `4-executing-plan` | 按计划落地编码，验证通过后回写进度，汇总执行报告 |
| `5-committing-changes` | 质量清单检查、过程文档归档提炼、按项目惯例提交 |
| `6-retrospective` | 把坑与约定提炼回规则库/经验库，让项目越用越聪明 |
| `bugfix` | 轻量修复线：复现 → 根因 → 分流 → 修复 → 验证 → 沉淀 |

技能会被 Claude 根据上下文**自动触发**；也可显式调用，如 `/ctxloom:bugfix`、`/ctxloom:2-technical-design`。

## 安装

```bash
# 1. 添加本市场（GitHub）
/plugin marketplace add lihu-001/ctxloom

# 也支持完整 git 地址：
# /plugin marketplace add https://github.com/lihu-001/ctxloom.git

# 2. 安装插件
/plugin install ctxloom@ctxloom
```

安装时可选作用域：`User`（个人全局，跨所有项目）、`Project`（写入 `.claude/settings.json`，随仓库共享给协作者）、`Local`（仅当前项目、仅自己）。

## 更新

```bash
/plugin marketplace update ctxloom
```

## 许可

MIT © lihu
