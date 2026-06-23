# 蛛丝

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_spider_silk.png" alt="蛛丝" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 14 |
| **资源 Key** | `spider_silk` |
| **中文名** | 蛛网（场景 
a`） |
| **解锁** | 通关时武装均为 DoT（代码已接入） |

</div>
</div>
</div>

---

## 效果

发射一团蛛丝，命中后展开蛛网；对范围内敌人身上所有持续伤害 Buff **立即结算**，造成一定比例的剩余伤害。

- 等级1：蛛网范围 +20%
- 等级2：结算比例提升至 55%
- 等级3：蛛网范围再 +40%
- 等级4：结算比例 100%；结算后 **保留** 原 Buff

---

## 数值

| 等级 | 基础伤害 |
|------|------------|
| 0 | 12 |
| 1 | 16 |
| 2 | 20 |
| 3 | 30 |
| 4 | 50 |

- 蛛丝弹伤害：基础伤害
- 结算比例：35% → 55% → 100%
- 子弹速度：500
- 攻击间隔：1 − 0.1 × 熟练
- 精准度：0.9 + 0.05 × 熟练
- 基础暴击率：5%
- 基础暴击伤害：200%

---

## 代码 ↔ 文档差异

- 百科名「蛛丝」；场景显示名 **「蛛网」**。
- 冻伤（`FrostBiteBuff`）**不是** `DotBuff`，不会被蛛网结算。
- 0～3 级结算后会清除 DoT Buff；4 级 `keepBuff = true` 保留。
