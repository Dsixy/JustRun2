# 群星之怒（Stellar Wrath）

| 字段 | 值 |
|------|-----|
| **ID** | 7 |
| **资源 Key** | `stellar_wrath` |
| **场景** | `scene/weapon/stellar_wrath.tscn` |
| **脚本** | `script/weapon/stellar_wrath.gd` |
| **特效** | `scene/item/star.tscn` → `script/item/star.gd`；爆炸 `scene/effect/poker_explode.tscn` |
| **解锁（设计）** | 使用 **卡莫（Carmor）** 累计击杀 **5000** 敌人 |
| **解锁（代码）** | 📋 **未接入**（`GameInfo.unlock_weapon` 无对应事件；`POLISH-A07` 待做） |
| **商店池** | 解锁后进入 `WeaponUnlock` 池（`GameInfo.refresh()`） |

---

## 概览

群星之怒是一类 **延迟落点 AOE** 武器：每次攻击在屏幕上现有子弹的位置（最多 `starNum` 个）召唤流星，约 **2 秒** 后坠地爆炸，造成范围伤害。伤害随 **等级** 与 **启迪（insight）** 缩放；可暴击。设计定位为 **力场伤害**、中等攻速（0.6s）、偏区域清场。

**核心机制**

- 目标选点：设计为「鼠标位置 + 场上随机 3 个子弹位置」；代码 **仅** 从 `bulletNode` 内、处于 1920×1080 视口内的子弹取点。
- 4 级前：若场上可见子弹不足 `starNum`，实际流星数 **少于** 配置数量。
- 4 级 `alwaysFall`：不足部分在玩家周围随机补点，保证每次攻击满 `starNum` 颗。
- 爆炸半径：`attackRadius(150) × attackBonus`；升级叠加 `attackBonus` 而非直接改 `attackRadius` 变量。

**装甲臂轮射**

- 继承 `BaseWeapon`，由 `BaseWeaponArm` 按 `attackInterval` 调用 `attack()`。
- 武器节点 `hide()`，仅作逻辑容器。

---

## 设计文档

来源：`docs/Just Run2.md` § 群星之怒(7)

### 获取方式

使用 **carmor** 杀死 **5000** 个敌人（跨局累计，按角色统计 — 补丁/POLISH 要求，代码未实现）。

### 攻击描述

向 **鼠标位置** 与场上 **随机 3 个子弹** 所在位置释放流星。流星会在 **1s** 后降落。

### 升级（设计）

| 等级 | 效果 |
|------|------|
| 1 | 流星范围增加 **40%** |
| 2 | 流星数量增加 **2** 颗 |
| 3 | 流星范围增加 **80%**（相对基础，与 1 级叠加语义见差异节） |
| 4 | 流星数量再增加 **4** 颗；场上子弹不足时，多余流星 **随机降落** |

### 数值（设计）

| 属性 | 值 |
|------|-----|
| 攻击间隔 | **0.6** s |
| 基础伤害 `[0~4]` | `[3, 5, 9, 15, 30]` |
| 伤害加成 | `+ 1.5 × 等级 × (2 + 0.2 × 启迪)` |
| 基础暴击率 | 5% |
| 暴击伤害 | 200% |
| 伤害类型 | **力场伤害** |

---

## 代码实现

### 武器脚本 `stellar_wrath.gd`

**初始状态（0 级）**

| 变量 | 值 | 含义 |
|------|-----|------|
| `attackInterval` | `0.6` | 轮射间隔 |
| `baseCritRate` | `0.05` | 武器基础暴击 |
| `baseCritDamage` | `2.0` | 暴击倍率 |
| `starNum` | `3` | 每次攻击流星数 |
| `attackRadius` | `150` | 爆炸基础半径（像素） |
| `attackBonus` | `1.0` | 半径乘数 |
| `alwaysFall` | `false` | 4 级开启子弹不足补点 |
| `baseDamage` | `[3,5,9,15,30]` | 各级基础面板 |

**`upgrade()`**（`level` 0→1→2→3→4，每次 `level <= 3` 时执行）

