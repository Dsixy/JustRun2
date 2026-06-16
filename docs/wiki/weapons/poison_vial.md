# 毒药瓶（Poison Vial）

| 字段 | 值 |
|------|-----|
| **ID** | 10 |
| **资源 Key** | `poison_vial` |
| **场景** | `scene/weapon/poison_vial.tscn` |
| **脚本** | `script/weapon/poison_vial.gd` |
| **投掷** | `scene/effect/poison_bottle.tscn` → `script/effect/poison_bottle.gd` |
| **毒圈** | `scene/effect/poison_area.tscn` → `script/effect/poison_area.gd` |
| **Buff** | `scene/buff/poison_buff.tscn` → `script/buff/poison_buff.gd` |
| **解锁（设计）** | **初始拥有** |
| **解锁（代码）** | 默认仅 `pistol`；**毒药瓶未默认解锁** 📋 |

---

## 概览

毒药瓶是 **抛物线投掷 + 地面毒圈 DoT** 武器。每次攻击随机方向甩出多瓶毒药，落地生成缩放后的 `PoisonArea`：约每秒对圈内敌人造成 **直接毒素伤害** 并附加 **中毒 Buff**（独立 DoT）。**无法暴击**（`isCrit=false`）。设计为初始武器，但元进度与角色起始武装均未包含它。

---

## 设计文档

来源：`docs/Just Run2.md` § 毒药瓶(10)

### 获取方式

**初始拥有**。

### 攻击描述

随机甩出 **3** 瓶毒药，生成毒圈；敌人 **每秒** 受到伤害并附加 **中毒 Buff**。

### 升级（设计）

| 等级 | 效果 |
|------|------|
| 1 / 3 | 额外掷出 **2 / 4** 瓶 |
| 2 | 毒圈范围增加 **40%** |
| 4 | 毒圈范围增加 **200%** |

### 数值（设计）

| 属性 | 值 |
|------|-----|
| 0 级 DPS | **7** |
| 满级 DPS | **60** |
| 攻击间隔 | **1** s |
| 基础伤害 `[0~4]` | `[3, 5, 8, 15, 30]` |
| 基础暴击率 | **0%**（无法暴击） |
| 伤害类型 | **毒素伤害** |

---

## 代码实现

### 武器脚本 `poison_vial.gd`

| 变量 | 初值 |
|------|------|
| `attackInterval` | 1 |
| `vialNum` | 3 |
| `range` | 1.0（毒圈 scale 乘数） |

**`upgrade()`**

| 等级 | 代码 |
|------|------|
| 1 | `vialNum += 2` → 5 |
| 2 | `range += 0.4` → 1.4 |
| 3 | `vialNum += 4` → 9 |
| 4 | `range += 2` → **3.4** |

**`attack()`**

- 每瓶：`bias = Vector2(randi_range(-600,600), randi_range(-400,400))`。
- `DamageInfo(calculate_damage(), 0, false, 0, player)` — 不可暴击。
- `poisonBottle.init(start, start+bias, range, damage)`。

**`calculate_damage()`**：`baseDamage[level]`（无属性缩放）。

### 投掷 `poison_bottle.gd`

- 1s 抛物线（`height=100`）飞向 `target_pos`。
- 落地 `spread()`：`poisonArea.init(pos, range, damage)`。

### 毒圈 `poison_area.gd`

- 场景基础 `scale = 1.5`；`init` 再 `self.scale *= range`。
- **Tick**：`tickInterval=1.0`，`elapsedTime` 初值 0.9 → 首次 tick 很快。
- 每 tick：重叠敌人 `be_hit(damage.copy())` + 添加 `poison_buff`。
- **Timer 2.0s** 后 `queue_free`（毒圈存活 2 秒，非永久）。

### 中毒 Buff `poison_buff.gd`

- DoT：`2 + 0.3 * source.level * (2 + 0.3 * source.insight)`，类型 `"Poison"`。
- `tickInterval=0.6`，`duration=4.5`。
- 与其他 Buff 叠加有修改 tick/持续时间/伤害倍率。

---

## 设计 ↔ 代码差异

| 主题 | 设计 | UI | 代码 |
|------|------|-----|------|
| 初始拥有 | 是 | — | 否（仅手枪默认） |
| 1/3 级瓶数 | +2 / +4 | +1 / +3 | +2 / +4 ✅ |
| 2/4 级伤害加成 | 无 | +5 / +15 | **无** |
| 4 级范围 | +200% | +100% | `range` 1→3.4 |
| 毒圈持续 | 每秒伤害 | — | 区域存在 **2s**，约 2 tick |

---

## 升级表

| 等级 | 设计 | 代码 | `vialNum` | `range` | 直伤面板 | 暴击 | 间隔 |
|------|------|------|-----------|---------|----------|------|------|
| **0** | 3 瓶 | 3 | 3 | 1.0 | 3 | 否 | 1s |
| **1** | +2 | +2 | 5 | 1.0 | 5 | 否 | 1s |
| **2** | 范围+40% | `range=1.4` | 5 | 1.4 | 8 | 否 | 1s |
| **3** | +4 | +4 | 9 | 1.4 | 15 | 否 | 1s |
| **4** | 范围+200% | `range=3.4` | 9 | 3.4 | 30 | 否 | 1s |

**设计 DPS**：0 级 7；满级 60（含 DoT 语境）。

**附加 DoT**：由 `poison_buff` 独立计算，与武器等级通过 `source.level`（玩家等级）关联。
