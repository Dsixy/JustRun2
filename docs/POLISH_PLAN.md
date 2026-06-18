# JustRun2 Polish 计划书

> 最后更新：2026-06-15  
> 阶段：玩法完整 → 细节打磨 → 可试玩样本  
> 依据：[patch.md](patch.md) · [wiki/](wiki/) · [Just Run2.md](Just%20Run2.md)

## 已确认决策

| 项 | 决策 |
|----|------|
| 元进度 | 启用 `config.save()` + 事件解锁（默认仅解锁手枪） |
| 波次 | 单局 **10 波**；第 **3** 波 carmor、第 **6** 波 alew、第 10 波 Boss |
| 开局 | 武器 / 装甲臂与角色绑定，**不自选**；初始仅 **阿猴** 可选 |
| 升级 | **+2** 天赋点 / 级（代码为主）；**+3** 商店刷新 / 级（文档为主，可存储） |
| 商店 | 一律扣钱；无首购免费；无屏蔽武器；定价以 `Utils.set_price` 为准 |
| 元素反应 | 📋 暂不实现（patch + 百科保留设计） |
| 文案 | 统一中文 |
| validate | 默认 `-ParseCheck`；`-Import` 可选且带超时 |

---

## 任务总览

| 阶段 | 主题 | 条目数 |
|------|------|--------|
| Phase 0 | 试玩阻断 | 6（✅ 已完成） |
| **Phase A** | **patch 对齐（代码待补）** | **12** |
| Phase 1 | 体验抛光 | 6 |
| Phase 2 | 架构清理 | 8 |
| Phase 3 | 锦上添花 | 8 |
|  backlog | 长线 / 内容向 | 4 |

---

## Phase 0 — 试玩阻断修复 ✅

| ID | 状态 | 任务 | 文件 |
|----|------|------|------|
| POLISH-001 | ✅ | 死亡/胜利面板中文 +「返回主菜单」 | `scene.gd` |
| POLISH-002 | ✅ | 升级飘字「升级！」「天赋点+2」（不弹天赋板） | `scene.gd`, `utils.gd`, `damage_label.gd` |
| POLISH-003 | ✅ | `Rest Time` →「剩余时间」 | `stats_ui.gd` |
| POLISH-004 | ✅ | 首局波波猫商店提示 + 正确关闭 UI 栈 | `scene.gd`, `note_board.gd` |
| POLISH-005 | ✅ | B 键提示「背包/武器」 | `scene.tscn` |
| POLISH-006 | ✅ | 商店空武器池 guard | `shop_board.gd` |

---

## Phase A — patch 对齐（代码待补充）

> 来源：`patch.md` 裁决 + [wiki/meta/sources.md](wiki/meta/sources.md) 实现度表。  
> **优先于 Phase 1 中与同一项冲突的任务。**

### A1 · 流程与选角

| ID | 状态 | 任务 | 文件 | DoD |
|----|------|------|------|-----|
| POLISH-A01 | ✅ | 选角页 **初始仅阿猴**；卡莫 / 阿女剧情后写入 `CharacterUnlock` 并开放 | `character_select_screen.gd`, `game_info.gd` | 新档只能选 aho；触发剧情后重启可选对应角色 |
| POLISH-A02 | ✅ | 阿女剧情波次 **7 → 6**；事件键 `first_to_wave_7` → `first_to_wave_6` + 旧档迁移 | `scene.gd`, `game_info.gd` | 与 patch / 百科一致 |
| POLISH-A03 | ✅ | 剧情解锁时同步 **解锁角色**（非仅 unlock_weapon） | `scene.gd`, `game_info.gd` | 第 3 波后可选 carmor；第 6 波后可选 alew |

### A2 · 等级与商店

| ID | 状态 | 任务 | 文件 | DoD |
|----|------|------|------|-----|
| POLISH-A04 | ✅ | 每次升级 **`refreshTime += 3`**（可跨波存储） | `base_player.gd` 或 `player_updgrade` | 升级后刷新次数 +3；与 +2 天赋同次触发 |
| POLISH-A05 | ✅ | **等级首次 10** → 解锁冰霜手镯 `hail_brace` | `scene.gd` `_on_level_triggered`, `Events` | 到 10 级 emit + unlock；持久化 |

### A3 · 武器解锁事件（patch：这些事件都加上）

