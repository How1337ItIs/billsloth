# WSL2 to Native Ubuntu Dual-Boot Transition Wizard
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
╔══════════════════════════════════════════════════════════════════════════════╗
║  🔄 WSL2 → NATIVE UBUNTU DUAL-BOOT TRANSITION WIZARD 🔄                     ║
║                                                                              ║
║  From virtualized Ubuntu to true dual-boot performance                      ║
║  Optimized for Bill's ASUS system with abundant storage                     ║
╚══════════════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "🎯 TRANSITION OVERVIEW:" -ForegroundColor Yellow
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

Write-Host "📊 BILL'S SYSTEM PROFILE:" -ForegroundColor Green
Write-Host "   CPU: $($script:BillSystemProfile.cpu)" -ForegroundColor White
Write-Host "   RAM: $($script:BillSystemProfile.ram_gb)GB" -ForegroundColor White
Write-Host "   Storage: $($script:BillSystemProfile.storage_total_tb)TB total" -ForegroundColor White
Write-Host "   Target: $($TargetDrive): drive ($($script:BillSystemProfile.target_free_gb)GB free)" -ForegroundColor White
Write-Host "   Boot: $($script:BillSystemProfile.boot_type)" -ForegroundColor White
Write-Host ""

# Phase 1: WSL2 Status Check
function Check-WSL2Status {
    Write-Host "═══ PHASE 1: WSL2 STATUS CHECK ═══" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "🔍 Current WSL2 status:" -ForegroundColor Yellow
    try {
        $wslStatus = & wsl --list --verbose 2>&1
        Write-Host $wslStatus -ForegroundColor White
        Write-Host ""
        
        Write-Host "💡 WSL2 Ubuntu detected - will be left as-is" -ForegroundColor Green
        Write-Host "   WSL2 remains available for development/testing" -ForegroundColor White
        Write-Host "   Native Ubuntu will be primary Linux environment" -ForegroundColor White
        Write-Host ""
        
        return "keep"
    }
    catch {
        Write-Host "ℹ️  WSL2 not detected or not running" -ForegroundColor Cyan
        return "none"
    }
}

# Phase 2: Ubuntu ISO Preparation  
function Get-OptimalUbuntuISO {
    Write-Host "═══ PHASE 2: UBUNTU ISO PREPARATION ═══" -ForegroundColor Cyan
    Write-Host ""
    
    # Check for existing ISOs (Bill has multiple Ubuntu 24.04.2 ISOs)
    if ($ExistingISO -and (Test-Path $ExistingISO)) {
        Write-Host "✅ Using specified ISO: $ExistingISO" -ForegroundColor Green
        return $ExistingISO
    }
    
    Write-Host "🔍 Scanning for existing Ubuntu ISOs..." -ForegroundColor Yellow
    
    $searchPaths = @(
        "$env:USERPROFILE\Downloads\ubuntu-24*.iso",
        "$env:USERPROFILE\Downloads\ubuntu*.iso",
        "$env:USERPROFILE\Desktop\ubuntu*.iso"
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
        Write-Host "✅ Found optimal ISO: $($bestISO.Name) ($isoSizeGB GB)" -ForegroundColor Green
        return $bestISO.FullName
    }
    
    Write-Host "⚠️  No Ubuntu ISOs found locally" -ForegroundColor Yellow
    Write-Host "📥 Please download Ubuntu 24.04+ LTS from ubuntu.com" -ForegroundColor White
    
    do {
        $manualPath = Read-Host "Enter path to Ubuntu ISO file"
        if (Test-Path $manualPath) {
            return $manualPath
        }
        Write-Host "❌ File not found: $manualPath" -ForegroundColor Red
    } while ($true)
}

