# Fixed Bill Sloth USB Creator
# Removes module export commands that cause errors

function Install-AutomatedRufus {
    param(
        [string]$RufusDownloadPath = "$env:TEMP\rufus.exe"
    )
    
    Write-Host "Downloading Rufus..." -ForegroundColor Green
    try {
        $rufusUrl = "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5.exe"
        Invoke-WebRequest -Uri $rufusUrl -OutFile $RufusDownloadPath -UseBasicParsing
        Write-Host "Rufus downloaded successfully to: $RufusDownloadPath" -ForegroundColor Green
        return $RufusDownloadPath
    }
    catch {
        Write-Error "Failed to download Rufus: $($_.Exception.Message)"
        return $null
    }
}

function New-UbuntuBootableUSB {
    param(
        [Parameter(Mandatory=$true)]
        [string]$IsoPath,
        
        [string]$UsbDrive,
        
        [ValidateSet("Rufus", "PowerShell", "Auto")]
        [string]$Method = "Auto"
    )
    
    # Validate ISO file exists
    if (-not (Test-Path $IsoPath)) {
        Write-Error "ISO file not found: $IsoPath"
        return $false
    }
    
    # Get available USB drives (including your H: drive)
    $usbDrives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {
        ($_.DriveType -eq 2 -or $_.DeviceID -eq "H:") -and $_.Size -gt 1GB
    }
    
    if ($usbDrives.Count -eq 0) {
        Write-Error "No suitable USB drives found (4GB+ required)"
        return $false
    }
    
    # Display available USB drives
    Write-Host "Available USB drives:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $usbDrives.Count; $i++) {
        $drive = $usbDrives[$i]
        $sizeGB = [math]::Round($drive.Size / 1GB, 2)
        Write-Host "[$i] $($drive.DeviceID) - $($drive.VolumeName) ($sizeGB GB)" -ForegroundColor Cyan
    }
    
    # Let user select USB drive if not specified
    if (-not $UsbDrive) {
        $selection = Read-Host "Select USB drive number (0-$($usbDrives.Count-1))"
        if ($selection -match '^\d+$' -and [int]$selection -lt $usbDrives.Count) {
            $UsbDrive = $usbDrives[[int]$selection].DeviceID
        } else {
            Write-Error "Invalid selection"
            return $false
        }
    }
    
    Write-Warning "This will ERASE all data on drive $UsbDrive"
    $confirm = Read-Host "Continue? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "Operation cancelled" -ForegroundColor Yellow
        return $false
    }
    
    # Use Rufus method
    if ($Method -eq "Rufus" -or $Method -eq "Auto") {
        Write-Host "Using Rufus method..." -ForegroundColor Green
        $rufusPath = Install-AutomatedRufus
        
        if ($rufusPath) {
            Write-Host "Starting Rufus..." -ForegroundColor Green
            Write-Host "In Rufus:" -ForegroundColor Yellow
            Write-Host "1. Select your USB drive: $UsbDrive" -ForegroundColor Yellow
            Write-Host "2. Click SELECT and choose: $IsoPath" -ForegroundColor Yellow
            Write-Host "3. Click START" -ForegroundColor Yellow
            
            Start-Process -FilePath $rufusPath -Wait
            return $true
        }
    }
    
    Write-Error "USB creation failed"
    return $false
}

function New-AutomatedUbuntuUSB {
    param(
        [string]$IsoPath,
        [string]$UsbDrive
    )
    
    if (-not $IsoPath) {
        $IsoPath = Read-Host "Enter path to Ubuntu ISO file"
    }
    
    return New-UbuntuBootableUSB -IsoPath $IsoPath -UsbDrive $UsbDrive -Method "Auto"
}

# Main execution
Write-Host "Bill Sloth USB Creator - Fixed Version" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

$isoPath = Read-Host "Enter the path to your Ubuntu ISO file"
New-AutomatedUbuntuUSB -IsoPath $isoPath