| ID | 状态 | 条件 | 武器 key | 文件 hint |
|----|------|------|----------|-----------|
| POLISH-A06 | ✅ | 单局消费 ≥ **4000** 金币 | `delivery_guy` | 运行时累计 `money_spent` |
| POLISH-A07 | ✅ | **卡莫** 累计击杀 ≥ **5000** | `stellar_wrath` | 按角色分统计 |
| POLISH-A08 | ✅ | 单局获得 ≥ **10000** 金币 | `coin_gun` | 运行时累计 `money_earned` |
| POLISH-A09 | ✅ | 通关时武装板 **均有 DoT 类武器/效果** | `spider_silk` | `final_results` 或 win 前检测 |
| POLISH-A10 | ✅ | 累计拾取植物 ≥ **100**（跨局） | `perfume_bottle` | `config` 计数 |
| POLISH-A11 | ✅ | 属性满 20 补全：明确 **仅 dexterity** 解锁扑克（去掉 agility 重复） | `scene.gd` | 与设计「熟练 20」一致 |
| POLISH-A12 | ✅ | 审计其余武器默认 / 条件解锁（狙击/霰弹/激光剑/毒瓶等），缺的补事件或文档标注 | `game_info`, `scene.gd` | 与 [wiki/unlocks.md](wiki/unlocks.md) 一致 |

**实现建议**：新增 `RunStats.gd`（Autoload 或挂 `scene`）统一记录单局消费、获得金币、击杀、使用角色，供 A06–A10 与 A14 共用。

### A4 · Boss

| ID | 状态 | 任务 | 文件 | DoD |
|----|------|------|------|-----|
| POLISH-A13 | ⬜ | 镰刀 **`shout()`**：全场小怪挂 **威慑 Buff**（伤害 **+50**） | `mr_scythe.gd`, 新 Buff 场景/脚本 | 技能 4 可触发；与小怪 `damage.baseAmount` 或独立加值 |

> patch 称 Buff「狂暴」；设计文档称「威慑」— 指 **敌人** 攻击加强，非玩家 HasteBuff。

### A5 · 战斗统计

| ID | 状态 | 任务 | 文件 | DoD |
|----|------|------|------|-----|
| POLISH-A14 | ✅ | **`RunStats`**：单局击杀、金币收支、使用角色、波次等 | 新 `script/run_stats.gd` | 死亡/胜利可读出；为成就与结算 UI 预留 |
| POLISH-A15 | ✅ | 通关 / 失败 **结算面板** 展示 RunStats 摘要 | `scene.gd`, `note_board` 或新 UI | 与 POLISH-011 可合并实现 |

### A6 · 文案 / 命名（小）

| ID | 状态 | 任务 | 文件 |
|----|------|------|------|
| POLISH-A16 | 🚫 | `option` / **浮游炮** — 代理攻击架构撤销，加入 `DISABLED_WEAPONS` | `game_info.gd` | 待架构重做后再开 |

---

## Phase 1 — 体验抛光

| ID | 状态 | 任务 | 文件 | 备注 |
|----|------|------|------|------|
| POLISH-007 | ✅ | 选角页角色定位文案 + 选中高亮 / 未选灰显 + 未解锁灰显 | `player_display`, `character_select_screen` | 三人全展示 |
| POLISH-008 | ✅ | 其余 UI 文案中文化 | `note_board.tscn` 等 | 默认占位改中文 |
| POLISH-009 | ⏭️ | 镜子 5% / 植物掉落 2% | — | **用户指定：掉落数值不改** |
| POLISH-010 | ✅ | Boss HP | `mr_scythe.gd` | **30000** |
| POLISH-011 | ✅ | 通关摘要 | 见 **POLISH-A15** | 避免重复做两次 |
| POLISH-012 | ✅ | 图鉴解锁式武器展示 + 合成逐级揭示描述 | `illustrated_handbook.gd`, `book_slot.gd`, `game_info.gd` | 描述来自武器场景 |

---

## Phase 2 — 架构小清理

| ID | 状态 | 任务 | 文件 |
|----|------|------|------|
| POLISH-013 | ✅ | 视口常量提取 | `viewport_constants.gd`, `utils.gd` |
| POLISH-014 | ✅ | 合并 `carmor_come` / `alew_come` 剧情辅助 | `scene.gd` `_story_guest_arrives` |
| POLISH-015 | ✅ | `properties` 共享 const | `player_skill_properties.gd` |
| POLISH-016 | ✅ | 武器 ID 命名常量 | `weapon_ids.gd` |
| POLISH-017 | ✅ | 抽出 WaveDirector / LootSpawner | `scene/wave_director.gd`, `scene/loot_spawner.gd` |
| POLISH-018 | ✅ | 10 波原生逻辑（剧情/经济/掉落） | `scene.gd` |
| POLISH-019 | ✅ | config.save + 事件解锁 | `game_info.gd` |
| POLISH-020 | ✅ | 清理 `scene/*.tmp` + `.gitignore` | 仓库 |

