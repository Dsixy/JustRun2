# 霰弹枪 (shotgun)

## 概览

| 字段 | 值 |
|------|-----|
| ID | 2 |
| 资源 key | `shotgun` |
| 类名 | `Shotgun`（`script/weapon/shotgun.gd`，`extends BaseWeapon`） |
| 实现状态 | ✅已实现 |
| 解锁条件 | 设计文档：初始拥有；**代码未接入默认解锁**（`DEFAULT_WEAPON_UNLOCKS` 仅 `pistol`）；文档示例中装甲臂轮次提及霰弹枪（`Just Run2.md` 装甲臂段落），但当前 `weapon_arm` 脚本未预装霰弹枪 |

**场景资源：** `res://scene/weapon/shotgun.tscn`  
**子弹场景：** `res://scene/item/bullet.tscn`  
**音效：** `res://asset/SFX/weapon/shotgun.wav`  
**禁用状态：** 不在 `DISABLED_WEAPONS` 中

---

## 设计文档（Just Run2.md）

**章节：** `## 霰弹枪(2)`

**获取方式：** 初始拥有

**武器描述：** 以扇面发射 5 颗子弹

**攻击间隔：** 0.9

**伤害数组：** [3, 6, 10, 18, 30]

**子弹个数：** 5

**子弹速度：** 800

**子弹反弹：** 0

**基础暴击率：** 5%

**暴击伤害：** 150%

**伤害类型：** 贯穿伤害

**升级效果（设计）：**

| 等级 | 效果 |
|------|------|
| 1 级 | 额外发射 2 颗子弹 |
| 2 级 | 子弹暴击伤害增加 50% |
| 3 级 | 额外发射 3 颗子弹 |
| 4 级 | 攻击发射 3 波弹幕，攻击间隔缩短至 0.6 |

---

## 代码实现

**脚本：** `script/weapon/shotgun.gd`  
**场景：** `scene/weapon/shotgun.tscn`

### 基础字段

| 字段 | 值 / 公式 |
|------|-----------|
| `id` | `2` |
| `na` | `"霰弹枪"` |
| `descriptions` | `["以扇面发射5颗子弹", "额外发射1颗子弹", "子弹暴击伤害增加50%", "额外发射3颗子弹", "子弹基础伤害额外增加2，攻击间隔减少到0.6s"]` |
| `baseDamage` | `[3, 6, 10, 18, 30]` |
| `bulletSpeed` | `700` |
| `shootAccuracy` | `0.8`（固定，不随熟练变化） |
| `attackInterval` | 初始 `0.9`；4 级后 `0.6` |
| `baseCritRate` | `0.05` |
| `baseCritDamage` | `1.5` |
| `bulletNum` | 初始 `5` |
| `bulletWave` | 初始 `1`；4 级后 `3` |

### `upgrade()` 分支

```gdscript
1: self.bulletNum += 2        # 5 → 7
2: self.baseCritDamage += 0.5 # 1.5 → 2.0
3: self.bulletNum += 3        # 7 → 10
4:
    self.bulletWave = 3
    self.attackInterval = 0.6
```

### `attack()` 行为

1. 对 `bulletWave` 波次循环，每波发射 `bulletNum` 颗子弹。
2. 扇形方向：`target - global_position + Vector2.from_angle(i - bulletNum / 2)`（以索引偏移角度形成扇面）。
3. 每颗子弹加入 `bulletNode`，间隔每波内即时发射，波间 `await 0.05s`。
4. 伤害含暴击判定；`DamageInfo` 无元素类型。

### `calculate_damage()`

```gdscript
return self.baseDamage[self.level] + 0.6 * self.level + 0.2 * self.player.dexterrity
```

**额外缩放（设计文档未记载）：** `+0.6 × 等级 + 0.2 × 熟练`

---

## 设计 ↔ 代码差异

- **解锁：** 设计「初始拥有」；代码无默认解锁。
- **子弹速度：** 设计 `800`，代码 `700`。
- **精准度：** 设计未单独列出；代码固定 `0.8`，不随熟练缩放。
- **1 级子弹数文案：** 场景写「额外发射 **1** 颗」；设计与代码均为 **+2**（7 颗）。
- **4 级描述：** 场景写「基础伤害额外增加 2」；代码 4 级仅 `bulletWave=3` 与 `attackInterval=0.6`，**无**额外 +2 基础伤害字段（但 `calculate_damage()` 因 `level` 项已含 `0.6×level` 被动成长）。
- **伤害公式：** 代码有 `+0.6×level + 0.2×dexterrity`，设计仅列出数组 `[3,6,10,18,30]`。
- **扇面 / 多波 / 暴伤升级 / 间隔缩短：** 与设计一致。

---

## 升级表

| 等级 | 设计效果 | 代码效果 |
|------|----------|----------|
| 0 | 5 弹扇面；伤害 3；间隔 0.9；暴伤 150% | `bulletNum=5`；`bulletWave=1`；`attackInterval=0.9`；实际伤害 `3+0+0.2×熟练` |
| 1 | 额外 +2 弹（共 7） | `bulletNum=7` |
| 2 | 暴伤 +50% | `baseCritDamage=2.0` |
| 3 | 额外 +3 弹（共 10） | `bulletNum=10` |
| 4 | 3 波弹幕；间隔 0.6 | `bulletWave=3`；`attackInterval=0.6`；伤害含 `+2.4+0.2×熟练`（来自 level 项） |
