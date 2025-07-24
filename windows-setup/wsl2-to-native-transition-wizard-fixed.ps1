# WSL2 to Native Ubuntu Dual-Boot Transition Wizard - FIXED VERSION
# Optimized for Bill's specific system configuration
# ASUS system, 32GB RAM, 27TB storage, existing WSL2 Ubuntu

param(
    [string]$TargetDrive = "E",
    [int]$UbuntuSizeGB = 500,
    [switch]$FastMode,
    [switch]$SkipClaude,
    [string]$ExistingISO = ""
)

#Requires -RunAsAdministrator

Write-Host @"
================================================================================
  WSL2 -> NATIVE UBUNTU DUAL-BOOT TRANSITION WIZARD                           
                                                                               
  From virtualized Ubuntu to true dual-boot performance                       
  Optimized for Bill's ASUS system with abundant storage                      
================================================================================
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "TRANSITION OVERVIEW:" -ForegroundColor Yellow
Write-Host "   Current: WSL2 Ubuntu 22.04 (fresh, being abandoned)" -ForegroundColor White
Write-Host "   Target: Native Ubuntu 24.04+ dual-boot" -ForegroundColor White
Write-Host "   Strategy: Clean install alongside Windows" -ForegroundColor White
Write-Host ""

# Bill's system profile (from analysis)
$script:BillSystemProfile = @{
    cpu = "AMD Ryzen (excellent Linux compatibility)"
    ram_gb = 32
    storage_total_tb = 27
    target_drive = $TargetDrive
    target_free_gb = 8200  # E: drive free space
    boot_type = "UEFI"
    manufacturer = "ASUS"
    existing_wsl2 = $true
    ubuntu_isos_found = $true
    git_installed = $true
    internet_available = $true
}

Write-Host "BILL'S SYSTEM PROFILE:" -ForegroundColor Green
Write-Host "   CPU: $($script:BillSystemProfile.cpu)" -ForegroundColor White
Write-Host "   RAM: $($script:BillSystemProfile.ram_gb)GB" -ForegroundColor White
Write-Host "   Storage: $($script:BillSystemProfile.storage_total_tb)TB total" -ForegroundColor White
Write-Host "   Target: $($TargetDrive): drive ($($script:BillSystemProfile.target_free_gb)GB free)" -ForegroundColor White
Write-Host ""

# Phase 1: WSL2 Assessment
function Get-WSL2Status {
    Write-Host "=== PHASE 1: WSL2 STATUS ASSESSMENT ===" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        $wslStatus = wsl --status 2>$null
        $wslList = wsl -l -v 2>$null
        
        if ($wslList -match "Ubuntu") {
            Write-Host "Found WSL2 Ubuntu installation" -ForegroundColor Green
            Write-Host "WSL2 will be LEFT INTACT for development/testing" -ForegroundColor Yellow
            Write-Host ""
            return "keep"
        }
    }
    catch {
        Write-Host "WSL2 not detected or not running" -ForegroundColor Cyan
        return "none"
    }
}

