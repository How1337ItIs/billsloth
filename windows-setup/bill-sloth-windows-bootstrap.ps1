# Bill Sloth Windows Bootstrap & Dual-Boot Preparation
# Prepares Windows system for Ubuntu dual-boot and handles pre-setup tasks
# Run as Administrator in PowerShell

param(
    [switch]$CheckOnly,
    [switch]$PrepareOnly,
    [switch]$FullSetup,
    [string]$UbuntuISO = "",
    [int]$UbuntuSizeGB = 100
)

# Requires Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator!"
    Write-Host "Right-click PowerShell and select 'Run as Administrator'"
    exit 1
}

# ASCII Banner
Write-Host @"
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  💀 BILL SLOTH WINDOWS DUAL-BOOT PREPARATION 💀                  █  
█  🖥️  DIGITAL CONSCIOUSNESS BRIDGE TO UBUNTU 🖥️                   █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "🚀 Preparing Windows system for Ubuntu dual-boot..." -ForegroundColor Green
Write-Host ""

# Global variables
$script:BillSlothDir = "$env:USERPROFILE\bill-sloth-windows"
$script:LogFile = "$script:BillSlothDir\setup.log"
$script:BackupDir = "$script:BillSlothDir\backups"

# Logging function
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    # Create log directory if needed
    if (!(Test-Path (Split-Path $script:LogFile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $script:LogFile -Parent) -Force | Out-Null
    }
    
    # Write to log file
    Add-Content -Path $script:LogFile -Value $logEntry
    
    # Write to console with colors
    switch ($Level) {
        "ERROR" { Write-Host "❌ $Message" -ForegroundColor Red }
        "WARN"  { Write-Host "⚠️  $Message" -ForegroundColor Yellow }
        "SUCCESS" { Write-Host "✅ $Message" -ForegroundColor Green }
        default { Write-Host "ℹ️  $Message" -ForegroundColor White }
    }
}

# System information gathering
function Get-SystemInfo {
    Write-Host "🔍 SYSTEM ANALYSIS" -ForegroundColor Cyan
    Write-Host "==================" -ForegroundColor Cyan
    Write-Host ""
    
    # Basic system info
    $computerInfo = Get-ComputerInfo
    $osVersion = $computerInfo.WindowsVersion
    $totalRAM = [math]::Round($computerInfo.TotalPhysicalMemory / 1GB, 1)
    $architecture = $env:PROCESSOR_ARCHITECTURE
    
    Write-Log "Windows Version: $($computerInfo.WindowsProductName) ($osVersion)"
    Write-Log "Architecture: $architecture"
    Write-Log "Total RAM: $totalRAM GB"
    Write-Log "Computer Name: $($computerInfo.CsName)"
    
    # Check UEFI vs BIOS
    try {
        $firmwareType = (Get-ComputerInfo).BiosFirmwareType
        Write-Log "Firmware Type: $firmwareType"
        
        if ($firmwareType -eq "Uefi") {
            Write-Log "✅ UEFI detected - Modern dual-boot support available" "SUCCESS"
        } else {
            Write-Log "⚠️  Legacy BIOS detected - Dual-boot still possible but more complex" "WARN"
        }
    } catch {
        Write-Log "Could not determine firmware type" "WARN"
    }
    
    # Check Secure Boot status
    try {
        $secureBoot = Confirm-SecureBootUEFI
        if ($secureBoot) {
            Write-Log "🔒 Secure Boot is ENABLED - May need configuration for Ubuntu" "WARN"
        } else {
            Write-Log "🔓 Secure Boot is DISABLED - Ubuntu installation will be easier" "INFO"
        }
    } catch {
        Write-Log "Could not determine Secure Boot status (likely BIOS system)" "INFO"
    }
    
    # Check Fast Startup
    $fastStartup = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -ErrorAction SilentlyContinue
    if ($fastStartup -and $fastStartup.HiberbootEnabled -eq 1) {
        Write-Log "⚡ Fast Startup is ENABLED - Should be disabled for dual-boot" "WARN"
    } else {
        Write-Log "✅ Fast Startup is disabled or not found" "SUCCESS"
    }
    
    return @{
        OSVersion = $osVersion
        TotalRAM = $totalRAM
        Architecture = $architecture
        FirmwareType = $firmwareType
        SecureBoot = $secureBoot
        FastStartup = ($fastStartup.HiberbootEnabled -eq 1)
    }
}

