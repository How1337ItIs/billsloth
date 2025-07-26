# Test WSL2 detection with new logic
Write-Host "Testing WSL2 detection..." -ForegroundColor Cyan

$wslList = wsl --list --quiet
Write-Host "Raw WSL output:" -ForegroundColor Yellow
$wslList | ForEach-Object { Write-Host "  [$_]" }

Write-Host "`nFiltered for Ubuntu (new logic):" -ForegroundColor Yellow
$ubuntuLine = $wslList | Where-Object { $_.ToString().Contains("Ubuntu") } | Select-Object -First 1
if ($ubuntuLine) {
    Write-Host "  Found: [$ubuntuLine]"
    $ubuntuDistro = $ubuntuLine.Trim() -replace '\s+', '-'
    Write-Host "  Cleaned: [$ubuntuDistro]" -ForegroundColor Green
    
    # Test execution
    Write-Host "`nTesting WSL execution:" -ForegroundColor Cyan
    wsl -d $ubuntuDistro bash -c "echo 'WSL execution successful with: $(uname -a)'"
} else {
    Write-Host "No Ubuntu distributions found" -ForegroundColor Red
}