# Phase 2: Ubuntu ISO Preparation  
function Get-OptimalUbuntuISO {
    Write-Host "=== PHASE 2: UBUNTU ISO PREPARATION ===" -ForegroundColor Cyan
    Write-Host ""
    
    # Check for existing ISOs (Bill has multiple Ubuntu 24.04.2 ISOs)
    if ($ExistingISO -and (Test-Path $ExistingISO)) {
        Write-Host "Using specified ISO: $ExistingISO" -ForegroundColor Green
        return $ExistingISO
    }
    
    Write-Host "Scanning for existing Ubuntu ISOs..." -ForegroundColor Yellow
    
    $searchPaths = @(
        "$env:USERPROFILE\Downloads",
        "$env:USERPROFILE\Desktop", 
        "$env:USERPROFILE\Documents",
        "C:\Users\*\Downloads"
    )
    
    $foundISOs = @()
    foreach ($path in $searchPaths) {
        $found = Get-ChildItem -Path $path -Filter "*ubuntu*.iso" -ErrorAction SilentlyContinue
        $foundISOs += $found
    }
    
    if ($foundISOs.Count -gt 0) {
        # Sort by newest and prefer 24.04+ versions
        $bestISO = $foundISOs | 
            Sort-Object @{Expression={$_.Name -match "24\.04"}; Descending=$true}, LastWriteTime -Descending |
            Select-Object -First 1
            
        $isoSizeGB = [math]::Round($bestISO.Length / 1GB, 2)
        Write-Host "Found optimal ISO: $($bestISO.Name) ($isoSizeGB GB)" -ForegroundColor Green
        return $bestISO.FullName
    }
    
    Write-Host "No Ubuntu ISOs found locally" -ForegroundColor Yellow
    Write-Host "Please download Ubuntu 24.04+ LTS from ubuntu.com" -ForegroundColor White
    
    do {
        $manualPath = Read-Host "Enter path to Ubuntu ISO file"
        if (Test-Path $manualPath) {
            return $manualPath
        }
        Write-Host "File not found: $manualPath" -ForegroundColor Red
    } while ($true)
}

# Phase 3: USB Creation with Bill Sloth Integration
function New-TransitionUSB {
    param([string]$ISOPath)
    
    Write-Host "=== PHASE 3: TRANSITION USB CREATION ===" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Detecting suitable USB drives..." -ForegroundColor Yellow
    
    # H: drive is 239GB FAT32 (from analysis) - perfect for Ubuntu USB
    $usbDrives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { 
        $_.DriveType -eq 2 -and $_.Size -gt 8GB 
    }
    
    if ($usbDrives.Count -eq 0) {
        Write-Host "No suitable USB drives found (8GB+ required)" -ForegroundColor Red
        Write-Host "Based on system analysis, H: drive (239GB) appears to be removable" -ForegroundColor Yellow
        Write-Host "Please ensure a USB drive is connected and try again" -ForegroundColor White
        return $null
    }
    
    # Auto-select H: drive if available (from Bill's system analysis)
    $hDrive = $usbDrives | Where-Object { $_.DeviceID -eq "H:" }
    if ($hDrive) {
        Write-Host "Using H: drive (239GB) - matches system analysis" -ForegroundColor Green
        $selectedUSB = $hDrive
    } else {
        # Interactive selection for other drives
        Write-Host "Available USB drives:" -ForegroundColor Cyan
        for ($i = 0; $i -lt $usbDrives.Count; $i++) {
            $drive = $usbDrives[$i]
            $sizeGB = [math]::Round($drive.Size / 1GB, 2)
            $label = if ($drive.VolumeName) { $drive.VolumeName } else { "No Label" }
            Write-Host "  [$i] $($drive.DeviceID) - $label ($sizeGB GB)" -ForegroundColor White
        }
        
        do {
            $selection = Read-Host "Select USB drive number (0-$($usbDrives.Count-1))"
            if ($selection -match '^\d+$' -and [int]$selection -lt $usbDrives.Count) {
                $selectedUSB = $usbDrives[[int]$selection]
                break
            }
            Write-Host "Invalid selection" -ForegroundColor Red
        } while ($true)
    }
    
    $usbSizeGB = [math]::Round($selectedUSB.Size / 1GB, 2)
    Write-Host "Target USB: $($selectedUSB.DeviceID) ($usbSizeGB GB)" -ForegroundColor Green
    Write-Host ""
    
    # Safety confirmation
    Write-Host "WARNING: ALL DATA on $($selectedUSB.DeviceID) will be ERASED!" -ForegroundColor Red
    Write-Host "This will create a bootable Ubuntu USB for dual-boot installation" -ForegroundColor Yellow
    Write-Host ""
    $confirm = Read-Host "Continue with USB creation? (y/N)"
    
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "USB creation cancelled" -ForegroundColor Red
        return $null
    }
    
    # Create USB using Rufus (most reliable for UEFI dual-boot)  
    Write-Host "Downloading Rufus for USB creation..." -ForegroundColor Yellow
    $rufusPath = "$env:TEMP\rufus.exe"
    
    try {
        if (-not (Test-Path $rufusPath)) {
            $rufusUrl = "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5.exe"
            Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusPath -UseBasicParsing
        }
        
        Write-Host "Rufus ready" -ForegroundColor Green
        Write-Host ""
        Write-Host "Launching Rufus for USB creation..." -ForegroundColor Green
        Write-Host ""
        Write-Host "RUFUS CONFIGURATION FOR BILL'S SYSTEM:" -ForegroundColor Yellow
        Write-Host "1. Device: Select $($selectedUSB.DeviceID)" -ForegroundColor White
        Write-Host "2. Boot selection: SELECT -> $ISOPath" -ForegroundColor White
        Write-Host "3. Image option: Standard Windows installation" -ForegroundColor White
        Write-Host "4. Partition scheme: GPT (for UEFI)" -ForegroundColor White
        Write-Host "5. Target system: UEFI (non CSM)" -ForegroundColor White
        Write-Host "6. File system: FAT32" -ForegroundColor White
        Write-Host "7. Click START" -ForegroundColor White
        Write-Host ""
        
        Start-Process -FilePath $rufusPath -Wait
        
        Write-Host "USB creation completed!" -ForegroundColor Green
        return $selectedUSB.DeviceID
        
    } catch {
        Write-Host "Error downloading/running Rufus: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please manually create Ubuntu USB using any USB creation tool" -ForegroundColor Yellow
        return $null
    }
}