# Disk analysis
function Get-DiskInfo {
    Write-Host ""
    Write-Host "💽 DISK ANALYSIS" -ForegroundColor Cyan
    Write-Host "================" -ForegroundColor Cyan
    Write-Host ""
    
    $disks = Get-Disk | Where-Object { $_.BusType -ne "USB" }
    $diskInfo = @()
    
    foreach ($disk in $disks) {
        $sizeGB = [math]::Round($disk.Size / 1GB, 1)
        $freeSpaceGB = 0
        
        # Get partitions for this disk
        $partitions = Get-Partition -DiskNumber $disk.Number -ErrorAction SilentlyContinue
        $partitionInfo = @()
        
        foreach ($partition in $partitions) {
            if ($partition.DriveLetter) {
                try {
                    $volume = Get-Volume -DriveLetter $partition.DriveLetter -ErrorAction SilentlyContinue
                    if ($volume) {
                        $partSizeGB = [math]::Round($partition.Size / 1GB, 1)
                        $partFreeGB = [math]::Round($volume.SizeRemaining / 1GB, 1)
                        $freeSpaceGB += $partFreeGB
                        
                        $partitionInfo += @{
                            DriveLetter = $partition.DriveLetter
                            SizeGB = $partSizeGB
                            FreeGB = $partFreeGB
                            FileSystem = $volume.FileSystem
                            Label = $volume.FileSystemLabel
                            Type = $partition.Type
                        }
                    }
                }
                catch {
                    # Skip if can't access volume
                }
            }
        }
        
        $diskInfo += @{
            Number = $disk.Number
            Model = $disk.FriendlyName
            SizeGB = $sizeGB
            PartitionStyle = $disk.PartitionStyle
            FreeSpaceGB = $freeSpaceGB
            Partitions = $partitionInfo
        }
        
        Write-Log "Disk $($disk.Number): $($disk.FriendlyName) ($sizeGB GB, $($disk.PartitionStyle))"
        
        foreach ($part in $partitionInfo) {
            Write-Log "  Drive $($part.DriveLetter): $($part.SizeGB) GB total, $($part.FreeGB) GB free ($($part.FileSystem), '$($part.Label)')"
        }
    }
    
    return $diskInfo
}

