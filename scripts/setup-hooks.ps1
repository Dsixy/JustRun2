# One-time setup: point this repo at tracked git hooks.
$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root
git config core.hooksPath .githooks
Write-Host "Git hooks path set to .githooks" -ForegroundColor Green
Write-Host "Pre-commit will run scripts/validate.ps1 on every commit." -ForegroundColor Cyan
