# 泪水

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_tear.png" alt="泪水" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 28 |
| **资源 Key** | `tear` |
| **中文名** | 泪水 |
| **解锁** | 累计失败 20 次 |

</div>
</div>
</div>

---

## 效果

向四面八方发射多滴泪弹；未命中时在终点留下小水珠。泪弹命中水珠被吸收，满 stack 后爆炸并散射新泪弹，形成链式反应。

- 等级1：（设计：伤害 +4）— 代码无单独逻辑，靠伤害数组跳档
- 等级2：泪弹数量 +4（6 → 10）
- 等级3：命中敌人也留水珠；爆炸散射数 +1
- 等级4：爆炸散射数 +2；水珠引爆阈值 −1（4 → 3）

---

## 数值

| 等级 | 基础伤害 |
|------|------------|
| 0 | 2 |
| 1 | 8 |
| 2 | 12 |
| 3 | 20 |
| 4 | 34 |

- 泪弹速度：400
- 飞行距离：约 375～625（随机）
- 水珠最大 stack：4（4 级 3）
- 爆炸散射数：4 → 5 → 7
- 攻击间隔：2.0s
- 基础暴击率：5%
- 基础暴击伤害：150%
