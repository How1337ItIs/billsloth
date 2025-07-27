# Bill Sloth Windows Dual-Boot Bootstrap (Minimal)
# Emergency fallback script for immediate deployment to repository root
# This gets the system functional while full windows-setup directory is uploaded

param(
    [switch]$CheckOnly,
    [switch]$DownloadOnly
)

# Requires Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "🔐 Administrator privileges required for dual-boot setup" -ForegroundColor Yellow
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run this command again:" -ForegroundColor Cyan
    Write-Host "iex (iwr -useb 'https://raw.githubusercontent.com/how1337itis/billsloth/main/windows-bootstrap.ps1')" -ForegroundColor Green
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host @"
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  💀 BILL SLOTH WINDOWS DUAL-BOOT BOOTSTRAP 💀                    █  
█  🖥️  PREPARING WINDOWS FOR UBUNTU TRANSITION 🖥️                 █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "🚀 Initializing Bill Sloth dual-boot preparation..." -ForegroundColor Green
Write-Host ""

# Create working directory
$setupDir = "$env:USERPROFILE\bill-sloth-windows"
if (!(Test-Path $setupDir)) {
    New-Item -ItemType Directory -Path $setupDir -Force | Out-Null
    Write-Host "📁 Created working directory: $setupDir" -ForegroundColor Green
}

# Enhanced logging
$logFile = "$setupDir\bootstrap.log"
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Add-Content -Path $logFile -Value $logEntry
    
    switch ($Level) {
        "ERROR" { Write-Host "❌ $Message" -ForegroundColor Red }
        "WARN"  { Write-Host "⚠️  $Message" -ForegroundColor Yellow }
        "SUCCESS" { Write-Host "✅ $Message" -ForegroundColor Green }
        default { Write-Host "ℹ️  $Message" -ForegroundColor White }
    }
}

Write-Log "Bill Sloth Windows Bootstrap started" "INFO"

# Quick system check
Write-Host "🔍 QUICK SYSTEM ANALYSIS" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host ""

$computerInfo = Get-ComputerInfo
$totalRAM = [math]::Round($computerInfo.TotalPhysicalMemory / 1GB, 1)
$osVersion = $computerInfo.WindowsProductName

Write-Log "System: $($computerInfo.CsName) - $osVersion" "INFO"
Write-Log "RAM: $totalRAM GB" "INFO"

# Check disk space
$cDrive = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "C:" }
$freeSpaceGB = [math]::Round($cDrive.FreeSpace / 1GB, 1)
$totalSpaceGB = [math]::Round($cDrive.Size / 1GB, 1)

Write-Log "C: drive: $freeSpaceGB GB free of $totalSpaceGB GB total" "INFO"

if ($freeSpaceGB -lt 120) {
    Write-Log "⚠️  Low disk space - recommend freeing up space before Ubuntu installation" "WARN"
    Write-Log "   Need ~100GB for Ubuntu + 20GB buffer for Windows" "INFO"
} else {
    Write-Log "✅ Sufficient disk space for Ubuntu dual-boot" "SUCCESS"
}

# Check UEFI vs BIOS
try {
    $firmwareType = (Get-ComputerInfo).BiosFirmwareType
    Write-Log "Firmware: $firmwareType" "INFO"
    if ($firmwareType -eq "Uefi") {
        Write-Log "✅ UEFI detected - Modern dual-boot support available" "SUCCESS"
    } else {
        Write-Log "Legacy BIOS detected - Dual-boot still possible but requires careful setup" "WARN"
    }
} catch {
    Write-Log "Could not determine firmware type" "WARN"
}

if ($CheckOnly) {
    Write-Host ""
    Write-Host "✅ System check complete - see $logFile for details" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎯 Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Free up disk space if needed (100GB+ recommended)" -ForegroundColor White
    Write-Host "  2. Run full setup: Remove -CheckOnly parameter" -ForegroundColor White
    Write-Host "  3. Or use Claude Code with the prompt from repository" -ForegroundColor White
    return
}

# Download full setup scripts (when they're uploaded to repo)
Write-Host ""
Write-Host "📥 DOWNLOADING FULL SETUP TOOLS" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
Write-Host ""

$fullScripts = @{
    "ubuntu-installer-prep.ps1" = "Main dual-boot preparation script"
    "bill-sloth-windows-bootstrap.ps1" = "Comprehensive system analysis"
    "bill-sloth-claude-assisted-setup.ps1" = "Claude Code integration"
}

$downloadSuccess = $true

