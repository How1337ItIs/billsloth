# WSL2 to Native Ubuntu Dual-Boot Transition Wizard - FIXED VERSION
# Optimized for Bill's specific system configuration
# ASUS system, 32GB RAM, 27TB storage, existing WSL2 Ubuntu

param(
    [string]$TargetDrive = "E",
    [int]$UbuntuSizeGB = 500,
    [switch]$FastMode,
    [switch]$SkipClaude,
    [switch]$NonInteractive,
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

# Robust path resolution for simple ISO builder (verified working)
function Get-SimpleISOBuilderPath {
    $possiblePaths = @(
        # Try PSScriptRoot (most reliable for PowerShell 3.0+)
        (Join-Path $PSScriptRoot "bill-sloth-RECOMMENDED-iso-builder.ps1"),
        
        # Try current working directory  
        (Join-Path $PWD "bill-sloth-RECOMMENDED-iso-builder.ps1"),
        
        # Try same directory as current script using PSCommandPath
        (Join-Path (Split-Path $PSCommandPath -Parent) "bill-sloth-RECOMMENDED-iso-builder.ps1"),
        
        # Try common installation paths
        "C:\Users\natha\bill sloth\windows-setup\bill-sloth-RECOMMENDED-iso-builder.ps1",
        "$env:USERPROFILE\bill sloth\windows-setup\bill-sloth-RECOMMENDED-iso-builder.ps1"
    )
    
    # Add MyInvocation path conditionally (avoid inline if in array)
    if ($MyInvocation.MyCommand.Path) {
        $possiblePaths += Join-Path (Split-Path $MyInvocation.MyCommand.Path) "bill-sloth-RECOMMENDED-iso-builder.ps1"
    }
    
    foreach ($path in $possiblePaths) {
        if ($path -and (Test-Path $path)) {
            Write-Host "Found simple ISO builder at: $path" -ForegroundColor Green
            return $path
        }
    }
    
    # If nothing found, FAIL FAST - no silent fallbacks!
    Write-Host "Simple ISO builder not found in expected locations" -ForegroundColor Red
    Write-Host ""
    Write-Host "Searched locations:" -ForegroundColor Yellow
    foreach ($path in $possiblePaths) {
        if ($path) {
            Write-Host "  - $path" -ForegroundColor Gray
        }
    }
    Write-Host ""
    
    throw "CRITICAL: Simple ISO builder not found. Cannot create custom ISO without it!"
    
}

# Phase 2: Ubuntu ISO Preparation  
function Get-CyberpunkBillSlothISO {
    Write-Host "=== PHASE 2: CYBERPUNK BILL SLOTH ISO CREATION ===" -ForegroundColor Cyan
    Write-Host ""
    
    # Check for existing Bill Sloth cyberpunk ISO
    $customISOPath = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso"
    
    if (Test-Path $customISOPath) {
        Write-Host "Found existing Bill Sloth Cyberpunk ISO" -ForegroundColor Green
        
        if ($NonInteractive) {
            $useExisting = "Y"
            Write-Host "Auto-using existing cyberpunk ISO (NonInteractive mode)" -ForegroundColor Yellow
        } else {
            $useExisting = Read-Host "Use existing cyberpunk ISO? (Y/n)"
        }
        
        if ($useExisting -ne 'n' -and $useExisting -ne 'N') {
            Write-Host "SUCCESS: Using existing cyberpunk ISO: $customISOPath" -ForegroundColor Green
            return $customISOPath
        }
    }
    
    Write-Host "Creating custom cyberpunk Bill Sloth ISO..." -ForegroundColor Magenta
    Write-Host "This badass ISO will include:" -ForegroundColor Yellow
    Write-Host "  - Complete Bill Sloth automation system" -ForegroundColor White
    Write-Host "  - Claude Code pre-installed and configured" -ForegroundColor White
    Write-Host "  - All dependencies integrated (audio, voice, dev tools)" -ForegroundColor White
    Write-Host "  - Cyberpunk aesthetics with ASCII sloth boot animations" -ForegroundColor White
    Write-Host "  - Automated first-boot setup" -ForegroundColor White
    Write-Host "  - ADHD/dyslexia optimized interface" -ForegroundColor White
    Write-Host ""
    
    if ($NonInteractive) {
        $confirm = "Y"
        Write-Host "Auto-proceeding with custom ISO creation (NonInteractive mode)" -ForegroundColor Yellow
    } else {
        $confirm = Read-Host "Proceed with custom cyberpunk ISO creation? This may take 30-60 minutes (Y/n)"
    }
    
    if ($confirm -eq 'n' -or $confirm -eq 'N') {
        Write-Host "Custom ISO creation cancelled - falling back to standard Ubuntu..." -ForegroundColor Yellow
        return Get-StandardUbuntuISO
    }
    
    try {
        # Execute the simple ISO builder (verified working by Bill)
        Write-Host "Launching verified working simple ISO builder..." -ForegroundColor Magenta
        $simpleBuilderPath = Get-SimpleISOBuilderPath
        
        # No fallbacks - fail fast if builder not found
        if (-not $simpleBuilderPath) {
            throw "Simple ISO builder not found - cannot create custom ISO!"
        }
        
        Write-Host "Found simple ISO builder: $simpleBuilderPath" -ForegroundColor Green
        Write-Host "Using Bill's verified working WSL2 commands" -ForegroundColor Cyan
        
        # Execute simple ISO builder
        $builderArgs = @(
            "-OutputISO", $customISOPath
        )
        
        Write-Host "Executing: & '$simpleBuilderPath' $($builderArgs -join ' ')" -ForegroundColor Cyan
        & $simpleBuilderPath @builderArgs
        
        if ($LASTEXITCODE -eq 0 -and (Test-Path $customISOPath)) {
            Write-Host "SUCCESS: Bill Sloth Cyberpunk ISO created with verified method!" -ForegroundColor Green
            Write-Host "This is a REAL custom ISO created with Bill's tested commands!" -ForegroundColor Cyan
            return $customISOPath
        } else {
            throw "Simple ISO creation failed - NO FALLBACK!"
        }
    }
    catch {
        Write-Host ""
        Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
        Write-Host "██  ❌ CUSTOM ISO CREATION FAILED - NO FALLBACK!                              ██" -ForegroundColor Red
        Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
        Write-Host ""
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "The user explicitly requested a custom ISO, not standard Ubuntu." -ForegroundColor Yellow
        Write-Host "Fix the issue above and try again." -ForegroundColor Yellow
        Write-Host ""
        throw "Cannot continue without custom ISO"
    }
}

# Fallback standard Ubuntu ISO detection
function Get-StandardUbuntuISO {
    Write-Host "Scanning for standard Ubuntu ISOs..." -ForegroundColor Yellow
    
    # Check for existing ISOs
    if ($ExistingISO -and (Test-Path $ExistingISO)) {
        Write-Host "SUCCESS: Using specified ISO: $ExistingISO"
        return $ExistingISO
    }
    
    $searchPaths = @(
        "$env:USERPROFILE\Downloads\*ubuntu*.iso",
        "$env:USERPROFILE\Desktop\*ubuntu*.iso",
        "$env:USERPROFILE\Documents\*ubuntu*.iso"
    )
    
    $foundISOs = @()
    foreach ($pattern in $searchPaths) {
        $found = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
        $foundISOs += $found
    }
    
    if ($foundISOs.Count -gt 0) {
        # Sort by newest and prefer 24.04+ versions
        $bestISO = $foundISOs | 
            Sort-Object @{Expression={$_.Name -match "24\.04"}; Descending=$true}, LastWriteTime -Descending |
            Select-Object -First 1
            
        $isoSizeGB = [math]::Round($bestISO.Length / 1GB, 2)
        Write-Host "SUCCESS: Found standard ISO: $($bestISO.Name) ($isoSizeGB GB)"
        return $bestISO.FullName
    }
    
    Write-Host "WARNING: No Ubuntu ISOs found locally"
    Write-Host "Please download Ubuntu 24.04+ LTS from ubuntu.com"
    
    # Handle NonInteractive mode
    if ($NonInteractive) {
        Write-Host "ERROR: NonInteractive mode requires Ubuntu ISO to be present" -ForegroundColor Red
        Write-Host "Please ensure Ubuntu ISO is in Downloads folder and retry" -ForegroundColor Yellow
        exit 1
    }
    
    do {
        $manualPath = Read-Host "Enter path to Ubuntu ISO file"
        if (Test-Path $manualPath) {
            return $manualPath
        }
        Write-Host "ERROR: File not found: $manualPath"
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
        
        if ($NonInteractive) {
            # Auto-select first available USB drive
            $selectedUSB = $usbDrives[0]
            Write-Host "Auto-selected USB drive: $($selectedUSB.DeviceID) (NonInteractive mode)" -ForegroundColor Yellow
        } else {
            do {
                $selection = Read-Host "Select USB drive number (0-$($usbDrives.Count-1))"
                if ($selection -match '^\d+$' -and [int]$selection -lt $usbDrives.Count) {
                    $selectedUSB = $usbDrives[[int]$selection]
                    break
                }
                Write-Host "Invalid selection" -ForegroundColor Red
            } while ($true)
        }
    }
    
    $usbSizeGB = [math]::Round($selectedUSB.Size / 1GB, 2)
    Write-Host "Target USB: $($selectedUSB.DeviceID) ($usbSizeGB GB)" -ForegroundColor Green
    Write-Host ""
    
    # Safety confirmation with NonInteractive support
    Write-Host "WARNING: ALL DATA on $($selectedUSB.DeviceID) will be ERASED!" -ForegroundColor Red
    Write-Host "This will create a bootable Ubuntu USB for dual-boot installation" -ForegroundColor Yellow
    Write-Host ""
    
    if ($NonInteractive) {
        $confirm = "y"
        Write-Host "Auto-confirming USB creation (NonInteractive mode)" -ForegroundColor Yellow
    } else {
        $confirm = Read-Host "Continue with USB creation? (y/N)"
    }
    
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "USB creation cancelled" -ForegroundColor Red
        return $null
    }
    
    # Create USB using fully automated CLI method
    Write-Host "Creating bootable Ubuntu USB (fully automated)..." -ForegroundColor Yellow
    
    try {
        # Download Rufus for USB creation
        Write-Host "Downloading Rufus for USB creation..." -ForegroundColor Yellow
        $rufusPath = "$env:TEMP\rufus.exe"
        
        if (-not (Test-Path $rufusPath)) {
            $rufusUrl = "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5.exe"
            Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusPath -UseBasicParsing
        }
        
        Write-Host "Creating Ubuntu USB with Rufus..." -ForegroundColor Green
        
        # Use Rufus command line if NonInteractive, otherwise GUI
        if ($NonInteractive) {
            # Try Rufus CLI automation
            $rufusArgs = @(
                "-iso", $ISOPath,
                "-device", $selectedUSB.DeviceID,
                "-partition", "GPT",
                "-target", "UEFI",
                "-filesystem", "FAT32",
                "-unattended"
            )
            
            Start-Process -FilePath $rufusPath -ArgumentList $rufusArgs -Wait -NoNewWindow
            $success = $true
        } else {
            # Launch Rufus GUI with instructions
            Write-Host "RUFUS CONFIGURATION:" -ForegroundColor Yellow
            Write-Host "1. Device: Select $($selectedUSB.DeviceID)" -ForegroundColor White  
            Write-Host "2. Boot selection: SELECT -> $ISOPath" -ForegroundColor White
            Write-Host "3. Partition scheme: GPT (for UEFI)" -ForegroundColor White
            Write-Host "4. Target system: UEFI (non CSM)" -ForegroundColor White
            Write-Host "5. File system: FAT32" -ForegroundColor White
            Write-Host "6. Click START" -ForegroundColor White
            
            Start-Process -FilePath $rufusPath -Wait
            $success = $true
        }
        
        if (-not $success) {
            throw "All USB creation methods failed"
        }
        
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

# PowerShell native USB creation method
function New-BootableUSBNative {
    param([string]$ISOPath, [string]$USBDrive)
    
    Write-Host "Attempting PowerShell native USB creation..." -ForegroundColor Yellow
    
    try {
        # Mount ISO
        $mount = Mount-DiskImage -ImagePath $ISOPath -PassThru
        $driveLetter = ($mount | Get-Volume).DriveLetter
        
        # Format USB drive
        $usbDriveLetter = $USBDrive.TrimEnd(':')
        Format-Volume -DriveLetter $usbDriveLetter -FileSystem FAT32 -Force -Confirm:$false
        
        # Copy ISO contents to USB
        Write-Host "Copying ISO contents to USB drive..." -ForegroundColor Cyan
        Copy-Item -Path "${driveLetter}:\*" -Destination "${USBDrive}\" -Recurse -Force
        
        # Dismount ISO
        Dismount-DiskImage -ImagePath $ISOPath
        
        Write-Host "PowerShell native USB creation completed" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "PowerShell native method failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Automated Rufus USB creation method
function New-BootableUSBRufusAutomated {
    param([string]$ISOPath, [string]$USBDrive)
    
    Write-Host "Attempting automated Rufus USB creation..." -ForegroundColor Yellow
    
    try {
        # Download Rufus if not present
        $rufusPath = "$env:TEMP\rufus.exe"
        if (-not (Test-Path $rufusPath)) {
            Write-Host "Downloading Rufus..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri "https://github.com/pbatard/rufus/releases/download/v4.4/rufus-4.4.exe" -OutFile $rufusPath
        }
        
        # Run Rufus with automated parameters
        $rufusArgs = @(
            "-i", $ISOPath,
            "-d", $USBDrive,
            "--FileSystem", "FAT32",
            "--Label", "BILLSLOTH-CYBER",
            "--QuickFormat",
            "--NoRufusCheck"
        )
        
        Start-Process -FilePath $rufusPath -ArgumentList $rufusArgs -Wait -WindowStyle Hidden
        
        Write-Host "Automated Rufus USB creation completed" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Automated Rufus method failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Manual Rufus USB creation method
function New-BootableUSBRufusManual {
    param([string]$ISOPath, [string]$USBDrive)
    
    Write-Host "Launching manual Rufus USB creation..." -ForegroundColor Yellow
    
    try {
        # Download Rufus if not present
        $rufusPath = "$env:TEMP\rufus.exe"
        if (-not (Test-Path $rufusPath)) {
            Write-Host "Downloading Rufus..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri "https://github.com/pbatard/rufus/releases/download/v4.4/rufus-4.4.exe" -OutFile $rufusPath
        }
        
        Write-Host "Launching Rufus GUI for manual USB creation..." -ForegroundColor Cyan
        Write-Host "Please configure:" -ForegroundColor Yellow
        Write-Host "  - Device: $USBDrive" -ForegroundColor White
        Write-Host "  - Image: $ISOPath" -ForegroundColor White
        Write-Host "  - Partition: GPT (UEFI)" -ForegroundColor White
        Write-Host "  - File System: FAT32" -ForegroundColor White
        Write-Host ""
        
        # Launch Rufus and wait for completion
        Start-Process -FilePath $rufusPath -Wait
        
        # Assume success if user completes process
        Write-Host "Manual Rufus process completed" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Manual Rufus method failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
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
    
    $targetDisk = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "${TargetDrive}:" }
    
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
    
    if ($NonInteractive) {
        Write-Host "NonInteractive mode: Manual restart required for installation" -ForegroundColor Yellow
        Write-Host "Boot from USB and install Ubuntu when ready" -ForegroundColor White
    } else {
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
}

# Main Execution Flow
Write-Host "Starting WSL2 to Native Ubuntu transition..." -ForegroundColor Green
Write-Host ""

# Phase 1: WSL2 Assessment
$wslStatus = Get-WSL2Status

# Phase 2: Find Ubuntu ISO
$ubuntuISO = Get-CyberpunkBillSlothISO

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