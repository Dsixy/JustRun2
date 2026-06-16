# 扑克牌（Poker）

| 字段 | 值 |
|------|-----|
| **ID** | 8 |
| **资源 Key** | `poker` |
| **场景** | `scene/weapon/poker.tscn` |
| **脚本** | `script/weapon/poker.gd` |
| **子弹** | `scene/item/poker_bullet.tscn` → `script/item/poker_bullet.gd` |
| **爆炸** | `scene/effect/poker_explode.tscn` |
| **解锁（设计）** | **熟练**（文档）首次到达 **20** |
| **解锁（代码）** | 属性 **`agility`** 或 **`dexterrity`** 首次达到 20 时 `unlock_weapon("poker")`（局末 `final_results` → `skill_triggered`）✅ |
| **双绑** | 敏捷与熟练任一满 20 均解锁同一武器 ⚠️ |

---

## 概览

扑克牌是 **远程扇形散射 + 小概率 ACE 爆炸** 武器。每次攻击向鼠标方向甩出多张扑克（带精准度偏差），普通牌造成面板贯穿伤害；**ACE（frame=3）** 命中或概率触发时产生范围爆炸，使用独立的 `explodeDamage` 数组。攻击间隔与精准度随 **熟练（dexterrity）** 动态变化。

**核心机制**

- 每 0.05s 发射一张（`await timer 0.05`）。
- 普通牌：`idx ∈ {0,1,2}`，`baseDamage[level]`。
- ACE：`idx=3`，`explodeDamage[level]`，命中敌人立即爆炸（`poker_explode`）。
- 2 级起：`pierce=3`，可穿透多个敌人（非 ACE 时在 `pierce` 耗尽前不销毁）。
- 4 级：`mustSpade=true`，每 **30** 张强制一张 ACE；ACE 爆炸半径 ×1.5。

---

## 设计文档

来源：`docs/Just Run2.md` § 扑克牌(8)

### 获取方式

**熟练**首次到达 20（代码映射为 `dexterrity`；同时 `agility` 也绑同一武器）。

### 攻击描述

甩出 **3** 张扑克，有 **1%** 概率甩出 **ACE** 牌，造成额外爆炸伤害。

### 升级（设计）

| 等级 | 效果 |
|------|------|
| 1 / 3 | 额外甩出 **2 / 5** 张扑克 |
| 2 | 扑克可以 **穿透 3** 个目标 |
| 4 | 每 **30** 张必然产生一张 ACE；ACE 爆炸范围提升 **50%**；造成 **火属性力场伤害** |

### 数值（设计）

| 属性 | 值 |
|------|-----|
| 0 级 DPS | **11.25** |
| 满级 DPS | **120 / 200** |
| 精准度 | `0.7 + 0.01 × 熟练` |
| 攻击间隔 | `0.8 - 0.015 × 熟练` |
| 扑克伤害 `[0~4]` | `[3, 5, 10, 20, 60]` |
| ACE 爆炸 `[0~4]` | `[50, 80, 150, 270, 500]` |
| 子弹速度 | 500 |
| 基础暴击率 | 5% |
| 暴击伤害 | 200% |
| 伤害类型 | **贯穿伤害**（ACE 4 级：**火属性力场**） |

---

## 代码实现

### 武器脚本 `poker.gd`

**动态属性**

```text
shootAccuracy = 0.7 + dexterrity * 0.01
attackInterval = 0.8 - dexterrity * 0.015
```

**常量 / 初始**

| 变量 | 初值 | 说明 |
|------|------|------|
| `bulletSpeed` | 500 | |
| `pierce` | 0 | 2 级 → 3 |
| `pokerNum` | 3 | |
| `spadeProb` | **0.016** | 1.6% 非 1% |
| `spadeExplodeRadius` | 200 | 4 级 ×1.5 → 300 |
| `mustSpade` | false | 4 级 true |
| `pokerCounter` | 0 | 30 张 ACE 计数 |
| `baseCritRate/Damage` | 0.05 / 2.0 | |

**`upgrade()`**

| 等级 | 效果 |
|------|------|
| 1 | `pokerNum += 2` → 5 |
| 2 | `pierce = 3` |
| 3 | `pokerNum += 5` → **10** |
| 4 | `mustSpade=true`; `spadeExplodeRadius *= 1.5` |

**`attack()` 流程**

1. 循环 `pokerNum` 次。
2. `idx = randi() % 3`；若 `randf() < spadeProb` 则 `idx=3`。
3. 4 级：`pokerCounter++`；若 `pokerCounter==30` 或已 roll 到 ACE，强制 `idx=3` 并清零计数。
4. 方向 = 鼠标 - 武器位置；偏差 = `direction.orthogonal() * (randf()*2-1) * (1 - shootAccuracy)`。
5. `poker.init(idx, pos, direction+bias, speed, damage, spadeExplodeRadius)`；`poker.pierce = pierce`。
6. 每张间隔 0.05s。

### 子弹 `poker_bullet.gd`

- `init`：`frame=idx`；ACE 时 `canExplode=true`，记录 `radius`。
- 飞行：`max_path=3000`，每帧 `position += direction * speed * delta`。
- 命中敌人：`be_hit(damage)`；ACE → `explode()`；否则 `pierce<=0` 时销毁。
- `explode()`：生成 `poker_explode`，`init(pos, damage, 0.3, radius)`。

---

## 设计 ↔ 代码差异

| 主题 | 设计 | UI | 代码 |
|------|------|-----|------|
| 解锁属性名 | 熟练 | — | `dexterrity` + 重复绑 `agility` |
| ACE 概率 | 1% | 1% | **1.6%** |
| 3 级张数 | 额外 +5 | 额外 +3 | `pokerNum+=5` → L3 共 **10** 张 |
| ACE 4 级元素 | 火属性力场 | 仅范围 +50% | 无 Fire / Force type |
| 解锁时机 | 属性到 20 即时？ | — | **局末** `final_results` 才 emit |

---

## 升级表

熟练 = 0 时的静态面板。

| 等级 | 设计 | 代码 | `pokerNum` | `pierce` | 单牌伤害 | ACE 爆炸 | 爆炸半径 | 间隔 | 精准 |
|------|------|------|------------|----------|----------|----------|----------|------|------|
| **0** | 3 张，1% ACE | 同左（1.6%） | 3 | 0 | 3 | 50 | 200 | 0.8s | 0.7 |
| **1** | +2 张 | +2 | 5 | 0 | 5 | 80 | 200 | 0.8s | 0.7 |
| **2** | 穿透 3 | `pierce=3` | 5 | 3 | 10 | 150 | 200 | 0.8s | 0.7 |
| **3** | +5 张 | +5 | **10** | 3 | 20 | 270 | 200 | 0.8s | 0.7 |
| **4** | 每30张必 ACE | `mustSpade`, 半径 300 | 10 | 3 | 60 | 500 | **300** | 0.8s | 0.7 |

**设计 DPS 参考**：0 级 11.25；满级 120/200。
