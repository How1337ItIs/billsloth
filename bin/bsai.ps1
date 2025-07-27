# Bill Sloth AI Assistant - Windows PowerShell Wrapper
# Phase 1 - Working Windows Terminal integration

param(
    [Parameter(Position=0)]
    [string]$ModuleName,
    
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$ModuleArgs
)

# Show usage if no module name provided
if ([string]::IsNullOrEmpty($ModuleName)) {
    Write-Host "Bill Sloth AI Assistant - Windows PowerShell" -ForegroundColor Cyan
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: bin/bsai.ps1 <module_name> [args...]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  bin/bsai.ps1 data_hoarding_interactive" -ForegroundColor White
    Write-Host "  bin/bsai.ps1 gaming_boost_interactive --quick-setup" -ForegroundColor White
    Write-Host ""
    Write-Host "Available modules:" -ForegroundColor Cyan
    if (Test-Path "modules") {
        Get-ChildItem "modules\*.sh" | ForEach-Object { 
            Write-Host "  $($_.BaseName)" -ForegroundColor White
        } | Select-Object -First 10
        $totalCount = (Get-ChildItem "modules\*.sh").Count
        if ($totalCount -gt 10) {
            Write-Host "  ... and $($totalCount - 10) more" -ForegroundColor Gray
        }
    } else {
        Write-Host "  (run from Bill Sloth project directory)" -ForegroundColor Gray
    }
    exit 1
}

# Check if we're in the right directory
if (!(Test-Path "modules\$ModuleName.sh")) {
    Write-Host "Error: Module not found: modules\$ModuleName.sh" -ForegroundColor Red
    Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Available modules:" -ForegroundColor Cyan
    if (Test-Path "modules") {
        Get-ChildItem "modules\*.sh" | ForEach-Object { 
            Write-Host "  $($_.BaseName)" -ForegroundColor White
        } | Select-Object -First 10
        $totalCount = (Get-ChildItem "modules\*.sh").Count
        if ($totalCount -gt 10) {
            Write-Host "  ... and $($totalCount - 10) more" -ForegroundColor Gray
        }
    } else {
        Write-Host "  (run from Bill Sloth project directory)" -ForegroundColor Gray
    }
    exit 1
}

# Function to check prerequisites
function Test-Prerequisites {
    $issues = @()
    
    # Check for Claude CLI
    try {
        $null = Get-Command claude -ErrorAction Stop
        Write-Host "OK Claude CLI found" -ForegroundColor Green
    } catch {
        $issues += "Claude CLI not found. Install from: https://claude.ai/code"
    }
    
    # Check for Windows Terminal
    $hasWindowsTerminal = $false
    try {
        $null = Get-Command wt -ErrorAction Stop
        $hasWindowsTerminal = $true
        Write-Host "OK Windows Terminal found" -ForegroundColor Green
    } catch {
        Write-Host "! Windows Terminal not found - using fallback method" -ForegroundColor Yellow
    }
    
    # Check for WSL2
    $hasWSL = $false
    try {
        $wslList = wsl --list --quiet 2>$null
        if ($wslList) {
            $hasWSL = $true
            Write-Host "OK WSL2 available" -ForegroundColor Green
        }
    } catch {
        Write-Host "! WSL2 not detected" -ForegroundColor Yellow
    }
    
    if ($issues.Count -gt 0) {
        Write-Host ""
        Write-Host "Prerequisites needed:" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "  - $issue" -ForegroundColor Red
        }
        exit 1
    }
    
    return @{
        HasWindowsTerminal = $hasWindowsTerminal
        HasWSL = $hasWSL
    }
}

# Function to launch with Windows Terminal
function Start-WindowsTerminalSession {
    param($ModuleName, $ModuleArgs)
    
    $moduleCmd = "bash modules\$ModuleName.sh $($ModuleArgs -join ' ')"
    $claudePrompt = "You are assisting inside Bill Sloth module $ModuleName. Monitor left pane and help when requested."
    
    # Launch Windows Terminal with split panes
    $wtArgs = @(
        "--title", "Bill Sloth - $ModuleName",
        "powershell", "-NoExit", "-Command", $moduleCmd,
        "split-pane", "--horizontal", 
        "powershell", "-NoExit", "-Command", "claude --dangerously-skip-permissions -p `"$claudePrompt`""
    )
    
    Write-Host "Launching Windows Terminal session for module: $ModuleName" -ForegroundColor Cyan
    Write-Host "Left pane: Bill Sloth module"
    Write-Host "Right pane: Claude CLI assistant"
    Write-Host ""
    
    Start-Process wt -ArgumentList $wtArgs
}

# Function to launch with fallback method
function Start-FallbackSession {
    param($ModuleName, $ModuleArgs)
    
    Write-Host "Using fallback method (separate windows)" -ForegroundColor Yellow
    
    # Launch module in one window
    $moduleCmd = "bash modules\$ModuleName.sh $($ModuleArgs -join ' ')"
    Start-Process cmd -ArgumentList "/k", $moduleCmd
    
    # Launch Claude in another window
    $claudePrompt = "You are assisting with Bill Sloth module $ModuleName. The module is running in a separate window."
    Start-Process cmd -ArgumentList "/k", "claude --dangerously-skip-permissions -p `"$claudePrompt`""
    
    Write-Host "Launched Bill Sloth module and Claude CLI in separate windows" -ForegroundColor Green
}

# Main execution
Write-Host "Bill Sloth AI Assistant - Windows PowerShell" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

$prereqs = Test-Prerequisites

# Choose launch method based on available tools
if ($prereqs.HasWindowsTerminal) {
    Start-WindowsTerminalSession -ModuleName $ModuleName -ModuleArgs $ModuleArgs
} else {
    Start-FallbackSession -ModuleName $ModuleName -ModuleArgs $ModuleArgs
}