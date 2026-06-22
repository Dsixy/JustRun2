# 敌人

普通敌人有 **3 个等级**（外观深浅/色调区分）。生命与伤害受 **怪物等级** 与 **波次系数** 共同影响。

波次系数见 [游戏机制 · 波次](mechanics.md#波次)。系数表：1, 2, 4, 8, 12, 24, 30, 36, 44, 50（第 1～10 波）。

---

## 普通敌人一览

| | 邪恶小豆豆 | 废物 | 破烂 | 垃圾 |
|---|:---:|:---:|:---:|:---:|
| 定位 | 近战碰撞 | 远程弹幕 | 高血量肉盾 | 冲刺突进 |
| 生命 | 5×波次系数 | 3×(波次系数+5×等级−5) | 20×(波次系数+10×等级) | (3+3×等级)×波次系数 |
| 接触伤害 | 15×等级 | 15×等级 | 15×等级 | 20×等级+10 |

---

## 邪恶小豆豆

<div class="wiki-char-sheet">
  <div class="wiki-char-sheet__top">
    <div class="wiki-char-sheet__visuals">
      <figure class="wiki-char-frame">
        <div class="wiki-char-frame__media">
          <p class="wiki-char-frame__placeholder">立绘 · 三等级<br>待补</p>
        </div>
        <figcaption class="wiki-char-frame__label">邪恶小豆豆</figcaption>
      </figure>
    </div>
    <div class="wiki-char-sheet__blurb">
      <p>最基础的近战怪，主动靠近玩家，通过<strong>碰撞</strong>造成伤害。</p>
      <ul class="wiki-stat-list">
        <li>生命：<strong>5 × 波次系数</strong></li>
        <li>接触伤害：<strong>15 × 等级</strong></li>
      </ul>
    </div>
  </div>
</div>

> 镰刀先生的宠物，很喜欢用鼻涕泡进行攻击，但是因为这个设定太恶心，被作者删除了。

---

## 废物

<div class="wiki-char-sheet">
  <div class="wiki-char-sheet__top">
    <div class="wiki-char-sheet__visuals">
      <figure class="wiki-char-frame">
        <div class="wiki-char-frame__media">
          <p class="wiki-char-frame__placeholder">立绘 · 三等级<br>待补</p>
        </div>
        <figcaption class="wiki-char-frame__label">废物</figcaption>
      </figure>
    </div>
    <div class="wiki-char-sheet__blurb">
      <p>远程怪，与玩家保持约 <strong>600</strong> 像素距离：太远靠近、太近后退，并周期性发射弹幕。</p>
      <ul class="wiki-stat-list">
        <li>生命：<strong>3 × (波次系数 + 5×等级 − 5)</strong></li>
        <li>接触伤害：<strong>15 × 等级</strong></li>
        <li>子弹伤害：<strong>20 × 等级</strong></li>
        <li>每轮弹数：<strong>3 + 2×等级</strong></li>
        <li>弹速 200 · 散布受命中率影响</li>
      </ul>
    </div>
  </div>
</div>

> 废物一点也不废物，作为团队中的脑力担当，他常常为莽撞的大哥与懒散的二弟操心，处理着数不清的冤家债主，但在闲暇之余，他依旧醉心学习，他深信：知识就是力量。「所以你为什么要去考一个法学硕士，还整理一个律师资格证？」垃圾问道。

---

## 破烂

<div class="wiki-char-sheet">
  <div class="wiki-char-sheet__top">
    <div class="wiki-char-sheet__visuals">
      <figure class="wiki-char-frame">
        <div class="wiki-char-frame__media">
          <p class="wiki-char-frame__placeholder">立绘 · 三等级<br>待补</p>
        </div>
        <figcaption class="wiki-char-frame__label">破烂</figcaption>
      </figure>
    </div>
    <div class="wiki-char-sheet__blurb">
      <p>体型更大的近战肉盾，移速较慢，单只血量高。缺乏 AOE 或穿透时清理较慢。</p>
      <ul class="wiki-stat-list">
        <li>生命：<strong>20 × (波次系数 + 10×等级)</strong></li>
        <li>接触伤害：<strong>15 × 等级</strong></li>
        <li>体型约为普通怪的 2 倍</li>
      </ul>
    </div>
  </div>
</div>

> 大多数情况下，破烂在团队中都是被欺负的那个，他一般作为垃圾的捧哏出现但是总是说不对话，又被垃圾敲一顿。

---

## 垃圾

<div class="wiki-char-sheet">
  <div class="wiki-char-sheet__top">
    <div class="wiki-char-sheet__visuals">
      <figure class="wiki-char-frame">
        <div class="wiki-char-frame__media">
          <p class="wiki-char-frame__placeholder">立绘 · 三等级<br>待补</p>
        </div>
        <figcaption class="wiki-char-frame__label">垃圾</figcaption>
      </figure>
    </div>
    <div class="wiki-char-sheet__blurb">
      <p>近战怪，周期性向玩家<strong>冲刺</strong>：冲刺期间移速 ×3，伤害倍率 +100%。</p>
      <ul class="wiki-stat-list">
        <li>生命：<strong>(3 + 3×等级) × 波次系数</strong></li>
        <li>平时接触伤害：<strong>20×等级 + 10</strong></li>
        <li>冲刺持续约 <strong>1 秒</strong></li>
      </ul>
    </div>
  </div>
</div>

> 作为坏蛋三人组中的老大，垃圾的性格十分暴躁，每当有人找上门欺负破烂，他就忍不住直接发动冲刺技能顶飞对方。「我的小弟也是你能欺负的？」

击杀垃圾有极低概率掉落 [火箭炮](weapons/rocket_launcher.md) 解锁。

---

## 镰刀先生（Boss） {#镰刀先生}

<div class="wiki-char-sheet">
  <div class="wiki-char-sheet__top">
    <div class="wiki-char-sheet__visuals">
      <figure class="wiki-char-frame">
        <div class="wiki-char-frame__media">
          <p class="wiki-char-frame__placeholder">Boss 立绘<br>待补</p>
        </div>
        <figcaption class="wiki-char-frame__label">镰刀先生</figcaption>
      </figure>
    </div>
    <div class="wiki-char-sheet__blurb">
      <p><strong>第 10 波</strong>加入战场，为单局最终 Boss。击败后可解锁 [漫画书](weapons/comic_book.md)。</p>
      <ul class="wiki-stat-list">
        <li>生命：<strong>30 000</strong></li>
        <li>等级：<strong>1</strong>（固定，不参与波次成长）</li>
        <li>平常接触伤害：<strong>25</strong></li>
        <li>约每 <strong>2 秒</strong> 从技能中随机释放一种（含威慑）</li>
      </ul>
    </div>
  </div>
</div>

### 已实装技能

| 技能 | 效果（以当前版本为准） |
|------|------------------------|
| **暗色冲击** | 向玩家方向高速冲刺约 **0.6 秒**（移速 1500），冲撞造成 50 点物理伤害 |
| **弧光** | 向前挥出刀光；命中造成 **50** 点伤害，约 **0.6 秒** 后在刀光范围内对玩家再次结算 **100** 点伤害|
| **血腥之雨** | 连续 **5 轮**弹幕，每轮 **10** 发扇形散射弹（弹速 800），每发 **20** 点伤害 |
| **威慑** | 对场上所有敌人施加 [狂热](buffs-and-damage.md#狂热)（不含 Boss 自身） |

---

> 镰刀先生一般是作为反派出现，但是很可惜，作为搞笑无厘头背景下的反派，镰刀先生并不比灰太狼更厉害，大部分情况都是从鞋底铲掉。
