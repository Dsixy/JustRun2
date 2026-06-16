# 香水瓶（Perfume Bottle）

| 字段 | 值 |
|------|-----|
| **ID** | 16 |
| **资源 Key** | `perfume_bottle` |
| **场景** | `scene/weapon/perfume_bottle.tscn` |
| **脚本** | `script/weapon/perfume_bottle.gd` |
| **喷射** | `scene/effect/spray.tscn` → `script/effect/spray.gd` |
| **解锁（设计）** | 累计获取 **100** 个植物 |
| **解锁（代码）** | 📋 **未接入**（POLISH-A10 跨局计数） |
| **香氛累积** | 拾取 group `flower` 时，若装甲臂含 id=16 武器，调用 `weapon.gain(item.n)` |

---

## 概览

香水瓶是 **方向性毒素喷雾**，伤害与多种 **植物香氛值** 联动。玩家本局拾取植物（风信子、蓝山绿叶、酒色玫瑰、雨滴茉莉、猫薄荷）会累积对应计数（受 **香氛上限** 约束），喷射时按计数加成 **伤害、范围、飞行速度、毒 DoT**。设计为成长型 build 武器；**无法暴击**。4 级提升各植物边际收益并提高上限。

---

## 设计文档

来源：`docs/Just Run2.md` § 香水瓶(16)

### 获取方式

累计获取 **100** 个植物。

### 攻击描述

向前喷射香氛；按收集的植物获得 **香氛值**（总和上限 **20**）；攻击按香氛值附加效果。

### 植物边际（设计）

| 植物 | 0~3 级 / 4 级 效果 |
|------|---------------------|
| 风信子 Hyacinth | 每点 **+0.3 / +0.8** 基础伤害 |
| 蓝山绿叶 BlueMountainLeaf | 每点 **+3% / +6%** 范围 |
| 酒色玫瑰 WineRose | 每点 **-0.01** 攻击间隔；4 级每点 **+10** 飞行速度 |
| 雨滴茉莉 RaindropJasmine | 毒伤 **+1 / +1.5** 每点 |
| 猫薄荷 Catnip | 获得 **流浪猫咪商人** 青睐 |

### 升级（设计）

| 等级 | 效果 |
|------|------|
| 1 / 3 | 范围 **+40% / +100%** |
| 2 | 每拾一朵植物 **额外 +2** 香氛值 |
| 4 | 能力上限 **+30**；各植物能力提升（见上表 4 级列） |

### 数值（设计）

| 属性 | 值 |
|------|-----|
| 0 级 DPS | **8.75** |
| 满级 DPS | **963**（+ 毒附加 DPS 75） |
| 攻击间隔 | **0.8** s |
| 基础伤害 `[0~4]` | `[5, 7, 9, 11, 15]` |
| 基础暴击率 | **0%** |
| 伤害类型 | **毒素伤害** |

---

## 代码实现

### 武器脚本 `perfume_bottle.gd`

**初始**

| 变量 | 值 |
|------|-----|
| `range` | 1.0 |
| `attackInterval` | **0.8**（固定，**不受** WineRose 影响） |
| `baseCritRate` | 0 |
| `damageBonus` | **2**（风信子倍率；L4→**5**） |
| `rangeBonus` | **0.03**（绿叶；L4→**0.06**） |
| `intervalBonus` | 0.01（**未使用**） |
| `speedBonus` | 0（L4→**4**，非 10） |
| `poisonBonus` | **0.3**（茉莉；L4→**0.8**） |
| `maxContent` | 20（L4→**50**） |
| `oneCollect` | 0（L2→**4**，非 2） |
| `curContent` | 当前总香氛 |

**`collections` 键**：`Hyacinth`, `BlueMountainLeaf`, `RaindropJasmine`, `WineRose`, `Catnip`。

**`upgrade()`**

| 等级 | 代码 |
|------|------|
| 1 | `range += 0.4` |
| 2 | `oneCollect = 4` |
| 3 | `range += 1` |
| 4 | `damageBonus=5`; `rangeBonus=0.06`; `speedBonus=4`; `poisonBonus=0.8`; `maxContent+=30` |

**`attack()`**

```text
direction = normalize(mouse - pos)
spray.init(pos, direction,
  range + rangeBonus * collections["BlueMountainLeaf"],
  400 + speedBonus * collections["WineRose"],
  damage, poisonBonus * collections["RaindropJasmine"])
```

**`calculate_damage()`**

```text
baseDamage[level] + damageBonus * collections["Hyacinth"]
```

**`gain(name)`**

```text
if curContent <= maxContent:
  collections[name] += oneCollect
  curContent += oneCollect
```

- **0~1 级**：`oneCollect=0` → 拾花 **不增加** 香氛。
- **Catnip** 仅计数，**无商人逻辑**。

### 喷射 `spray.gd`

- 粒子与 HitArea 向前 spread；lifetime `400/speed`。
- 敌人：`be_hit(damage)` + 添加 `poison_buff`，Buff 伤害 `+= extraDamage`（茉莉加成）。
- 直伤 `DamageInfo` 未设 Poison type。

### 拾取链 `base_player.gd`

- group `flower` → `item.on_picked_up` + 若 `weapon.id==16` 则 `gain(item.n)`。

---

## 设计 ↔ 代码差异

| 主题 | 设计 | 代码 |
|------|------|------|
| 解锁 100 植物 | 是 | 未实现 |
| 风信子加成 | 0.3/0.8 | **2/5** 每点 |
| 绿叶范围 | 3%/6% | **0.03/0.06** 绝对加算 |
| 玫瑰间隔 | -0.01/点 | **未实现** |
| 玫瑰速度 | 4 级 +10/点 | **+4/点** |
| 茉莉毒伤 | 1/1.5 | **0.3/0.8** |
| 猫薄荷 | 商人青睐 | **无** |
| 2 级拾取 | +2 香氛/朵 | `oneCollect=4` |
| 0~1 级拾花 | 应有香氛 | `oneCollect=0` **无效** |

---

## 升级表

无植物拾取时（香氛全 0）。

| 等级 | 设计范围 | 代码 `range` | `oneCollect` | `maxContent` | 风信子系数 | 面板伤害 | 间隔 |
|------|----------|--------------|--------------|--------------|------------|----------|------|
| **0** | — | 1.0 | 0 | 20 | ×2/点 | 5 | 0.8s |
| **1** | +40% | 1.4 | 0 | 20 | ×2 | 7 | 0.8s |
| **2** | +2/朵 | 1.4 | **4** | 20 | ×2 | 9 | 0.8s |
| **3** | +100% | 2.4 | 4 | 20 | ×2 | 11 | 0.8s |
| **4** | 上限+30 | 2.4 | 4 | **50** | **×5** | 15 | 0.8s |

**有香氛时的攻击参数（代码）**

| 参数 | 公式 |
|------|------|
| 直伤 | `baseDamage[level] + damageBonus × 风信子数` |
| 喷雾 range | `range + rangeBonus × 绿叶数` |
| 粒子速度 | `400 + speedBonus × 玫瑰数` |
| 毒 Buff 附加 | `poisonBonus × 茉莉数` |

**设计 DPS 参考**：0 级 8.75；满级 963 + 毒 75（理想堆叠；实装系数不同）。
