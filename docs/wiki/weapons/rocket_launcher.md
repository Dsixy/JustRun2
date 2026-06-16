# 火箭炮 (rocket_launcher)

| 字段 | 值 |
|------|-----|
| **ID** | **30**（`rocket_launcher.tscn`；设计文档标注 **(20)** ⚠️） |
| **资源 Key** | `rocket_launcher` |
| **场景** | `scene/weapon/rocket_launcher.tscn` |
| **脚本** | `script/weapon/rocket_launcher.gd` |
| **火箭** | `scene/effect/rocket.tscn` |
| **解锁（设计）** | 解锁 **健忘症** 角色 |
| **解锁（代码）** | 📋 健忘症选角注释掉，剧情 TODO |

---

## 概述

向 **鼠标位置** 部署准星，从玩家周围 **随机方向** 发射多枚 **制导火箭**；抵达后 **范围爆炸**。高等级增加准星数量、火箭数量、巨型弹与灼烧。

---

## 设计文档（Just Run2.md）

间隔 1s；伤害 [2,4,8,15,30]；暴伤 150%。

1 级 +2 火箭；2 级 2 个随机准星各 2 火箭；3 级 3 准星各 +2 火箭；4 级巨型 300 伤 + 灼烧。

---

## 基础参数（代码）

| 参数 | 0 级 | 说明 |
|------|------|------|
| `attackInterval` | **0.9 s** | 设计 1s |
| `baseDamage` | [2,4,8,15,30] | ✅ |
| `rocketNum` | 4 | |
| `extraCrosshairNum` | 0 | 2 级 → 2 |
| `extraRocketNum` | 2 | 3 级 +2 → 4 |
| `hugeRocket` | false | 4 级 true，**300** 固定伤 |
| `burningBuff` | false | 4 级 true |
| 火箭速度 | 700 | |

---

## 攻击流程

1. `launch_rockets(mouse, rocketNum)` — 主准星。
2. `extraCrosshairNum` 次：在 target 附近随机距离 300～800 再发射。
3. 4 级：`launch_rockets(target, 1, huge=true)`。

### 火箭 `rocket.gd`

- 每帧 10% 混合制导飞向 target。
- 距 target < 10 → 爆炸；巨型：scale×2、速度÷2、半径×2。
- 4 级爆炸附加 `BurningBuff`。

---

## 升级表

| 等级 | 设计 | 代码 |
|------|------|------|
| 1 | +2 火箭 | `rocketNum += 2` → 6 |
| 2 | 2 准星×2 火箭 | `extraCrosshairNum = 2` |
| 3 | 3 准星各 +2 | `extraRocketNum += 2`；`rocketNum += 2` |
| 4 | 巨型+灼烧 | `hugeRocket`；`burningBuff` |

**4 级估算**：主准星 8 火箭 + 2 准星×4 + 巨型 1。

---

## 设计 ↔ 代码差异

- ID 20 vs 30。
- 3 级「3 个准星」vs 代码仍 2 个额外准星。

---

## 相关文件

`rocket_launcher.gd`、`rocket.gd`、`rocked_explode.gd`、`crosshair.tscn`
