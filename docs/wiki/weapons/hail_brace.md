# 冰霜手镯 (hail_brace)

## 概览

| 字段 | 值 |
|------|-----|
| ID | 6 |
| 资源 key | `hail_brace` |
| 类名 | `HailBrace`（`script/weapon/hail_brace.gd`，`extends BaseWeapon`） |
| 实现状态 | ✅已实现（**解锁事件未接入**） |
| 解锁条件 | 设计：等级首次到达 10；`patch.md` 要求接 `level_triggered`；代码：`Events.level_triggered` 已声明但 **无任何 `emit`**，`_on_level_triggered` 为空 `pass`，**未调用** `unlock_weapon("hail_brace")` |

**场景资源：** `res://scene/weapon/hail_brace.tscn`  
**寒风特效：** `res://scene/effect/frost_wind.tscn`  
**冰龙卷：** `res://scene/effect/frost_whirl_wind.tscn`  
**禁用状态：** 不在 `DISABLED_WEAPONS` 中

---

## 设计文档（Just Run2.md）

**章节：** `## 冰霜手镯(6)`

**获取方式：** 等级首次到达 10 解锁

**武器描述：** 吹出锥形的冷风。

**攻击间隔：** 1

**伤害：** `[2, 4, 8, 16, 30] + 2 × 启迪`

**最大范围：** 700

**基础暴击率：** 5%

**暴击伤害：** 150%

**伤害类型：** 冰元素

**升级效果（设计）：**

| 等级 | 效果 |
|------|------|
| 1 级 | 范围增加 40% |
| 2 级 | 使后面的武器攻击附着冰元素 |
| 3 级 | 范围增加 60% |
| 4 级 | 产生冰龙卷，向前推进，造成 `15 + 2.5 × 启迪` 伤害 |

---

## 代码实现

**脚本：** `script/weapon/hail_brace.gd`  
**场景：** `scene/weapon/hail_brace.tscn`  
**寒风：** `script/effect/frost_wind.gd`  
**冰龙卷：** `script/effect/frost_whirl_wind.gd`

### 基础字段

| 字段 | 值 / 公式 |
|------|-----------|
| `id` | `6` |
| `na` | `"冰霜手镯"` |
| `descriptions` | `["吹出锥形的冷风。对命中的敌人施加冻伤Buff", "寒风范围增加40%", "寒风范围额外增加60%", "寒风范围额外增加100%", "攻击额外释放产生冰龙卷，向前推进，对首次命中的敌人造成伤害并施加冻伤Buff"]` |
| `baseDamage` | `[2, 4, 8, 16, 30]` |
| `rangeBonus` | 初始 `1.0` |
| `attackInterval` | `1.0` |
| `whirlDamage` | `15`（冰龙卷基础） |
| `emitWhirlWind` | 初始 `false`；4 级 `true` |
| `baseCritRate` | `0.05` |
| `baseCritDamage` | `1.5` |

### `upgrade()` 分支（代码）

```gdscript
1: self.rangeBonus += 0.4    # 1.0 → 1.4
2: self.rangeBonus += 0.6    # 1.4 → 2.0
3: self.rangeBonus += 1.0    # 2.0 → 3.0
4: self.emitWhirlWind = true
```

**无** `follow_up_attack()` 实现（设计 2 级「后续武器附冰」未做）。

### `attack()` 行为

1. 计算指向鼠标的方向。
2. 实例化 `windEffectScene`（`frost_wind`），加入主场景。
3. 寒风伤害：`DamageInfo.new(calculate_damage("wind"), 0, 暴击判定, baseCritDamage, player, "Ice")`。
4. `windEffect.init(global_position, direction, rangeBonus, damage)`。
5. 若 `emitWhirlWind`：额外实例化 `whirlWindScene`，伤害 `calculate_damage("whirlWind")`，元素 `"Ice"`，推进速度 `100`（`frost_whirl_wind.gd`）。

### `calculate_damage(name)`

```gdscript
# wind:
baseDamage[level] + 2 * player.insight
# whirlWind:
whirlDamage + 2.5 * player.insight   # 即 15 + 2.5×启迪
```

### 寒风特效（`frost_wind.gd`）

- 锥形粒子 + Area2D 缩放：`scale → range * 3`，位移 `position → Vector2(300, 0) * range`，持续约 `1.4s`。
- 命中敌人：`be_hit` + 施加 `frost_bite_buff`（冻伤 Buff）。
- **无**硬编码 `700` 最大范围；范围由 `rangeBonus` 乘子控制。

### 冰龙卷（`frost_whirl_wind.gd`）

- 沿方向推进 `speed = 100`。
- 首次命中：`be_hit` + 冻伤 Buff + 反向 `extraVel` 击退效果。
- 粒子结束 `queue_free`。

### 场景描述补充

- 0 级描述含「施加冻伤 Buff」——代码通过 `frost_bite_buff` 实现 ✅。

---

## 设计 ↔ 代码差异

- **解锁：** 设计 / 补丁要求等级 10；代码 **完全未实现**（`level_triggered` 无发射方）。
- **2 级效果：** 设计「后续武器攻击附着冰元素」；代码改为 **范围 +60%**（`rangeBonus += 0.6`），无 `follow_up_attack` / 元素传递。
- **范围升级结构：** 设计 1/3 级 +40%/+60%；代码 1/2/3 级连续三次范围加成（+40%/+60%/+100%），3 级累计 `rangeBonus=3.0`。
- **最大范围 700：** 设计明确数值；代码无对应常量，实际范围取决于 `rangeBonus` 与 `frost_wind` tween（约 `300 * rangeBonus` 位移）。
- **寒风 / 龙卷伤害公式 / 冰元素 / 间隔 / 暴率 / 暴伤：** 与设计一致。
- **冻伤 Buff：** 代码有，设计正文未写（场景描述有）。

---

## 升级表

| 等级 | 设计效果 | 代码效果 |
|------|----------|----------|
| 0 | 锥形冷风；伤害 `2+2×启迪`；间隔 1；范围基准 | `rangeBonus=1.0`；`emitWhirlWind=false`；冻伤 Buff |
| 1 | 范围 +40% | `rangeBonus=1.4` |
| 2 | 后续武器附冰元素 | `rangeBonus=2.0`（**无**附冰逻辑） |
| 3 | 范围 +60% | `rangeBonus=3.0`（代码在 3 级 +100% 倍率） |
| 4 | 冰龙卷 `15+2.5×启迪` | `emitWhirlWind=true`；龙卷伤害 `15+2.5×insight` |
