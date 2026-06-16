# 花刀玉手 (falling_blossom)

## 概览

| 字段 | 值 |
|------|-----|
| ID | 4 |
| 资源 key | `falling_blossom` |
| 类名 | `FallingBlossom`（`script/weapon/falling_blossom.gd`，`extends BaseWeapon`） |
| 实现状态 | ✅已实现 |
| 解锁条件 | 设计：解锁阿女获取；剧情第 **6** 波 `first_to_wave_6` 触发 `alew_come()` → `unlock_character("alew")` + `unlock_weapon("falling_blossom")` 并赠送武器；阿女装甲臂 `lady` 槽位 1 预装花刀 |

**场景资源：** `res://scene/weapon/falling_blossom.tscn`  
**斩击特效：** `res://scene/effect/slash.tscn`（`slashScene`）  
**音效：** `res://asset/SFX/weapon/falling_blossom.mp3`  
**禁用状态：** 不在 `DISABLED_WEAPONS` 中

**剧情注记：** 设计文档写第 20 波；`patch.md` / 代码为第 **6** 波（`first_to_wave_6`）。

---

## 设计文档（Just Run2.md）

**章节：** `## 花刀玉手(4)`

**获取方式：** 解锁阿女获取

**武器描述：** 刺出 3 道令人眼花缭乱的剑势，如落英缤纷。

**0 级 DPS：** 11.67

**满级 DPS：** 166.7 / 330

**攻击间隔：** 0

**伤害：** `[2, 3, 5, 10, 20] + 0.5 × 力量 × (0.1 × 熟练 + 1)`

**基础暴击率：** 5%

**暴击伤害：** 200%

**伤害类型：** 劈砍伤害

**升级效果（设计）：**

| 等级 | 效果 |
|------|------|
| 1 级 | 花刀范围增加 40% |
| 2 级 | 花刀追加一刀 |
| 3 级 | 花刀范围增加 120% |
| 4 级 | 花刀追加两刀，命中敌人回复 1 点生命值 |

---

## 代码实现

**脚本：** `script/weapon/falling_blossom.gd`  
**场景：** `scene/weapon/falling_blossom.tscn`

### 基础字段

| 字段 | 值 / 公式 |
|------|-----------|
| `id` | `4` |
| `na` | `"花刀玉手"` |
| `descriptions` | `["刺出3道令人眼花缭乱的剑势，如落英缤纷。", "花刀范围增加40%", "花刀追加一刀剑势", "花刀范围额外增加60%", "花刀追加两刀，命中敌人回复1点生命值"]` |
| `baseDamage` | `[2, 3, 5, 10, 20]` |
| `attackInterval` | `1.0` |
| `slashScale` | 初始 `1.0` |
| `baseCritRate` | `0.05` |
| `baseCritDamage` | `2.0` |
| `lifeSteal` | 初始 `0`；4 级 `1.0` |
| `anis` | `["flowerSlash", "backFlowerSlash2", "flowerSlash2"]`（3 段） |

### `upgrade()` 分支

```gdscript
1: self.slashScale += 0.4           # +40%
2: self.anis.append("backFlowerSlash") # +1 段 → 4 段
3: self.slashScale += 1.2            # 累计 slashScale = 2.6
4:
    self.anis = ["flowerSlash", "backFlowerSlash2",
                 "flowerSlash3", "backFlowerSlash",
                 "flowerSlash2", "backFlowerSlash3"]  # 6 段
    self.lifeSteal = 1.0
```

### `attack()` 行为

1. 遍历 `anis`，每段实例化 `slashScene`，挂 `player`。
2. `slash.init(ani, direction, damage, slashScale * 3)`。
3. `slash.lifeSteal = lifeSteal`（4 级命中回血 1 HP，见 `slash.gd`：`damage.source.HP += lifeSteal`）。
4. 段间间隔 `0.1s`。
5. 伤害 `DamageInfo` 无元素类型（默认 `""`）。

### `calculate_damage(name)`

```gdscript
return baseDamage[level] + 0.5 * player.strength * (0.1 * player.dexterrity + 1)
```

与设计公式一致。

### 阿女装甲臂（`lady.gd`）

- `weaponList = [null, falling_blossom, null, null]`
- 轮次：`[[weaponList[0], weaponList[1]], [weaponList[2], weaponList[3]]]`

---

## 设计 ↔ 代码差异

- **解锁波次：** 设计第 20 波；代码 / 补丁第 **6** 波（`first_to_wave_6`）。
- **攻击间隔：** 设计 `0`；代码 `attackInterval = 1.0`（装甲臂 CD 受此约束）。
- **3 级范围：** 设计「增加 **120%**」；代码 1 级 +0.4、3 级 +1.2 → `slashScale = 2.6`（相对基础 +160%）；场景描述写「额外增加 **60%**」。
- **2 级追加一刀：** 设计 +1 刀；代码 `append` 1 段动画（4 段）✅。
- **4 级追加两刀：** 设计 +2 刀；代码将 `anis` 重置为 **6 段**（相对 0 级 3 段为 +3 段；相对 2 级 4 段为 +2 段）✅。
- **伤害类型：** 设计「劈砍伤害」；代码未指定 `damageType`。
- **伤害公式 / 暴率 / 暴伤 / 吸血：** 与设计一致。

---

## 升级表

| 等级 | 设计效果 | 代码效果 |
|------|----------|----------|
| 0 | 3 段剑势；伤害 `2+0.5×力量×(0.1×熟练+1)`；间隔 0 | 3 段 `anis`；`slashScale=1.0`；`attackInterval=1.0` |
| 1 | 范围 +40% | `slashScale=1.4` |
| 2 | 追加 1 刀 | `anis` 4 段（含 `backFlowerSlash`） |
| 3 | 范围 +120% | `slashScale=2.6` |
| 4 | 追加 2 刀；命中回血 1 | 6 段 `anis`；`lifeSteal=1.0` |
