# 激光剑 (laser_sword)

## 概览

| 字段 | 值 |
|------|-----|
| ID | 3 |
| 资源 key | `laser_sword` |
| 类名 | `LaserSword`（`script/weapon/laser_sword.gd`，`extends BaseWeapon`） |
| 实现状态 | ✅已实现 |
| 解锁条件 | 设计文档：初始拥有；**代码未接入默认解锁** |

**场景资源：** `res://scene/weapon/laser_sword.tscn`  
**斩击特效：** `res://scene/effect/slash.tscn`（`circleSlashScene`）  
**音效：** `res://asset/SFX/weapon/laser_sword.wav`  
**禁用状态：** 不在 `DISABLED_WEAPONS` 中

---

## 设计文档（Just Run2.md）

**章节：** `## 激光剑(3)`

**获取方式：** 初始拥有。

**武器描述：** 发动左劈，右劈攻击。

**0 级 DPS：** 11

**满级 DPS：** 206

**攻击间隔：** 0.6

**伤害：**

- 左右劈：`[3, 6, 15, 27, 40] + 4 × 力量`
- 穿刺：`[5, 12, 25, 55, 150] + 6 × 力量`

**基础暴击率：** 5%

**暴击伤害：** 200%

**伤害类型：** 劈砍伤害（左右劈）；贯穿伤害（戳刺）

**元素伤害：** 电元素

**升级效果（设计）：**

| 等级 | 效果 |
|------|------|
| 1 级 | 攻击范围增加 20% |
| 2 级 | 会发动刺击 |
| 3 级 | 攻击范围增加 45% |
| 4 级 | 穿刺必定暴击且暴击伤害提高 200% |

---

## 代码实现

**脚本：** `script/weapon/laser_sword.gd`  
**场景：** `scene/weapon/laser_sword.tscn`

### 基础字段

| 字段 | 值 / 公式 |
|------|-----------|
| `id` | `3` |
| `na` | `"激光剑"` |
| `descriptions` | `["发动左劈，右劈攻击。", "攻击范围增加20%", "攻击额外发动一次刺击。", "攻击范围额外增加40%", "穿刺必定暴击且暴击伤害挺高200%"]` |
| `baseDamage` | `[3, 6, 15, 27, 40]`（左右劈） |
| `pierceDamage` | `[5, 12, 25, 55, 150]`（穿刺） |
| `attackInterval` | `0.6` |
| `slashScale` | 初始 `1.0` |
| `baseCritRate` | `0.05` |
| `baseCritDamage` | `2.0` |
| `pierceCritRate` | 初始 `0.05` |
| `pierceCritDamage` | 初始 `2.0` |
| `anis` | `["circleSlash", "backCircleSlash"]` |

### `upgrade()` 分支

```gdscript
1: self.slashScale += 0.2           # 范围 +20%
2: self.anis.append("pierce")       # 追加刺击动画
3: self.slashScale += 0.45          # 累计 +65%（1.0→1.65）
4:
    self.pierceCritRate = 1.0       # 穿刺必暴
    self.pierceCritDamage += 2      # 穿刺暴伤 2.0→4.0
```

### `attack()` 行为

1. 遍历 `anis` 数组，依次播放每个动画（0 级：左劈 + 右劈；2 级起含 `pierce`）。
2. 实例化 `circleSlashScene`，挂到 `player` 子节点。
3. 方向指向鼠标；调用 `slash.init(ani, direction, damage, slashScale * 4)`。
4. 动画间隔 `0.2s`（`await`）。
5. 单次 `attack()` 内完成所有斩击段，**不**受 `attackInterval` 段间拆分（由装甲臂轮次控制整体 CD）。

### `calculate_damage(name)`

```gdscript
# pierce:
DamageInfo.new(pierceDamage[level] + 6 * player.strength, 0,
    randf() < pierceCritRate + player.critRate, pierceCritDamage, player, "Lightning")
# 左右劈:
DamageInfo.new(baseDamage[level] + 4 * player.strength, 0,
    randf() < baseCritRate + player.critRate, baseCritDamage, player, "Lightning")
```

两种斩击均标记为 `"Lightning"`（电元素），未区分劈砍 / 贯穿字符串类型。

### 斩击特效（`slash.gd`）

- 命中敌人 `be_hit` + 击退 `be_knock_back`。
- 动画结束自动 `queue_free`。

---

## 设计 ↔ 代码差异

- **解锁：** 设计「初始拥有」；代码无默认解锁。
- **3 级范围文案：** 场景写「额外增加 **40%**」；代码 `slashScale += 0.45`（相对基础累计 +65%，与设计「1/3 级 +20%/+45%」一致，但描述索引 3 的 +40% 与 +45% 不符）。
- **伤害类型：** 设计区分劈砍 / 贯穿；代码统一 `"Lightning"`。
- **4 级暴伤：** 设计「提高 200%」；代码 `pierceCritDamage += 2`（从 2.0 到 4.0，即暴伤倍率 ×2 或 +200% 附加，取决于解读）。
- **力量加成 / 伤害数组 / 刺击解锁 / 范围缩放 / 间隔：** 与设计一致。
- **元素：** 设计电元素；代码 `"Lightning"` ✅。

---

## 升级表

| 等级 | 设计效果 | 代码效果 |
|------|----------|----------|
| 0 | 左劈+右劈；劈砍伤害 `3+4×力量`；间隔 0.6 | `anis=["circleSlash","backCircleSlash"]`；`slashScale=1.0` |
| 1 | 范围 +20% | `slashScale=1.2` |
| 2 | 发动刺击 | `anis` 追加 `"pierce"`；穿刺伤害 `5+6×力量` |
| 3 | 范围 +45%（相对基础） | `slashScale=1.65` |
| 4 | 穿刺必暴；暴伤 +200% | `pierceCritRate=1.0`；`pierceCritDamage=4.0` |