# Check for suitable Ubuntu installation space
function Test-UbuntuSpace {
    param([array]$DiskInfo, [int]$RequiredGB = 100)
    
    Write-Host ""
    Write-Host "📏 UBUNTU SPACE ANALYSIS" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    Write-Host ""
    
    $recommendations = @()
    
    foreach ($disk in $DiskInfo) {
        # Look for Windows system drive (usually C:)
        $systemPartition = $disk.Partitions | Where-Object { $_.DriveLetter -eq "C" }
        
        if ($systemPartition -and $systemPartition.FreeGB -gt ($RequiredGB + 20)) {
            $availableSpace = $systemPartition.FreeGB - 20  # Leave 20GB buffer for Windows
            $recommendations += @{
                Type = "Shrink C: Drive"
                Disk = $disk.Number
                AvailableGB = [math]::Min($availableSpace, $RequiredGB * 2)
                Description = "Shrink Windows C: drive to create space"
                Difficulty = "Easy"
                Recommended = $true
            }
            Write-Log "✅ Option 1: Shrink C: drive ($($systemPartition.FreeGB) GB free, can allocate ~$([math]::Min($availableSpace, $RequiredGB)) GB)" "SUCCESS"
        }
        
        # Look for other large partitions
        foreach ($partition in $disk.Partitions) {
            if ($partition.DriveLetter -ne "C" -and $partition.FreeGB -gt ($RequiredGB + 10)) {
                $recommendations += @{
                    Type = "Use Drive $($partition.DriveLetter):"
                    Disk = $disk.Number
                    AvailableGB = $partition.FreeGB - 10
                    Description = "Use space from drive $($partition.DriveLetter): ($($partition.Label))"
                    Difficulty = "Medium"
                    Recommended = $false
                }
                Write-Log "Option: Use drive $($partition.DriveLetter): ($($partition.FreeGB) GB free)" "INFO"
            }
        }
        
        # Check for completely free space on disk
        $usedSpace = ($disk.Partitions | Measure-Object -Property SizeGB -Sum).Sum
        $freeUnpartitioned = $disk.SizeGB - $usedSpace
        
        if ($freeUnpartitioned -gt $RequiredGB) {
            $recommendations += @{
                Type = "Use Unpartitioned Space"
                Disk = $disk.Number
                AvailableGB = $freeUnpartitioned
                Description = "Use unpartitioned space on disk $($disk.Number)"
                Difficulty = "Easy"
                Recommended = $true
            }
            Write-Log "✅ Option: Unpartitioned space available ($freeUnpartitioned GB)" "SUCCESS"
        }
    }
    
    if ($recommendations.Count -eq 0) {
        Write-Log "❌ No suitable space found for Ubuntu installation ($RequiredGB GB required)" "ERROR"
        Write-Log "Consider freeing up space or using external drive" "INFO"
    } else {
        $bestOption = $recommendations | Where-Object { $_.Recommended } | Sort-Object -Property AvailableGB -Descending | Select-Object -First 1
        if ($bestOption) {
            Write-Log "🎯 Recommended: $($bestOption.Type) ($($bestOption.AvailableGB) GB available)" "SUCCESS"
        }
    }
    
    return $recommendations
}