foreach ($script in $fullScripts.Keys) {
    try {
        $url = "https://raw.githubusercontent.com/how1337itis/billsloth/main/windows-setup/$script"
        $localPath = "$setupDir\$script"
        
        Write-Log "Downloading $script..." "INFO"
        Invoke-WebRequest -Uri $url -OutFile $localPath -UseBasicParsing
        
        if (Test-Path $localPath) {
            $fileSize = [math]::Round((Get-Item $localPath).Length / 1KB, 1)
            Write-Log "✅ Downloaded: $script ($fileSize KB)" "SUCCESS"
        } else {
            throw "File not created"
        }
    } catch {
        Write-Log "❌ Failed to download $script" "ERROR"
        Write-Log "   URL: $url" "ERROR"
        Write-Log "   Error: $($_.Exception.Message)" "ERROR"
        $downloadSuccess = $false
    }
}

if ($DownloadOnly) {
    if ($downloadSuccess) {
        Write-Host ""
        Write-Host "✅ Download complete - scripts ready in $setupDir" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "❌ Some downloads failed - check log for details" -ForegroundColor Red
    }
    return
}

# If downloads failed, provide manual instructions
if (-not $downloadSuccess) {
    Write-Host ""
    Write-Host "📋 MANUAL SETUP INSTRUCTIONS" -ForegroundColor Yellow
    Write-Host "=============================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "The automated download failed. You can still proceed manually:" -ForegroundColor White
    Write-Host ""
    Write-Host "Option 1 - Wait for Full Deployment:" -ForegroundColor Cyan
    Write-Host "  The full windows-setup directory is being uploaded to the repository." -ForegroundColor White
    Write-Host "  Try again in a few minutes with the same command." -ForegroundColor White
    Write-Host ""
    Write-Host "Option 2 - Use Existing Ubuntu Installer:" -ForegroundColor Cyan
    Write-Host "  1. Download Ubuntu 22.04.5 LTS ISO manually" -ForegroundColor White
    Write-Host "  2. Use Rufus to create bootable USB" -ForegroundColor White  
    Write-Host "  3. Install Ubuntu alongside Windows" -ForegroundColor White
    Write-Host "  4. After Ubuntu install, clone Bill Sloth repository" -ForegroundColor White
    Write-Host ""
    Write-Host "Option 3 - Claude Code Assisted:" -ForegroundColor Cyan
    Write-Host "  Copy this prompt into Claude Code:" -ForegroundColor White
    Write-Host "  'Help me set up Windows-Ubuntu dual boot for Bill Sloth automation'" -ForegroundColor Green
    Write-Host ""
    Write-Host "🆘 Emergency Contact:" -ForegroundColor Red
    Write-Host "  Check repository issues: https://github.com/how1337itis/billsloth/issues" -ForegroundColor White
    
    Write-Log "Manual setup instructions provided due to download failure" "WARN"
    return
}

# Run main setup if downloads succeeded
Write-Host ""
Write-Host "🔧 LAUNCHING FULL DUAL-BOOT SETUP" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host ""

try {
    $mainScript = "$setupDir\ubuntu-installer-prep.ps1"
    if (Test-Path $mainScript) {
        Write-Log "Launching main setup script..." "INFO"
        & $mainScript -FullSetup
        Write-Log "✅ Main setup completed" "SUCCESS"
    } else {
        throw "Main setup script not found"
    }
} catch {
    Write-Log "❌ Setup execution failed: $($_.Exception.Message)" "ERROR"
    Write-Host ""
    Write-Host "🆘 Setup failed - check log: $logFile" -ForegroundColor Red
    Write-Host "Try running the individual scripts manually from: $setupDir" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📊 BOOTSTRAP SUMMARY" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ System analyzed" -ForegroundColor Green
Write-Host "✅ Working directory created: $setupDir" -ForegroundColor Green
Write-Host "📋 Setup log: $logFile" -ForegroundColor White
Write-Host ""
Write-Host "🎯 What's next:" -ForegroundColor Cyan
Write-Host "  Your Windows system is now prepared for Ubuntu dual-boot" -ForegroundColor White
Write-Host "  Follow the generated guides to complete Ubuntu installation" -ForegroundColor White
Write-Host ""
Write-Host "🤖 For AI assistance, use Claude Code with Bill Sloth prompts!" -ForegroundColor Magenta
Write-Host ""

# CLI Pane Bridge Prerequisites Check (Phase 0 Stub)
Write-Host "🔧 CLI PANE BRIDGE PREREQUISITES" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Log "Checking CLI Pane Bridge prerequisites..." "INFO"

# TODO: Implement full prerequisite checking
Write-Host "TODO: Check for Windows Terminal availability" -ForegroundColor Yellow
Write-Host "TODO: Check for WSL2 installation" -ForegroundColor Yellow  
Write-Host "TODO: Check for tmux in WSL2 environment" -ForegroundColor Yellow
Write-Host "TODO: Verify Claude Code CLI installation" -ForegroundColor Yellow
Write-Host ""
Write-Log "CLI Pane Bridge prerequisite check (stub) completed" "INFO"

Write-Log "Bill Sloth Windows Bootstrap completed" "INFO"