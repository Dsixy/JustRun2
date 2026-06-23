# 浮游炮

<!-- wiki-weapon-header -->
<div class="wiki-weapon-sheet" markdown="1">
<div class="wiki-weapon-sheet__grid" markdown="1">
<div class="wiki-weapon-sheet__icon"><img src="/JustRun2/assets/images/wiki/weapon_option.png" alt="浮游炮" width="96" height="96"></div>
<div class="wiki-weapon-sheet__meta" markdown="1">

| 字段 | 值 |
|------|-----|
| **ID** | 25 |
| **资源 Key** | `option` |
| **中文名** | 浮游炮 |
| **解锁** | 🚫 已禁用（架构待重做） |

</div>
</div>
</div>

> 补丁：`option` 即浮游炮。  
> **当前状态**：已加入 `GameInfo.DISABLED_WEAPONS`，不出现在商店 / 作弊栏；代理攻击架构已撤销，待重做后再启用。

---

## 效果

召唤一个浮游炮单元，在玩家周围浮动，绑定背包第一格的武器。攻击时发动一次绑定武器的攻击。槽位为空时发射默认子弹。

- 等级1：子弹基础伤害增加 5 点
- 等级2：浮游炮可随机飞向鼠标附近（约 20% 概率）
- 等级3：浮游炮数量 +1（1 → 2）
- 等级4：槽内武器按各自间隔 **自动攻击**；浮游炮本体轮射时仅补员。

---

## 数值

| 等级 | 默认弹伤害 |
|------|------------|
| 0 | 3 |
| 1 | 6 |
| 2 | 12 |
| 3 | 20 |
| 4 | 35 |

- 默认弹速度：700
- 武器攻击间隔：0.8 − 0.02 × 熟练
- 基础暴击率：5%
- 基础暴击伤害：200%

---

## 代码 ↔ 文档差异

- 场景 
a = "Option"`，中文名未改
- 设计 1 级「伤害 +5」；代码 L1 **`pass`**，未实装
- 浮游炮 i 绑定 `inventory[i]`，非独立 UI 槽位
- 代理攻击（背包武器出射 / 音效 / 场景树）架构不稳定 → **整武器禁用**，相关 `attack_origin` 重构已撤销
