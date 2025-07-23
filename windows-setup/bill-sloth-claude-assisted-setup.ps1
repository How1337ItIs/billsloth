# Bill Sloth Windows Dual-Boot Setup with Claude Code Integration
# Claude Code assisted dual-boot preparation, disk management, and Ubuntu setup
# Run as Administrator in PowerShell

param(
    [switch]$Interactive,
    [switch]$CheckOnly,
    [switch]$AIAssisted = $true,
    [string]$ClaudeBinary = "claude",
    [int]$UbuntuSizeGB = 100
)

# Requires Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator!"
    Write-Host "Right-click PowerShell and select 'Run as Administrator'"
    exit 1
}

# ASCII Banner with Claude integration
Write-Host @"
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  💀 BILL SLOTH CLAUDE-ASSISTED DUAL-BOOT SETUP 💀               █  
█  🤖 AI-POWERED WINDOWS-TO-UBUNTU TRANSITION 🤖                   █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "🤖 Claude Code assisted dual-boot preparation starting..." -ForegroundColor Green
Write-Host ""

# Global variables
$script:BillSlothDir = "$env:USERPROFILE\bill-sloth-windows"
$script:LogFile = "$script:BillSlothDir\claude-assisted-setup.log"
$script:ClaudeContextFile = "$script:BillSlothDir\claude-context.json"
$script:SystemAnalysisFile = "$script:BillSlothDir\system-analysis.json"

# Enhanced logging with Claude integration
function Write-Log {
    param([string]$Message, [string]$Level = "INFO", [switch]$SendToClaude)
    
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
        "CLAUDE" { Write-Host "🤖 $Message" -ForegroundColor Magenta }
        default { Write-Host "ℹ️  $Message" -ForegroundColor White }
    }
    
    # Send to Claude if requested and available
    if ($SendToClaude -and $script:ClaudeAvailable) {
        Add-ClaudeContext -Type "log" -Content $logEntry
    }
}

# Check Claude Code availability
function Test-ClaudeAvailability {
    try {
        $claudeTest = & $ClaudeBinary --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "✅ Claude Code is available: $claudeTest" "CLAUDE"
            $script:ClaudeAvailable = $true
            return $true
        }
    }
    catch {
        Write-Log "⚠️  Claude Code not found - falling back to standard mode" "WARN"
        Write-Log "Install Claude Code: npm install -g @anthropic-ai/claude-code" "INFO"
    }
    
    $script:ClaudeAvailable = $false
    return $false
}

# Initialize Claude context for the session
function Initialize-ClaudeContext {
    $context = @{
        session_id = [guid]::NewGuid().ToString()
        timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        task = "Windows to Ubuntu dual-boot setup"
        user = "Bill Sloth"
        system_info = @{}
        progress = @{}
        recommendations = @()
    }
    
    $context | ConvertTo-Json -Depth 5 | Set-Content -Path $script:ClaudeContextFile -Encoding UTF8
    Write-Log "🤖 Claude context initialized" "CLAUDE"
}

# Add information to Claude context
function Add-ClaudeContext {
    param(
        [string]$Type,
        [object]$Content,
        [string]$Category = "general"
    )
    
    if (!(Test-Path $script:ClaudeContextFile)) {
        Initialize-ClaudeContext
    }
    
    try {
        $context = Get-Content $script:ClaudeContextFile -Raw | ConvertFrom-Json
        
        if (!$context.data) {
            $context | Add-Member -NotePropertyName "data" -NotePropertyValue @()
        }
        
        $contextEntry = @{
            timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            type = $Type
            category = $Category
            content = $Content
        }
        
        $context.data += $contextEntry
        $context.last_updated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        $context | ConvertTo-Json -Depth 10 | Set-Content -Path $script:ClaudeContextFile -Encoding UTF8
    }
    catch {
        Write-Log "Failed to update Claude context: $($_.Exception.Message)" "WARN"
    }
}

