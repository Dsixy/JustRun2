# 手枪 (pistol)

## 概览

| 字段 | 值 |
|------|-----|
| ID | 0 |
| 资源 key | `pistol` |
| 类名 | `Pistol`（`script/weapon/pistol.gd`，`extends BaseWeapon`） |
| 实现状态 | ✅已实现 |
| 解锁条件 | 新档默认解锁（`GameInfo.DEFAULT_WEAPON_UNLOCKS = ["pistol"]`）；阿猴装甲臂 `awu_kong` 槽位 1 预装 1 把手枪 |

**场景资源：** `res://scene/weapon/pistol.tscn`  
**子弹场景：** `res://scene/item/bullet.tscn`  
**音效：** `res://asset/SFX/weapon/pistol_shot.wav`  
**禁用状态：** 不在 `GameInfo.DISABLED_WEAPONS` 中

---

## 设计文档（Just Run2.md）

**章节：** `## 手枪(0)`

**获取方式：** 初始拥有。

**武器描述：** 拥有均衡的属性。

**0 级 DPS：** 12.5

**满级 DPS：** 100

**精准度：** 0.7 + 0.01 × 熟练

**攻击间隔：** 0.8 − 0.03 × 熟练

**伤害数组：** 10 / 20 / 35 / 60 / 100

**子弹速度：** 500

**子弹反弹：** 0

**基础暴击率：** 5%

**暴击伤害：** 200%

**伤害类型：** 贯穿伤害

**升级效果（设计）：**

| 等级 | 效果 |
|------|------|
| 1 级 | 暴击伤害增加 50% |
| 2 级 | 攻击 15% 概率发射 4 枚连锁弹 |
| 3 级 | 暴击率增加 30% |
| 4 级 | 连锁弹发射概率提升 25%，子弹数增加 2 |

---

## 代码实现

**脚本：** `script/weapon/pistol.gd`  
**场景：** `scene/weapon/pistol.tscn`

### 基础字段（.gd）

| 字段 | 值 / 公式 |
|------|-----------|
| `id` | `0`（`base_weapon.gd` 默认值；`pistol.tscn` 未覆盖） |
| `na` | `"手枪"` |
| `descriptions` | `["平平无奇", "暴击伤害增加50%", "攻击5%概率发射4枚连锁弹。", "暴击率增加30%", "连锁弹发射概率提升25%，子弹数增加2"]` |
| `baseDamage` | `[10, 20, 35, 60, 100]` |
| `bulletSpeed` | `1000` |
| `shootAccuracy` | `0.8 + player.dexterrity * 0.01`（getter） |
| `attackInterval` | `0.8 - player.dexterrity * 0.03`（getter） |
| `baseCritRate` | `0.05` |
| `baseCritDamage` | `2.0`（即 200%） |
| `chainFire` | 初始 `0.0`；2 级后 `0.15`；4 级后 `0.4` |
| `chainFireNum` | 初始 `4`；4 级后 `6`（`+= 2`） |

### `upgrade()` 分支

```gdscript
if self.level <= 3:
    self.level += 1
    match self.level:
        1: self.baseCritDamage += 0.5      # 暴伤 +50%
        2: self.chainFire = 0.15          # 15% 连锁
        3: self.baseCritRate += 0.3      # 暴击率 +30%
        4:
            self.chainFire = 0.4          # 连锁概率 40%
            self.chainFireNum += 2        # 连锁弹 6 枚
```

### `attack()` 行为

1. 以鼠标位置计算射击方向。
2. 默认发射 1 颗子弹；若 `randf() < chainFire`，则发射 `chainFireNum` 颗。
3. 每颗子弹：
   - 实例化 `bulletScene`，加入 `GameInfo.mainscene.bulletNode`。
   - 精准偏差：`direction.orthogonal() * (randf() * 2 - 1) * (1 - shootAccuracy)`。
   - 伤害：`DamageInfo.new(calculate_damage(), 0, randf() < baseCritRate + player.critRate, baseCritDamage, player)`（伤害类型默认 `""`，非元素）。
   - `bullet.init(global_position, direction + bias, bulletSpeed, damage)`。
   - 子弹间隔 `0.06s`（`await`）。

### `calculate_damage()`

```gdscript
return self.baseDamage[self.level]
```

无额外属性缩放。

### 关联子弹逻辑（`script/item/bullet.gd`）

- 直线飞行，`pierce` 默认 `0`，命中敌人后销毁（除非 pierce > 0）。
- 最大飞行距离 `max_path = 3000`。

---

## 设计 ↔ 代码差异

- **子弹速度：** 设计 `500`，代码 `1000`。
- **精准度基础值：** 设计 `0.7 + 0.01 × 熟练`，代码 `0.8 + 0.01 × 熟练`。
- **2 级连锁概率文案：** 场景 `descriptions[2]` 写「5%」，设计与代码均为 **15%**（`chainFire = 0.15`）。
- **伤害类型：** 设计「贯穿伤害」；代码 `DamageInfo` 未指定 `damageType`（空字符串）。
- **DPS：** 设计给出 0 级 12.5 / 满级 100；代码无 DPS 字段，实际 DPS 受连锁弹随机触发影响。
- **攻击间隔 / 熟练缩放：** 与设计一致（`0.8 - 0.03 × dexterrity`）。
- **伤害数组：** 与设计一致。
- **升级数值逻辑：** 与设计一致（暴伤、连锁概率、暴击率、连锁弹数量）。

---

## 升级表

| 等级 | 设计效果 | 代码效果 |
|------|----------|----------|
| 0 | 均衡远程；伤害 10；暴率 5%；暴伤 200%；间隔 0.8−0.03熟练；精准 0.7+0.01熟练 | `baseDamage[0]=10`；`baseCritRate=0.05`；`baseCritDamage=2.0`；`chainFire=0`；精准 `0.8+0.01×熟练`；间隔 `0.8−0.03×熟练` |
| 1 | 暴击伤害 +50% | `baseCritDamage` 变为 `2.5`（+50%） |
| 2 | 15% 概率发射 4 枚连锁弹 | `chainFire = 0.15`；`chainFireNum = 4` |
| 3 | 暴击率 +30% | `baseCritRate = 0.35` |
| 4 | 连锁概率 +25%（至 40%），子弹数 +2（至 6 枚） | `chainFire = 0.4`；`chainFireNum = 6` |