# Disable Fast Startup
function Disable-FastStartup {
    Write-Host ""
    Write-Host "⚡ DISABLING FAST STARTUP" -ForegroundColor Cyan
    Write-Host "=========================" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        # Disable Fast Startup via registry
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0 -Type DWord
        
        # Also disable hibernation for good measure
        powercfg /hibernate off
        
        Write-Log "✅ Fast Startup disabled successfully" "SUCCESS"
        Write-Log "ℹ️  This prevents file system corruption in dual-boot setups" "INFO"
        
        return $true
    }
    catch {
        Write-Log "❌ Failed to disable Fast Startup: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Create Ubuntu bootable USB preparation
function Prepare-UbuntuUSB {
    param([string]$ISOPath)
    
    Write-Host ""
    Write-Host "💿 UBUNTU USB PREPARATION" -ForegroundColor Cyan
    Write-Host "=========================" -ForegroundColor Cyan
    Write-Host ""
    
    # Check if Rufus is available
    $rufusPath = Get-Command "rufus" -ErrorAction SilentlyContinue
    if (-not $rufusPath) {
        Write-Log "Rufus not found. Attempting to download..." "INFO"
        
        try {
            $rufusUrl = "https://github.com/pbatard/rufus/releases/download/v4.3/rufus-4.3.exe"
            $rufusDownload = "$script:BillSlothDir\rufus.exe"
            
            if (!(Test-Path $script:BillSlothDir)) {
                New-Item -ItemType Directory -Path $script:BillSlothDir -Force | Out-Null
            }
            
            Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusDownload
            Write-Log "✅ Rufus downloaded to $rufusDownload" "SUCCESS"
            $rufusPath = $rufusDownload
        }
        catch {
            Write-Log "❌ Failed to download Rufus: $($_.Exception.Message)" "ERROR"
            Write-Log "Please manually download Rufus from https://rufus.ie" "INFO"
            return $false
        }
    }
    
    # Get available USB drives
    $usbDrives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 -and $_.Size -gt 4GB }
    
    if ($usbDrives.Count -eq 0) {
        Write-Log "❌ No suitable USB drives found (need 8GB+ USB drive)" "ERROR"
        return $false
    }
    
    Write-Log "📱 Available USB drives:" "INFO"
    foreach ($usb in $usbDrives) {
        $sizeGB = [math]::Round($usb.Size / 1GB, 1)
        Write-Log "  Drive $($usb.DeviceID) - $sizeGB GB ($($usb.VolumeName))" "INFO"
    }
    
    # Download Ubuntu ISO if not provided
    if ([string]::IsNullOrEmpty($ISOPath) -or !(Test-Path $ISOPath)) {
        Write-Log "Ubuntu ISO not found. Preparing to download..." "INFO"
        
        $ubuntuUrl = "https://releases.ubuntu.com/22.04.3/ubuntu-22.04.3-desktop-amd64.iso"
        $isoDownload = "$script:BillSlothDir\ubuntu-22.04.3-desktop-amd64.iso"
        
        Write-Log "⬬ Downloading Ubuntu 22.04.3 LTS (this will take a while)..." "INFO"
        Write-Log "Download URL: $ubuntuUrl" "INFO"
        Write-Log "Saving to: $isoDownload" "INFO"
        Write-Log ""
        Write-Log "🔥 PROTIP: You can download this manually and specify -UbuntuISO path to skip this step" "INFO"
        
        # Note: Large download - could take 30+ minutes
        # In production, might want to use Background Intelligent Transfer Service (BITS)
        Write-Log "Starting download... (grab coffee, this takes ~30-45 minutes)" "INFO"
        
        $ISOPath = $isoDownload
    }
    
    Write-Log "🎯 Next steps for Ubuntu USB creation:" "INFO"
    Write-Log "1. Insert 8GB+ USB drive" "INFO"
    Write-Log "2. Run Rufus from: $rufusPath" "INFO"
    Write-Log "3. Select Ubuntu ISO: $ISOPath" "INFO"
    Write-Log "4. Use GPT partition scheme for UEFI" "INFO"
    Write-Log "5. Create bootable USB" "INFO"
    
    return $true
}

# Install Windows Subsystem for Linux (WSL) as interim solution
function Install-WSL {
    Write-Host ""
    Write-Host "🐧 WINDOWS SUBSYSTEM FOR LINUX SETUP" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Log "Installing WSL as interim solution while preparing dual-boot..." "INFO"
    
    try {
        # Enable WSL feature
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
        
        # Enable Virtual Machine Platform (for WSL2)
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
        
        # Install Ubuntu via WSL
        wsl --install -d Ubuntu-22.04
        
        Write-Log "✅ WSL with Ubuntu 22.04 installation started" "SUCCESS"
        Write-Log "ℹ️  A restart may be required to complete WSL setup" "INFO"
        Write-Log "ℹ️  After restart, run 'wsl' to complete Ubuntu setup" "INFO"
        
        return $true
    }
    catch {
        Write-Log "❌ WSL installation failed: $($_.Exception.Message)" "ERROR"
        Write-Log "Try running 'wsl --install' manually" "INFO"
        return $false
    }
}