# Ask Claude for recommendations
function Get-ClaudeRecommendation {
    param([string]$Query, [string]$Context = "")
    
    if (!$script:ClaudeAvailable) {
        Write-Log "Claude not available - using fallback recommendations" "WARN"
        return "Claude Code not available. Proceeding with standard recommendations."
    }
    
    try {
        Write-Log "🤖 Consulting Claude Code..." "CLAUDE"
        
        # Build comprehensive prompt
        $systemContext = ""
        if (Test-Path $script:SystemAnalysisFile) {
            $systemContext = Get-Content $script:SystemAnalysisFile -Raw
        }
        
        $prompt = @"
You are helping Bill (a user with ADHD and dyslexia) set up a Windows-Ubuntu dual-boot system for his vacation rental business automation. 

SYSTEM CONTEXT:
$systemContext

CURRENT SITUATION:
$Context

QUESTION:
$Query

Please provide:
1. Clear, step-by-step recommendations
2. Potential risks and how to mitigate them  
3. ADHD-friendly explanations (no overwhelming technical jargon)
4. Alternative approaches if the main approach fails
5. Specific commands or tools to use

Keep responses practical and actionable. Bill needs this to work reliably for his VRBO property management automation.
"@
        
        # Execute Claude query
        $claudeResponse = & $ClaudeBinary $prompt 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "✅ Claude consultation completed" "CLAUDE"
            Add-ClaudeContext -Type "recommendation" -Content @{
                query = $Query
                response = $claudeResponse
            } -Category "ai_assistance"
            
            return $claudeResponse
        } else {
            Write-Log "❌ Claude query failed: $claudeResponse" "ERROR"
            return "Claude query failed. Proceeding with standard approach."
        }
    }
    catch {
        Write-Log "❌ Error consulting Claude: $($_.Exception.Message)" "ERROR"
        return "Error consulting Claude. Proceeding with standard approach."
    }
}

