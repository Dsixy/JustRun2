# 毒药瓶

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_poison_vial.png" alt="毒药瓶" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 10 |
| **资源 Key** | `poison_vial` |
| **中文名** | 毒药瓶 |
| **解锁** | 默认解锁 |

</div>
</div>
</div>

---

## 效果

随机方向甩出多瓶毒药，落地生成毒圈；敌人每秒受到伤害并附加中毒 Buff。

- 等级1：毒药数量 +2（3 → 5）
- 等级2：毒圈范围增加 40%
- 等级3：毒药数量 +4（5 → 9）
- 等级4：毒圈范围再增加 200%（累计 +240%）

---

## 数值

| 等级 | 基础伤害 |
|------|------------|
| 0 | 3 |
| 1 | 5 |
| 2 | 8 |
| 3 | 15 |
| 4 | 30 |

- 毒圈伤害：基础伤害（每秒 tick）
- 落点偏移：随机 ±600 / ±400
- 攻击间隔：1s
- 暴击：**不可暴击**（`isCrit = false`）
