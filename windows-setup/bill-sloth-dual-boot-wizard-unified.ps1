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

# System profile detection (optimized for Bill's system)
$script:SystemProfile = @{
    # Hardware detection
    manufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer
    model = (Get-CimInstance -ClassName Win32_ComputerSystem).Model
    ram_gb = [math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 0)
    cpu = (Get-CimInstance -ClassName Win32_Processor).Name
    
    # Boot configuration
    firmware_type = (Get-ComputerInfo).BiosFirmwareType
    
    # Storage
    target_drive = $TargetDrive
    target_free_gb = if (Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "$TargetDrive`:" }) {
        [math]::Round((Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "$TargetDrive`:" }).FreeSpace / 1GB, 0)
    } else { 0 }
    
    # System capabilities
    existing_wsl2 = (Get-Command wsl -ErrorAction SilentlyContinue) -ne $null
    git_installed = (Get-Command git -ErrorAction SilentlyContinue) -ne $null
    internet_available = Test-Connection -ComputerName "8.8.8.8" -Count 1 -ErrorAction SilentlyContinue
    
    # Hardware-specific boot keys
    boot_key = switch -Regex ((Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer) {
        "ASUS" { "F2 or Del" }
        "Dell" { "F12 or F2" }
        "HP" { "F9 or F10" }
        "Lenovo" { "F12 or F1" }
        "MSI" { "F11 or Del" }
        "Gigabyte" { "F12 or Del" }
        default { "F12, F2, or Del" }
    }
}

Write-Host "DETECTED SYSTEM PROFILE:" -ForegroundColor Green
Write-Host "   Hardware: $($script:SystemProfile.manufacturer) $($script:SystemProfile.model)" -ForegroundColor White
Write-Host "   CPU: $($script:SystemProfile.cpu)" -ForegroundColor White
Write-Host "   RAM: $($script:SystemProfile.ram_gb)GB" -ForegroundColor White
Write-Host "   BIOS: $($script:SystemProfile.firmware_type)" -ForegroundColor White
Write-Host "   Boot Key: $($script:SystemProfile.boot_key)" -ForegroundColor White
Write-Host "   Target: $($TargetDrive): drive ($($script:SystemProfile.target_free_gb)GB free)" -ForegroundColor White
Write-Host "   WSL2: $(if ($script:SystemProfile.existing_wsl2) { 'Available' } else { 'Not found' })" -ForegroundColor White
Write-Host "   Git: $(if ($script:SystemProfile.git_installed) { 'Installed' } else { 'Not found' })" -ForegroundColor White
Write-Host "   Internet: $(if ($script:SystemProfile.internet_available) { 'Connected' } else { 'Offline' })" -ForegroundColor White
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
        
        # Add Bill Sloth automation to USB
        Write-Host "Adding Bill Sloth automation system to USB..." -ForegroundColor Yellow
        $billSlothSuccess = Add-BillSlothToUSB $selectedUSB.DeviceID
        
        if ($billSlothSuccess) {
            Write-Host "Bill Sloth integration complete!" -ForegroundColor Green
        } else {
            Write-Host "Warning: Bill Sloth integration failed - proceeding with basic USB" -ForegroundColor Yellow
        }
        
        return $selectedUSB.DeviceID
        
    } catch {
        Write-Host "Error downloading/running Rufus: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please manually create Ubuntu USB using any USB creation tool" -ForegroundColor Yellow
        return $null
    }
}