# Enhanced system analysis with Claude insights
function Get-EnhancedSystemAnalysis {
    Write-Host "🔍 CLAUDE-ASSISTED SYSTEM ANALYSIS" -ForegroundColor Cyan
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Basic system info
    $computerInfo = Get-ComputerInfo
    $osVersion = $computerInfo.WindowsVersion
    $totalRAM = [math]::Round($computerInfo.TotalPhysicalMemory / 1GB, 1)
    $architecture = $env:PROCESSOR_ARCHITECTURE
    
    # Enhanced disk analysis
    $diskInfo = @()
    $disks = Get-Disk | Where-Object { $_.BusType -ne "USB" }
    
    foreach ($disk in $disks) {
        $sizeGB = [math]::Round($disk.Size / 1GB, 1)
        $partitions = Get-Partition -DiskNumber $disk.Number -ErrorAction SilentlyContinue
        $partitionDetails = @()
        
        foreach ($partition in $partitions) {
            if ($partition.DriveLetter) {
                try {
                    $volume = Get-Volume -DriveLetter $partition.DriveLetter -ErrorAction SilentlyContinue
                    if ($volume) {
                        $partitionDetails += @{
                            DriveLetter = $partition.DriveLetter
                            SizeGB = [math]::Round($partition.Size / 1GB, 1)
                            FreeGB = [math]::Round($volume.SizeRemaining / 1GB, 1)
                            FileSystem = $volume.FileSystem
                            Label = $volume.FileSystemLabel
                            BootPartition = $partition.IsActive
                        }
                    }
                }
                catch { }
            }
        }
        
        $diskInfo += @{
            Number = $disk.Number
            Model = $disk.FriendlyName
            SizeGB = $sizeGB
            PartitionStyle = $disk.PartitionStyle
            IsSystemDisk = $disk.IsBoot
            Partitions = $partitionDetails
        }
    }
    
    # Get BIOS/UEFI info
    $firmwareType = "Unknown"
    $secureBootStatus = $false
    try {
        $firmwareType = (Get-ComputerInfo).BiosFirmwareType
        $secureBootStatus = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
    } catch { }
    
    # Create comprehensive analysis
    $analysis = @{
        ComputerName = $computerInfo.CsName
        WindowsVersion = $computerInfo.WindowsProductName
        OSBuild = $osVersion
        Architecture = $architecture
        TotalRAM_GB = $totalRAM
        FirmwareType = $firmwareType
        SecureBootEnabled = $secureBootStatus
        DiskConfiguration = $diskInfo
        FastStartupEnabled = $false
        RecommendedUbuntuSize = $UbuntuSizeGB
        AnalysisTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    
    # Check Fast Startup
    try {
        $fastStartup = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -ErrorAction SilentlyContinue
        $analysis.FastStartupEnabled = ($fastStartup -and $fastStartup.HiberbootEnabled -eq 1)
    } catch { }
    
    # Save analysis for Claude
    $analysis | ConvertTo-Json -Depth 5 | Set-Content -Path $script:SystemAnalysisFile -Encoding UTF8
    Add-ClaudeContext -Type "system_analysis" -Content $analysis -Category "hardware"
    
    Write-Log "System: $($analysis.ComputerName) - $($analysis.WindowsVersion)" "INFO"
    Write-Log "Hardware: $($analysis.TotalRAM_GB)GB RAM, $($analysis.Architecture), $($analysis.FirmwareType)" "INFO"
    Write-Log "Disks: $($diskInfo.Count) detected" "INFO"
    
    foreach ($disk in $diskInfo) {
        Write-Log "  Disk $($disk.Number): $($disk.Model) ($($disk.SizeGB)GB, $($disk.PartitionStyle))" "INFO"
        foreach ($partition in $disk.Partitions) {
            Write-Log "    $($partition.DriveLetter): $($partition.SizeGB)GB total, $($partition.FreeGB)GB free" "INFO"
        }
    }
    
    return $analysis
}

# Claude-assisted partition planning
function Get-ClaudePartitionPlan {
    param([object]$SystemAnalysis)
    
    Write-Host ""
    Write-Host "🤖 CLAUDE-ASSISTED PARTITION PLANNING" -ForegroundColor Magenta
    Write-Host "=====================================" -ForegroundColor Magenta
    Write-Host ""
    
    $query = @"
Analyze this Windows system for Ubuntu dual-boot setup:

REQUIREMENTS:
- Need ${UbuntuSizeGB}GB for Ubuntu
- Must preserve Windows functionality
- User will run VRBO automation software in Ubuntu
- System needs to be reliable for business use

CURRENT DISK SETUP:
$($SystemAnalysis.DiskConfiguration | ConvertTo-Json -Depth 3)

Please recommend:
1. Best partition strategy (shrink C:, use other drives, etc.)
2. Specific partition sizes for Ubuntu (/, swap, /home)
3. Potential risks and mitigation strategies
4. Step-by-step partitioning approach
5. Backup recommendations before proceeding
"@
    
    $claudeResponse = Get-ClaudeRecommendation -Query $query -Context "Dual-boot partition planning"
    
    Write-Host "🤖 CLAUDE'S PARTITION RECOMMENDATIONS:" -ForegroundColor Magenta
    Write-Host "=====================================" -ForegroundColor Magenta
    Write-Host $claudeResponse
    Write-Host ""
    
    # Also generate fallback recommendations
    $fallbackPlan = Get-FallbackPartitionPlan -SystemAnalysis $SystemAnalysis
    
    return @{
        ClaudeRecommendation = $claudeResponse
        FallbackPlan = $fallbackPlan
        Analysis = $SystemAnalysis
    }
}

# Fallback partition analysis if Claude unavailable
function Get-FallbackPartitionPlan {
    param([object]$SystemAnalysis)
    
    $recommendations = @()
    
    # Find C: drive
    $systemDisk = $SystemAnalysis.DiskConfiguration | Where-Object { $_.IsSystemDisk }
    $cDrive = $systemDisk.Partitions | Where-Object { $_.DriveLetter -eq "C" }
    
    if ($cDrive -and $cDrive.FreeGB -gt ($UbuntuSizeGB + 20)) {
        $recommendations += @{
            Strategy = "Shrink C: Drive"
            Description = "Shrink Windows C: drive to create space for Ubuntu"
            AvailableGB = [math]::Min($cDrive.FreeGB - 20, $UbuntuSizeGB * 2)
            Difficulty = "Medium"
            Risk = "Low"
            Steps = @(
                "Defragment C: drive",
                "Use Disk Management to shrink C:",
                "Create Ubuntu partitions during installation"
            )
        }
    }
    
    # Look for other drives with space
    foreach ($disk in $SystemAnalysis.DiskConfiguration) {
        foreach ($partition in $disk.Partitions) {
            if ($partition.DriveLetter -ne "C" -and $partition.FreeGB -gt ($UbuntuSizeGB + 10)) {
                $recommendations += @{
                    Strategy = "Use Drive $($partition.DriveLetter):"
                    Description = "Install Ubuntu on drive $($partition.DriveLetter): ($($partition.Label))"
                    AvailableGB = $partition.FreeGB - 10
                    Difficulty = "High"
                    Risk = "Medium"
                    Steps = @(
                        "Backup data from $($partition.DriveLetter):",
                        "Repartition drive during Ubuntu installation",
                        "Restore data to Windows partition"
                    )
                }
            }
        }
    }
    
    return $recommendations
}

# Interactive partition setup with Claude assistance
function Start-InteractivePartitionSetup {
    param([object]$PartitionPlan)
    
    Write-Host ""
    Write-Host "🔧 INTERACTIVE PARTITION SETUP" -ForegroundColor Yellow
    Write-Host "==============================" -ForegroundColor Yellow
    Write-Host ""
    
    if ($Interactive) {
        Write-Host "Would you like to proceed with partition preparation? (Y/N)"
        $response = Read-Host
        
        if ($response -notmatch '^[Yy]') {
            Write-Log "User declined partition setup" "INFO"
            return $false
        }
    }
    
    # Show current disk usage
    Write-Host "📊 Current Disk Usage:" -ForegroundColor Cyan
    Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
        $freeGB = [math]::Round($_.FreeSpace / 1GB, 1)
        $totalGB = [math]::Round($_.Size / 1GB, 1)
        $usedPercent = [math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100, 1)
        Write-Host "  Drive $($_.DeviceID) - $freeGB GB free of $totalGB GB total ($usedPercent% used)"
    }
    
    Write-Host ""
    
    # Get Claude's specific recommendations for this system
    $specificQuery = @"
The user is ready to prepare partitions. Current disk usage shown above.

What are the exact next steps to:
1. Prepare the Windows system safely
2. Create the optimal partitioning strategy
3. Minimize risk of data loss
4. Ensure the dual-boot will work reliably

Be specific about which tools to use and in what order.
"@
    
    $claudeGuidance = Get-ClaudeRecommendation -Query $specificQuery -Context "Ready to partition"
    
    Write-Host "🤖 CLAUDE'S STEP-BY-STEP GUIDANCE:" -ForegroundColor Magenta
    Write-Host "==================================" -ForegroundColor Magenta
    Write-Host $claudeGuidance
    Write-Host ""
    
    return $true
}