# Phase 4: Partition Analysis and Preparation
function Initialize-DualBootPartitioning {
    Write-Host "=== PHASE 4: DUAL-BOOT PARTITIONING ===" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Analyzing $TargetDrive drive for Ubuntu installation..." -ForegroundColor Yellow
    
    $targetDisk = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "$TargetDrive:" }
    
    if (-not $targetDisk) {
        Write-Host "Error: Drive $TargetDrive not found!" -ForegroundColor Red
        return $false
    }
    
    $freeSpaceGB = [math]::Round($targetDisk.FreeSpace / 1GB, 2)
    $totalSizeGB = [math]::Round($targetDisk.Size / 1GB, 2)
    
    Write-Host "Drive Analysis:" -ForegroundColor Green
    Write-Host "  Drive: $TargetDrive" -ForegroundColor White
    Write-Host "  Total Size: $totalSizeGB GB" -ForegroundColor White
    Write-Host "  Free Space: $freeSpaceGB GB" -ForegroundColor White
    Write-Host "  Ubuntu Target: $UbuntuSizeGB GB" -ForegroundColor White
    Write-Host ""
    
    if ($freeSpaceGB -lt $UbuntuSizeGB) {
        Write-Host "Insufficient free space for Ubuntu installation!" -ForegroundColor Red
        Write-Host "Required: $UbuntuSizeGB GB, Available: $freeSpaceGB GB" -ForegroundColor Red
        return $false
    }
    
    Write-Host "PARTITIONING STRATEGY:" -ForegroundColor Yellow
    Write-Host "1. Ubuntu Root: 100GB (system files)" -ForegroundColor White
    Write-Host "2. Ubuntu Home: $($UbuntuSizeGB - 132)GB (user data)" -ForegroundColor White
    Write-Host "3. Ubuntu Swap: 32GB (matches RAM)" -ForegroundColor White
    Write-Host "4. Remaining: $($freeSpaceGB - $UbuntuSizeGB)GB (available)" -ForegroundColor White
    Write-Host ""
    Write-Host "INSTALLATION WILL BE HANDLED BY UBUNTU INSTALLER" -ForegroundColor Green
    Write-Host "No Windows partition changes needed - abundant free space!" -ForegroundColor Green
    
    return $true
}

