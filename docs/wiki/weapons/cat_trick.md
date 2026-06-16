# 猫之计谋（猫的计谋）(cat_trick)

| 字段 | 值 |
|------|-----|
| **ID** | 22 |
| **资源 Key** | `cat_trick` |
| **场景** | `scene/weapon/cat_trick.tscn` |
| **脚本** | `script/weapon/cat_trick.gd` |
| **显示名** | 猫之计谋 |
| **解锁（设计）** | 解锁 **饱饱猫**；Popocat 需单局 30 猫薄荷 📋 |
| **状态** | ⚠️ 已实装；解锁未接 |

---

## 定位

**防御 / 计数触发型** 武器。无直接伤害（`calculate_damage` 恒 0）。通过攻击次数累积，周期性给予 **猫咪护盾**（抵挡一次伤害）；每次攻击还叠加 **超级 Pro** Buff（单次受伤上限）。

---

## 设计文档（Just Run2.md）

获取：解锁饱饱猫。每 10 次攻击释放猫咪毛球，抵挡一次伤害。间隔 1s。

1 级：间隔 -2；2 级：可存 1 个；3 级：间隔 -3；4 级：单次受伤 ≤10% 最大生命。

---

## 每次攻击流程（`attack()`）

1. `attackTime += 1`
2. **始终**实例化 `SuperProBuff` 并 `player.buffManager.add_buff(b)`
3. 若 `attackTime >= requiredAttackTime`：
   - 生成 `CatShield` 效果
   - `shield.init(player, maxStack)`
   - `attackTime -= requiredAttackTime`

**攻击间隔**：固定 **1.0 秒**。

---

## 猫咪护盾（CatShield → CatShieldBuff）

- 若玩家已有 Buff **ID 10**（`CatShieldBuff`）→ 新护盾 **立即自毁**。
- `modify_damage`：将 `damage.baseAmount` 置 **0**，`stackNum -= 1`；层数耗尽 `expire()`。
- 设计 BuffID 5；代码 ID **10**。

---

## 超级 Pro（SuperProBuff）

- Buff ID：**9**
- 持续 **2 秒**；每次攻击 **刷新**。
- `modify_damage`：`damage.baseAmount = min(damage.baseAmount, maxHP × 0.1)`

⚠️ 代码在 **所有等级** 每次攻击都添加 SuperProBuff；`upgrade()` 中 `superPro = true` **仅 4 级设置但未在 attack 中判断**——0 级起可能已有 10% 单次受伤上限。

---

## 攻击计数与护盾

| 等级 | 设计 | 代码 `requiredAttackTime` | `maxStack` |
|------|------|---------------------------|------------|
| 0 | 10 | **10** | 1 |
| 1 | 8 | **8** | 1 |
| 2 | 可存 1 层 | 8 | **2** |
| 3 | 5 | **5** | 2 |
| 4 | ≤10% HP | 5 | 2 + SuperPro |

---

## 设计 ↔ 代码差异

- SuperPro 可能全等级生效。
- 解锁链（30 猫薄荷 → 饱饱猫 → 本武器）未实装。
- 设计「毛球」vs 实装 Buff 层数。

---

## 相关资源

`cat_trick.gd`、`cat_shield.tscn`、`cat_shield_buff.gd`、`super_pro_buff.gd`
