# Bill Sloth Auto-Setup Script
# One-click download and execution of Bill Sloth Windows dual-boot preparation
# Designed to be run by Claude Code or pasted into PowerShell

param(
    [switch]$SkipElevation,
    [switch]$Interactive = $true,
    [string]$Repository = "https://raw.githubusercontent.com/how1337itis/billsloth/main"
)

# ASCII Banner
Write-Host @"
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  🚀 BILL SLOTH AUTO-SETUP 🚀                                      █  
█  💀 ONE-CLICK DUAL-BOOT PREPARATION 💀                            █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "🤖 Automated setup for Bill's Windows-to-Ubuntu dual-boot transition" -ForegroundColor Green
Write-Host ""

# Self-elevate if not running as admin
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    if (-NOT $SkipElevation) {
        Write-Host "⚠️ This script requires Administrator privileges for partition management." -ForegroundColor Yellow
        Write-Host "   Attempting to restart with elevated privileges..." -ForegroundColor Yellow
        
        try {
            $arguments = "-File `"$PSCommandPath`" -SkipElevation"
            if (!$Interactive) { $arguments += " -Interactive:`$false" }
            if ($Repository -ne "https://raw.githubusercontent.com/anthropics/bill-sloth/main") {
                $arguments += " -Repository `"$Repository`""
            }
            
            Start-Process PowerShell -Verb RunAs -ArgumentList $arguments
            exit 0
        }
        catch {
            Write-Host "❌ Failed to elevate privileges. Please run PowerShell as Administrator." -ForegroundColor Red
            Write-Host "   Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
            exit 1
        }
    }
    else {
        Write-Host "❌ This script must be run with Administrator privileges!" -ForegroundColor Red
        Write-Host "   Please restart PowerShell as Administrator and run again." -ForegroundColor Yellow
        exit 1
    }
}

# Setup working directory
$SetupDir = "$env:USERPROFILE\bill-sloth-setup"
Write-Host "📁 Creating setup directory: $SetupDir" -ForegroundColor Blue

if (Test-Path $SetupDir) {
    Write-Host "   Directory exists, cleaning up..." -ForegroundColor Gray
    Remove-Item $SetupDir -Recurse -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $SetupDir -Force | Out-Null
Set-Location $SetupDir

# Report status for Claude Code integration
function Report-StatusToClaude {
    param([string]$Status, [string]$Details, [string]$Stage = "setup")
    
    $statusFile = "$env:TEMP\bill-sloth-claude-status.json"
    $statusData = @{
        timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        status = $Status
        details = $Details
        stage = $Stage
        directory = $SetupDir
    }
    
    try {
        $statusData | ConvertTo-Json | Set-Content -Path $statusFile -Encoding UTF8
    }
    catch {
        # Silent fail if can't write status file
    }
    
    # Output for Claude Code to monitor
    Write-Host "CLAUDE_STATUS: [$Stage] $Status - $Details" -ForegroundColor Magenta
}

# Download function with progress and error handling
function Download-BillSlothScript {
    param([string]$ScriptName, [string]$Description)
    
    $url = "$Repository/windows-setup/$ScriptName"
    $localPath = "$SetupDir\$ScriptName"
    
    Write-Host "📥 Downloading $Description..." -ForegroundColor Blue
    Write-Host "   Source: $url" -ForegroundColor Gray
    
    try {
        # Use BITS if available for better progress tracking
        if (Get-Module -ListAvailable -Name BitsTransfer) {
            Import-Module BitsTransfer
            Start-BitsTransfer -Source $url -Destination $localPath -DisplayName "Bill Sloth: $ScriptName"
        }
        else {
            # Fallback to Invoke-WebRequest
            $progressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $url -OutFile $localPath -UseBasicParsing
            $progressPreference = 'Continue'
        }
        
        if (Test-Path $localPath) {
            Write-Host "   ✅ Downloaded successfully" -ForegroundColor Green
            Report-StatusToClaude "DOWNLOADED" "$ScriptName downloaded successfully" "download"
            return $true
        }
        else {
            throw "File not created after download"
        }
    }
    catch {
        Write-Host "   ❌ Download failed: $($_.Exception.Message)" -ForegroundColor Red
        Report-StatusToClaude "ERROR" "Failed to download $ScriptName" "download"
        return $false
    }
}

# Main download process
Write-Host ""
Write-Host "🌐 DOWNLOADING BILL SLOTH SCRIPTS" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

Report-StatusToClaude "STARTING" "Beginning Bill Sloth auto-setup" "init"

# List of scripts to download
$scripts = @(
    @{
        Name = "bill-sloth-claude-assisted-setup.ps1"
        Description = "Main Claude-assisted setup orchestrator"
        Required = $true
    },
    @{
        Name = "disk-partition-manager.ps1"  
        Description = "Advanced partition management system"
        Required = $true
    },
    @{
        Name = "ubuntu-installer-prep.ps1"
        Description = "Ubuntu ISO and USB preparation system"
        Required = $true
    },
    @{
        Name = "README.md"
        Description = "Setup documentation and instructions"
        Required = $false
    }
)

$downloadSuccess = $true
$downloadedScripts = @()

foreach ($script in $scripts) {
    $success = Download-BillSlothScript -ScriptName $script.Name -Description $script.Description
    
    if ($success) {
        $downloadedScripts += $script.Name
    }
    elseif ($script.Required) {
        $downloadSuccess = $false
        Write-Host "❌ Required script failed to download: $($script.Name)" -ForegroundColor Red
    }
}

if (-not $downloadSuccess) {
    Write-Host ""
    Write-Host "❌ DOWNLOAD FAILED" -ForegroundColor Red
    Write-Host "==================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Some required scripts failed to download. This could be due to:" -ForegroundColor Yellow
    Write-Host "• Network connectivity issues" -ForegroundColor Yellow
    Write-Host "• Repository URL changes" -ForegroundColor Yellow
    Write-Host "• Firewall or antivirus blocking downloads" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
    
    Report-StatusToClaude "FAILED" "Download process failed" "download"
    exit 1
}

Write-Host ""
Write-Host "✅ DOWNLOAD COMPLETE" -ForegroundColor Green
Write-Host "====================" -ForegroundColor Green
Write-Host ""
Write-Host "Downloaded scripts:" -ForegroundColor White
foreach ($script in $downloadedScripts) {
    Write-Host "  ✅ $script" -ForegroundColor Green
}
Write-Host ""

Report-StatusToClaude "DOWNLOADED" "All scripts downloaded successfully" "download"

# Verify Claude Code availability
Write-Host "🤖 CHECKING CLAUDE CODE INTEGRATION" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

$claudeAvailable = $false
try {
    $claudeVersion = claude --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Claude Code CLI detected: $claudeVersion" -ForegroundColor Green
        $claudeAvailable = $true
        
        # Check authentication
        try {
            claude auth status 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Claude Code is authenticated and ready" -ForegroundColor Green
                Report-StatusToClaude "CLAUDE_READY" "Claude Code is available and authenticated" "validation"
            }
            else {
                Write-Host "⚠️ Claude Code is installed but not authenticated" -ForegroundColor Yellow
                Write-Host "   Run 'claude login' to authenticate before continuing" -ForegroundColor Yellow
                Report-StatusToClaude "CLAUDE_AUTH_NEEDED" "Claude Code needs authentication" "validation"
            }
        }
        catch {
            Write-Host "⚠️ Could not check Claude Code authentication status" -ForegroundColor Yellow
        }
    }
}
catch {
    Write-Host "⚠️ Claude Code CLI not found" -ForegroundColor Yellow
    Write-Host "   Install with: npm install -g @anthropic-ai/claude-code" -ForegroundColor Yellow
    Write-Host "   Setup will continue in fallback mode" -ForegroundColor Yellow
    Report-StatusToClaude "CLAUDE_MISSING" "Claude Code not available, using fallback mode" "validation"
}

Write-Host ""

# Start the main setup process
Write-Host "🚀 STARTING BILL SLOTH SETUP" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

Report-StatusToClaude "LAUNCHING" "Starting main Bill Sloth setup process" "execution"

try {
    # Build arguments for main script
    $mainScriptArgs = @()
    if ($Interactive) { $mainScriptArgs += "-Interactive" }
    if ($claudeAvailable) { $mainScriptArgs += "-AIAssisted", "`$true" }
    
    # Launch main setup script
    $mainScript = "$SetupDir\bill-sloth-claude-assisted-setup.ps1"
    
    if (Test-Path $mainScript) {
        Write-Host "🎯 Launching Claude-assisted setup..." -ForegroundColor Blue
        Write-Host "   Script: $mainScript" -ForegroundColor Gray
        Write-Host "   Arguments: $($mainScriptArgs -join ' ')" -ForegroundColor Gray
        Write-Host ""
        
        # Execute main script
        if ($mainScriptArgs.Count -gt 0) {
            & $mainScript @mainScriptArgs
        }
        else {
            & $mainScript
        }
        
        $exitCode = $LASTEXITCODE
        
        if ($exitCode -eq 0) {
            Write-Host ""
            Write-Host "🎉 BILL SLOTH SETUP COMPLETED SUCCESSFULLY!" -ForegroundColor Green
            Write-Host "===========================================" -ForegroundColor Green
            Write-Host ""
            Report-StatusToClaude "SUCCESS" "Bill Sloth setup completed successfully" "completion"
        }
        else {
            Write-Host ""
            Write-Host "⚠️ Setup completed with warnings (exit code: $exitCode)" -ForegroundColor Yellow
            Report-StatusToClaude "WARNING" "Setup completed with warnings" "completion"
        }
    }
    else {
        throw "Main setup script not found: $mainScript"
    }
}
catch {
    Write-Host ""
    Write-Host "❌ SETUP FAILED" -ForegroundColor Red
    Write-Host "===============" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Setup files are available in: $SetupDir" -ForegroundColor Yellow
    Write-Host "You can try running the scripts manually or contact support." -ForegroundColor Yellow
    
    Report-StatusToClaude "FAILED" "Setup process failed: $($_.Exception.Message)" "execution"
    exit 1
}

# Final status and cleanup
Write-Host ""
Write-Host "📁 Setup files location: $SetupDir" -ForegroundColor Blue
Write-Host "📋 For troubleshooting, check the logs in the setup directory" -ForegroundColor Blue
Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Review the generated installation guide" -ForegroundColor White
Write-Host "   2. Boot from the created Ubuntu USB" -ForegroundColor White
Write-Host "   3. Install Ubuntu alongside Windows" -ForegroundColor White
Write-Host "   4. Run Bill Sloth setup in Ubuntu" -ForegroundColor White
Write-Host ""

Report-StatusToClaude "COMPLETE" "Auto-setup process finished" "completion"

Write-Host "✨ Bill Sloth Auto-Setup Complete! ✨" -ForegroundColor Magenta