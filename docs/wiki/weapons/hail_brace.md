# 冰霜手镯

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_hail_brace.png" alt="冰霜手镯" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 6 |
| **资源 Key** | `hail_brace` |
| **中文名** | 冰霜手镯 |
| **解锁** | 等级首次到达 10（代码已接入） |

</div>
</div>
</div>

> 冰冷的手镯，通过的气流都会变成凛冽的寒风，有很多妙用，但是什么就别问了。

---

## 效果

吹出锥形冷风，对命中敌人造成伤害并施加冻伤 Buff。

- 等级1：寒风范围增加 40%
- 等级2：寒风范围再增加 60%
- 等级3：寒风范围再增加 100%
- 等级4：额外释放冰龙卷，向前推进并对首次命中敌人造成伤害与冻伤

---

## 数值

| 等级 | 寒风基础伤害 |
|------|------------|
| 0 | 2 |
| 1 | 4 |
| 2 | 8 |
| 3 | 16 |
| 4 | 30 |

- 寒风伤害：基础伤害 + 2 × 启迪
- 冰涡伤害：15 + 2.5 × 启迪
- 伤害类型：冰（Ice）
- 攻击间隔：1s
- 基础暴击率：5%
- 基础暴击伤害：150%

---

## 代码 ↔ 文档差异

- 文档称「冰冻 buff」；代码施加 **冻伤**（`FrostBiteBuff`），非通用冰冻。
- 冰涡在 L4 每次攻击 **额外** 生成，与锥形风同时出现。
