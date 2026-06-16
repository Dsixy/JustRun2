# 蛛丝（蛛网）

| 字段 | 值 |
|------|-----|
| **武器 ID** | 14 |
| **资源 Key** | `spider_silk` |
| **场景** | `res://scene/weapon/spider_silk.tscn` |
| **脚本** | `res://script/weapon/spider_silk.gd` |
| **场景显示名** | 蛛网（`na` 字段；设计文档与百科统称「蛛丝」） |
| **商店 / 图鉴** | 已实装场景；解锁事件 **尚未接入代码**（📋） |
| **状态** | ⚠️ 可进商店池（解锁后）；解锁条件待实现 |

---

## 定位与玩法角色

远程 **DoT 辅助 / 爆发结算** 武器。发射蛛丝弹，命中敌人后展开蛛网；蛛网对范围内敌人身上所有 **持续伤害（DoT）类 Buff** 进行 **立即结算**，按剩余 tick 量折算伤害，并可选择是否清除原 Buff。

与中毒（`PoisonBuff`）、灼烧（`BurningBuff`）等 `DotBuff` 子类配合价值最高。冻伤（`FrostBiteBuff`）**不是** `DotBuff`，**不会**被蛛网结算。

---

## 解锁条件

| 来源 | 条件 |
|------|------|
| **设计文档** | 通关时，武装臂板上的 **最终武器均有 DoT 类效果** |
| **补丁 / POLISH-A09** | 同上；在 `final_results` 或胜利前检测武装板 |
| **代码现状** | ❌ 未接入；`final_results()` 仅处理属性满 20 的武器解锁 |

---

## 基础机制

### 攻击流程

1. 武器 `attack()` 由装甲臂轮射系统调用。
2. 从玩家位置向 **鼠标位置** 发射一枚 `SpiderSilkBullet`（`scene/item/spider_silk_bullet.tscn`；脚本默认 preload 为 `bullet.tscn`，**场景已覆盖**）。
3. 子弹速度 **500** 像素/秒，最大飞行路径 **3000** 像素，出屏或路径耗尽后销毁。
4. **精准度**：`0.9 + 0.05 × 熟练`（`dexterrity`）。偏差垂直于瞄准方向。
5. **命中敌人** 时：先造成 **直接命中伤害**（可暴击）；调用 `explode()` 在命中点生成 `SpiderWeb`（`scene/effect/spider_web.tscn`）。

### 蛛网展开与 DoT 结算

蛛网 `init(pos, range, keepBuff, damagePercent)`：

1. **展开动画**：0.4 秒内 `scale` tween 到 `Vector2.ONE × range × 4`。
2. **激活**（`activate()`）：读取 `Area2D` 内所有 `enemy` 组碰撞体。
3. 对每个敌人的 `buffManager.activeBuff` 遍历：
   - 若 Buff 实例为 `DotBuff`：
     - 结算伤害：`baseAmount = (duration - elapsed) / tickInterval × buff.damage.baseAmount × damagePercent`
     - 对敌人 `be_hit(damage)`。
     - 若 `keepBuff == false`（4 级前）：将该 Buff `expire()`。
     - 若 `keepBuff == true`（**4 级**）：**不**清除 DoT，仅造成结算伤害。
4. 0.3 秒后蛛网节点 `queue_free()`。

**结算比例 `damagePercent`**：

| 等级 | 设计文档 | 代码 |
|------|----------|------|
| 0～1 级 | 35% | 0.35 |
| 2 级 | 55% | 0.55 |
| 4 级 | 100% | 1.0 |

### 直接命中伤害

| 等级 | `baseDamage[level]` |
|------|---------------------|
| 0 | 12 |
| 1 | 16 |
| 2 | 20 |
| 3 | 30 |
| 4 | 50 |

- **暴击率**：武器基础 5% + 玩家 `critRate`
- **暴击伤害倍率**：200%（`baseCritDamage = 2.0`）

---

## 设计文档（Just Run2.md）

> 发射一团蛛丝，命中敌人会展开蛛网，被蛛丝攻击的敌人身上的所有持续伤害立刻结算并造成 35% 的伤害。  
> 1/3 级：范围 +40% / +100%。2 级：结算 55%。4 级：结算 100%，且不清除原有 buff。  
> 精准度 0.9+0.05 熟练；间隔 1-0.1 熟练；伤害 [12,16,20,30,50]；暴击 5% / 200%。

---

## 升级（0～4 级）

| 升至等级 | 设计文档效果 | 场景 `descriptions` | 代码实装 |
|----------|--------------|---------------------|----------|
| **1** | 蛛丝范围 +40% | 范围 +20% | `range += 0.2`（+20%） |
| **2** | 结算伤害 → 55% | 结算 → 55% | `damagePercent = 0.55` ✅ |
| **3** | 蛛丝范围 +100%（相对 0 级累计） | 范围 **额外** +40% | `range += 0.4`（累计 +60%） |
| **4** | 结算 100%；**不清除**原 DoT | 同设计 | `damagePercent = 1.0`；`keepBuff = true` ✅ |

**范围系数累计（代码）**：0 级 `1.0` → 1 级 `1.2` → 3 级 `1.6` → 4 级 `1.6`。

---

## 数值总表

| 属性 | 公式 / 数值 |
|------|-------------|
| **攻击间隔** | `1 - 0.1 × 熟练`（秒） |
| **精准度** | `0.9 + 0.05 × 熟练` |
| **子弹速度** | 500 |
| **DoT 结算** | 仅 `DotBuff` 子类 |

---

## 协同与 counter

| 协同 | 说明 |
|------|------|
| 毒药瓶、火箭炮灼烧、激光枪等 DoT 武器 | 蛛网放大剩余 DoT 价值 |
| 4 级不清 Buff | 可反复「预支」DoT 而不打断后续 tick |

| 限制 | 说明 |
|------|------|
| 无 DoT 的敌人 | 蛛网仅造成直接命中伤害 |
| 解锁未实现 | 正常流程无法解锁 |

---

## 设计 ↔ 代码差异

- 1/3 级范围加成与设计 +40%/+100% 不符（代码 +20%/+40%）。
- 解锁条件（通关全 DoT 武装）**无代码**。

---

## 升级表

| 等级 | 设计效果 | 代码效果 |
|------|----------|----------|
| 0 | 35% 结算 | `damagePercent=0.35`，`range=1.0` |
| 1 | 范围 +40% | `range=1.2` |
| 2 | 55% 结算 | `damagePercent=0.55` |
| 3 | 范围 +100% | `range=1.6` |
| 4 | 100%、保留 Buff | `damagePercent=1.0`，`keepBuff=true` |

---

## 相关资源

| 类型 | 路径 |
|------|------|
| 武器 | `scene/weapon/spider_silk.tscn` / `script/weapon/spider_silk.gd` |
| 蛛丝弹 | `scene/item/spider_silk_bullet.tscn` / `script/item/spider_silk_bullet.gd` |
| 蛛网效果 | `scene/effect/spider_web.tscn` / `script/effect/spider_web.gd` |
| DoT 基类 | `script/buff/dot_buff.gd` |