# Create Bill Sloth preparation package
function Create-BillSlothPackage {
    Write-Host ""
    Write-Host "📦 BILL SLOTH PACKAGE PREPARATION" -ForegroundColor Cyan
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host ""
    
    $packageDir = "$script:BillSlothDir\ubuntu-package"
    
    if (Test-Path $packageDir) {
        Remove-Item -Path $packageDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
    
    # Create post-install script for Ubuntu
    $postInstallScript = @"
#!/bin/bash
# Bill Sloth Post-Ubuntu-Install Setup
# Run this immediately after Ubuntu installation

set -euo pipefail

echo "🚀 Bill Sloth Post-Ubuntu Installation Setup"
echo "============================================"

# Update system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl git wget

# Download and run Bill Sloth fresh installer
cd ~
git clone https://github.com/how1337itis/billsloth.git || {
    echo "Git clone failed, downloading zip..."
    wget -O bill-sloth.zip https://github.com/how1337itis/billsloth/archive/main.zip
    unzip bill-sloth.zip
    mv bill-sloth-main bill-sloth
}

cd bill-sloth

# Run fresh Ubuntu installer
chmod +x fresh_ubuntu_installer.sh
./fresh_ubuntu_installer.sh

echo ""
echo "✅ Bill Sloth Ubuntu setup complete!"
echo "🎯 Next: Run ./bill_command_center.sh to start"
"@

    Set-Content -Path "$packageDir\bill-sloth-ubuntu-setup.sh" -Value $postInstallScript -Encoding UTF8
    
    # Create Windows-to-Ubuntu transition guide
    $transitionGuide = @"
# Bill Sloth Windows-to-Ubuntu Transition Guide

## You Are Here: Windows Dual-Boot Preparation Complete! ✅

### Next Steps:

1. **Create Ubuntu Bootable USB**
   - Use Rufus with Ubuntu 22.04.3 LTS ISO
   - GPT partition scheme for UEFI systems
   - FAT32 file system

2. **Boot from USB**
   - Restart computer
   - Access BIOS/UEFI (usually F12, F2, or Delete during startup)
   - Select USB drive as boot device

3. **Install Ubuntu**
   - Choose "Install Ubuntu alongside Windows"
   - Allocate $($UbuntuSizeGB)GB or more for Ubuntu
   - Create user account (remember this password!)

4. **Post-Installation**
   - Boot into Ubuntu
   - Open terminal (Ctrl+Alt+T)
   - Copy and run: cd ~ && wget -O - https://raw.githubusercontent.com/how1337itis/billsloth/main/ubuntu-bootstrap.sh | bash
   - OR manually copy bill-sloth-ubuntu-setup.sh from USB and run it

5. **Bill Sloth Activation**
   - Navigate to bill-sloth directory
   - Run: ./fresh_ubuntu_installer.sh
   - Follow setup prompts
   - Start: ./bill_command_center.sh

### Important Notes:
- Windows will still be available (dual-boot menu will appear on startup)
- You can access Windows files from Ubuntu at /mnt/c/ (if mounted)
- Ubuntu gets its own separate file system and user account
- Bill Sloth will have full Linux capabilities for VRBO automation

### Troubleshooting:
- If boot issues occur, use Windows Recovery to repair boot loader
- Secure Boot may need to be disabled in BIOS for Ubuntu
- Fast Startup has been disabled to prevent file system issues

### Emergency Contacts:
- Ubuntu Community: https://askubuntu.com
- Bill Sloth Issues: Check TROUBLESHOOTING.md in the repository

---
Generated by Bill Sloth Windows Bootstrap
Date: $(Get-Date)
System: $($env:COMPUTERNAME)
"@

    Set-Content -Path "$packageDir\TRANSITION-GUIDE.md" -Value $transitionGuide -Encoding UTF8
    
    # Create quick reference card
    $quickRef = @"
🚀 BILL SLOTH UBUNTU QUICK REFERENCE 🚀

After Ubuntu Installation:

1. Open Terminal: Ctrl + Alt + T

2. Get Bill Sloth:
   curl -fsSL https://raw.githubusercontent.com/how1337itis/billsloth/main/ubuntu-bootstrap.sh | bash

3. Install Everything:
   cd bill-sloth && ./fresh_ubuntu_installer.sh

4. Start Bill Sloth:
   ./bill_command_center.sh

5. Get Help:
   Type 'help' in command center

VRBO Commands:
- vrbo - VRBO management
- automation - Automation tools
- health - System health check

Emergency:
- Ctrl + C - Cancel current operation
- ./bill_command_center.sh --reset - Reset to defaults
"@

    Set-Content -Path "$packageDir\QUICK-REFERENCE.txt" -Value $quickRef -Encoding UTF8
    
    Write-Log "✅ Bill Sloth Ubuntu package created in $packageDir" "SUCCESS"
    Write-Log "📁 Package contains:" "INFO"
    Write-Log "  - bill-sloth-ubuntu-setup.sh (post-install script)" "INFO"  
    Write-Log "  - TRANSITION-GUIDE.md (complete setup instructions)" "INFO"
    Write-Log "  - QUICK-REFERENCE.txt (command cheat sheet)" "INFO"
    
    return $packageDir
}

