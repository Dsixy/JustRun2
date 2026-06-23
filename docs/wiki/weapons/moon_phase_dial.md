# 月相盘

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_moon_phase_dial.png" alt="月相盘" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 29 |
| **资源 Key** | `moon_phase_dial` |
| **中文名** | 月相盘 |
| **解锁** | 待设计；**已禁用** 🚫 |

</div>
</div>
</div>

---

## 效果

（设计未完成）发动圆形劈砍与戳刺，机制类似激光剑的占位实现。

- 等级1：范围 +20%
- 等级2：追加戳刺
- 等级3：范围 +40%
- 等级4：戳刺必定暴击，戳刺暴伤 +50%

---

## 数值

| 等级 | 劈砍基础伤害 | 戳刺基础伤害 |
|------|------------|------------|
| 0 | 3 | 5 |
| 1 | 6 | 12 |
| 2 | 15 | 25 |
| 3 | 27 | 55 |
| 4 | 40 | 150 |

- 劈砍：基础 + 4 × 力量
- 戳刺：基础 + 6 × 力量
- 伤害类型：雷电（Lightning）
- 攻击间隔：0.6s
- 范围倍率：`slashScale × 3`（激光剑为 ×4）
- 基础暴击率：5%（戳刺 4 级 100%）

---

## 代码 ↔ 文档差异

- 列入 `GameInfo.DISABLED_WEAPONS`。
- 场景未配置 
a`、`descriptions`；无月相/月能专用机制。
- 与激光剑差异：L3 范围 +0.4（非 +0.45）；L4 戳刺暴伤 +0.5（激光剑 +2）；缩放 ×3（激光剑 ×4）。
- 设计文档中的月相系统 **未实装**。
