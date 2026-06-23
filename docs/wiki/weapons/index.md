# 武器

武器分 **0～4 级**，同 ID 同级可合成升级。购买或拾取后进入背包，拖入角色 [武装板槽位](characters.md) 参与轮射。

## 伤害梯度（设计参考）

| 类型 | 0 | 1 | 2 | 3 | 4 级 |
|------|---|---|---|---|------|
| 单体 | 15 | 25 | 45 | 80 | 150 |
| 伪 AOE | 10 | 16 | 25 | 40 | 90 |
| AOE | 7 | 12 | 20 | 36 | 60 |

（假设 30% 暴击、属性 5/6/7/8/10 — 设计文档基准，实装各武器略有出入。）

## 百科分册

| 页面 | 内容 |
|------|------|
| [已实现武器](implemented.md) | 有场景 / 脚本的武器列表与解锁 |
| [计划中武器](planned.md) | 设计有、资源无或已禁用的武器 |

## 已实现武器索引（按 ID）

| ID | 名称 | Key | 详情 |
|----|------|-----|------|
| 0 | 手枪 | `pistol` | [pistol.md](pistol.md) |
| 1 | 狙击枪 | `sniping_riffe` | [sniping_riffe.md](sniping_riffe.md) |
| 2 | 霰弹枪 | `shotgun` | [shotgun.md](shotgun.md) |
| 3 | 激光剑 | `laser_sword` | [laser_sword.md](laser_sword.md) |
| 4 | 花刀玉手 | `falling_blossom` | [falling_blossom.md](falling_blossom.md) |
| 5 | 思维泡泡 | `thought_bubble` | [thought_bubble.md](thought_bubble.md) |
| 6 | 冰霜手镯 | `hail_brace` | [hail_brace.md](hail_brace.md) |
| 7 | 群星之怒 | `stellar_wrath` | [stellar_wrath.md](stellar_wrath.md) |
| 8 | 扑克牌 | `poker` | [poker.md](poker.md) |
| 9 | 心之歌 | `song_of_soul` | [song_of_soul.md](song_of_soul.md) |
| 10 | 毒药瓶 | `poison_vial` | [poison_vial.md](poison_vial.md) |
| 11 | 激光枪 | `laser_gun` | [laser_gun.md](laser_gun.md) |
| 12 | 肉蛋葱鸡 | `mest` | [mest.md](mest.md) |
| 13 | 外卖员 | `delivery_guy` | [delivery_guy.md](delivery_guy.md) |
| 14 | 蛛丝 | `spider_silk` | [spider_silk.md](spider_silk.md) |
| 15 | 漫画书 | `comic_book` | [comic_book.md](comic_book.md) |
| 16 | 香水瓶 | `perfume_bottle` | [perfume_bottle.md](perfume_bottle.md) |
| 19 | 金币枪 | `coin_gun` | [coin_gun.md](coin_gun.md) |
| 20 | 扳手 | `wrench` | [wrench.md](wrench.md) |
| 21 | 唤灵海螺 | `spirit_conch` | [spirit_conch.md](spirit_conch.md) |
| 22 | 猫之计谋 | `cat_trick` | [cat_trick.md](cat_trick.md) |
| 24 | 极速光轮 | `lightwheel` | [lightwheel.md](lightwheel.md) |
| 25 | 浮游炮 | `option` | [option.md](option.md) |
| 26 | 复制器 | `replicator` | [replicator.md](replicator.md) |
| 27 | 叶子 | `leaf` | [leaf.md](leaf.md) |
| 28 | 泪水 | `tear` | [tear.md](tear.md) |
| 29 | 月相盘 🚫 | `moon_phase_dial` | [moon_phase_dial.md](moon_phase_dial.md) |
| 30 | 火箭炮 | `rocket_launcher` | [rocket_launcher.md](rocket_launcher.md) |
| — | 少女温柔的抚摸 🚫 | `maiden_touch` | [maiden_touch.md](maiden_touch.md) |

🚫 = `GameInfo.DISABLED_WEAPONS`，不进商店池。

## 计划中武器索引

| 设计名 | 详情 |
|--------|------|
| 冲锋枪 | [planned/submachine-gun.md](planned/submachine-gun.md) |
| 加特林 | [planned/gatling.md](planned/gatling.md) |
| 靶向枪 | [planned/targeting-gun.md](planned/targeting-gun.md) |
| 羽扇 | [planned/feather-fan.md](planned/feather-fan.md) |
| 奶茶 | [planned/milk-tea.md](planned/milk-tea.md) |
| 高斯炮 | [planned/gauss-cannon.md](planned/gauss-cannon.md) |
| 粉色水球 | [planned/pink-water-ball.md](planned/pink-water-ball.md) |
| 阳爻 | [planned/yang-yao.md](planned/yang-yao.md) |
| 阴爻 | [planned/yin-yao.md](planned/yin-yao.md) |
| 太极 | [planned/taiji.md](planned/taiji.md) |
| 鼓动的心 | [planned/beating-heart.md](planned/beating-heart.md) |

## 命名对照

| 百科 / 设计名 | 资源 key | 备注 |
|---------------|----------|------|
| 浮游炮 | `option` | 补丁：Option 即浮游炮 |
| 唤灵海螺 | `spirit_conch` | 文档「亡灵海螺」 |
| 复制器 | `replicator` | 文档「拷贝器」 |
| 猫之计谋 | `cat_trick` | 文档「猫的计谋」 |
| 蛛丝 | `spider_silk` | 场景显示名「蛛网」 |

## 已禁用（不进入商店 / 作弊栏）

| 武器 | 原因 |
|------|------|
| 少女温柔的抚摸 `maiden_touch` | 设计未完成 — [详情](maiden_touch.md) |
| 月相盘 `moon_phase_dial` | 设计未完成 — [详情](moon_phase_dial.md) |

完整数值、升级描述与实装差异见各武器详情页。