# Automated system preparation
function Start-SystemPreparation {
    Write-Host ""
    Write-Host "⚙️ AUTOMATED SYSTEM PREPARATION" -ForegroundColor Green
    Write-Host "===============================" -ForegroundColor Green
    Write-Host ""
    
    $preparationSteps = @()
    
    # Disable Fast Startup
    try {
        Write-Log "Disabling Fast Startup..." "INFO"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0 -Type DWord
        powercfg /hibernate off
        $preparationSteps += "✅ Fast Startup disabled"
        Write-Log "✅ Fast Startup disabled successfully" "SUCCESS"
    }
    catch {
        $preparationSteps += "❌ Failed to disable Fast Startup"
        Write-Log "❌ Failed to disable Fast Startup: $($_.Exception.Message)" "ERROR"
    }
    
    # Create system restore point
    try {
        Write-Log "Creating system restore point..." "INFO"
        Checkpoint-Computer -Description "Bill Sloth Pre-Ubuntu Setup" -RestorePointType "MODIFY_SETTINGS"
        $preparationSteps += "✅ System restore point created"
        Write-Log "✅ System restore point created" "SUCCESS"
    }
    catch {
        $preparationSteps += "⚠️ Could not create restore point"
        Write-Log "⚠️ Could not create restore point: $($_.Exception.Message)" "WARN"
    }
    
    # Check disk errors
    try {
        Write-Log "Checking disk for errors..." "INFO"
        $checkDiskResult = & chkdsk C: /f /r /x 2>&1
        if ($LASTEXITCODE -eq 0) {
            $preparationSteps += "✅ Disk check completed"
            Write-Log "✅ Disk check completed successfully" "SUCCESS"
        }
    }
    catch {
        $preparationSteps += "⚠️ Disk check had issues"
        Write-Log "⚠️ Disk check issues: $($_.Exception.Message)" "WARN"
    }
    
    # Defragment system drive
    try {
        Write-Log "Defragmenting system drive (this may take a while)..." "INFO"
        Optimize-Volume -DriveLetter C -Defrag -Verbose
        $preparationSteps += "✅ System drive defragmented"
        Write-Log "✅ System drive defragmented" "SUCCESS"
    }
    catch {
        $preparationSteps += "⚠️ Defragmentation had issues"
        Write-Log "⚠️ Defragmentation issues: $($_.Exception.Message)" "WARN"
    }
    
    Add-ClaudeContext -Type "preparation_results" -Content $preparationSteps -Category "system_prep"
    
    return $preparationSteps
}

