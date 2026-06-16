# 拷贝器（复制器）(replicator)

| 字段 | 值 |
|------|-----|
| **百科 Key** | `replicator` |
| **武器 ID** | **26** |
| **场景** | `res://scene/weapon/replicator.tscn` |
| **脚本** | `script/weapon/replicator.gd` |
| **显示名** | 复制器（设计称「拷贝器」） |
| **实现状态** | ✅ 有代码 · ⚠️ 解锁事件未接入 |
| **禁用** | 否 |

---

## 概述

拷贝器是 **辅助型武器**：自身不造成直接伤害，在装甲臂轮到它开火时，**立即令槽位列表中位于其后的下一把武器额外攻击一次**（可附带暴击加成）。无法复制自身。

---

## 解锁条件

| 来源 | 条件 |
|------|------|
| 设计文档 | 未写明具体解锁事件 |
| 代码 | 📋 未接入；新档不默认解锁 |

---

## 复制目标判定（`arm()`）

1. 在 `weaponArm.weaponList` 中查找自身索引 `idx`。
2. 从 `idx + 1` 起向后扫描，取第一个有效 `BaseWeapon` 作为 `nextWeapon`。
3. 若后面没有武器 → `nextWeapon = null`，本轮无复制效果。

---

## 基础参数

| 参数 | 0 级 | 说明 |
|------|------|------|
| `attackInterval` | **2.0 s** | |
| 直接伤害 | **0** | |
| `attackTimes` | 1 | 4 级 → 2 |
| `extraCritRate` | 0 | 3 级 → **+1.0** |
| `extraCritDamage` | 0 | 2 级 → **+1.5** |

---

## 升级（0 → 4 级）

| 等级 | 设计 | 代码 |
|------|------|------|
| 0 | 复制下一武器 1 次 | `attackTimes=1`，间隔 2.0s |
| 1 | 间隔 -0.4s | → **1.6 s** |
| 2 | 复制暴伤 +150% | `extraCritDamage = 1.5` |
| 3 | 间隔 -0.6s；复制暴率 100% | `extraCritRate = 1.0`；→ **1.0 s** |
| 4 | 复制两次；间隔 -0.4s | `attackTimes = 2`；→ **0.6 s** |

### 复制攻击流程

```text
若 nextWeapon 存在:
  重复 attackTimes 次:
    nextWeapon.baseCritRate += extraCritRate
    nextWeapon.baseCritDamage += extraCritDamage
    nextWeapon.attack()
    还原 crit 加成
```

---

## 构筑建议

| 搭配 | 说明 |
|------|------|
| 高单发伤害武器 | 复制 = 免费额外轮次 |
| 放在高伤武器 **正前方** | 最优位置 |
| 叶子 | 复制触发的 attack 仍会走全局 `follow_up_attack()` |

---

## 设计 ↔ 代码差异

- 名称：拷贝器 vs 场景「复制器」。
- 核心机制与设计一致。

---

## 相关文件

`replicator.gd`、`weapon_arm.gd`、`base_weapon.gd`