---

## Phase 3 — 锦上添花

| ID | 状态 | 任务 |
|----|------|------|
| POLISH-021 | ✅ | Esc 提示、stats_ui 整合 B/M/T | `stats_ui.gd`, `pause_menu` |
| POLISH-022 | ✅ | 图鉴武装板槽位说明 | `illustrated_handbook.gd` |
| POLISH-023 | ⬜ | 商店重复武器降权 |
| POLISH-024 | ⬜ | 漏捡自动拾取率微调 |
| POLISH-025 | ✅ | 弱化 `GameInfo.mainscene` | `game_info.gd` run scene accessors |
| POLISH-026 | ⬜ | 开放 forgetfulness（见 backlog） |
| POLISH-027 | ✅ | 修复 main_menu UID | `main_menu.tscn` |
| POLISH-028 | ⬜ | cheat 移入 Debug 菜单 |

---

## Backlog — 设计保留、暂不排期

| ID | 任务 | 来源 | 说明 |
|----|------|------|------|
| POLISH-B01 | 健忘症：地图 x ≈ **−100000** 触发三遇剧情 → 火箭炮 | patch §流程-6 | 先文档 / 百科，后实现 |
| POLISH-B02 | 大力士：单局击杀 **3000** → 解锁 + `maiden_touch` | 设计文档 | 依赖 **POLISH-A14** 击杀统计 |
| POLISH-B03 | **元素反应** 完整矩阵 | patch §元素 | 刻意不做直至专项 |
| POLISH-B04 | 12+ **计划中武器**（冲锋枪、加特林等） | 设计文档 | 见 [wiki/weapons/planned.md](wiki/weapons/planned.md) |
| POLISH-B05 | `maiden_touch` / `moon_phase_dial` 实装并移出 DISABLED | 设计未完成 | 现 `game_info.DISABLED_WEAPONS` |

---

## 建议实施顺序

```
Phase A（patch 对齐）
  A04 升级 +3 刷新          ← 小改、体验明显
  A02 阿女第 6 波           ← 与百科一致
  A01 / A03 选角解锁        ← 流程核心
  A05 10 级冰霜手镯
  A14 → A06–A10 解锁事件    ← 先 RunStats 再解锁
  A13 Boss 威慑
  A11 / A12 / A16           ← 收尾
Phase 1 体验抛光
Phase 2 架构（按需）
Phase 3 / Backlog
```

---

## 手测验收清单

### P0（试玩样本）
- [ ] 主菜单 → 选角 → 战斗无崩溃
- [ ] WASD / 攻击 / 击杀掉落
- [ ] 波波猫 → 商店 → 购买
- [ ] B/M/T / Esc
- [ ] 升级飘字 + 天赋点 +2
- [ ] 死亡 / 10 波通关回主菜单
- [ ] `validate.ps1` 通过

### P1（patch 对齐后追加）
- [ ] 新档仅可选阿猴
- [ ] 第 3 波 carmor 剧情 → 激光枪 + 可选卡莫
- [ ] 第 **6** 波 alew 剧情 → 花刀 + 10 点 + 可选阿女
- [ ] 升级后 `refreshTime` +3
- [ ] 10 级解锁冰霜手镯
- [ ] 武器解锁持久化
- [ ] 第 10 波 Boss；`shout` 威慑可见
- [ ] 结算页展示击杀 / 金币等（A15）

---

## 刻意不做

- 开局图鉴选武 / 自选装甲臂（patch 删除）
- 商店首购免费、每波屏蔽武器（patch 删除）
- 30 波流程与第 29/30 波 Popocat 剧情（patch 删除）
- 元素反应矩阵（patch TODO）
- 重做武器攻击顺序 / 回合制构想
- 全面 ECS 或大规模重命名（`dexterrity` 等单开任务）
- 波次表外置 JSON

---

## 文档同步

完成 POLISH 条目后更新：

- [wiki/meta/sources.md](wiki/meta/sources.md) 实现度表
- 对应 [wiki/](wiki/) 条目（去掉 ⚠️ / 📋）
- 本文件任务 **状态** 列

