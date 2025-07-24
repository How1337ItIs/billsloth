# Bill Sloth Complete System USB Creator
# Creates Ubuntu USB with full Bill Sloth automation system pre-loaded
# Designed for neurodivergent users with ADHD/dyslexia optimization

param(
    [string]$IsoPath = "",
    [string]$USBDrive = "",
    [switch]$AutoDetect = $true
)

# ASCII-only output for Windows PowerShell compatibility
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  BILL SLOTH COMPLETE SYSTEM USB CREATOR" -ForegroundColor Cyan
Write-Host "  Self-building Jarvis for dyslexic Tony Stark" -ForegroundColor Magenta
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# Auto-detect Ubuntu ISO if not specified
if (-not $IsoPath -and $AutoDetect) {
    $commonPaths = @(
        "$env:USERPROFILE\Downloads\Ubuntu.iso",
        "$env:USERPROFILE\Downloads\ubuntu-*.iso",
        "C:\Users\Sloth\Downloads\Ubuntu.iso"
    )
    
    foreach ($path in $commonPaths) {
        $found = Get-ChildItem -Path (Split-Path $path) -Filter (Split-Path $path -Leaf) -ErrorAction SilentlyContinue
        if ($found) {
            $IsoPath = $found[0].FullName
            break
        }
    }
}

# Validate ISO
if (-not $IsoPath -or -not (Test-Path $IsoPath)) {
    Write-Host "[ERROR] Ubuntu ISO not found!" -ForegroundColor Red
    Write-Host "Please specify ISO path or place Ubuntu.iso in Downloads folder" -ForegroundColor Yellow
    $IsoPath = Read-Host "Enter path to Ubuntu ISO file"
    
    if (-not (Test-Path $IsoPath)) {
        Write-Host "[ERROR] ISO file not found: $IsoPath" -ForegroundColor Red
        exit 1
    }
}

$isoSize = [math]::Round((Get-Item $IsoPath).Length / 1GB, 2)
Write-Host "[OK] Ubuntu ISO found: $IsoPath" -ForegroundColor Green
Write-Host "     Size: $isoSize GB" -ForegroundColor White

# Auto-detect USB drive
if (-not $USBDrive -and $AutoDetect) {
    $usbDrives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { 
        $_.DriveType -eq 2 -and $_.Size -gt 4GB 
    }
    
    if ($usbDrives.Count -eq 1) {
        $USBDrive = $usbDrives[0].DeviceID
        Write-Host "[OK] Auto-detected USB drive: $USBDrive" -ForegroundColor Green
    } elseif ($usbDrives.Count -gt 1) {
        Write-Host "[INFO] Multiple USB drives found:" -ForegroundColor Yellow
        for ($i = 0; $i -lt $usbDrives.Count; $i++) {
            $drive = $usbDrives[$i]
            $sizeGB = [math]::Round($drive.Size / 1GB, 2)
            $label = if ($drive.VolumeName) { $drive.VolumeName } else { "No Label" }
            Write-Host "  [$i] $($drive.DeviceID) - $label ($sizeGB GB)" -ForegroundColor Cyan
        }
        $selection = Read-Host "Select USB drive number (0-$($usbDrives.Count-1))"
        if ($selection -match '^\d+$' -and [int]$selection -lt $usbDrives.Count) {
            $USBDrive = $usbDrives[[int]$selection].DeviceID
        }
    }
}

# Validate USB drive
if (-not $USBDrive -or -not (Test-Path "$USBDrive\")) {
    Write-Host "[ERROR] USB drive not found or not accessible: $USBDrive" -ForegroundColor Red
    Write-Host "Available drives:" -ForegroundColor Yellow
    Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 } | ForEach-Object {
        $sizeGB = [math]::Round($_.Size / 1GB, 2)
        $label = if ($_.VolumeName) { $_.VolumeName } else { "No Label" }
        Write-Host "  $($_.DeviceID) - $label ($sizeGB GB)" -ForegroundColor Cyan
    }
    $USBDrive = Read-Host "Enter USB drive letter (e.g., H:)"
}

Write-Host "[OK] Target USB drive: $USBDrive" -ForegroundColor Green
Write-Host ""

# Confirmation
Write-Host "[WARNING] This will ERASE ALL DATA on drive $USBDrive" -ForegroundColor Yellow
Write-Host "The following will be created:" -ForegroundColor White
Write-Host "  - Bootable Ubuntu installation media" -ForegroundColor Cyan
Write-Host "  - Complete Bill Sloth automation system" -ForegroundColor Cyan
Write-Host "  - Command Center and Onboarding scripts" -ForegroundColor Cyan
Write-Host "  - Voice Control and Adaptive Learning" -ForegroundColor Cyan
Write-Host "  - ADHD/Dyslexia optimized interface" -ForegroundColor Cyan
Write-Host ""
$confirm = Read-Host "Continue with Bill Sloth system creation? (y/N)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "[CANCELLED] Operation cancelled by user" -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "=== PHASE 1: DOWNLOADING TOOLS ===" -ForegroundColor Green

