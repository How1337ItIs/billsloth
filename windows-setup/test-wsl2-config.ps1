# Test WSL2 Live-Build Configuration
param(
    [string]$UbuntuVersion = "jammy"
)

Write-Host "=== TESTING WSL2 LIVE-BUILD CONFIGURATION ===" -ForegroundColor Cyan

# Test template substitution
$testScript = @'
#!/bin/bash
set -e
echo "UBUNTU_VERSION = {UBUNTU_VERSION}"
echo "Testing lb config with distribution: {UBUNTU_VERSION}"
mkdir -p /tmp/config-test-{UBUNTU_VERSION}
cd /tmp/config-test-{UBUNTU_VERSION}
lb config --distribution {UBUNTU_VERSION} --architecture amd64 --binary-images iso-hybrid
echo "Config completed successfully for {UBUNTU_VERSION}"
ls -la config/
echo "Contents of config/bootstrap:"
cat config/bootstrap 2>/dev/null || echo "No bootstrap config found"
'@

# Replace placeholder
$testScript = $testScript -replace '{UBUNTU_VERSION}', $UbuntuVersion

Write-Host "Template after substitution:" -ForegroundColor Green
Write-Host $testScript -ForegroundColor White

# Save and execute
$tempScript = "$env:TEMP\test-config.sh"
$testScript | Out-File -FilePath $tempScript -Encoding UTF8 -NoNewline

$wslScriptPath = $tempScript -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }

Write-Host "`nExecuting in WSL2..." -ForegroundColor Yellow
wsl -d Ubuntu-22.04 bash -c "bash $wslScriptPath"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Configuration test successful!" -ForegroundColor Green
} else {
    Write-Host "`n❌ Configuration test failed with exit code $LASTEXITCODE" -ForegroundColor Red
}