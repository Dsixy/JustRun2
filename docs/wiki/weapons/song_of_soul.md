# 心之歌（Song of Soul）

| 字段 | 值 |
|------|-----|
| **ID** | 9 |
| **资源 Key** | `song_of_soul` |
| **场景** | `scene/weapon/song_of_soul.tscn` |
| **脚本** | `script/weapon/song_of_soul.gd` |
| **特效** | `scene/effect/song_effect.tscn` → `script/effect/song_effect.gd` |
| **解锁（设计）** | **魅力**首次到达 **20** |
| **解锁（代码）** | `charisma == 20` 局末触发 `unlock_weapon("song_of_soul")` ✅ |

---

## 概览

心之歌是 **以玩家为中心扩散的圆形心灵 AOE**。攻击时在玩家身上生成 `SongEffect`，0.6s 内 scale 从 0 扩至 `maxRadius`，对范围内敌人造成伤害；2 级起 **击退**；4 级起对范围内 **经验宝石** 施加吸附拾取（调用 `player.pick`）。伤害受 **魅力 + 启迪 + 等级** 加成，伤害类型为 **Psychic**。

---

## 设计文档

来源：`docs/Just Run2.md` § 心之歌(9)

### 获取方式

魅力首次到达 20 点。

### 攻击描述

奏响心灵的旋律，对 **周围敌人** 造成范围伤害。

### 升级（设计）

| 等级 | 效果 |
|------|------|
| 1 / 3 | 范围增加 **20% / 60%** |
| 2 | **击退** 周围目标 |
| 4 | 吸取范围内 **水晶**，并 **增加其经验获取值** |

### 数值（设计）

| 属性 | 值 |
|------|-----|
| 0 级 DPS | **7.1** |
| 满级 DPS | **93** |
| 攻击间隔 | **0.7** s |
| 基础伤害 `[0~4]` | `[5, 8, 12, 20, 30]` |
| 加成 | `+ (1.5×魅力 + 1×启迪) × (1 + 等级)` |
| 基础暴击率 | 5% |
| 暴击伤害 | 200% |
| 伤害类型 | **心灵伤害** |

---

## 代码实现

### 武器脚本 `song_of_soul.gd`

| 变量 | 初值 | 说明 |
|------|------|------|
| `baseRange` | 500 | 基础半径基数 |
| `rangeBonus` | 1.0 | 乘数 |
| `attackInterval` | 0.7 | |
| `canKnockBack` | false | L2 true |
| `canPick` | false | L4 true |

**`upgrade()`**

| 等级 | 代码 |
|------|------|
| 1 | `rangeBonus += 0.4` |
| 2 | `canKnockBack = true` |
| 3 | `rangeBonus += 0.6` |
| 4 | `rangeBonus += 0.4`；`canPick = true` |

**累计 `rangeBonus`**：L0 1.0 → L1 1.4 → L3 2.0 → L4 **2.4**

**`attack()`**

- 实例化 `SongEffect`，挂 `player`。
- `DamageInfo(..., "Psychic")`。
- `songEffect.init(global_position, rangeBonus * baseRange, damage, canKnockBack, canPick)`。

**`calculate_damage()`**

```text
baseDamage[level] + (1.5 * charisma + 1 * insight) * (1 + level)
```

### 特效 `song_effect.gd`

- 初始 `scale=0`，`modulate` 半透明绿。
- `spread()`：Tween 0.6s 缩放到 `maxRadius/100`（即半径像素 ≈ `maxRadius`）。
- 敌人：`be_hit(damage.copy())`；若 `knock`：`extraVel = 归一化(敌人-中心)*1000`。
- 经验宝石（group `expGem`）：若 `pick`，`damage.source.pick(area)` — **无额外经验倍率逻辑**。
- 动画结束 `queue_free`（单次 tick 型 AOE，非持续）。

---

## 设计 ↔ 代码差异

| 主题 | 设计 | 代码 |
|------|------|------|
| 1/3 级范围 | +20% / +60% | +40% / +60%（L1 为 +40% 非 +20%） |
| 4 级经验 | 增加水晶经验获取值 | 仅 `pick()` 正常拾取，**无倍率** |
| 伤害类型 | 心灵 | `"Psychic"` ✅ |
| 解锁时机 | 魅力 20 | 局末结算 ✅ |

---

## 升级表

魅力=0，启迪=0 示例。

| 等级 | 设计范围加成 | `rangeBonus` | 有效半径 | 击退 | 吸宝石 | 伤害公式 | 间隔 |
|------|--------------|--------------|----------|------|--------|----------|------|
| **0** | — | 1.0 | 500 | 否 | 否 | `5` | 0.7s |
| **1** | +20% | 1.4 | 700 | 否 | 否 | `11` | 0.7s |
| **2** | 击退 | 1.4 | 700 | **是** | 否 | `21` | 0.7s |
| **3** | +60% | 2.0 | 1000 | 是 | 否 | `38` | 0.7s |
| **4** | 吸水晶+经验 | 2.4 | **1200** | 是 | **是** | `60` | 0.7s |

**设计 DPS**：0 级 7.1；满级 93。
