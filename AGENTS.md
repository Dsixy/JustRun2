# JustRun2 — 开发说明

Godot 4.2.2 Roguelike 项目。

## 验证

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate.ps1
```

首次克隆后可选：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/setup-hooks.ps1
```

- Godot **4.2.2+**（路径见 `scripts/find-godot.ps1`，或设置 `$env:GODOT_BIN`）
- `validate.ps1` 默认 ParseCheck（`scripts/godot_smoke.gd`），不进入主菜单
- 完整资源导入：`-Import`

## 文档

- 玩家百科：`docs/` + [MkDocs](https://dsixy.github.io/JustRun2/)
- 设计裁决：`docs/patch.md`

## Cursor（本地，已 gitignore）

Agent 工作流配置在 `.cursor/`；不影响游戏导出。
