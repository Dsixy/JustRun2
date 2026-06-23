# 群星之怒

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_stellar_wrath.png" alt="群星之怒" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 7 |
| **资源 Key** | `stellar_wrath` |
| **中文名** | 群星之怒 |
| **解锁** | 卡莫单局击杀 1000 |

</div>
</div>
</div>

---

## 效果

在屏幕上现有子弹位置召唤流星，约 2 秒后坠地爆炸；4 级前若场上子弹不足则流星数减少。

- 等级1：流星爆炸范围增加 40%
- 等级2：流星数量 +2（3 → 5）
- 等级3：流星爆炸范围再增加 80%
- 等级4：流星数量 +4（5 → 9）；场上子弹不足时在玩家周围随机补点

---

## 数值

| 等级 | 基础伤害 |
|------|------------|
| 0 | 3 |
| 1 | 5 |
| 2 | 9 |
| 3 | 15 |
| 4 | 30 |

- 流星伤害：基础伤害 + 1.5 × 等级 × (2 + 0.2 × 启迪)
- 爆炸半径：150 × attackBonus（0 级 1.0；3 级 2.2；4 级 2.2）
- 坠落延迟：约 2s
- 攻击间隔：0.6s
- 基础暴击率：5%
- 基础暴击伤害：200%
