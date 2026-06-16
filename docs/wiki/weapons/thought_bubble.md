# 思维泡泡 (thought_bubble)

## 概览

| 字段 | 值 |
|------|-----|
| ID | 5 |
| 资源 key | `thought_bubble` |
| 类名 | `ThoughtBubble`（`script/weapon/thought_bubble.gd`，`extends BaseWeapon`） |
| 实现状态 | ✅已实现 |
| 解锁条件 | 设计：启迪首次到达 20；代码：通关结算 `final_results()` 检测 `player.insight == 20` 且未触发过 → `Events.skill_triggered.emit("insight")` → `unlock_weapon("thought_bubble")` |

**场景资源：** `res://scene/weapon/thought_bubble.tscn`  
**泡泡场景：** `res://scene/item/bubble.tscn`  
**音效：** `res://asset/SFX/weapon/thought_bubble.wav`  
**禁用状态：** 不在 `DISABLED_WEAPONS` 中

**场景缺失：** `thought_bubble.tscn` **未设置** `na` 与 `descriptions`（图鉴 `illustrated_handbook.tscn` 有名称「思维泡泡」）。

---

## 设计文档（Just Run2.md）

**章节：** `## 思维泡泡(5)`

**获取方式：** 启迪首次到达 20

**武器描述：** 召唤 3 颗围绕自身的思维泡泡并攻击敌人。攻击 5 次后消失。泡泡每秒旋转一周

**攻击间隔：** 0.6

**伤害：** `[3, 5, 8, 12, 20] + 2 × 等级 + 1 × 魅力 + 2 × 启迪`

**子弹速度：** 200

**基础暴击率：** 5%

**暴击伤害：** 150%

**伤害类型：** 心灵伤害

**升级效果（设计）：**

| 等级 | 效果 |
|------|------|
| 1 级 | 召唤 4 个思维泡泡 |
| 2 级 | 召唤 6 个思维泡泡 |
| 3 级 | 思维泡泡永久存在 |
| 4 级 | 思维泡泡将内外移动，个数 +2 |

---

## 代码实现

**脚本：** `script/weapon/thought_bubble.gd`  
**场景：** `scene/weapon/thought_bubble.tscn`  
**泡泡逻辑：** `script/item/bubble.gd`

### 基础字段（武器脚本）

| 字段 | 值 / 公式 |
|------|-----------|
| `id` | `5` |
| `na` | **未在场景中配置** |
| `descriptions` | **未在场景中配置** |
| `baseDamage` | `[3, 5, 8, 12, 20]` |
| `bubbleAngVel` | `2 * PI`（弧度/秒 → **每秒旋转一周**） |
| `attackInterval` | `0.6` |
| `radius` | `150` |
| `baseCritRate` | `0`（**0%**，非 5%） |
| `baseCritDamage` | `1.5` |
| `bubbleNum` | 初始 `3` |
| `bubbleMaxHit` | 初始 `5`；3 级后 `-1`（永久） |
| `bubbleRadiusMove` | 初始 `false`；4 级 `true` |

### `upgrade()` 分支

```gdscript
1: self.bubbleNum += 1    # 3 → 4
2: self.bubbleNum += 2    # 4 → 6
3: self.bubbleMaxHit = -1 # 永久存在
4:
    self.bubbleRadiusMove = true
    self.bubbleNum += 2   # 6 → 8
```

### `attack()` 行为

1. 清理无效泡泡引用。
2. **非永久模式**（`bubbleMaxHit != -1`）：若场上仍有存活泡泡，**直接 return**（不重复召唤）。
3. **永久模式**（3 级+）：每次攻击先 `queue_free` 全部旧泡泡再重新召唤。
4. 召唤 `bubbleNum` 个泡泡，均匀分布角度 `2π × i / bubbleNum`。
5. `bubble.init(pos, phase, radius=150, angVel, int(calculate_damage()), bubbleMaxHit, bubbleRadiusMove)`。

### `calculate_damage()`

```gdscript
return baseDamage[level] + 2 * level + 1 * player.charisma + 2 * player.insight
```

与设计一致。

### `dearm()`

卸下武器时销毁所有泡泡。

### 泡泡命中（`bubble.gd`）

- 绕玩家旋转：`position = player.global_position + Vector2.from_angle(phase) * radius`。
- `radiusMove=true` 时半径在约 150–450 间周期性变化（`time` 模 6 秒）。
- 命中敌人：
  - `maxHit > 0`：计数减 1，归零销毁。
  - `maxHit == -1`：不销毁，永久攻击。
  - 伤害：`DamageInfo.new(baseDamage, 0, false, 1.0, player, "Psychic")` — **永不暴击**。
- 设计写子弹速度 200；泡泡为环绕 HitArea，**无弹道速度字段**。

---

## 设计 ↔ 代码差异

- **场景元数据：** 缺少 `na`、`descriptions`。
- **基础暴击率：** 设计 5%；代码 `baseCritRate = 0`，且 `bubble.gd` 硬编码 `isCrit = false`。
- **暴击伤害字段：** 武器有 `baseCritDamage = 1.5` 但泡泡命中未使用。
- **子弹速度 200：** 设计有此项；实现为轨道旋转，无对应速度参数。
- **0–3 级召唤逻辑：** 场上泡泡未全部消失前不会再次 `attack()` 召唤（受装甲臂轮次影响）。
- **旋转一周/秒、伤害公式、升级数量、永久/内外移动：** 与设计一致。
- **伤害类型：** 设计「心灵伤害」；代码 `"Psychic"` ✅。

---

## 升级表

| 等级 | 设计效果 | 代码效果 |
|------|----------|----------|
| 0 | 3 泡泡；每泡泡攻击 5 次后消失；间隔 0.6 | `bubbleNum=3`；`bubbleMaxHit=5`；`bubbleRadiusMove=false` |
| 1 | 4 个泡泡 | `bubbleNum=4` |
| 2 | 6 个泡泡 | `bubbleNum=6` |
| 3 | 永久存在 | `bubbleMaxHit=-1`；每次攻击刷新泡泡群 |
| 4 | 内外移动；个数 +2（共 8） | `bubbleRadiusMove=true`；`bubbleNum=8` |