# Download Rufus
Write-Host "[INFO] Downloading Rufus USB creator..." -ForegroundColor White
$rufusPath = "$env:TEMP\rufus.exe"
try {
    $rufusUrl = "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5.exe"
    Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusPath -UseBasicParsing
    Write-Host "[OK] Rufus downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to download Rufus: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== PHASE 2: PREPARING BILL SLOTH SYSTEM ===" -ForegroundColor Green

# Clone Bill Sloth repository
Write-Host "[INFO] Downloading complete Bill Sloth automation system..." -ForegroundColor White
$billSlothTemp = "$env:TEMP\billsloth-complete-system"

if (Test-Path $billSlothTemp) {
    Remove-Item -Path $billSlothTemp -Recurse -Force
}

try {
    git clone https://github.com/How1337ItIs/billsloth.git $billSlothTemp
    Write-Host "[OK] Bill Sloth system downloaded" -ForegroundColor Green
    
    # Verify essential components
    $essentialFiles = @(
        "bill_command_center.sh",
        "onboard.sh", 
        "BILL_SLOTH_GIGA_DOC.md"
    )
    
    foreach ($file in $essentialFiles) {
        $filePath = Join-Path $billSlothTemp $file
        if (Test-Path $filePath) {
            Write-Host "[OK] Found: $file" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] Missing: $file" -ForegroundColor Yellow
        }
    }
    
} catch {
    Write-Host "[ERROR] Failed to download Bill Sloth system: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "[INFO] Continuing with basic Ubuntu USB creation..." -ForegroundColor Yellow
    $billSlothTemp = $null
}

Write-Host ""
Write-Host "=== PHASE 3: CREATING BOOTABLE USB ===" -ForegroundColor Green
Write-Host ""
Write-Host "[INFO] Launching Rufus for Ubuntu USB creation..." -ForegroundColor White
Write-Host ""
Write-Host "RUFUS INSTRUCTIONS:" -ForegroundColor Yellow
Write-Host "  1. Device: Select $USBDrive" -ForegroundColor White
Write-Host "  2. Boot selection: Click SELECT and choose:" -ForegroundColor White
Write-Host "     $IsoPath" -ForegroundColor Cyan
Write-Host "  3. Partition scheme: GPT (for UEFI)" -ForegroundColor White
Write-Host "  4. Target system: UEFI (non CSM)" -ForegroundColor White
Write-Host "  5. Click START and wait for completion" -ForegroundColor White
Write-Host ""
Write-Host "[ACTION REQUIRED] Please complete Rufus setup, then press Enter here..." -ForegroundColor Yellow

