# Prepare image assets and build the wiki locally.
param(
    [switch]$Serve,
    [switch]$RefreshImages
)

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent

Set-Location $Root

$gameDir = Join-Path $Root "docs/assets/images/game"
$shotDir = Join-Path $Root "docs/assets/images/screenshots"
$assetsDir = Join-Path $Root "docs/assets/images"

New-Item -ItemType Directory -Force -Path $gameDir, $shotDir | Out-Null

if ($RefreshImages) {
    python (Join-Path $PSScriptRoot "apply_wiki_images.py")
    python (Join-Path $PSScriptRoot "patch_weapon_pages.py")
}

Copy-Item -Force (Join-Path $Root "icon.svg") $assetsDir
Copy-Item -Force (Join-Path $Root "asset/image/*.png") $gameDir
Copy-Item -Force (Join-Path $Root "readme/*.png") $shotDir

Write-Host "Wiki assets copied to docs/assets/images/"

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error "Python is required. Install Python 3.11+ and run: pip install -r wiki/requirements.txt"
}

pip install -q -r (Join-Path $Root "wiki/requirements.txt")

if ($Serve) {
    mkdocs serve
} else {
    mkdocs build
    Write-Host "Built to site/ — open site/index.html or run with -Serve"
}
