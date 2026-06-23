# 思维泡泡

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_thought_bubble.png" alt="思维泡泡" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 5 |
| **资源 Key** | `thought_bubble` |
| **中文名** | 思维泡泡 |
| **解锁** | 启迪首次到达 20 |

</div>
</div>
</div>

---

## 效果

召唤若干思维泡泡环绕玩家旋转并碰撞敌人；泡泡每秒旋转一周。

- 等级1：泡泡数量 +1（3 → 4）
- 等级2：泡泡数量 +2（4 → 6）
- 等级3：泡泡永久存在（不再因命中次数消失）
- 等级4：泡泡内外径周期性变化，数量 +2（6 → 8）

---

## 数值

| 等级 | 基础伤害 |
|------|------------|
| 0 | 3 |
| 1 | 5 |
| 2 | 8 |
| 3 | 12 |
| 4 | 20 |

- 泡泡伤害：基础伤害 + 2 × 等级 + 1 × 魅力 + 2 × 启迪
- 伤害类型：心灵（Psychic）
- 轨道半径：150（4 级可扩至约 450）
- 0～2 级：每颗泡泡命中 5 次后消失；场上仍有泡泡时不会再次召唤
- 攻击间隔：0.6s
- 暴击：代码 **不可暴击**（`baseCritRate = 0`，泡泡命中硬编码 `isCrit = false`）