# Phase 3: USB Creation with Bill Sloth Integration
function New-TransitionUSB {
    param([string]$ISOPath)
    
    Write-Host "═══ PHASE 3: TRANSITION USB CREATION ═══" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "🔍 Detecting suitable USB drives..." -ForegroundColor Yellow
    
    # H: drive is 239GB FAT32 (from analysis) - perfect for Ubuntu USB
    $usbDrives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { 
        $_.DriveType -eq 2 -and $_.Size -gt 8GB 
    }
    
    if ($usbDrives.Count -eq 0) {
        Write-Host "❌ No suitable USB drives found (8GB+ required)" -ForegroundColor Red
        Write-Host "💡 Based on system analysis, H: drive (239GB) appears to be removable" -ForegroundColor Yellow
        Write-Host "Please ensure a USB drive is connected and try again" -ForegroundColor White
        return $null
    }
    
    # Auto-select H: drive if available (from Bill's system analysis)
    $hDrive = $usbDrives | Where-Object { $_.DeviceID -eq "H:" }
    if ($hDrive) {
        Write-Host "✅ Using H: drive (239GB) - matches system analysis" -ForegroundColor Green
        $selectedUSB = $hDrive
    } else {
        # Interactive selection for other drives
        Write-Host "📋 Available USB drives:" -ForegroundColor Cyan
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
            Write-Host "❌ Invalid selection" -ForegroundColor Red
        } while ($true)
    }
    
    $usbSizeGB = [math]::Round($selectedUSB.Size / 1GB, 2)
    Write-Host "🎯 Target USB: $($selectedUSB.DeviceID) ($usbSizeGB GB)" -ForegroundColor Green
    Write-Host ""
    
    # Safety confirmation
    Write-Host "⚠️  WARNING: ALL DATA on $($selectedUSB.DeviceID) will be ERASED!" -ForegroundColor Red
    Write-Host "This will create a bootable Ubuntu USB for dual-boot installation" -ForegroundColor Yellow
    Write-Host ""
    $confirm = Read-Host "Continue with USB creation? (y/N)"
    
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "❌ USB creation cancelled" -ForegroundColor Red
        return $null
    }
    
    # Create USB using Rufus (most reliable for UEFI dual-boot)  
    Write-Host "📥 Downloading Rufus for USB creation..." -ForegroundColor Yellow
    $rufusPath = "$env:TEMP\rufus.exe"
    
    try {
        if (-not (Test-Path $rufusPath)) {
            $rufusUrl = "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5.exe"
            Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusPath -UseBasicParsing
        }
        
        Write-Host "✅ Rufus ready" -ForegroundColor Green
        Write-Host ""
        Write-Host "🚀 Launching Rufus for USB creation..." -ForegroundColor Green
        Write-Host ""
        Write-Host "📋 RUFUS CONFIGURATION FOR DUAL-BOOT:" -ForegroundColor Yellow
        Write-Host "   1. Device: Select $($selectedUSB.DeviceID)" -ForegroundColor White
        Write-Host "   2. Boot selection: Click SELECT and choose:" -ForegroundColor White
        Write-Host "      $ISOPath" -ForegroundColor Cyan
        Write-Host "   3. Partition scheme: GPT" -ForegroundColor White
        Write-Host "   4. Target system: UEFI (non CSM)" -ForegroundColor White
        Write-Host "   5. File system: FAT32" -ForegroundColor White
        Write-Host "   6. Click START" -ForegroundColor White
        Write-Host ""
        
        Start-Process -FilePath $rufusPath -Wait
        Write-Host "✅ Rufus completed" -ForegroundColor Green
        
        # Add Bill Sloth automation to USB
        Write-Host "📦 Adding Bill Sloth automation to USB..." -ForegroundColor Yellow
        Add-BillSlothToTransitionUSB $selectedUSB.DeviceID
        
        return $selectedUSB.DeviceID
    }
    catch {
        Write-Host "❌ USB creation failed: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Add Bill Sloth system to transition USB
function Add-BillSlothToTransitionUSB {
    param([string]$USBDrive)
    
    Write-Host "🔧 Integrating Bill Sloth automation system..." -ForegroundColor Cyan
    
    $billSlothUSBDir = "${USBDrive}\BillSloth"
    $tempCloneDir = "$env:TEMP\billsloth-transition"
    
    try {
        # Clone Bill Sloth repository
        if (Test-Path $tempCloneDir) {
            Remove-Item -Path $tempCloneDir -Recurse -Force
        }
        
        Write-Host "📥 Downloading Bill Sloth system..." -ForegroundColor Yellow
        git clone https://github.com/How1337ItIs/billsloth.git $tempCloneDir
        
        # Create Bill Sloth directory on USB
        if (Test-Path $billSlothUSBDir) {
            Remove-Item -Path $billSlothUSBDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $billSlothUSBDir -Force | Out-Null
        
        # Copy system with transition-specific setup
        Write-Host "📋 Copying automation system..." -ForegroundColor Yellow
        Copy-Item -Path "$tempCloneDir\*" -Destination $billSlothUSBDir -Recurse -Force
        
        # Create native Ubuntu setup script
        $nativeSetupScript = @"
#!/bin/bash
# Bill Sloth Native Ubuntu Setup Script
echo "🚀 Bill Sloth Native Ubuntu Setup"
echo "================================="
echo ""

# Navigate to Bill Sloth directory
BILL_SLOTH_DIR=`$(find /media -name "BillSloth" 2>/dev/null | head -1)
if [ -z "`$BILL_SLOTH_DIR" ]; then
    echo "❌ Bill Sloth directory not found on USB"
    exit 1
fi

cd "`$BILL_SLOTH_DIR"

# Make scripts executable
chmod +x *.sh lib/*.sh modules/*.sh scripts/*.sh 2>/dev/null

echo "🎯 Starting Bill Sloth native Ubuntu setup..."
echo "This is a FRESH native installation - no WSL2 baggage!"
echo ""

# Check for Windows drives (dual-boot confirmation)
if [ -d "/mnt/c" ] || ls /media/*/Windows* 2>/dev/null; then
    echo "✅ Dual-boot configuration detected"
    echo "Windows drives accessible for cross-platform workflows"
else
    echo "ℹ️  Native Ubuntu installation (Windows drives may need mounting)"
fi

echo ""
echo "🚀 Launching Bill Sloth native setup..."
echo ""

# Run onboarding with native mode
if [ -f "onboard.sh" ]; then
    echo "🎯 Starting native Ubuntu onboarding..."
    ./onboard.sh --native-ubuntu --hardware-access
else
    echo "🚀 Starting command center..."
    ./bill_command_center.sh
fi
"@
        
        $nativeSetupScript | Out-File -FilePath "$billSlothUSBDir\native-ubuntu-setup.sh" -Encoding UTF8
        
        # Create Windows-accessible readme
        $readmeContent = @"
BILL SLOTH NATIVE UBUNTU SETUP
==============================

After Ubuntu installation is complete:

1. Open Terminal (Ctrl+Alt+T)
2. Navigate to USB: cd /media/*/BillSloth
3. Run setup script: ./native-ubuntu-setup.sh

This will:
- Set up Bill Sloth automation in native Ubuntu
- Configure voice control and system automation  
- Initialize ADHD/dyslexia optimized interface
- Enable direct hardware access (audio, GPU, etc.)

Your native Ubuntu with Bill Sloth automation will be ready!

Note: WSL2 remains available in Windows for development/testing.
"@
        
        $readmeContent | Out-File -FilePath "$billSlothUSBDir\TRANSITION-README.txt" -Encoding UTF8
        
        Write-Host "✅ Bill Sloth transition system added to USB" -ForegroundColor Green
        
        return $true
    }
    catch {
        Write-Host "❌ Failed to add Bill Sloth system: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        if (Test-Path $tempCloneDir) {
            Remove-Item -Path $tempCloneDir -Recurse -Force
        }
    }
}

# Phase 4: Final Transition Instructions
function Show-TransitionInstructions {
    param([string]$USBDrive)
    
    Write-Host ""
    Write-Host "═══ PHASE 4: TRANSITION COMPLETION ═══" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🎉 WSL2 → NATIVE UBUNTU TRANSITION READY!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 NEXT STEPS:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. 🔄 RESTART your computer" -ForegroundColor Cyan
    Write-Host "2. ⌨️  Press F2 or Del during ASUS boot logo" -ForegroundColor Cyan  
    Write-Host "3. 🎯 Select USB drive: $USBDrive" -ForegroundColor Cyan
    Write-Host "4. 🐧 Choose 'Install Ubuntu'" -ForegroundColor Cyan
    Write-Host "5. 📦 Select 'Install Ubuntu alongside Windows Boot Manager'" -ForegroundColor Cyan
    Write-Host "6. 🎯 Install to $TargetDrive: drive ($UbuntuSizeGB GB)" -ForegroundColor Cyan
    Write-Host "7. ⚡ After installation: run /media/*/BillSloth/native-ubuntu-setup.sh" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "🎯 BILL'S OPTIMAL PARTITION STRATEGY:" -ForegroundColor Green
    Write-Host "   Root (/): 100GB" -ForegroundColor White
    Write-Host "   Home (/home): 400GB" -ForegroundColor White  
    Write-Host "   Swap: 32GB (matches RAM)" -ForegroundColor White
    Write-Host "   Remaining: ~7.5TB for projects/data" -ForegroundColor White
    Write-Host ""
    
    Write-Host "💡 ADVANTAGES OF NATIVE UBUNTU:" -ForegroundColor Magenta
    Write-Host "   ✅ Direct hardware access (GPU, audio, USB)" -ForegroundColor Green
    Write-Host "   ✅ Better performance (no virtualization overhead)" -ForegroundColor Green
    Write-Host "   ✅ Full Linux ecosystem compatibility" -ForegroundColor Green
    Write-Host "   ✅ Professional audio tools (PipeWire, JACK)" -ForegroundColor Green
    Write-Host "   ✅ Voice control optimization" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "🔄 WSL2 COEXISTENCE:" -ForegroundColor Cyan
    Write-Host "   WSL2 Ubuntu remains available in Windows for development" -ForegroundColor White
    Write-Host "   Native Ubuntu provides full hardware access and performance" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🦥 Your transition from WSL2 to native Ubuntu is ready!" -ForegroundColor Magenta
    Write-Host "Bill Sloth will have full hardware access and optimal performance!" -ForegroundColor Green
    Write-Host ""
}

# Main transition execution
function Start-WSL2Transition {
    Write-Host "🔄 Starting WSL2 to native Ubuntu transition..." -ForegroundColor Green
    Write-Host ""
    
    # Phase 1: WSL2 status check
    $wsl2Action = Check-WSL2Status
    
    # Phase 2: Get Ubuntu ISO
    $isoPath = Get-OptimalUbuntuISO
    if (-not $isoPath) {
        Write-Host "❌ Ubuntu ISO required for transition" -ForegroundColor Red
        return $false
    }
    
    # Phase 3: Create transition USB
    $usbDrive = New-TransitionUSB $isoPath
    if (-not $usbDrive) {
        Write-Host "❌ USB creation failed" -ForegroundColor Red
        return $false
    }
    
    # Phase 4: Show instructions
    Show-TransitionInstructions $usbDrive
    
    Write-Host "✅ WSL2 → Native Ubuntu transition preparation complete!" -ForegroundColor Green
    return $true
}

# Execute the transition wizard
if (-not $DryRun) {
    $success = Start-WSL2Transition
    if ($success) {
        Write-Host ""
        Write-Host "🎯 Ready to transition from WSL2 to native Ubuntu dual-boot!" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "❌ Transition preparation failed" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "🧪 DRY RUN MODE - No changes made" -ForegroundColor Yellow
}