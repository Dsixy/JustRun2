# JustRun2 Wiki

基于 [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) 构建的游戏百科站点。

**在线地址：** https://dsixy.github.io/JustRun2/wiki/

## 本地预览

```powershell
pip install -r wiki/requirements.txt
powershell -NoProfile -ExecutionPolicy Bypass -File wiki/build.ps1 -Serve
```

浏览器打开 http://127.0.0.1:8000/JustRun2/wiki/

## 构建

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File wiki/build.ps1
```

输出目录：`site/`

## 部署

推送到 `main` 分支后，GitHub Actions（`.github/workflows/deploy-wiki.yml`）会自动构建并部署到 GitHub Pages。

**首次启用 Pages：**

1. 仓库 **Settings → Pages**
2. **Build and deployment → Source** 选择 **GitHub Actions**
3. 推送包含 workflow 的 commit，等待 Actions 完成

## 素材来源

构建时会自动复制以下图片到 `docs/assets/images/`：

| 来源 | 用途 |
|------|------|
| `asset/image/*.png` | 角色、商店、背景等游戏素材 |
| `readme/*.png` | 游戏截图 |
| `icon.svg` | 站点 Logo / Favicon |

## 文档源

Markdown 源文件位于 `docs/wiki/`，导航结构在根目录 `mkdocs.yml` 中维护。