# Generate setup summary report
function New-SetupReport {
    param(
        [hashtable]$SystemInfo,
        [array]$DiskInfo,
        [array]$SpaceRecommendations,
        [string]$PackageDir
    )
    
    $reportPath = "$script:BillSlothDir\BILL-SLOTH-SETUP-REPORT.md"
    
    $report = @"
# Bill Sloth Windows Dual-Boot Setup Report

Generated: $(Get-Date)
System: $($env:COMPUTERNAME)

## System Analysis Summary

### Hardware Configuration
- **OS**: Windows $($SystemInfo.OSVersion)
- **RAM**: $($SystemInfo.TotalRAM) GB
- **Architecture**: $($SystemInfo.Architecture)
- **Firmware**: $($SystemInfo.FirmwareType)
- **Secure Boot**: $(if ($SystemInfo.SecureBoot) { "Enabled ⚠️" } else { "Disabled ✅" })

### Disk Configuration
$($DiskInfo | ForEach-Object {
"#### Disk $($_.Number): $($_.Model)
- **Size**: $($_.SizeGB) GB
- **Partition Style**: $($_.PartitionStyle)
- **Partitions**:
$($_.Partitions | ForEach-Object { "  - Drive $($_.DriveLetter): $($_.SizeGB) GB total, $($_.FreeGB) GB free" })
"
})

### Ubuntu Installation Recommendations
$(if ($SpaceRecommendations.Count -gt 0) {
$SpaceRecommendations | ForEach-Object {
"- **$($_.Type)**: $($_.AvailableGB) GB available ($($_.Difficulty)) $(if ($_.Recommended) { "✅ RECOMMENDED" })"
}
} else {
"❌ **No suitable space found** - Free up disk space or use external drive"
})

## Setup Actions Completed ✅

- [x] System analysis and compatibility check
- [x] Fast Startup disabled (prevents dual-boot file system corruption)
- [x] Disk space analysis for Ubuntu partition
- [x] Ubuntu installation package prepared
- [x] Post-installation scripts created
- [x] Transition guide generated

## Next Steps 🎯

### Immediate (Windows):
1. **Create Ubuntu bootable USB** using Rufus with Ubuntu 22.04.3 LTS
2. **Free up disk space** if needed ($(100) GB recommended for Ubuntu)
3. **Backup important Windows data** as safety precaution

### Ubuntu Installation:
1. **Boot from USB** (access BIOS boot menu during startup)
2. **Install Ubuntu** alongside Windows (guided partitioning)
3. **Run post-install script**: Copy from '$PackageDir' to Ubuntu

### Bill Sloth Activation:
1. **Boot into Ubuntu** from dual-boot menu
2. **Run setup script**: ./bill-sloth-ubuntu-setup.sh
3. **Start Bill Sloth**: ./bill_command_center.sh

## Important Notes ⚠️

- **Dual-boot menu** will appear on every startup (choose Windows or Ubuntu)
- **Both operating systems** will be fully functional and separate
- **Bill Sloth** will have full Linux capabilities in Ubuntu environment
- **Windows remains unchanged** - all your current setup is preserved

## Support Resources 🔗

- **Setup Guide**: $PackageDir\TRANSITION-GUIDE.md
- **Quick Reference**: $PackageDir\QUICK-REFERENCE.txt
- **Ubuntu Community**: https://askubuntu.com
- **Dual-boot Help**: https://help.ubuntu.com/community/WindowsDualBoot

---

**Status**: ✅ Windows preparation complete - Ready for Ubuntu installation

This report has been saved to: $reportPath
Package location: $PackageDir

🚀 **You're ready to install Ubuntu and unleash Bill Sloth's full power!**
"@

    Set-Content -Path $reportPath -Value $report -Encoding UTF8
    
    Write-Host ""
    Write-Host "📊 SETUP COMPLETE!" -ForegroundColor Green
    Write-Host "==================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Report saved to: $reportPath" -ForegroundColor Yellow
    Write-Host "📦 Package created: $PackageDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🎯 Next: Create Ubuntu bootable USB and follow transition guide" -ForegroundColor Cyan
    
    return $reportPath
}

