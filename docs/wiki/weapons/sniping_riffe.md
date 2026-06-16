# 狙击枪 (sniping_riffe)

## 概览

| 字段 | 值 |
|------|-----|
| ID | 1 |
| 资源 key | `sniping_riffe`（文件名拼写为 riffe，非 rifle） |
| 类名 | `SnipingRiffe`（`script/weapon/sniping_riffe.gd`，`extends BaseWeapon`） |
| 实现状态 | ✅已实现 |
| 解锁条件 | 设计文档：初始拥有；**代码未接入默认解锁**（`DEFAULT_WEAPON_UNLOCKS` 仅含 `pistol`）；无专属 `unlock_weapon` 事件；可通过作弊武器栏 `get_all_weapon_scene_paths()` 获取场景路径 |

**场景资源：** `res://scene/weapon/sniping_riffe.tscn`  
**子弹场景：** `res://scene/item/bullet.tscn`  
**音效：** `res://asset/SFX/weapon/rifle.wav`  
**禁用状态：** 不在 `DISABLED_WEAPONS` 中

---

## 设计文档（Just Run2.md）

**章节：** `## 狙击枪(1)`

**获取方式：** 初始拥有。

**武器描述：** 低攻速但高伤害。

**精准度：** 1

**攻击间隔：** 2 − 0.05 × 熟练

**伤害数组：** 25，50，80，180，350

**子弹速度：** 2000

**子弹反弹：** 0

**基础暴击率：** 35%

**暴击伤害：** 200%

**伤害类型：** 贯穿伤害

**升级效果（设计）：**

| 等级 | 效果 |
|------|------|
| 1 级 | 暴击后贯穿 1 次 |
| 2 级 | 暴击伤害增加 50% |
| 3 级 | 暴击后贯穿 7 次 |
| 4 级 | 暴击伤害增加 150%，狙击枪造成火元素伤害 |

---

## 代码实现

**脚本：** `script/weapon/sniping_riffe.gd`  
**场景：** `scene/weapon/sniping_riffe.tscn`

### 基础字段（.gd / .tscn）

| 字段 | 值 / 公式 |
|------|-----------|
| `id` | `1` |
| `na` | `"狙击枪"` |
| `descriptions` | `["低攻速但高伤害。", "暴击后贯穿1次", "基础伤害+10", "暴击后贯穿7次", "狙击枪基础伤害额外+15，暴击伤害增加50%"]` |
| `baseDamage` | `[25, 50, 80, 180, 350]` |
| `bulletSpeed` | `2000` |
| `shootAccuracy` | `1.0`（固定） |
| `attackInterval` | `2 - player.dexterrity * 0.1`（getter） |
| `baseCritRate` | `0.35` |
| `baseCritDamage` | `2.0` |
| `critPierce` | 初始 `0`；1 级 `1`；3 级 `7` |

### `upgrade()` 分支

```gdscript
match self.level:
    1: self.critPierce = 1
    2: self.baseCritDamage += 0.5      # 暴伤 +50%
    3: self.critPierce = 7
    4: self.baseCritDamage += 1.5      # 暴伤再 +150%（累计 +200% 于基础）
```

**注意：** 2 级、4 级**无**基础伤害 +10 / +15 的实现。

### `attack()` 行为

1. 实例化子弹，加入 `GameInfo.mainscene`（非 `bulletNode`）。
2. 方向指向鼠标；精准偏差公式与手枪相同（`shootAccuracy=1` 时偏差为 0）。
3. 先掷暴击：`DamageInfo.new(calculate_damage(), 0, randf() < baseCritRate + player.critRate, baseCritDamage, player)`。
4. **仅当暴击时** 设置 `bullet.pierce = critPierce`。
5. `bullet.init(...)` 发射。

### `calculate_damage()`

```gdscript
return self.baseDamage[self.level]
```

### 贯穿机制（`bullet.gd`）

- `pierce` 每命中一名敌人减 1；`pierce <= 0` 时销毁子弹。
- `critPierce = 1` → 最多再贯穿 1 名敌人；`critPierce = 7` → 最多再贯穿 7 名。

---

## 设计 ↔ 代码差异

- **解锁：** 设计「初始拥有」；代码无默认解锁事件（仅手枪默认解锁）。
- **攻击间隔熟练系数：** 设计 `−0.05 × 熟练`；代码 `−0.1 × dexterrity`（熟练即 `dexterrity`）。
- **4 级火元素：** 设计「造成火元素伤害」；代码 `DamageInfo` 未传 `"Fire"` 类型。
- **场景 descriptions 与代码不符：**
  - `descriptions[2]` 写「基础伤害+10」→ 代码 2 级仅 `baseCritDamage += 0.5`。
  - `descriptions[4]` 写「基础伤害额外+15，暴击伤害增加50%」→ 代码 4 级为 `baseCritDamage += 1.5`（+150%），无基础伤害加成。
- **伤害数组 / 子弹速度 / 暴率：** 与设计一致。
- **暴击贯穿 1/7 次：** 与设计一致（仅暴击触发）。

---

## 升级表

| 等级 | 设计效果 | 代码效果 |
|------|----------|----------|
| 0 | 伤害 25；暴率 35%；暴伤 200%；间隔 2−0.05熟练；精准 1 | `baseDamage[0]=25`；`critPierce=0`；间隔 `2−0.1×熟练` |
| 1 | 暴击后贯穿 1 次 | `critPierce = 1` |
| 2 | 暴击伤害 +50% | `baseCritDamage = 2.5`（无基础伤害 +10） |
| 3 | 暴击后贯穿 7 次 | `critPierce = 7` |
| 4 | 暴伤 +150%，火元素伤害 | `baseCritDamage = 4.0`；**无**火元素类型；**无**基础伤害 +15 |
