# JustRun2 static validation — must pass before human review or git commit.
# Default: ParseCheck (loads core .gd, fast). Use -Import for full resource import (slower).
param(
    [switch]$Import,
    [switch]$SkipParseCheck,
    [int]$ImportTimeoutSec = 180
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = Split-Path $PSScriptRoot -Parent
Set-Location $ProjectRoot

$Godot = & "$PSScriptRoot\find-godot.ps1"
Write-Host "Using Godot: $Godot" -ForegroundColor Cyan

function Invoke-Godot {
    param(
        [string[]]$GodotArgs,
        [int]$TimeoutSec = 0
    )
    $allArgs = @(
        '--headless',
        '--display-driver', 'headless',
        '--audio-driver', 'Dummy'
    ) + $GodotArgs

    # Do not redirect stdout/stderr here — reading pipes after WaitForExit deadlocks
    # when Godot writes more than the buffer holds (~4 KB).
    if ($TimeoutSec -gt 0) {
        $proc = Start-Process `
            -FilePath $Godot `
            -ArgumentList $allArgs `
            -NoNewWindow `
            -PassThru
        if (-not $proc.WaitForExit($TimeoutSec * 1000)) {
            try { $proc.Kill($true) } catch {}
            Write-Error "Godot timed out after ${TimeoutSec}s. Args: $($GodotArgs -join ' ')"
            return -1
        }
        return $proc.ExitCode
    }

    $proc = Start-Process `
        -FilePath $Godot `
        -ArgumentList $allArgs `
        -NoNewWindow `
        -PassThru `
        -Wait
    return $proc.ExitCode
}

if ($Import) {
    Write-Host "Importing project (script compile + resource scan, timeout ${ImportTimeoutSec}s)..." -ForegroundColor Cyan
    $importExit = Invoke-Godot @('--path', $ProjectRoot, '--import') -TimeoutSec $ImportTimeoutSec
    if ($importExit -ne 0) {
        Write-Error "Godot import failed (exit $importExit). Try -SkipParseCheck with manual editor import, or increase -ImportTimeoutSec."
        exit $importExit
    }
} else {
    Write-Host "Skipping full import (pass -Import to enable)." -ForegroundColor Yellow
}

if (-not $SkipParseCheck) {
    Write-Host "Parse check (loads core .gd, does not run main menu)..." -ForegroundColor Cyan
    $parseExit = Invoke-Godot @(
        '--path', $ProjectRoot,
        '--script', 'res://scripts/godot_smoke.gd'
    )
    if ($parseExit -ne 0) {
        Write-Error "Godot parse check failed (exit $parseExit)"
        exit $parseExit
    }
} else {
    Write-Host "Skipping parse check (-SkipParseCheck)." -ForegroundColor Yellow
}

$gdlint = Get-Command gdlint -ErrorAction SilentlyContinue
if ($gdlint) {
    Write-Host "Running gdlint..." -ForegroundColor Cyan
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    & gdlint script/ 2>&1 | ForEach-Object { Write-Host $_ }
    $lintExit = if ($null -ne $LASTEXITCODE) { $LASTEXITCODE } else { 0 }
    $ErrorActionPreference = $prev
    if ($lintExit -ne 0) {
        Write-Error "gdlint reported issues"
        exit $lintExit
    }
} else {
    Write-Host "gdlint not installed — skipping (optional: pip install gdtoolkit)" -ForegroundColor Yellow
}

Write-Host "Validation passed." -ForegroundColor Green
exit 0