| 新等级 | 代码效果 |
|--------|----------|
| 1 | `attackBonus += 0.4` → 半径 ×1.4 |
| 2 | `starNum += 2` → 共 5 颗 |
| 3 | `attackBonus += 0.8` → 相对初始累计 ×2.2 |
| 4 | `starNum += 4` → 共 9 颗；`alwaysFall = true` |

**`attack()`**

1. `get_target_positions()` 得到落点数组。
2. 每点 `starScene.instantiate()`，挂到 `GameInfo.mainscene.effectNode`。
3. `DamageInfo(calculate_damage(), 0, critRoll, baseCritDamage, player)` — **未传 `damageType`**，默认为 `""`。
4. `star.init(targetPos, attackRadius * attackBonus, damage)`。

**`calculate_damage()`**

```text
baseDamage[level] + 1.5 * level * (2 + 0.2 * player.insight)
```

**`get_target_positions()`**

1. 视口矩形：相机中心 ± (960, 540)。
2. 收集 `bulletNode` 子节点中 `global_position` 在视口内的子弹。
3. 若 `alwaysFall`：在玩家位置 + 随机偏移补 `(starNum - len(bulletList))` 个点。
4. 再取 `min(len(bulletList), starNum)` 个子弹的 `global_position`。
5. **不包含鼠标位置**。

### 流星实体 `star.gd`

- `init(target_pos, radius, damage)` 保存参数并调用 `fall(target_pos)`。
- `fall(..., dur=2.0)`：Tween 约 **2.0s** 自高空落到 `target_pos`（非设计 1s）。
- `on_ground()`：实例化 `explodeScene`（`poker_explode`），`explode.init(target_pos, damage, 0.3, radius)`，流星节点销毁。
- 爆炸持续 **0.3s**（`poker_explode.gd`）。

### 场景 `stellar_wrath.tscn`

| 字段 | 值 |
|------|-----|
| `id` | 7 |
| `na` | 群星之怒 |
| `starScene` | `scene/item/star.tscn` |
| `descriptions[0~4]` | 见差异节（与脚本升级顺序 **不一致**） |

---

## 设计 ↔ 代码差异

| 主题 | 设计文档 | 场景 UI 文案 | 代码实现 |
|------|----------|--------------|----------|
| 解锁 | 卡莫杀 5000 | — | 无事件 📋 |
| 落点 | 鼠标 + 3 子弹 | 随机 3 子弹 | 仅子弹；4 级前可 **0 颗** |
| 降落延迟 | 1s | 1s | **2s** (`star.gd`) |
| 1 级升级 | 范围 +40% | 「最大流星数量+2」 | 范围 +40% |
| 2 级升级 | 数量 +2 | 「流星范围增加40%」 | 数量 +2 |
| 3 级升级 | 范围 +80% | 「最大流星额外数量+3」 | 范围 +80% |
| 4 级升级 | 数量 +4 + 随机补点 | 范围 +60% + 子弹不足随机 | 数量 +4 + `alwaysFall` |
| 伤害类型 | 力场 | — | `damageType=""` |

---

## 升级表

假设启迪 = 0，暴击期望未计入 DPS。

| 等级 | 设计效果 | 代码效果 | `starNum` | 爆炸半径（约） | 单次伤害（insight=0） | 间隔 |
|------|----------|----------|-----------|----------------|----------------------|------|
| **0** | 3 落点（+鼠标） | 最多 3 颗，仅子弹 | 3 | 150 | `3` | 0.6s |
| **1** | 范围 +40% | `attackBonus=1.4` | 3 | 210 | `8` | 0.6s |
| **2** | 数量 +2 | `starNum=5` | 5 | 210 | `15` | 0.6s |
| **3** | 范围 +80% | `attackBonus=2.2` | 5 | 330 | `24` | 0.6s |
| **4** | +4 颗；子弹不足随机 | `starNum=9`, `alwaysFall` | 9 | 330 | `42` | 0.6s |

**合成规则**：同 ID、同级拖拽合并，`level < 4` 时调用 `upgrade()`。

**暴击**：`randf() < 0.05 + player.critRate`，暴伤 ×2.0。
