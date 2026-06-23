# 扑克牌

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_poker.png" alt="扑克牌" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 8 |
| **资源 Key** | `poker` |
| **中文名** | 扑克牌 |
| **解锁** | 熟练首次到达 20 |

</div>
</div>
</div>

---

## 效果

向鼠标方向甩出多张扑克；小概率甩出 ACE 牌，命中后造成范围爆炸伤害。

- 等级1：扑克数量 +2（3 → 5）
- 等级2：扑克可穿透 3 个目标
- 等级3：扑克数量 +5（5 → 10）
- 等级4：每 30 张必出一张 ACE；ACE 爆炸范围 +50%

---

## 数值

| 等级 | 普通牌伤害 | ACE 爆炸伤害 |
|------|------------|------------|
| 0 | 3 | 50 |
| 1 | 5 | 80 |
| 2 | 10 | 150 |
| 3 | 20 | 270 |
| 4 | 60 | 500 |

- 扑克数量：见升级表
- 子弹速度：500
- 攻击间隔：0.8 − 0.015 × 熟练
- 精准度：0.7 + 0.01 × 熟练
- ACE 自然概率：1.6%（`spadeProb = 0.016`）
- 基础暴击率：5%
- 基础暴击伤害：200%