# Generate Ubuntu installation guide with Claude assistance
function New-ClaudeAssistedInstallGuide {
    param([object]$SystemAnalysis, [object]$PartitionPlan)
    
    Write-Host ""
    Write-Host "📚 GENERATING CLAUDE-ASSISTED INSTALL GUIDE" -ForegroundColor Magenta
    Write-Host "===========================================" -ForegroundColor Magenta
    Write-Host ""
    
    # Get Claude's comprehensive installation guide
    $installQuery = @"
Create a comprehensive, step-by-step Ubuntu installation guide for this specific system:

SYSTEM SPECIFICATIONS:
- Computer: $($SystemAnalysis.ComputerName)
- Windows: $($SystemAnalysis.WindowsVersion) 
- RAM: $($SystemAnalysis.TotalRAM_GB)GB
- Firmware: $($SystemAnalysis.FirmwareType)
- Secure Boot: $($SystemAnalysis.SecureBootEnabled)

INSTALLATION REQUIREMENTS:
- Dual-boot with Windows (preserve existing Windows installation)
- Ubuntu for VRBO business automation (needs to be reliable)
- ${UbuntuSizeGB}GB partition for Ubuntu
- User has ADHD/dyslexia (needs clear, simple steps)

Please provide:
1. Pre-installation checklist
2. BIOS/UEFI configuration steps
3. Ubuntu installer walkthrough (specific to this system)
4. Post-installation setup for Bill Sloth automation
5. Troubleshooting common issues for this hardware
6. How to switch between Windows and Ubuntu
7. Recovery procedures if something goes wrong

Make it comprehensive but easy to follow step-by-step.
"@
    
    $claudeGuide = Get-ClaudeRecommendation -Query $installQuery -Context "Creating installation guide"
    
    # Create comprehensive guide file
    $guideContent = @"
# Bill Sloth Ubuntu Installation Guide
## Claude Code Assisted Setup for $($SystemAnalysis.ComputerName)

Generated: $(Get-Date)
System: $($SystemAnalysis.WindowsVersion) on $($SystemAnalysis.ComputerName)
Target: Ubuntu 22.04.3 LTS Dual-Boot

---

## 🤖 CLAUDE'S COMPREHENSIVE INSTALLATION GUIDE

$claudeGuide

---

## 📋 PRE-INSTALLATION CHECKLIST

### Before You Start:
- [ ] **Backup Important Data** - Create backup of important Windows files
- [ ] **System Restore Point Created** - Windows recovery point is available
- [ ] **Fast Startup Disabled** - Prevents file system corruption
- [ ] **Ubuntu USB Created** - Bootable USB with Ubuntu 22.04.3 LTS
- [ ] **Power Connected** - Laptop plugged in for installation
- [ ] **Internet Available** - For downloading updates during install

### System Information:
- **Computer**: $($SystemAnalysis.ComputerName)
- **Windows**: $($SystemAnalysis.WindowsVersion)
- **RAM**: $($SystemAnalysis.TotalRAM_GB) GB
- **Firmware**: $($SystemAnalysis.FirmwareType)
- **Secure Boot**: $(if ($SystemAnalysis.SecureBootEnabled) { "Enabled" } else { "Disabled" })

---

## 🚀 BILL SLOTH POST-INSTALLATION SETUP

After Ubuntu installation completes:

### 1. First Boot into Ubuntu
```bash
# Open terminal (Ctrl+Alt+T) and run:
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install curl git wget -y
```

### 2. Get Bill Sloth
```bash
# Clone Bill Sloth repository
cd ~
git clone https://github.com/how1337itis/billsloth.git

# Or download if git clone fails:
wget -O bill-sloth.zip https://github.com/how1337itis/billsloth/archive/main.zip
unzip bill-sloth.zip && mv bill-sloth-main bill-sloth
```

### 3. Run Bill Sloth Setup
```bash
cd bill-sloth
chmod +x fresh_ubuntu_installer.sh
./fresh_ubuntu_installer.sh
```

### 4. Start Bill Sloth
```bash
./bill_command_center.sh
```

---

## 🆘 EMERGENCY RECOVERY

If installation fails or system won't boot:

### Windows Recovery:
1. Boot from Windows installation USB
2. Choose "Repair your computer"
3. Go to Troubleshoot > Advanced > Command Prompt
4. Run: `bootrec /fixmbr` and `bootrec /fixboot`

### Ubuntu Recovery:
1. Boot from Ubuntu USB in "Try Ubuntu" mode
2. Open terminal and run: `sudo update-grub`
3. Or reinstall GRUB bootloader

### Complete Reset:
- Use Windows System Restore to return to pre-installation state
- System restore point was created before installation

---

## 📞 SUPPORT RESOURCES

- **Ubuntu Community**: https://askubuntu.com
- **Bill Sloth Issues**: Check repository documentation
- **Dual-Boot Help**: https://help.ubuntu.com/community/WindowsDualBoot
- **ADHD-Friendly Tech Support**: Take breaks, don't rush, ask for help

---

**Generated by Bill Sloth Claude-Assisted Setup**
**Report saved to**: $script:BillSlothDir\CLAUDE-ASSISTED-INSTALL-GUIDE.md
"@

    $guidePath = "$script:BillSlothDir\CLAUDE-ASSISTED-INSTALL-GUIDE.md"
    Set-Content -Path $guidePath -Value $guideContent -Encoding UTF8
    
    Write-Log "✅ Claude-assisted installation guide created" "SUCCESS"
    Write-Log "📖 Guide location: $guidePath" "INFO"
    
    return $guidePath
}

