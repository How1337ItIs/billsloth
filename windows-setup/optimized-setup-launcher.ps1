# Optimized Bill Sloth Setup Launcher
# Automatically runs pre-flight check then launches optimized wizard

param(
    [switch]$SkipPreFlight,
    [switch]$ManualPreFlight,
    [string]$PreFlightFile = ""
)

#Requires -RunAsAdministrator

Write-Host @"
╔══════════════════════════════════════════════════════════════════════════════╗
║  🎯 BILL SLOTH OPTIMIZED SETUP LAUNCHER 🎯                                  ║
║                                                                              ║
║  Pre-flight system analysis + Token-efficient dual-boot wizard              ║
╚══════════════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host ""

# Check if Claude Code is available for pre-flight
function Test-ClaudeForPreFlight {
    try {
        $claudeTest = & claude --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
    }
    catch {
        return $false
    }
    return $false
}

# Generate pre-flight analysis commands
function Get-PreFlightCommands {
    return @"
# System specifications
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, BiosFirmwareType, TotalPhysicalMemory, CsProcessors

# CPU and architecture  
Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, Architecture, MaxClockSpeed

# Memory configuration
Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | ForEach-Object { "Total RAM: " + [math]::Round(`$_.Sum / 1GB, 2) + " GB" }

# Disk configuration and free space
Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { `$_.DriveType -eq 3 } | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round(`$_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round(`$_.FreeSpace/1GB,2)}}, @{Name="UsedPercent";Expression={[math]::Round(((`$_.Size-`$_.FreeSpace)/`$_.Size)*100,1)}}, FileSystem

# GPU information
Get-CimInstance -ClassName Win32_VideoController | Where-Object { `$_.Name -notlike "*Basic*" } | Select-Object Name, DriverVersion, @{Name="VRAM(MB)";Expression={if(`$_.AdapterRAM){[math]::Round(`$_.AdapterRAM/1MB,0)}else{"Unknown"}}}

# Boot configuration
`$secureBootEnabled = try { (Get-SecureBootUEFI -Name SetupMode -ErrorAction SilentlyContinue).Bytes[0] -eq 0 } catch { "Unknown" }
"UEFI: " + (Get-ComputerInfo).BiosFirmwareType
"Secure Boot: " + `$secureBootEnabled  
"TPM Available: " + ((Get-CimInstance -Namespace 'Root\CIMv2\Security\MicrosoftTpm' -ClassName Win32_Tpm -ErrorAction SilentlyContinue) -ne `$null)

# USB drives available
Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { `$_.DriveType -eq 2 } | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round(`$_.Size/1GB,2)}}, VolumeName, @{Name="FreeSpace(GB)";Expression={[math]::Round(`$_.FreeSpace/1GB,2)}}

# Network connectivity
Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet

# PowerShell execution policy
Get-ExecutionPolicy

