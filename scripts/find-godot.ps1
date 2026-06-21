# Resolves Godot 4.x executable for JustRun2 validation.
# Priority: GODOT_BIN env -> project local path -> common install paths -> PATH.

$ErrorActionPreference = 'Stop'

function Test-GodotVersion {
    param([string]$Exe)
    if (-not (Test-Path $Exe)) { return $null }
    try {
        $out = & $Exe --version 2>&1 | Out-String
        if ($out -match '4\.\d+') { return $Exe }
    } catch {}
    return $null
}

if ($env:GODOT_BIN) {
    $resolved = Test-GodotVersion $env:GODOT_BIN
    if ($resolved) { return $resolved }
}

$candidates = @(
    'C:\Program Files\Godot\Godot_v4.2.2-stable_win64.exe',
    'C:\Program Files\Godot\Godot_v4.2.2-stable_win64_console.exe',
    'C:\Godot\Godot_v4.2.2-stable_win64_console.exe',
    'C:\Godot\Godot_v4.2.2-stable_win64.exe',
    "$env:LOCALAPPDATA\Godot\Godot_v4.2.2-stable_win64_console.exe",
    'C:\Users\Doney\Desktop\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64.exe'
)

foreach ($path in $candidates) {
    $resolved = Test-GodotVersion $path
    if ($resolved) { return $resolved }
}

$cmd = Get-Command godot -ErrorAction SilentlyContinue
if ($cmd) {
    $resolved = Test-GodotVersion $cmd.Source
    if ($resolved) { return $resolved }
}

Write-Error @"
Godot 4.x not found.
Set GODOT_BIN to your Godot executable, e.g.:
  `$env:GODOT_BIN = 'C:\Users\Doney\Desktop\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64.exe'
README recommends Godot 4.2.2; 4.6+ is accepted for validate when project loads.
"@
exit 1