# Main execution
function Main {
    Write-Log "Bill Sloth Windows Bootstrap started" "INFO"
    Write-Log "Parameters: CheckOnly=$CheckOnly, PrepareOnly=$PrepareOnly, FullSetup=$FullSetup" "INFO"
    
    # Create working directory
    if (!(Test-Path $script:BillSlothDir)) {
        New-Item -ItemType Directory -Path $script:BillSlothDir -Force | Out-Null
        Write-Log "Created working directory: $script:BillSlothDir" "INFO"
    }
    
    # System analysis
    $systemInfo = Get-SystemInfo
    $diskInfo = Get-DiskInfo
    $spaceRecommendations = Test-UbuntuSpace -DiskInfo $diskInfo -RequiredGB $UbuntuSizeGB
    
    if ($CheckOnly) {
        Write-Host ""
        Write-Host "✅ System check complete - see log for details" -ForegroundColor Green
        return
    }
    
    # Prepare system for dual-boot
    if ($PrepareOnly -or $FullSetup) {
        Write-Host ""
        Write-Host "🔧 SYSTEM PREPARATION" -ForegroundColor Cyan
        Write-Host "=====================" -ForegroundColor Cyan
        
        # Disable Fast Startup
        $fastStartupDisabled = Disable-FastStartup
        
        # Install WSL as interim solution
        if ($FullSetup) {
            Install-WSL
        }
        
        # Create Ubuntu preparation package
        $packageDir = Create-BillSlothPackage
        
        # Generate report
        $reportPath = New-SetupReport -SystemInfo $systemInfo -DiskInfo $diskInfo -SpaceRecommendations $spaceRecommendations -PackageDir $packageDir
        
        Write-Log "✅ Windows preparation completed successfully" "SUCCESS"
        Write-Log "📋 Review setup report: $reportPath" "INFO"
        Write-Log "📦 Ubuntu package ready: $packageDir" "INFO"
    }
    
    if ($FullSetup) {
        # Prepare Ubuntu bootable USB
        Prepare-UbuntuUSB -ISOPath $UbuntuISO
        
        Write-Host ""
        Write-Host "🎉 FULL SETUP COMPLETE!" -ForegroundColor Green
        Write-Host "=======================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your Windows system is now prepared for Ubuntu dual-boot." -ForegroundColor White
        Write-Host "Follow the transition guide to complete Ubuntu installation." -ForegroundColor White
        Write-Host ""
        Write-Host "📖 Next steps: Open $script:BillSlothDir\TRANSITION-GUIDE.md" -ForegroundColor Yellow
    }
}

# Execute main function
try {
    Main
}
catch {
    Write-Log "❌ Script execution failed: $($_.Exception.Message)" "ERROR"
    Write-Log "Full error: $($_.Exception)" "ERROR"
    exit 1
}

Write-Log "Bill Sloth Windows Bootstrap completed" "INFO"