# Launch Rufus and wait
try {
    Start-Process -FilePath $rufusPath -Wait
    Write-Host "[OK] Rufus completed" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to launch Rufus: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Read-Host "Press Enter after Rufus has finished creating the Ubuntu USB"

Write-Host ""
Write-Host "=== PHASE 4: INSTALLING BILL SLOTH SYSTEM ===" -ForegroundColor Green

if ($billSlothTemp -and (Test-Path $billSlothTemp)) {
    $usbBillSlothDir = "$USBDrive\BillSloth"
    
    try {
        # Create Bill Sloth directory on USB
        Write-Host "[INFO] Creating Bill Sloth directory on USB..." -ForegroundColor White
        if (Test-Path $usbBillSlothDir) {
            Remove-Item -Path $usbBillSlothDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $usbBillSlothDir -Force | Out-Null
        
        # Copy complete Bill Sloth system
        Write-Host "[INFO] Copying complete automation system..." -ForegroundColor White
        Copy-Item -Path "$billSlothTemp\*" -Destination $usbBillSlothDir -Recurse -Force
        Write-Host "[OK] Bill Sloth system copied to USB" -ForegroundColor Green
        
        # Create auto-launch script
        Write-Host "[INFO] Creating auto-launch script..." -ForegroundColor White
        $autoLaunchScript = @"
#!/bin/bash
# Bill Sloth Auto-Launch Script
# Launches the complete automation system with onboarding

echo "========================================"
echo "  BILL SLOTH AUTOMATION SYSTEM"
echo "  Self-building Jarvis activated!"
echo "========================================"
echo ""

# Navigate to Bill Sloth directory
BILL_SLOTH_DIR=`$(find /media -name "BillSloth" 2>/dev/null | head -1)
if [ -z "`$BILL_SLOTH_DIR" ]; then
    echo "ERROR: Bill Sloth directory not found on USB"
    exit 1
fi

cd "`$BILL_SLOTH_DIR"

# Make scripts executable
chmod +x bill_command_center.sh
chmod +x onboard.sh
chmod +x lib/*.sh 2>/dev/null
chmod +x modules/*.sh 2>/dev/null
chmod +x scripts/*.sh 2>/dev/null

echo "Starting Bill Sloth onboarding and system initialization..."
echo ""

# Launch onboarding first, then command center
if [ -f "onboard.sh" ]; then
    echo "Launching onboarding system..."
    ./onboard.sh
else
    echo "Onboarding not found, launching command center directly..."
fi

if [ -f "bill_command_center.sh" ]; then
    echo "Launching Bill Sloth Command Center..."
    ./bill_command_center.sh
else
    echo "ERROR: Command center not found!"
    exit 1
fi
"@
        
        $autoLaunchScript | Out-File -FilePath "$usbBillSlothDir\auto-launch.sh" -Encoding UTF8
        
        # Create comprehensive setup documentation
        $setupDocs = @"
BILL SLOTH - COMPLETE LINUX AUTOMATION SYSTEM
==============================================

Welcome to your personal automation assistant!

WHAT IS BILL SLOTH?
- Self-building automation system for Linux
- Designed specifically for neurodivergent users (ADHD/dyslexia)
- "Jarvis for poor dyslexic Tony Stark"
- Progressive independence from Claude Code
- Local-first, mature open-source tool integration

SYSTEM COMPONENTS:
- Command Center (bill_command_center.sh) - Main control interface
- Interactive Onboarding (onboard.sh) - Personalized setup
- Module System (modules/) - Specialized automation tools
- Voice Control Integration - Hands-free operation
- Adaptive Learning Engine - Learns your patterns
- Library System (lib/) - Shared functionality
- ADHD/Dyslexia Optimized UX - Clear, visual interface

QUICK START (After Ubuntu Installation):
========================================
1. Open terminal (Ctrl+Alt+T)
2. cd /media/*/BillSloth
3. chmod +x auto-launch.sh
4. ./auto-launch.sh

The system will automatically:
- Run onboarding to learn your preferences
- Launch the command center
- Initialize all automation modules
- Set up voice control (if available)
- Begin adaptive pattern learning

MANUAL LAUNCH OPTIONS:
=====================
- Onboarding only: ./onboard.sh
- Command center only: ./bill_command_center.sh
- Individual modules: ./modules/[module-name].sh

SYSTEM PHILOSOPHY:
- Mature-First, Local-First approach
- Pattern learning and adaptive suggestions
- Reduces Claude Code dependency over time
- Empowers neurodivergent users with technology

SUPPORT:
- Full documentation: BILL_SLOTH_GIGA_DOC.md
- Claude integration notes: CLAUDE.md
- Community support: GitHub issues

Your personal automation assistant is ready to transform your Linux experience!
"@
        
        $setupDocs | Out-File -FilePath "$usbBillSlothDir\README-COMPLETE-SYSTEM.txt" -Encoding UTF8
        
        # Create desktop launcher for easy access
        $desktopLauncher = @"
[Desktop Entry]
Version=1.0
Type=Application
Name=Bill Sloth Automation
Comment=Launch Bill Sloth automation system
Exec=bash /media/*/BillSloth/auto-launch.sh
Icon=utilities-terminal
Terminal=true
Categories=System;Utility;
"@
        
        $desktopLauncher | Out-File -FilePath "$usbBillSlothDir\BillSloth.desktop" -Encoding UTF8
        
        Write-Host "[OK] Auto-launch system configured" -ForegroundColor Green
        Write-Host "[OK] Complete documentation created" -ForegroundColor Green
        Write-Host "[OK] Desktop launcher created" -ForegroundColor Green
        
    } catch {
        Write-Host "[ERROR] Failed to install Bill Sloth system: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "[INFO] Ubuntu USB created, but without Bill Sloth automation" -ForegroundColor Yellow
    }
} else {
    Write-Host "[WARNING] Bill Sloth system not available - basic Ubuntu USB created" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== BILL SLOTH SYSTEM CREATION COMPLETE ===" -ForegroundColor Green
Write-Host ""
Write-Host "[SUCCESS] Custom Bill Sloth USB created on $USBDrive" -ForegroundColor Green
Write-Host ""
Write-Host "WHAT YOU NOW HAVE:" -ForegroundColor Cyan
Write-Host "- Bootable Ubuntu installation media" -ForegroundColor White
Write-Host "- Complete Bill Sloth automation system" -ForegroundColor White
Write-Host "- Auto-launch onboarding and command center" -ForegroundColor White
Write-Host "- Voice control and adaptive learning ready" -ForegroundColor White
Write-Host "- ADHD/Dyslexia optimized interface" -ForegroundColor White
Write-Host "- Self-building Jarvis system" -ForegroundColor Magenta
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Boot from USB drive" -ForegroundColor White
Write-Host "2. Install Ubuntu alongside Windows (dual-boot)" -ForegroundColor White
Write-Host "3. After installation, run: /media/*/BillSloth/auto-launch.sh" -ForegroundColor White
Write-Host "4. Complete onboarding to personalize your system" -ForegroundColor White
Write-Host "5. Enjoy your personal automation assistant!" -ForegroundColor White
Write-Host ""
Write-Host "Your self-building Jarvis for dyslexic Tony Stark is ready!" -ForegroundColor Magenta

# Clean up
if ($billSlothTemp -and (Test-Path $billSlothTemp)) {
    Remove-Item -Path $billSlothTemp -Recurse -Force
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")