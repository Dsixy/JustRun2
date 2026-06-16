# 外卖员（Delivery Guy）

| 字段 | 值 |
|------|-----|
| **ID** | 13 |
| **资源 Key** | `delivery_guy` |
| **场景** | `scene/weapon/delivery_guy.tscn` |
| **脚本** | `script/weapon/delivery_guy.gd` |
| **实体** | `scene/effect/delivery_guy_bullet.tscn` → `script/effect/delivery_guy_bullet.gd` |
| **解锁（设计）** | 单局消费 **4000** 金币 |
| **解锁（代码）** | 📋 **未接入**（POLISH-A06） |

---

## 概览

外卖员是 **召唤型往返单位**：每次攻击释放多个外卖员 NPC，各自锁定 **随机敌人** 冲刺，命中目标后返回玩家；路径上对敌人造成伤害，返回时可 **收集金币** 并交给玩家。4 级起拾取的金币数量会 **动态增加该次伤害**。伤害受 **等级 + 魅力** 缩放；设计为钝击，代码未标注 type。

---

## 设计文档

来源：`docs/Just Run2.md` § 外卖员(13)

### 获取方式

单局消费 **4000** 金币。

### 攻击描述

攻击释放 **2** 个外卖员；向随机敌人冲刺，到达后返回；对路径敌人造成伤害并 **带回金币**。

### 升级（设计）

| 等级 | 效果 |
|------|------|
| 1 / 3 | 外卖员个数 **+1 / +2** |
| 2 | 带回额外 **0.2** 金币 |
| 4 | 返回时带回 **路上金币**；每带回 **1** 金币，伤害 **+5** |

### 数值（设计）

| 属性 | 值 |
|------|-----|
| 攻击间隔 | **0.9** s |
| 伤害 `[0~4]` | `[2, 4, 10, 20, 40]` |
| 加成 | `+ 0.5×等级×(2+0.5×魅力)` |
| 子弹速度 | **200** |
| 基础暴击率 | 5% |
| 暴击伤害 | 200% |
| 伤害类型 | **钝击伤害** |

---

## 代码实现

### 武器脚本 `delivery_guy.gd`

| 变量 | 初值 |
|------|------|
| `guySpeed` | **400** |
| `attackInterval` | 0.9 |
| `guyNum` | 2 |
| `extraCoin` | false → L2 true |
| `bringCoin` | false → L4 true |

**`upgrade()`**

| 等级 | 代码 |
|------|------|
| 1 | `guyNum += 1` → 3 |
| 2 | `extraCoin = true` |
| 3 | `guyNum += 2` → 5 |
| 4 | `bringCoin = true` |

**`attack()`**

- 循环中若 `enemies == []` 则 **立即 return**（剩余外卖员不生成）。
- 随机 `target` from `enemies.pick_random()`。
- `guy.init(pos, target, guySpeed, damage, player, extraCoin, bringCoin)`。

**`calculate_damage()`**

```text
baseDamage[level] + 0.5 * level * (2 + 0.5 * charisma)
```

### 实体 `delivery_guy_bullet.gd`

**冲刺阶段**：追踪 `target`；`speed` 移动。

**命中敌人**

- 复制伤害；若 `bringCoin`：`d.baseAmount += collection * 5.0`。
- 若命中的是锁定 `target` → `come_back()`。

**金币**

- group `coin`：碰撞时 `collection += 1` 并销毁金币（仅 `bringCoin` 时 mask 含 coin层）。

**返回**

- `target = player`；到达玩家 hurtbox → `delete()`。
- `player.gain_coin(collection + int(extraCoin) * 0.2)`。

---

## 设计 ↔ 代码差异

| 主题 | 设计 | 代码 |
|------|------|------|
| 解锁 | 单局消费 4000 | 未实现 |
| 移动速度 | 200 | **400** |
| 伤害类型 | 钝击 | `""` |
| 无敌人 | — | 整次 attack 可能 **0 召唤** |

---

## 升级表

魅力=0 示例。

| 等级 | 设计 | `guyNum` | 额外金币 | 捡路金币 | 单员伤害 | 速度 | 间隔 |
|------|------|----------|----------|----------|----------|------|------|
| **0** | 2 外卖员 | 2 | 否 | 否 | `2` | 400 | 0.9s |
| **1** | +1 | 3 | 否 | 否 | `5` | 400 | 0.9s |
| **2** | +0.2 金 | 3 | **+0.2** | 否 | `12` | 400 | 0.9s |
| **3** | +2 | 5 | +0.2 | 否 | `23` | 400 | 0.9s |
| **4** | 捡币+伤 | 5 | +0.2 | **是** | `44` (+5/币) | 400 | 0.9s |