# Phase 5: Final Instructions
function Show-InstallationInstructions {
    param([string]$USBDrive, [string]$ISOPath)
    
    Write-Host "=== PHASE 5: INSTALLATION INSTRUCTIONS ===" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "DUAL-BOOT INSTALLATION READY!" -ForegroundColor Green
    Write-Host ""
    Write-Host "NEXT STEPS:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. RESTART YOUR COMPUTER" -ForegroundColor White
    Write-Host "   - Save all work and close programs" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. BOOT FROM USB" -ForegroundColor White
    Write-Host "   - Press F2 or Del during startup for BIOS/UEFI" -ForegroundColor Gray
    Write-Host "   - Set USB ($USBDrive) as first boot device" -ForegroundColor Gray
    Write-Host "   - Save and restart" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. UBUNTU INSTALLATION" -ForegroundColor White
    Write-Host "   - Choose 'Install Ubuntu alongside Windows'" -ForegroundColor Gray
    Write-Host "   - Select $TargetDrive drive for installation" -ForegroundColor Gray
    Write-Host "   - Allocate $UbuntuSizeGB GB for Ubuntu" -ForegroundColor Gray
    Write-Host "   - Follow installer prompts to completion" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. POST-INSTALLATION" -ForegroundColor White
    Write-Host "   - GRUB bootloader will manage dual-boot menu" -ForegroundColor Gray
    Write-Host "   - WSL2 remains available in Windows for development" -ForegroundColor Gray
    Write-Host "   - Native Ubuntu provides full hardware access" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "BILL SLOTH INTEGRATION:" -ForegroundColor Magenta
    Write-Host "- All Bill Sloth automation will be available in native Ubuntu" -ForegroundColor White
    Write-Host "- Voice control and full system access enabled" -ForegroundColor White
    Write-Host "- Development environment significantly faster than WSL2" -ForegroundColor White
    Write-Host ""
    
    Write-Host "Ready to restart and begin installation? (y/N)" -ForegroundColor Yellow
    $restart = Read-Host
    
    if ($restart -eq 'y' -or $restart -eq 'Y') {
        Write-Host "Restarting system in 10 seconds..." -ForegroundColor Green
        Write-Host "Press Ctrl+C to cancel" -ForegroundColor Gray
        Start-Sleep -Seconds 10
        Restart-Computer -Force
    } else {
        Write-Host "Manual restart required when ready for installation" -ForegroundColor Yellow
    }
}

# Main Execution Flow
Write-Host "Starting WSL2 to Native Ubuntu transition..." -ForegroundColor Green
Write-Host ""

# Phase 1: WSL2 Assessment
$wslStatus = Get-WSL2Status

# Phase 2: Find Ubuntu ISO
$ubuntuISO = Get-OptimalUbuntuISO

if (-not $ubuntuISO) {
    Write-Host "Ubuntu ISO required for installation. Exiting." -ForegroundColor Red
    exit 1
}

# Phase 3: Create USB
$usbDrive = New-TransitionUSB -ISOPath $ubuntuISO

if (-not $usbDrive) {
    Write-Host "USB creation required for installation. Exiting." -ForegroundColor Red
    exit 1
}

# Phase 4: Partition Analysis
$partitionReady = Initialize-DualBootPartitioning

if (-not $partitionReady) {
    Write-Host "Partition preparation failed. Exiting." -ForegroundColor Red
    exit 1
}

# Phase 5: Final Instructions
Show-InstallationInstructions -USBDrive $usbDrive -ISOPath $ubuntuISO

Write-Host ""
Write-Host "WSL2 to Native Ubuntu Transition Wizard Complete!" -ForegroundColor Green
Write-Host "System ready for dual-boot installation." -ForegroundColor White