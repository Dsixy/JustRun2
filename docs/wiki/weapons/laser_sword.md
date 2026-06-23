# 激光剑

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_laser_sword.png" alt="激光剑" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 3 |
| **资源 Key** | `laser_sword` |
| **中文名** | 激光剑 |
| **解锁** | 设计为初始拥有|

</div>
</div>
</div>

> 一把炫酷的激光剑。「真帅吧？」

---

## 效果

发动圆形范围的劈砍；2 级起追加戳刺。

- 等级1：攻击范围增加 20%
- 等级2：攻击额外发动一次戳刺
- 等级3：攻击范围再增加 45%
- 等级4：戳刺必定暴击，戳刺暴击伤害 +200%（暴伤倍率 400%）

---

## 数值

| 等级 | 劈砍基础伤害 | 戳刺基础伤害 |
|------|------------|------------|
| 0 | 3 | 5 |
| 1 | 6 | 12 |
| 2 | 15 | 25 |
| 3 | 27 | 55 |
| 4 | 40 | 150 |

- 劈砍伤害：劈砍基础伤害 + 4 × 力量
- 戳刺伤害：戳刺基础伤害 + 6 × 力量
- 伤害类型：雷电（Lightning）
- 攻击间隔：0.6s
- 基础暴击率：5%（戳刺 4 级 100%）
- 基础暴击伤害：200%

---

## 代码 ↔ 文档差异

- 场景 L4 文案「暴击伤害挺高 200%」；代码为 `pierceCritDamage += 2`，即戳刺暴伤从 200% 升至 **400%**。
- 攻击范围倍率：`slashScale × 4`（0 级 scale 1.0）。
