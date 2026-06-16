# 叶子 (leaf)

| 字段 | 值 |
|------|-----|
| **ID** | 27 |
| **资源 Key** | `leaf` |
| **场景** | `scene/weapon/leaf.tscn` |
| **脚本** | `script/weapon/leaf.gd` |
| **子弹** | `scene/item/leaf_bullet.tscn` |
| **实现状态** | ✅ · ⚠️ 解锁未接入 |

---

## 概述

**贯穿伤害** 辅助输出武器，双模式：

1. **追加攻击（被动）**：装甲臂上 **任意武器** 攻击后，叶子有概率向鼠标方向射出一片叶子；叶子飞到最大距离后 **停留**，对路径敌人造成伤害。
2. **主动攻击（轮射）**：轮到叶子开火时，**收回** 场上所有未消失的叶子，沿回收路径再次造成伤害。

---

## 设计文档（Just Run2.md）

追加 50% 概率射出叶子；1 级概率 100%；2 级收回额外 40% 伤害；3 级距离 +50%；4 级 60% 再追加一次可连锁。

间隔 0.8-0.2×熟练；伤害 [2,4,10,25,60]；暴击 5%/200%。

---

## 基础参数（代码）

| 参数 | 0 级 | 说明 |
|------|------|------|
| `attackInterval` | **1.2 s** | 设计熟练缩减 **未实装** |
| `baseDamage` | [2,4,10,25,60] | |
| `baseCritRate` | **0%** | 设计 5% ⚠️ |
| `followUPProb` | **1.0** | 设计 0 级 50% ⚠️ |
| `maxDistance` | 800 | 3 级 +400 → 1200 |
| `comeBackDamageBonus` | 0 | 2 级 **0.4** |
| `extraFollowUp` | false | 4 级 true |

**叶子子弹**：速度 2000；飞出至 `maxDistance` 后停留；`come_back()` 时 `damage.bonus = comeBackBonus`。

---

## 追加攻击 `follow_up_attack()`

```text
若 randf() < followUPProb: shoot()
若 extraFollowUp:
  while randf() < 0.6: shoot(); await 0.05s
```

由 `weapon_arm.gd` 在每次 `weapon.attack()` 后对 **全部** 武器调用。

---

## 升级表

| 等级 | 设计 | 代码 |
|------|------|------|
| 0 | 50% 追加 | 100% |
| 1 | 100% | 100%（与 0 级无差别） |
| 2 | 收回 +40% | `comeBackDamageBonus=0.4` |
| 3 | 距离 +50% | `maxDistance=1200` |
| 4 | 60% 连锁追加 | `extraFollowUp=true` |

---

## 相关文件

`leaf.gd`、`leaf_bullet.gd`、`weapon_arm.gd`
