# Simple USB Creator for H: Drive
Write-Host "Simple USB Creator" -ForegroundColor Green
Write-Host "=================" -ForegroundColor Green

# Check if H: drive exists
if (-not (Test-Path "H:\")) {
    Write-Error "H: drive not found. Please make sure your USB drive is plugged in."
    exit
}

# Get ISO path
$isoPath = Read-Host "Enter path to Ubuntu ISO file"

if (-not (Test-Path $isoPath)) {
    Write-Error "ISO file not found: $isoPath"
    exit
}

Write-Host "Found ISO: $isoPath" -ForegroundColor Green
Write-Host "Target drive: H:\" -ForegroundColor Green

Write-Warning "This will ERASE all data on H: drive"
$confirm = Read-Host "Continue? (y/N)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Operation cancelled" -ForegroundColor Yellow
    exit
}

# Download Rufus
Write-Host "Downloading Rufus..." -ForegroundColor Green
$rufusPath = "$env:TEMP\rufus.exe"
try {
    Invoke-WebRequest -Uri "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5.exe" -OutFile $rufusPath -UseBasicParsing
    Write-Host "Rufus downloaded successfully" -ForegroundColor Green
}
catch {
    Write-Error "Failed to download Rufus: $($_.Exception.Message)"
    exit
}

# Launch Rufus with instructions
Write-Host "`nStarting Rufus..." -ForegroundColor Green
Write-Host "`nIn Rufus window:" -ForegroundColor Yellow
Write-Host "1. Select H: drive in the Device dropdown" -ForegroundColor Yellow
Write-Host "2. Click SELECT button and choose: $isoPath" -ForegroundColor Yellow
Write-Host "3. Click START button" -ForegroundColor Yellow
Write-Host "4. Wait for it to finish" -ForegroundColor Yellow

Start-Process -FilePath $rufusPath -Wait

Write-Host "`nUSB creation completed!" -ForegroundColor Green
Write-Host "Your bootable Ubuntu USB is ready on H: drive" -ForegroundColor Green