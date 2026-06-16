# 肉蛋葱鸡（MEST）

| 字段 | 值 |
|------|-----|
| **ID** | 12 |
| **资源 Key** | `mest` |
| **场景** | `scene/weapon/mest.tscn` |
| **脚本** | `script/weapon/mest.gd` |
| **冲刺 Hitbox** | `scene/effect/slash.tscn` → `script/effect/slash.gd`（动画 `"dash"`） |
| **解锁（设计）** | **体力**首次到达 **20** |
| **解锁（代码）** | `stamina == 20` 局末 `unlock_weapon("mest")` ✅ |

---

## 概览

肉蛋葱鸡是 **无敌冲刺近战** 武器：攻击时玩家进入 **无敌 + dash 状态**，沿鼠标方向高速位移，路径上 `slash` HitArea 造成伤害并 **击飞** 敌人；可选 **生命偷取**。2 级永久增大玩家 `scale`；4 级 **连续两次** 冲击（间隔 0.35s）。暴击率受 **坚韧（resilience）** 额外加成。

---

## 设计文档

来源：`docs/Just Run2.md` § 肉蛋葱鸡(12)

### 获取方式

体力首次到达 20。

### 攻击描述

武器攻击时，玩家进入 **无敌** 并 **向前突进**，弹开路径怪物并造成伤害。

### 升级（设计）

| 等级 | 效果 |
|------|------|
| 1 / 3 | 造成伤害后回复 **1 / 3** 点生命值 |
| 2 | 玩家体型增加 **体力×10%** |
| 4 | **连续两次** 冲击 |

### 数值（设计）

| 属性 | 值 |
|------|-----|
| 伤害 `[0~4]` | `[8, 15, 30, 70, 180]` |
| 加成 | `+ 10 × 等级 × 体力` |
| 基础暴击率 | `5 + 3×坚韧` % |
| 暴击伤害 | 200% |
| 攻击间隔 | **0.6s** |

---

## 代码实现

### 武器脚本 `mest.gd`

| 变量 | 初值 |
|------|------|
| `attackInterval` | 0.6 |
| `dashScale` | 1.0 |
| `heal` | 0 → L1:1 → L3:3 |
| `dashTime` | 1 → L4:2 |
| `baseCritRate/Damage` | 0.05 / 2.0 |

**`upgrade()`**

| 等级 | 代码 |
|------|------|
| 1 | `heal = 1` |
| 2 | `player.scale += Vector2.ONE * player.stamina * 0.1`（**永久**） |
| 3 | `heal = 3` |
| 4 | `dashTime += 1` |

**`attack()`**：循环 `dashTime` 次，调用 `attack_once()` 后 `await 0.35s`。

**`attack_once()`**

- 方向 = 归一化(鼠标 - 位置)。
- `slash.init("dash", direction, damage, dashScale * 3)`；`extraVel = direction * 1200`；`lifeSteal = heal`。
- 设置 `player.isDash=true`、`isInvincible=true`。
- Tween：`speed` ×5 持续 0.1s，再 0.24s 恢复原速。

**暴击判定**

```text
randf() < 0.05 + player.critRate + 0.03 * player.resilience
```

**`calculate_damage()`**

```text
baseDamage[level] + 10 * player.stamina * level
```

### 特效 `slash.gd`

- 播放 `"dash"` 动画；命中：`be_hit` + `be_knock_back(extraVel, 0.5)` + `damage.source.HP += lifeSteal`。

---

## 设计 ↔ 代码差异

| 主题 | 设计 | UI | 代码 |
|------|------|-----|------|
| 1/3 级 | 回复 1/3 HP | 伤害+10/+30 | `heal=1/3` ✅ |
| 2 级体型 | 体力×10% | 同 | 永久改 `player.scale` |
| 突进方向 | 向前 | — | **朝鼠标** |

---

## 升级表

体力=3，坚韧=0 示例。

| 等级 | 设计 | 代码 | 吸血 | 冲击次数 | 伤害（stamina=3） | 间隔 |
|------|------|------|------|----------|-------------------|------|
| **0** | 无敌突进 | — | 0 | 1 | `8` | 0.6s |
| **1** | 回复1 | `heal=1` | 1 | 1 | `45` | 0.6s |
| **2** | 体型+体力×10% | scale+=0.3 | 1 | 1 | `90` | 0.6s |
| **3** | 回复3 | `heal=3` | 3 | 1 | `160` | 0.6s |
| **4** | 两次冲击 | `dashTime=2` | 3 | **2** | `300` | 0.6s |

公式：`baseDamage[level] + 10 × stamina × level`。
