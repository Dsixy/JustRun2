# 掉落物

击杀敌人时，会在其位置独立判定是否掉落 **经验宝石**、**金币** 与 **植物**（三者互不影响）。波次越高，高级经验宝石出现率通常越高。波次与系数见 [游戏机制 · 波次](mechanics.md#波次)。

---

## 击杀掉落速查

| 掉落物 | 触发条件 | 说明 |
|--------|----------|------|
| 经验宝石 | 每次击杀单独判定 | 依当前波次权重表决定等级；未命中则不掉落 |
| 金币 | 每次击杀：`波次×1% + 40%` | 拾取获得 **1** 枚金币（受感知属性加成影响） |
| 植物 | 每次击杀：**1.2%** | 命中后再按种类权重随机一种 |

---

## 经验宝石 {#经验宝石}

拾取后获得经验，是升级与获取天赋点的主要来源。实际经验受角色 **感知** 加成。

<div class="wiki-exp-gems">
<div class="wiki-exp-gems__table">
<table>
<thead><tr><th>等级</th><th>经验值</th></tr></thead>
<tbody>
<tr><td>基础</td><td>10</td></tr>
<tr><td>中级</td><td>50</td></tr>
<tr><td>高级</td><td>500</td></tr>
</tbody>
</table>
</div>
<div class="wiki-exp-gems__icons">
  <figure class="wiki-char-frame">
    <div class="wiki-char-frame__media">
      <img src="/JustRun2/assets/images/wiki/exp_gem_basic.png" alt="基础经验宝石">
    </div>
    <figcaption class="wiki-char-frame__label">基础 · 10 EXP</figcaption>
  </figure>
  <figure class="wiki-char-frame">
    <div class="wiki-char-frame__media">
      <img src="/JustRun2/assets/images/wiki/exp_gem_mid.png" alt="中级经验宝石">
    </div>
    <figcaption class="wiki-char-frame__label">中级 · 50 EXP</figcaption>
  </figure>
  <figure class="wiki-char-frame">
    <div class="wiki-char-frame__media">
      <img src="/JustRun2/assets/images/wiki/exp_gem_high.png" alt="高级经验宝石">
    </div>
    <figcaption class="wiki-char-frame__label">高级 · 500 EXP</figcaption>
  </figure>
</div>
</div>

### 各波掉落权重

下表为**单次击杀**掉出对应等级宝石的概率；剩余概率为「本击不掉宝石」。

| 波次 | 基础 | 中级 | 高级 |
|:----:|:----:|:----:|:----:|
| 1 | 30% | — | — |
| 2 | 30% | 5% | — |
| 3 | 45% | 7% | — |
| 4 | — | 30% | — |
| 5 | 50% | 10% | — |
| 6 | — | 50% | 2% |
| 7 | 30% | 25% | — |
| 8 | — | — | 30% |
| 9 | 10% | 40% | — |
| 10 | — | — | 50% |


---

## 金币

<div class="wiki-char-sheet wiki-char-sheet--split">
  <div class="wiki-char-sheet__top">
    <div class="wiki-char-sheet__visuals">
      <figure class="wiki-char-frame">
        <div class="wiki-char-frame__media">
          <img src="/JustRun2/assets/images/wiki/coin.png" alt="金币">
        </div>
        <figcaption class="wiki-char-frame__label">金币</figcaption>
      </figure>
    </div>
    <div class="wiki-char-sheet__blurb">
      <p>主要金币来源。击杀时按 <strong>波次×1% + 40%</strong> 概率掉落一枚。</p>
      <p>拾取固定为 <strong>1</strong> 枚，再乘以角色的金币加成（与感知相关）。用于饱饱猫商店购物与部分武器解锁条件。</p>
    </div>
  </div>
</div>

---

## 植物 {#植物}

击杀约 **1.2%** 概率掉落植物。命中后按下列权重随机一种（合计 100%）：

| 植物 | 权重 | 拾取效果 |
|------|:----:|----------|
| 风信子 | 10% | 获得 [狂暴](buffs-and-damage.md#狂暴)（攻速提升，15 秒） |
| 蓝山绿叶 | 10% | **立即升 1 级**（含升级奖励） |
| 酒色玫瑰 | 50% | 恢复 **99** 点生命（不超过上限） |
| 雨滴茉莉 | 10% | 获得 [无敌](buffs-and-damage.md#无敌)（10 秒） |
| 猫薄荷 | 20% | **+1** 商店刷新次数 |

<div class="wiki-card-grid wiki-card-grid--plants">
  <div class="wiki-card wiki-card--static">
    <img class="wiki-card__icon" src="/JustRun2/assets/images/wiki/plant_hyacinth.png" alt="风信子">
    <p class="wiki-card__title">风信子</p>
    <p class="wiki-card__desc">狂暴 · 攻速 ↑</p>
  </div>
  <div class="wiki-card wiki-card--static">
    <img class="wiki-card__icon" src="/JustRun2/assets/images/wiki/plant_blue_mountain_leaf.png" alt="蓝山绿叶">
    <p class="wiki-card__title">蓝山绿叶</p>
    <p class="wiki-card__desc">立刻升 1 级</p>
  </div>
  <div class="wiki-card wiki-card--static">
    <img class="wiki-card__icon" src="/JustRun2/assets/images/wiki/plant_wine_rose.png" alt="酒色玫瑰">
    <p class="wiki-card__title">酒色玫瑰</p>
    <p class="wiki-card__desc">+99 HP · 最常见</p>
  </div>
  <div class="wiki-card wiki-card--static">
    <img class="wiki-card__icon" src="/JustRun2/assets/images/wiki/plant_raindrop_jasmine.png" alt="雨滴茉莉">
    <p class="wiki-card__title">雨滴茉莉</p>
    <p class="wiki-card__desc">无敌 10 秒</p>
  </div>
  <div class="wiki-card wiki-card--static">
    <img class="wiki-card__icon" src="/JustRun2/assets/images/wiki/plant_catnip.png" alt="猫薄荷">
    <p class="wiki-card__title">猫薄荷</p>
    <p class="wiki-card__desc">+1 商店刷新</p>
  </div>
</div>

### 与香水瓶

若已装备 [香水瓶](weapons/perfume_bottle.md)，拾取植物时还会计入香水瓶的 **花材收集**（不同植物对应不同加成方向）。累计拾取 **100** 株可解锁香水瓶，见 [已实现武器](weapons/implemented.md)。

---

## 波次结束自动拾取

波次计时结束时，场上尚未拾取的金币与经验宝石会被清理；其中一部分会改为飞向玩家：

| 掉落物 | 自动吸附概率 |
|--------|:------------:|
| 金币 | 30% |
| 经验宝石 | 10% |

未被吸附的同类掉落物将消失，不会带入下一波。