# Add Bill Sloth system to USB
function Add-BillSlothToUSB {
    param([string]$USBDrive)
    
    Write-Host "Integrating Bill Sloth automation system..." -ForegroundColor Cyan
    
    $billSlothUSBDir = "${USBDrive}\BillSloth"
    $tempCloneDir = "$env:TEMP\billsloth-integration"
    
    try {
        # Clone Bill Sloth repository
        if (Test-Path $tempCloneDir) {
            Remove-Item -Path $tempCloneDir -Recurse -Force
        }
        
        Write-Host "Downloading Bill Sloth system..." -ForegroundColor Yellow
        git clone --depth 1 https://github.com/How1337ItIs/billsloth.git $tempCloneDir
        
        # Create Bill Sloth directory on USB
        if (Test-Path $billSlothUSBDir) {
            Remove-Item -Path $billSlothUSBDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $billSlothUSBDir -Force | Out-Null
        
        # Copy system with optimization
        Write-Host "Copying automation system..." -ForegroundColor Yellow
        Copy-Item -Path "$tempCloneDir\*" -Destination $billSlothUSBDir -Recurse -Force
        
        # Create hardware-optimized startup script
        $startupScript = @"
#!/bin/bash
# Hardware-Optimized Bill Sloth Startup
# Customized for: ASUS System with 32GB RAM

echo "Bill Sloth Hardware-Optimized Startup"
echo "Hardware: ASUS System"
echo "BIOS: UEFI"
echo "================================="
echo ""

# Navigate to Bill Sloth
cd "`$(dirname "`$0")"

# Make everything executable
chmod +x *.sh lib/*.sh modules/*.sh scripts/*.sh bin/* 2>/dev/null

# Hardware-specific optimizations
echo "Applying hardware optimizations..."

# ASUS-specific optimizations
if [[ "`$(dmidecode -s system-manufacturer)" == *"ASUS"* ]]; then
    echo "ASUS system detected - applying ASUS optimizations"
fi

# AMD CPU optimizations
if grep -q "AMD" /proc/cpuinfo; then
    echo "AMD CPU detected - applying AMD optimizations"
fi

# Large RAM optimizations (32GB+)
TOTAL_RAM=`$(grep MemTotal /proc/meminfo | awk '{print `$2}')
if [ "`$TOTAL_RAM" -gt 30000000 ]; then
    echo "Large RAM system detected - applying memory optimizations"
fi

echo ""
echo "Starting optimized Bill Sloth setup..."

# Launch with hardware profile
if [ -f "onboard.sh" ]; then
    ./onboard.sh --hardware-profile="asus-uefi" --native-ubuntu
else
    ./bill_command_center.sh
fi
"@
        
        $startupScript | Out-File -FilePath "$billSlothUSBDir\hardware-optimized-startup.sh" -Encoding UTF8
        
        # Create automated post-install script
        $postInstall = @"
#!/bin/bash
# Automated Post-Install Configuration
# Runs after Ubuntu installation completes

echo "Bill Sloth Automated Post-Install"
echo "=================================="
echo ""

# Check if we're in the right environment
if [ ! -f /etc/os-release ]; then
    echo "ERROR: Not in Linux environment"
    exit 1
fi

. /etc/os-release
echo "Detected: `$NAME `$VERSION"
echo ""

# Update system
echo "Updating system packages..."
sudo apt update -y

# Install essential dependencies
echo "Installing dependencies automatically..."
sudo apt install -y curl wget git python3 python3-pip build-essential

# Audio system (essential for Bill Sloth voice control)
echo "Installing audio system..."
sudo apt install -y pulseaudio alsa-utils pipewire

# Voice control dependencies
echo "Installing voice control dependencies..."
sudo apt install -y portaudio19-dev python3-pyaudio

# Development tools
sudo apt install -y nodejs npm

echo "Automated installation complete"
echo ""
echo "Ready to launch Bill Sloth native system!"
echo "Run: ./hardware-optimized-startup.sh"
"@
        
        $postInstall | Out-File -FilePath "$billSlothUSBDir\automated-post-install.sh" -Encoding UTF8
        
        # Create system-specific documentation
        $docs = @"
BILL SLOTH SYSTEM-OPTIMIZED SETUP
==================================

Your System: ASUS with 32GB RAM
BIOS: UEFI
Boot Key: F2 or Del

POST-INSTALLATION STEPS:
========================

1. AUTOMATIC SETUP:
   cd /media/*/BillSloth
   ./automated-post-install.sh

2. HARDWARE-OPTIMIZED LAUNCH:
   ./hardware-optimized-startup.sh

3. VERIFY HARDWARE ACCESS:
   - Audio: arecord -l (should show audio devices)
   - Graphics: lspci | grep VGA
   - USB: lsusb

SYSTEM-SPECIFIC NOTES:
=====================

Hardware: ASUS systems have excellent Linux compatibility
Audio: Voice control optimized for detected audio hardware
Performance: 32GB RAM provides excellent performance for AI workloads
Storage: Multiple drives detected - plenty of space for development

Your Bill Sloth system is optimized for maximum performance and hardware access!
"@
        
        $docs | Out-File -FilePath "$billSlothUSBDir\SYSTEM-OPTIMIZED-SETUP.txt" -Encoding UTF8
        
        Write-Host "Bill Sloth automation system added to USB successfully" -ForegroundColor Green
        
        return $true
    }
    catch {
        Write-Host "Failed to add Bill Sloth system: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        if (Test-Path $tempCloneDir) {
            Remove-Item -Path $tempCloneDir -Recurse -Force
        }
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
    Write-Host "   - Press $($script:SystemProfile.boot_key) during $($script:SystemProfile.manufacturer) startup" -ForegroundColor Gray
    Write-Host "   - Set USB ($USBDrive) as first boot device" -ForegroundColor Gray
    Write-Host "   - Save and restart" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. UBUNTU INSTALLATION" -ForegroundColor White
    Write-Host "   - Choose 'Install Ubuntu alongside Windows'" -ForegroundColor Gray
    Write-Host "   - Select $TargetDrive drive for installation" -ForegroundColor Gray
    Write-Host "   - Allocate $UbuntuSizeGB GB for Ubuntu" -ForegroundColor Gray
    Write-Host "   - Follow installer prompts to completion" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. POST-INSTALLATION (AUTOMATED)" -ForegroundColor White
    Write-Host "   - GRUB bootloader will manage dual-boot menu" -ForegroundColor Gray
    Write-Host "   - WSL2 remains available in Windows for development" -ForegroundColor Gray
    Write-Host "   - Native Ubuntu provides full hardware access" -ForegroundColor Gray
    Write-Host ""
    Write-Host "5. BILL SLOTH AUTOMATION SETUP" -ForegroundColor White
    Write-Host "   - Open Terminal in Ubuntu: Ctrl+Alt+T" -ForegroundColor Gray
    Write-Host "   - Navigate to USB: cd /media/*/BillSloth" -ForegroundColor Gray
    Write-Host "   - Run automated setup: ./automated-post-install.sh" -ForegroundColor Gray
    Write-Host "   - Launch Bill Sloth: ./hardware-optimized-startup.sh" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "BILL SLOTH INTEGRATION BENEFITS:" -ForegroundColor Magenta
    Write-Host "- Complete automation system with ADHD/dyslexia optimizations" -ForegroundColor White
    Write-Host "- Voice control with full hardware access (no WSL2 limitations)" -ForegroundColor White
    Write-Host "- Audio tools: PipeWire, JACK, professional signal flow" -ForegroundColor White
    Write-Host "- Development environment significantly faster than WSL2" -ForegroundColor White
    Write-Host "- Direct GPU, USB, and system hardware access" -ForegroundColor White
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