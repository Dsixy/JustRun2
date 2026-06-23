# Crop asset/image/asset.png into asset/image/slices/
param(
    [switch]$InstallDeps
)

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

if ($InstallDeps -or -not (python -c "import PIL" 2>$null)) {
    pip install -q Pillow
}

python (Join-Path $PSScriptRoot "crop_asset_atlas.py")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "Done. Browse slices:"
Write-Host "  asset/image/slices/by_rect/   (unique Rect2 crops)"
Write-Host "  asset/image/slices/grid/      (full 100x100 grid)"
Write-Host "  asset/image/slices/named/     (semantic filenames)"
Write-Host "  asset/image/slices/manifest.json   (lookup table)"
