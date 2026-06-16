# 已实现武器

> ✅ = 可正常进商店池（需解锁） · ⚠️ = 部分实现 · 🚫 = 已禁用

| ID | 名称 | Key | 解锁条件 | 状态 | 详情 |
|----|------|-----|----------|------|------|
| 0 | 手枪 | `pistol` | 默认 | ✅ | [pistol.md](pistol.md) |
| 1 | 狙击枪 | `sniping_riffe` | 待补充事件 📋 | ⚠️ | [sniping_riffe.md](sniping_riffe.md) |
| 2 | 霰弹枪 | `shotgun` | 待补充 📋 | ⚠️ | [shotgun.md](shotgun.md) |
| 3 | 激光剑 | `laser_sword` | 待补充 📋 | ⚠️ | [laser_sword.md](laser_sword.md) |
| 4 | 花刀玉手 | `falling_blossom` | 阿女剧情 | ✅ | [falling_blossom.md](falling_blossom.md) |
| 5 | 思维泡泡 | `thought_bubble` | 启迪 → 20 | ✅ | [thought_bubble.md](thought_bubble.md) |
| 6 | 冰霜手镯 | `hail_brace` | **等级 → 10** 📋 | ⚠️ | [hail_brace.md](hail_brace.md) |
| 7 | 群星之怒 | `stellar_wrath` | 卡莫杀 5000 📋 | ⚠️ | [stellar_wrath.md](stellar_wrath.md) |
| 8 | 扑克牌 | `poker` | 熟练 / 敏捷 → 20 | ✅ | [poker.md](poker.md) |
| 9 | 心之歌 | `song_of_soul` | 魅力 → 20 | ✅ | [song_of_soul.md](song_of_soul.md) |
| 10 | 毒药瓶 | `poison_vial` | 待补充 📋 | ⚠️ | [poison_vial.md](poison_vial.md) |
| 11 | 激光枪 | `laser_gun` | 卡莫剧情（第 3 波） | ✅ | [laser_gun.md](laser_gun.md) |
| 12 | 肉蛋葱鸡 | `mest` | 体力 → 20 | ✅ | [mest.md](mest.md) |
| 13 | 外卖员 | `delivery_guy` | 单局消费 4000 📋 | ⚠️ | [delivery_guy.md](delivery_guy.md) |
| 14 | 蛛丝 | `spider_silk` | 通关全 DoT 📋 | ⚠️ | [spider_silk.md](spider_silk.md) |
| 15 | 漫画书 | `comic_book` | 待补充 📋 | ⚠️ | [comic_book.md](comic_book.md) |
| 16 | 香水瓶 | `perfume_bottle` | 累计 100 植物 📋 | ⚠️ | [perfume_bottle.md](perfume_bottle.md) |
| 19 | 金币枪 | `coin_gun` | 单局赚 10000 📋 | ⚠️ | [coin_gun.md](coin_gun.md) |
| 20 | 扳手 | `wrench` | 待补充 📋 | ⚠️ | [wrench.md](wrench.md) |
| 21 | 唤灵海螺 | `spirit_conch` | 待补充 📋 | ⚠️ | [spirit_conch.md](spirit_conch.md) |
| 22 | 猫之计谋 | `cat_trick` | 待补充 📋 | ⚠️ | [cat_trick.md](cat_trick.md) |
| 24 | 极速光轮 | `lightwheel` | 待补充 📋 | ⚠️ | [lightwheel.md](lightwheel.md) |
| 25 | **浮游炮** | `option` | — | 🚫 | [option.md](option.md) |
| 26 | 复制器 | `replicator` | 待补充 📋 | ⚠️ | [replicator.md](replicator.md) |
| 27 | 叶子 | `leaf` | 待补充 📋 | ⚠️ | [leaf.md](leaf.md) |
| 28 | 泪水 | `tear` | 待补充 📋 | ⚠️ | [tear.md](tear.md) |
| 30 | 火箭炮 | `rocket_launcher` | 健忘症剧情 📋 | ⚠️ | [rocket_launcher.md](rocket_launcher.md) |
| — | 少女温柔的抚摸 | `maiden_touch` | 大力士剧情 | 🚫 | [maiden_touch.md](maiden_touch.md) |
| 29 | 月相盘 | `moon_phase_dial` | 待设计 | 🚫 | [moon_phase_dial.md](moon_phase_dial.md) |

📋 = 补丁要求 **补全解锁事件**，多数尚未接入代码。

---

## 代表武器摘要

### 手枪 (ID 0)

均衡远程；贯穿伤害。升级：暴伤 → 连锁弹 → 暴击率 → 强化连锁。→ [详情](pistol.md)

### 激光枪 (ID 11)

卡莫剧情赠送；火焰伤害；多道激光（高等级）。→ [详情](laser_gun.md)

### 花刀玉手 (ID 4)

阿女专属风格；劈砍；多段剑势；4 级命中回血。→ [详情](falling_blossom.md)

### 毒药瓶 (ID 10)

投掷毒圈，持续伤害 + 中毒 Buff；无法暴击。→ [详情](poison_vial.md)

### 香水瓶 (ID 16)

毒素伤害；香氛值由本局拾取的植物种类累积，增强范围 / 伤害 / 攻速等。→ [详情](perfume_bottle.md)

### 浮游炮 (ID 25 · `option`)

🚫 **已禁用**（`DISABLED_WEAPONS`）：代理攻击架构不稳定，待重做。设计见 [详情](option.md)。

---

完整索引见 [武器首页](index.md)。数值权威：[设计文档](../Just%20Run2.md#武器) · 范围权威：[补丁](../patch.md)。
