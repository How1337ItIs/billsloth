# Windows Integration for Bill Sloth ISO Customization
param(
    [Parameter(Mandatory=$true)]
    [string]$ChRootPath
)

Write-Host "🎨 Integrating Bill Sloth customization via WSL..." -ForegroundColor Green

$AssetsPath = Split-Path $MyInvocation.MyCommand.Path -Parent | Join-Path -ChildPath "assets"
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent | Join-Path -ChildPath "integrate_customization.sh"

# Convert Windows path to WSL path
$WSLChRootPath = $ChRootPath -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
$WSLScriptPath = $ScriptPath -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }

# Run integration script in WSL
wsl -d Ubuntu-22.04 bash -c "chmod +x '$WSLScriptPath' && '$WSLScriptPath' '$WSLChRootPath'"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Bill Sloth customization integrated successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Integration failed with exit code: $LASTEXITCODE" -ForegroundColor Red
}