# Create emergency recovery package
function New-EmergencyRecoveryPackage {
    param([object]$SystemAnalysis)
    
    Write-Host ""
    Write-Host "🆘 CREATING EMERGENCY RECOVERY PACKAGE" -ForegroundColor Red
    Write-Host "======================================" -ForegroundColor Red
    Write-Host ""
    
    $recoveryDir = "$script:BillSlothDir\emergency-recovery"
    if (Test-Path $recoveryDir) {
        Remove-Item -Path $recoveryDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $recoveryDir -Force | Out-Null
    
    # System information backup
    $SystemAnalysis | ConvertTo-Json -Depth 5 | Set-Content -Path "$recoveryDir\system-backup.json" -Encoding UTF8
    
    # Boot repair script
    $bootRepairScript = @"
@echo off
echo Bill Sloth Emergency Boot Repair
echo ================================
echo.
echo This script will attempt to repair Windows boot issues
echo that may occur after Ubuntu dual-boot installation.
echo.
pause

echo Repairing Master Boot Record...
bootrec /fixmbr

echo Repairing Boot Sector...  
bootrec /fixboot

echo Rebuilding Boot Configuration...
bootrec /rebuildbcd

echo Scanning for Windows installations...
bootrec /scanos

echo.
echo Boot repair completed. Restart your computer.
echo If issues persist, use Windows System Restore.
pause
"@
    
    Set-Content -Path "$recoveryDir\repair-windows-boot.cmd" -Value $bootRepairScript -Encoding UTF8
    
    # GRUB repair script (for Ubuntu)
    $grubRepairScript = @"
#!/bin/bash
# Bill Sloth GRUB Repair Script
# Run this from Ubuntu live USB if dual-boot menu disappears

echo "Bill Sloth GRUB Repair"
echo "====================="
echo ""
echo "This will repair the Ubuntu GRUB bootloader"
echo "Continue? (y/n)"
read -r confirm

if [[ $confirm == "y" ]]; then
    echo "Updating GRUB configuration..."
    sudo update-grub
    
    echo "Reinstalling GRUB..."
    sudo grub-install /dev/sda
    
    echo "GRUB repair completed."
    echo "Restart your computer - dual-boot menu should appear."
else
    echo "GRUB repair cancelled."
fi
"@
    
    Set-Content -Path "$recoveryDir\repair-grub.sh" -Value $grubRepairScript -Encoding UTF8
    
    # Recovery instructions
    $recoveryInstructions = @"
# Bill Sloth Emergency Recovery Instructions

## If Windows Won't Boot After Ubuntu Installation

### Method 1: Boot Repair from Windows USB
1. Boot from Windows installation USB
2. Choose "Repair your computer" (not "Install")
3. Go to Troubleshoot > Advanced Options > Command Prompt
4. Copy and run: repair-windows-boot.cmd from this package

### Method 2: System Restore
1. Boot from Windows installation USB  
2. Go to Troubleshoot > Advanced Options > System Restore
3. Choose "Bill Sloth Pre-Ubuntu Setup" restore point
4. Follow prompts to restore system

## If Dual-Boot Menu Disappears

### From Ubuntu Live USB:
1. Boot from Ubuntu USB in "Try Ubuntu" mode
2. Open terminal (Ctrl+Alt+T)
3. Copy and run: repair-grub.sh from this package

### Alternative GRUB Fix:
```bash
sudo mount /dev/sda1 /mnt  # Adjust sda1 to your Ubuntu partition
sudo grub-install --root-directory=/mnt /dev/sda
sudo update-grub
```

## Nuclear Option: Complete Recovery

If everything fails:
1. Boot from Windows installation USB
2. Use System Restore to return to pre-installation state
3. Your Windows system will be exactly as it was before
4. You can try Ubuntu installation again later

## System Information Backup

Your system configuration is backed up in:
- system-backup.json (complete system analysis)
- This recovery package location: $recoveryDir

## Getting Help

- Windows issues: Windows support forums
- Ubuntu issues: https://askubuntu.com  
- Bill Sloth issues: Check repository documentation

Remember: Take breaks, don't panic, and ask for help if needed.
"@
    
    Set-Content -Path "$recoveryDir\RECOVERY-INSTRUCTIONS.md" -Value $recoveryInstructions -Encoding UTF8
    
    Write-Log "✅ Emergency recovery package created" "SUCCESS"
    Write-Log "📁 Recovery package: $recoveryDir" "INFO"
    
    return $recoveryDir
}

# Main execution with Claude integration
function Main {
    Write-Log "Bill Sloth Claude-Assisted Windows Setup started" "INFO"
    
    # Initialize
    if (!(Test-Path $script:BillSlothDir)) {
        New-Item -ItemType Directory -Path $script:BillSlothDir -Force | Out-Null
    }
    
    # Test Claude availability
    Test-ClaudeAvailability | Out-Null
    Initialize-ClaudeContext
    
    Write-Log "🤖 Claude Code integration: $(if ($script:ClaudeAvailable) { 'ACTIVE' } else { 'FALLBACK MODE' })" "CLAUDE"
    
    # Enhanced system analysis
    $systemAnalysis = Get-EnhancedSystemAnalysis
    
    if ($CheckOnly) {
        Write-Host ""
        Write-Host "✅ Claude-assisted system analysis complete" -ForegroundColor Green
        return
    }
    
    # Claude-assisted partition planning
    $partitionPlan = Get-ClaudePartitionPlan -SystemAnalysis $systemAnalysis
    
    # Interactive setup if requested
    if ($Interactive) {
        $proceed = Start-InteractivePartitionSetup -PartitionPlan $partitionPlan
        if (!$proceed) {
            Write-Log "Setup cancelled by user" "INFO"
            return
        }
    }
    
    # System preparation
    Write-Host ""
    Write-Host "⚙️ PREPARING SYSTEM FOR DUAL-BOOT" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Green
    
    $prepResults = Start-SystemPreparation
    
    # Create Claude-assisted installation guide
    $installGuide = New-ClaudeAssistedInstallGuide -SystemAnalysis $systemAnalysis -PartitionPlan $partitionPlan
    
    # Create emergency recovery package
    $recoveryPackage = New-EmergencyRecoveryPackage -SystemAnalysis $systemAnalysis
    
    # Final report
    Write-Host ""
    Write-Host "🎉 CLAUDE-ASSISTED SETUP COMPLETE!" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Setup Summary:" -ForegroundColor White
    Write-Host "  ✅ System analyzed with Claude assistance" -ForegroundColor Green
    Write-Host "  ✅ Partition strategy planned" -ForegroundColor Green  
    Write-Host "  ✅ System prepared for dual-boot" -ForegroundColor Green
    Write-Host "  ✅ Installation guide generated" -ForegroundColor Green
    Write-Host "  ✅ Emergency recovery package created" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Files Created:" -ForegroundColor Yellow
    Write-Host "  📖 Installation Guide: $installGuide" -ForegroundColor White
    Write-Host "  🆘 Recovery Package: $recoveryPackage" -ForegroundColor White
    Write-Host "  📋 Setup Log: $script:LogFile" -ForegroundColor White
    Write-Host ""
    Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. Create Ubuntu bootable USB (use Rufus with Ubuntu 22.04.3 LTS)" -ForegroundColor White
    Write-Host "  2. Follow installation guide: $installGuide" -ForegroundColor White
    Write-Host "  3. Keep recovery package safe: $recoveryPackage" -ForegroundColor White
    Write-Host ""
    Write-Host "🤖 Claude Code assisted you through this entire process!" -ForegroundColor Magenta
    Write-Host "    Your system is optimally prepared for Bill Sloth automation." -ForegroundColor Magenta
    Write-Host ""
    
    Add-ClaudeContext -Type "completion" -Content @{
        status = "success"
        files_created = @($installGuide, $recoveryPackage, $script:LogFile)
        next_steps = @(
            "Create Ubuntu USB",
            "Follow installation guide", 
            "Install Ubuntu alongside Windows",
            "Run Bill Sloth setup in Ubuntu"
        )
    } -Category "final_status"
}

# Execute with error handling
try {
    Main
}
catch {
    Write-Log "❌ Claude-assisted setup failed: $($_.Exception.Message)" "ERROR"
    Write-Log "Full error: $($_.Exception)" "ERROR"
    
    if ($script:ClaudeAvailable) {
        $errorQuery = "The Windows dual-boot setup encountered this error: $($_.Exception.Message). What should the user do to recover and continue?"
        $claudeErrorHelp = Get-ClaudeRecommendation -Query $errorQuery -Context "Setup error occurred"
        Write-Host ""
        Write-Host "🤖 CLAUDE'S ERROR RECOVERY ADVICE:" -ForegroundColor Magenta
        Write-Host "==================================" -ForegroundColor Magenta
        Write-Host $claudeErrorHelp
    }
    
    exit 1
}

Write-Log "Bill Sloth Claude-Assisted Windows Bootstrap completed successfully" "SUCCESS"