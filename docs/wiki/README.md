# Just Run2 百科

> 2D Roguelike · Godot 4.2 · 单局 10 波

<div class="wiki-hero">
  <div class="wiki-hero__grid">
    <div>
      <h1 class="wiki-hero__title">Just Run2 百科</h1>
      <p class="wiki-hero__tagline">规范化游戏说明，供玩家查阅与开发对齐。内容综合自设计文档与补丁决议；当二者冲突时，以补丁标注的「代码为主 / 文档为主」为准。</p>
    </div>
    <img class="wiki-hero__img" src="../assets/images/screenshots/titlescene.png" alt="Just Run2 标题画面">
  </div>
</div>

<div class="wiki-card-grid">
  <a class="wiki-card" href="overview/">
    <p class="wiki-card__title">游戏概览</p>
    <p class="wiki-card__desc">10 波循环、核心系统与补丁差异</p>
  </a>
  <a class="wiki-card" href="controls/">
    <p class="wiki-card__title">操作与界面</p>
    <p class="wiki-card__desc">快捷键、背包、天赋与图鉴</p>
  </a>
  <a class="wiki-card" href="weapons/">
    <p class="wiki-card__title">武器索引</p>
    <p class="wiki-card__desc">27+ 把已实现武器与计划列表</p>
  </a>
  <a class="wiki-card" href="characters/">
    <p class="wiki-card__title">角色与构筑</p>
    <p class="wiki-card__desc">三名角色、八维属性与装甲臂</p>
  </a>
</div>

## 游戏截图

<div class="wiki-screenshots">
  <img src="../assets/images/screenshots/choose.png" alt="选角界面">
  <img src="../assets/images/screenshots/demo.png" alt="战斗画面">
  <img src="../assets/images/screenshots/note.png" alt="武器图鉴">
  <img src="../assets/images/screenshots/attribute.png" alt="天赋界面">
</div>

## 游戏素材

<div class="wiki-screenshots">
  <img src="../assets/images/game/awo_kong.png" alt="阿猴">
  <img src="../assets/images/game/lady.png" alt="阿女">
  <img src="../assets/images/game/shop.png" alt="波波猫商店">
  <img src="../assets/images/game/back.png" alt="背景">
</div>

---

## 百科目录

| 分类 | 条目 |
|------|------|
| **入门** | [游戏概览](overview.md) · [操作与界面](controls.md) |
| **构筑** | [角色](characters.md) · [属性](attributes.md) · [装甲臂](weapon-arm.md) · [武器索引](weapons/index.md) |
| **单局** | [波次与流程](progression.md) · [商店](shop.md) · [敌人](enemies.md) · [掉落物](items.md) |
| **战斗** | [Buff 与伤害](buffs-and-damage.md) |
| **进度** | [解锁条件](unlocks.md) · [剧情与事件](events.md) |
| **武器详表** | [已实现武器](weapons/implemented.md) · [计划中武器](weapons/planned.md) |
| **维护** | [文档来源与状态](meta/sources.md) |

---

## 状态图例

| 标记 | 含义 |
|------|------|
| ✅ | 已实现且与百科一致 |
| ⚠️ | 部分实现或与代码有偏差 |
| 📋 | 设计已定，待开发 |
| 🚫 | 已废弃或补丁明确删除 |

---

## 快速参考

- **单局长度**：10 波，波间波波猫商店
- **初始角色**：仅阿猴；第 3 波解锁卡莫、第 6 波解锁阿女（剧情后可选）
- **快捷键**：`B` 背包/武器 · `M` 天赋 · `T` 图鉴 · `Esc` 关闭 UI
- **升级**：+2 天赋点 · +3 商店刷新次数（可存储）
