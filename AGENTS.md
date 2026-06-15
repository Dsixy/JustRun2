# JustRun2 — Agent 工作流

Godot 4.2.2 Roguelike 项目 **打磨阶段** 的多 Agent 编排说明。

## 快速开始

1. 主 Agent 读取 `.cursor/rules/agent-workflow.mdc`
2. 复杂任务启用 skill：`justrun-orchestrator`、`justrun-polish`
3. 委派子 Agent：`.cursor/agents/*.md`（`@architect` `@programmer` 等）
4. 完成前运行：`powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate.ps1`
5. 首次克隆后运行：`powershell -NoProfile -ExecutionPolicy Bypass -File scripts/setup-hooks.ps1`（启用提交前验证）

## 角色一览

| Agent | 文件 | 只读 | 职责 |
|-------|------|------|------|
| architect | `.cursor/agents/architect.md` | ✓ | 架构与重构方案 |
| programmer | `.cursor/agents/programmer.md` | | 实现与修复 |
| tester | `.cursor/agents/tester.md` | ✓ | 回归与验收标准 |
| designer | `.cursor/agents/designer.md` | ✓ | 数值与体验策划 |
| artist | `.cursor/agents/artist.md` | ✓ | UI/视觉建议 |
| reviewer | `.cursor/agents/reviewer.md` | ✓ | 代码审查 |

## AgentQuery 协议

跨 Agent 通信使用 JSON，完整 schema：`.cursor/skills/justrun-orchestrator/agent-protocol.md`

```
orchestrator ──AgentQuery──► subagent
subagent ──AgentResponse──► orchestrator ──► 人类 Handoff
```

**禁止**：子 Agent 之间直接委派；未读代码即断言行为。

## 标准流水线（打磨）

```
用户任务
  → 主 Agent 拆单（POLISH-NNN）
  → 并行只读分析（architect / tester / designer / artist）
  → programmer 实现
  → reviewer + tester
  → validate.ps1
  → Handoff 模板（见 agent-protocol.md）
  → 人类试玩验收
```

## 验证门禁

| 层级 | 触发 | 命令 |
|------|------|------|
| Agent 停手 | ~~Cursor `stop` hook~~（已暂时关闭） | 提醒跑 validate |
| 本地提交 | `.githooks/pre-commit` | `scripts/validate.ps1` |
| 可选 CI | GitHub Actions | 同 validate 脚本 |

### 环境要求

- Godot **4.2.2+**（本机可用 4.6.1；路径已写入 `scripts/find-godot.ps1`）
- 可选覆盖：`$env:GODOT_BIN = '...\Godot.exe'`
- 可选：`pip install gdtoolkit` → `gdlint`

`validate.ps1` 默认 **ParseCheck**（快速 load 核心 `.gd`），**不会**启动主菜单或进入可玩循环；完整资源导入用 `-Import`（带超时）。手测试玩由 `@tester` 清单单独覆盖。

## Worktree

- 配置：`.cursor/worktrees.json`（新 worktree 自动 `setup-hooks`）
- 实验分支在独立 worktree，避免污染主工作区
- 合并：`/apply-worktree` · 清理：`/delete-worktree`

## Cursor Hooks

`.cursor/hooks.json`：

- `sessionStart` — 注入打磨阶段上下文
- `subagentStart` — 角色边界提醒
- ~~`stop` — 验证提醒~~（已关闭，待 `validate.ps1` 修好后恢复）
- `beforeShellExecution` — 拦截危险 git 命令

## Slash 命令

- `/polish` — 见 `.cursor/commands/polish.md`

## Handoff（人类验收）

```markdown
## 任务
## 变更（文件 + 说明）
## 验证（validate + 手测清单）
## 风险 / 刻意未做
## 请确认：可试玩 / 需继续
```

## 子 Agent 创建说明

自定义子 Agent 位于 `.cursor/agents/<name>.md`，YAML frontmatter 支持 `name`、`description`、`readonly`、`model`。

主 Agent 根据 `description` 自动委派，也可显式 `@programmer` 调用。
