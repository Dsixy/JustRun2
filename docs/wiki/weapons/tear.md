# 泪水 (tear)

| 字段 | 值 |
|------|-----|
| **ID** | 28 |
| **资源 Key** | `tear` |
| **场景** | `scene/weapon/tear.tscn` |
| **脚本** | `script/weapon/tear.gd` |
| **子弹** | `tear_bullet.tscn` / `tear_ball.tscn` |
| **实现状态** | ✅ · ⚠️ 解锁未接入 |

---

## 概述

向 **四面八方** 发射多滴泪弹；未命中则在终点留 **小水珠**。泪弹命中水珠被吸收；水珠满 stack 后 **爆炸** 散射新泪弹，形成链式反应。

---

## 设计文档（Just Run2.md）

间隔 1.2-0.02×熟练；伤害 [2,4,7,15,30]；暴伤 150%。

1 级 +4 伤害；2 级 +4 滴；3 级爆炸 +1 滴且命中留珠；4 级爆炸 +2 滴、阈值 -1。

---

## 基础参数（代码）

| 参数 | 0 级 | 说明 |
|------|------|------|
| `attackInterval` | **2.0 s** | 熟练缩减未实装 |
| `baseDamage` | [2,8,12,20,34] | 与设计数组不同 ⚠️ |
| `tearNum` | 6 | 2 级 +4 → 10 |
| `explodeNum` | 4 | 3 级 +1 → 5；4 级 +2 → 7 |
| `maxStack` | 4 | 4 级 -1 → 3 |
| `always` | false | 3 级 true：命中也留珠 |
| 子弹速度 | 400 | |
| 飞行距离 | 约 375～625 随机 | |

---

## 机制

### `attack()`

发射 `tearNum` 颗，方向均匀随机 `Vector2.from_angle(randf() * 2π)`。

### 泪弹 `tear_bullet.gd`

- 命中敌人造成伤害；未命中或 `always` 时在位置 `generate()` 水珠。

### 水珠 `tear_ball.gd`

- 吸收组 `TearBullet` 的泪弹 → `curStack += 1`
- `curStack >= maxStack` → `explode()` 向 `explodeNum` 方向散射
- 5s 无引爆则消失
- 场上子弹 ≥100 时散射数 ×0.35（性能保护）

---

## 升级表

| 等级 | 设计 | 代码 |
|------|------|------|
| 1 | +4 伤害 | `pass`（靠数组跳档） |
| 2 | +4 滴 | `tearNum += 4` |
| 3 | 爆炸+1；命中留珠 | `always=true`；`explodeNum += 1` |
| 4 | 爆炸+2；阈值-1 | `explodeNum += 2`；`maxStack -= 1` |

---

## 相关文件

`tear.gd`、`tear_bullet.gd`、`tear_ball.gd`