# Check for existing Ubuntu ISOs
Get-ChildItem -Path "`$env:USERPROFILE\Downloads\ubuntu*.iso", "`$env:USERPROFILE\Desktop\ubuntu*.iso" -ErrorAction SilentlyContinue | Select-Object Name, @{Name="Size(GB)";Expression={[math]::Round(`$_.Length/1GB,2)}}, LastWriteTime

# Check dependencies
try { & claude --version } catch { "Claude Code not installed" }
try { & git --version } catch { "Git not installed" }  
try { & node --version } catch { "Node.js not installed" }

# Administrator check
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
"@
}

# Run automated pre-flight analysis
function Start-AutomatedPreFlight {
    Write-Host "🔍 Running automated pre-flight system analysis..." -ForegroundColor Yellow
    
    # Create temp file for commands
    $commandFile = "$env:TEMP\bill-sloth-preflight-commands.ps1"
    $outputFile = "$env:TEMP\bill-sloth-preflight-output.txt"
    
    try {
        # Write commands to file
        Get-PreFlightCommands | Out-File -FilePath $commandFile -Encoding UTF8
        
        # Execute commands and capture output
        Write-Host "📊 Gathering system information..." -ForegroundColor Cyan
        $output = & powershell -ExecutionPolicy Bypass -File $commandFile 2>&1 | Out-String
        $output | Out-File -FilePath $outputFile -Encoding UTF8
        
        # Basic analysis without Claude
        $analysis = Analyze-SystemOutput $output
        
        Write-Host "✅ Pre-flight analysis complete" -ForegroundColor Green
        return $analysis
    }
    catch {
        Write-Host "❌ Pre-flight analysis failed: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
    finally {
        # Cleanup
        if (Test-Path $commandFile) { Remove-Item $commandFile -Force }
        if (Test-Path $outputFile) { Remove-Item $outputFile -Force }
    }
}

# Basic system analysis without Claude
function Analyze-SystemOutput {
    param([string]$Output)
    
    Write-Host "🤖 Analyzing system configuration..." -ForegroundColor Cyan
    
    # Extract key information from output
    $ramMatch = $Output | Select-String "Total RAM: ([\d.]+) GB"
    $ramGB = if ($ramMatch) { [float]$ramMatch.Matches[0].Groups[1].Value } else { 0 }
    
    $freeSpaceMatch = $Output | Select-String "C:\s+[\d.]+\s+([\d.]+)"
    $freeSpaceGB = if ($freeSpaceMatch) { [float]$freeSpaceMatch.Matches[0].Groups[1].Value } else { 0 }
    
    $isUEFI = $Output -match "UEFI: Uefi"
    $hasUSB = $Output -match "DeviceID.*Size\(GB\).*[89]\d+"  # 8GB+ USB
    $hasUbuntuISO = $Output -match "ubuntu.*\.iso"
    $hasGit = $Output -match "git version"
    $hasNode = $Output -match "v\d+\.\d+\.\d+"
    $hasClaude = $Output -match "claude.*\d+\.\d+\.\d+"
    
    # Determine system complexity and compatibility
    $complexity = "simple"
    $compatibility = "excellent"
    $skipClaude = $false
    $estimatedTime = "30-60min"
    $estimatedTokens = 0
    
    if ($ramGB -lt 8 -or $freeSpaceGB -lt 120) {
        $complexity = "moderate"
        $compatibility = "fair"
        $estimatedTime = "1-2hrs"
        $estimatedTokens = 50
    }
    
    if ($ramGB -lt 4 -or $freeSpaceGB -lt 80) {
        $complexity = "complex"
        $compatibility = "poor"
        $estimatedTime = "2-4hrs"
        $estimatedTokens = 100
    }
    
    # Simple systems with good resources can skip Claude
    if ($ramGB -ge 8 -and $freeSpaceGB -ge 150 -and $isUEFI -and ($hasGit -and $hasNode)) {
        $skipClaude = $true
        $estimatedTokens = 0
    }
    
    $criticalActions = @()
    if (-not $hasGit) { $criticalActions += "install_git" }
    if (-not $hasNode) { $criticalActions += "install_nodejs" }
    if (-not $hasClaude) { $criticalActions += "install_claude_code" }
    if (-not $hasUSB) { $criticalActions += "insert_usb_drive" }
    if ($freeSpaceGB -lt 120) { $criticalActions += "free_disk_space" }
    
    $hardwareConsiderations = @()
    if ($isUEFI) { $hardwareConsiderations += "uefi_boot_available" }
    if ($ramGB -ge 8) { $hardwareConsiderations += "sufficient_ram" }
    if ($Output -match "NVIDIA") { $hardwareConsiderations += "nvidia_gpu_detected" }
    
    # Generate optimized command
    $recommendedCommand = if ($skipClaude) {
        ".\fine-tuned-dual-boot-wizard.ps1 -SkipClaude"
    } elseif ($complexity -eq "simple") {
        ".\fine-tuned-dual-boot-wizard.ps1 -ClaudeLevel minimal -ConserveTokens"
    } else {
        ".\fine-tuned-dual-boot-wizard.ps1 -ClaudeLevel standard -ConserveTokens"
    }
    
    return @{
        system_profile = @{
            complexity = $complexity
            ubuntu_compatibility = $compatibility
            dual_boot_feasibility = if ($compatibility -eq "excellent") { "high" } elseif ($compatibility -eq "good") { "medium" } else { "low" }
            estimated_setup_time = $estimatedTime
        }
        optimization_recommendations = @{
            claude_assistance_level = if ($skipClaude) { "none" } elseif ($complexity -eq "simple") { "minimal" } else { "standard" }
            skip_claude_recommended = $skipClaude
            wizard_mode = if ($complexity -eq "simple") { "express" } elseif ($complexity -eq "moderate") { "guided" } else { "comprehensive" }
        }
        resource_status = @{
            disk_space_adequate = ($freeSpaceGB -ge 120)
            usb_drive_available = $hasUSB
            ubuntu_iso_found = $hasUbuntuISO
            dependencies_installed = @($hasGit, $hasNode, $hasClaude) | Where-Object { $_ }
        }
        critical_actions_needed = $criticalActions
        hardware_considerations = $hardwareConsiderations
        wizard_parameters = @{
            recommended_command = $recommendedCommand
            ubuntu_partition_size = if ($freeSpaceGB -gt 200) { 120 } else { 100 }
            estimated_token_usage = $estimatedTokens
        }
    }
}

# Show pre-flight results and get user confirmation
function Show-PreFlightResults {
    param([hashtable]$Analysis)
    
    Write-Host ""
    Write-Host "📊 PRE-FLIGHT ANALYSIS RESULTS:" -ForegroundColor Cyan
    Write-Host ""
    
    # System profile
    Write-Host "🖥️  SYSTEM PROFILE:" -ForegroundColor Yellow
    Write-Host "   Complexity: $($Analysis.system_profile.complexity)" -ForegroundColor White
    Write-Host "   Ubuntu Compatibility: $($Analysis.system_profile.ubuntu_compatibility)" -ForegroundColor $(switch ($Analysis.system_profile.ubuntu_compatibility) {
        "excellent" { "Green" } "good" { "Green" } "fair" { "Yellow" } default { "Red" }
    })
    Write-Host "   Estimated Setup Time: $($Analysis.system_profile.estimated_setup_time)" -ForegroundColor White
    
    # Critical actions
    if ($Analysis.critical_actions_needed.Count -gt 0) {
        Write-Host ""
        Write-Host "⚠️  ACTIONS NEEDED BEFORE SETUP:" -ForegroundColor Red
        foreach ($action in $Analysis.critical_actions_needed) {
            $actionText = switch ($action) {
                "install_git" { "Install Git from git-scm.com" }
                "install_nodejs" { "Install Node.js from nodejs.org" }
                "install_claude_code" { "Install Claude Code: npm install -g @anthropic-ai/claude-code" }
                "insert_usb_drive" { "Insert USB drive (8GB+ required)" }
                "free_disk_space" { "Free up disk space (120GB+ recommended)" }
                default { $action }
            }
            Write-Host "   • $actionText" -ForegroundColor Yellow
        }
    }
    
    # Optimization recommendations
    Write-Host ""
    Write-Host "🎯 OPTIMIZATION RECOMMENDATIONS:" -ForegroundColor Green
    Write-Host "   Wizard Mode: $($Analysis.optimization_recommendations.wizard_mode)" -ForegroundColor White
    if ($Analysis.optimization_recommendations.skip_claude_recommended) {
        Write-Host "   Claude Integration: ⚡ Skip (system is straightforward)" -ForegroundColor Green
        Write-Host "   Estimated Tokens Saved: $($Analysis.wizard_parameters.estimated_token_usage)" -ForegroundColor Green
    } else {
        Write-Host "   Claude Level: $($Analysis.optimization_recommendations.claude_assistance_level)" -ForegroundColor White
        Write-Host "   Estimated Token Usage: $($Analysis.wizard_parameters.estimated_token_usage)" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "🚀 RECOMMENDED COMMAND:" -ForegroundColor Magenta
    Write-Host "   $($Analysis.wizard_parameters.recommended_command)" -ForegroundColor White
    Write-Host ""
    
    return $Analysis.critical_actions_needed.Count -eq 0
}

# Main launcher logic
function Start-OptimizedSetup {
    # Skip pre-flight if requested
    if ($SkipPreFlight) {
        Write-Host "⚡ Skipping pre-flight analysis, launching standard wizard..." -ForegroundColor Yellow
        & "$PSScriptRoot\fine-tuned-dual-boot-wizard.ps1"
        return
    }
    
    # Load existing pre-flight data if provided
    if ($PreFlightFile -and (Test-Path $PreFlightFile)) {
        Write-Host "📋 Loading existing pre-flight analysis..." -ForegroundColor Green
        try {
            $preFlightData = Get-Content -Path $PreFlightFile -Raw | ConvertFrom-Json
            $canProceed = Show-PreFlightResults $preFlightData
            
            if ($canProceed) {
                Write-Host "🚀 Launching optimized wizard with pre-flight data..." -ForegroundColor Green
                & "$PSScriptRoot\fine-tuned-dual-boot-wizard.ps1" -PreFlightData $PreFlightFile
            } else {
                Write-Host "❌ Please address the required actions before proceeding" -ForegroundColor Red
            }
            return
        }
        catch {
            Write-Host "❌ Invalid pre-flight file format: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Proceeding with automated analysis..." -ForegroundColor Yellow
        }
    }
    
    # Manual pre-flight (show user the prompt to run in Claude)
    if ($ManualPreFlight) {
        Write-Host "📋 Manual pre-flight analysis mode" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Please run the pre-flight check prompt in your Claude Code instance:" -ForegroundColor Cyan
        Write-Host "   File: pre-flight-system-check.md" -ForegroundColor White
        Write-Host ""
        Write-Host "After getting the JSON response, save it to a file and run:" -ForegroundColor Yellow
        Write-Host "   .\optimized-setup-launcher.ps1 -PreFlightFile path\to\analysis.json" -ForegroundColor White
        return
    }
    
    # Automated pre-flight analysis
    Write-Host "🎯 Starting automated pre-flight optimization..." -ForegroundColor Green
    
    $analysis = Start-AutomatedPreFlight
    if (-not $analysis) {
        Write-Host "❌ Pre-flight analysis failed, launching standard wizard..." -ForegroundColor Red
        & "$PSScriptRoot\fine-tuned-dual-boot-wizard.ps1"
        return
    }
    
    # Show results and get confirmation
    $canProceed = Show-PreFlightResults $analysis
    
    if (-not $canProceed) {
        Write-Host "⚠️  Critical actions required before setup can continue" -ForegroundColor Yellow
        Write-Host "Please address the items above, then run this launcher again" -ForegroundColor White
        return
    }
    
    # Save analysis for reference
    $analysisFile = "$env:TEMP\bill-sloth-preflight-analysis.json"
    $analysis | ConvertTo-Json -Depth 5 | Out-File -FilePath $analysisFile -Encoding UTF8
    
    Write-Host "💾 Pre-flight analysis saved to: $analysisFile" -ForegroundColor Green
    Write-Host ""
    
    # Launch optimized wizard
    Write-Host "🚀 Launching optimized dual-boot wizard..." -ForegroundColor Green
    Write-Host ""
    
    & "$PSScriptRoot\fine-tuned-dual-boot-wizard.ps1" -PreFlightData $analysisFile
}

# Execute the optimized setup
Start-OptimizedSetup