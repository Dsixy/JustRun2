# 唤灵海螺（亡灵海螺）(spirit_conch)

| 字段 | 值 |
|------|-----|
| **ID** | 21 |
| **资源 Key** | `spirit_conch` |
| **场景** | `scene/weapon/spirit_conch.tscn` |
| **脚本** | `script/weapon/spirit_conch.gd` |
| **显示名** | **唤灵海螺**（场景）；设计称 **亡灵海螺** |
| **解锁** | 待补充 📋 |
| **状态** | ⚠️ 已实装 |

---

## 定位

**召唤 / 反伤 / 魂魄充能** 混合型武器。场上维持 **小死灵**（`LittleSpirit`）；死灵 **受伤** 时对周围造成 **心灵（Psychic）** 范围伤害。4 级起收集敌人死亡 **魂魄**，满员时 **注入** 随机死灵。

武器本体 **无法暴击**（`baseCritRate = 0`）；部分触发伤害 **必定暴击**。

---

## 武器攻击逻辑

```text
若 spirits.length < spiritMaxNum：
    召唤一只死灵
elif collect（4级）且已满员：
    随机选一只死灵 gainPower(collectedSoul)
    collectedSoul = 0
```

- **攻击间隔**：**1.2 秒**
- 死灵死亡或离屏 → 从 `spirits` 列表移除

---

## 死灵（LittleSpirit）

| 属性 | 公式 / 值 |
|------|-----------|
| 生命值 | `spiritHP + 20×启迪 + 15×等级`，初值 `spiritHP=20`；2 级 `spiritHP+=50` |
| 移动 | 随机方向，速度 **100** |
| 分组 | `Area2D` 在 **`player` 组** |

设计：生命 `20 + 10×启迪 + 15×等级`；代码启迪系数 **20 非 10**。

### 受伤反伤 `take_damage(damage)`

1. `HP -= damage.finalDamage`
2. 生成 `SoulShock`：心灵伤害 = 所受 baseAmount × 0.2 × 武器等级 + `baseDamage[level] + 5×感知`
3. 随机改变移动方向；HP ≤ 0 删除

---

## 魂魄机制（4 级 `collect = true`）

`scene.gd` → `process_enemy_death`：对每个武装 weapon，若 `id == 21` 且 `collect`，则 `collectedSoul += 1`。

满员且攻击 tick：`gainPower(collectedSoul)` 后清零。

### `gainPower(n)`

1. 死灵 `HP += n × 10`
2. SoulShock：半径 `radiusBonus + 0.6`；伤害 `n×10 + baseDamage`；**必暴**

---

## 伤害表 `baseDamage[level]`

[2, 4, 8, 16, 40] + 5×感知（在 `calculate_damage` 中）

---

## 升级

| 等级 | 设计 | 代码 |
|------|------|------|
| 1 | +1 死灵 | `spiritMaxNum += 1` → 3 |
| 2 | 生命 +50 | `spiritHP += 50` |
| 3 | +1 死灵；范围 +40% | `spiritMaxNum += 1`；`spiritRadiusBonus += 0.4` |
| 4 | 吸魂魄；满员注入 | `collect = true` |

**死灵上限**：2 → 3 → 3 → **4**。

---

## SoulShock

`maxRadius = 5 × (1 + radiusBonus)`；0.6s 内 scale tween 后销毁；伤害类型 Psychic。

---

## 设计 ↔ 代码差异

- 命名：唤灵 vs 亡灵。
- 启迪系数 20 vs 设计 10。
- 反伤触发依赖 `take_damage` 外部调用，需手测。

---

## 相关资源

`spirit_conch.gd`、`little_spirit.tscn`、`soul_shock.tscn`、`scene.gd`
