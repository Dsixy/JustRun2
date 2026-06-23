# Export wiki images from asset.png and patch weapon pages
param(
    [switch]$PatchOnly
)

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

if (-not $PatchOnly) {
    pip install -q Pillow pyyaml
    python (Join-Path $PSScriptRoot "apply_wiki_images.py")
}
python (Join-Path $PSScriptRoot "patch_weapon_pages.py")

Write-Host ""
Write-Host "Wiki images -> docs/assets/images/wiki/"
Write-Host "Mapping: wiki/wiki_images_manifest.yml"
