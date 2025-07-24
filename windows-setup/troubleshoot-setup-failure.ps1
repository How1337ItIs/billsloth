# Bill Sloth Setup Failure Troubleshooter
# Automated diagnosis and recovery for dual-boot setup issues

param(
    [switch]$AutoFix,
    [switch]$SendToClaude,
    [string]$LogFile = "",
    [ValidateSet("usb", "iso", "disk", "claude", "general")]
    [string]$IssueType = "general"
)

#Requires -RunAsAdministrator

Write-Host @"
╔══════════════════════════════════════════════════════════════════════════════╗
║  🔧 BILL SLOTH SETUP TROUBLESHOOTER 🔧                                      ║
║                                                                              ║
║  Automated diagnosis and recovery for setup failures                        ║
╚══════════════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Red

Write-Host ""
Write-Host "🔍 Analyzing setup failure..." -ForegroundColor Yellow
Write-Host ""

# Common issue patterns and solutions
$script:KnownIssues = @{
    "execution_policy" = @{
        pattern = "execution.*policy"
        description = "PowerShell execution policy blocking scripts"
        solution = "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
        auto_fixable = $true
    }
    "claude_not_found" = @{
        pattern = "claude.*not.*found|command.*not.*found.*claude"
        description = "Claude Code not installed or not in PATH"
        solution = "npm install -g @anthropic-ai/claude-code"
        auto_fixable = $false
    }
    "admin_required" = @{
        pattern = "administrator|elevated|access.*denied"
        description = "Script requires administrator privileges"
        solution = "Right-click PowerShell and select 'Run as Administrator'"
        auto_fixable = $false
    }
    "disk_space" = @{
        pattern = "insufficient.*space|not.*enough.*space|disk.*full"
        description = "Insufficient disk space for Ubuntu installation"
        solution = "Free up disk space or use external USB drive"
        auto_fixable = $false
    }
    "usb_not_found" = @{
        pattern = "usb.*not.*found|drive.*not.*found"
        description = "USB drive not detected or inaccessible"
        solution = "Check USB drive connection and format"
        auto_fixable = $false
    }
    "iso_download_failed" = @{
        pattern = "download.*failed|network.*error|connection.*timeout"
        description = "Ubuntu ISO download failed"
        solution = "Check internet connection or manually download Ubuntu ISO"
        auto_fixable = $false
    }
    "rufus_failed" = @{
        pattern = "rufus.*failed|usb.*creation.*failed"
        description = "USB creation with Rufus failed"
        solution = "Try different USB drive or manual Rufus configuration"
        auto_fixable = $false
    }
}

# Analyze error logs
function Get-ErrorAnalysis {
    param([string]$LogPath = "")
    
    Write-Host "🔍 Analyzing error logs..." -ForegroundColor Yellow
    
    $logContent = ""
    $logFiles = @()
    
    # Find relevant log files
    if ($LogPath -and (Test-Path $LogPath)) {
        $logFiles += $LogPath
    }
    
    # Check standard log locations
    $standardLogs = @(
        "$env:USERPROFILE\bill-sloth-windows\claude-assisted-setup.log",
        "$env:USERPROFILE\bill-sloth-windows\*.log",
        "$env:TEMP\bill-sloth-*.log"
    )
    
    foreach ($pattern in $standardLogs) {
        $found = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
        $logFiles += $found.FullName
    }
    
    # Read log contents
    foreach ($file in $logFiles) {
        if (Test-Path $file) {
            Write-Host "📄 Reading log: $file" -ForegroundColor Cyan
            $content = Get-Content -Path $file -Raw
            $logContent += $content + "`n"
        }
    }
    
    if (-not $logContent) {
        Write-Host "⚠️  No log files found - using PowerShell error information" -ForegroundColor Yellow
        $logContent = $Error | Out-String
    }
    
    # Analyze for known issues
    $detectedIssues = @()
    foreach ($issueKey in $script:KnownIssues.Keys) {
        $issue = $script:KnownIssues[$issueKey]
        if ($logContent -match $issue.pattern) {
            $detectedIssues += @{
                type = $issueKey
                description = $issue.description
                solution = $issue.solution
                auto_fixable = $issue.auto_fixable
            }
        }
    }
    
    return @{
        log_content = $logContent
        detected_issues = $detectedIssues
        log_files = $logFiles
    }
}

# System health check
function Test-SystemHealth {
    Write-Host "🏥 Running system health check..." -ForegroundColor Yellow
    
    $health = @{
        overall = "healthy"
        issues = @()
        recommendations = @()
    }
    
    # Check PowerShell execution policy
    $policy = Get-ExecutionPolicy
    if ($policy -eq "Restricted") {
        $health.issues += "PowerShell execution policy is Restricted"
        $health.recommendations += "Run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
        $health.overall = "issues_found"
    }
    
    # Check administrator privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        $health.issues += "Not running as Administrator"
        $health.recommendations += "Right-click PowerShell and select 'Run as Administrator'"
        $health.overall = "issues_found"
    }
    
    # Check internet connectivity
    $internetOk = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet
    if (-not $internetOk) {
        $health.issues += "No internet connectivity"
        $health.recommendations += "Check network connection for ISO downloads"
        $health.overall = "issues_found"
    }
    
    # Check disk space
    $systemDrive = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $env:SystemDrive }
    $freeSpaceGB = [math]::Round($systemDrive.FreeSpace / 1GB, 2)
    if ($freeSpaceGB -lt 120) {
        $health.issues += "Low disk space: $freeSpaceGB GB free (120GB+ recommended)"
        $health.recommendations += "Free up disk space or use external storage"
        if ($freeSpaceGB -lt 80) {
            $health.overall = "critical"
        } else {
            $health.overall = "issues_found"
        }
    }
    
    # Check for USB drives
    $usbDrives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 -and $_.Size -gt 8GB }
    if ($usbDrives.Count -eq 0) {
        $health.issues += "No suitable USB drives found (8GB+ required)"
        $health.recommendations += "Insert a USB drive 8GB or larger"
        $health.overall = "issues_found"
    }
    
    # Check Claude Code availability
    try {
        $claudeTest = & claude --version 2>&1
        if ($LASTEXITCODE -ne 0) {
            $health.issues += "Claude Code not installed or not in PATH"
            $health.recommendations += "Install: npm install -g @anthropic-ai/claude-code"
            $health.overall = "issues_found"
        }
    }
    catch {
        $health.issues += "Claude Code not available"
        $health.recommendations += "Install: npm install -g @anthropic-ai/claude-code"
        $health.overall = "issues_found"
    }
    
    return $health
}

# Auto-fix common issues
function Repair-CommonIssues {
    param([array]$DetectedIssues)
    
    Write-Host "🔧 Attempting automatic repairs..." -ForegroundColor Yellow
    
    $fixedCount = 0
    $totalIssues = $DetectedIssues.Count
    
    foreach ($issue in $DetectedIssues) {
        if ($issue.auto_fixable) {
            Write-Host "🔄 Fixing: $($issue.description)" -ForegroundColor Cyan
            
            try {
                switch ($issue.type) {
                    "execution_policy" {
                        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
                        Write-Host "✅ PowerShell execution policy updated" -ForegroundColor Green
                        $fixedCount++
                    }
                    default {
                        Write-Host "⚠️  Auto-fix not implemented for: $($issue.type)" -ForegroundColor Yellow
                    }
                }
            }
            catch {
                Write-Host "❌ Failed to fix $($issue.type): $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            Write-Host "📋 Manual fix required for: $($issue.description)" -ForegroundColor Yellow
            Write-Host "   Solution: $($issue.solution)" -ForegroundColor White
        }
    }
    
    Write-Host ""
    Write-Host "🔧 Auto-repair complete: $fixedCount/$totalIssues issues fixed" -ForegroundColor Green
    
    return $fixedCount -eq $totalIssues
}

# Generate Claude troubleshooting request
function New-ClaudeTroubleshootingRequest {
    param([hashtable]$Analysis, [hashtable]$SystemHealth)
    
    if (-not $SendToClaude) {
        return $null
    }
    
    Write-Host "🤖 Preparing Claude troubleshooting request..." -ForegroundColor Magenta
    
    # Create concise troubleshooting context
    $context = @{
        timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        issue_type = $IssueType
        detected_issues = $Analysis.detected_issues | ForEach-Object { $_.description }
        system_health = $SystemHealth.overall
        log_summary = $Analysis.log_content.Split("`n") | Where-Object { $_ -match "error|failed|exception" } | Select-Object -First 10
    }
    
    $prompt = @"
Bill Sloth dual-boot setup troubleshooting assistance needed:

ISSUE TYPE: $IssueType
SYSTEM HEALTH: $($SystemHealth.overall)

DETECTED ISSUES:
$($Analysis.detected_issues | ForEach-Object { "- $($_.description)" } | Out-String)

RECENT ERRORS:
$($context.log_summary | Out-String)

Please provide:
1. Root cause analysis
2. Step-by-step resolution
3. Prevention recommendations

Keep response concise for token efficiency.
"@
    
    Write-Host "📋 Claude request prepared (estimated tokens: $([math]::Ceiling($prompt.Length / 4)))" -ForegroundColor Cyan
    
    try {
        $response = & claude --max-tokens 200 --prompt $prompt 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "🤖 CLAUDE ASSISTANCE:" -ForegroundColor Magenta
            Write-Host $response -ForegroundColor White
            Write-Host ""
            return $response
        }
    }
    catch {
        Write-Host "❌ Failed to get Claude assistance: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    return $null
}

# Show recovery recommendations
function Show-RecoveryOptions {
    param([hashtable]$Analysis, [hashtable]$SystemHealth)
    
    Write-Host ""
    Write-Host "💡 RECOVERY OPTIONS:" -ForegroundColor Green
    Write-Host ""
    
    # Specific recovery based on issue type
    switch ($IssueType) {
        "usb" {
            Write-Host "🔧 USB DRIVE ISSUES:" -ForegroundColor Yellow
            Write-Host "   1. Try a different USB drive (8GB+ required)" -ForegroundColor White
            Write-Host "   2. Format USB drive as FAT32" -ForegroundColor White
            Write-Host "   3. Run: .\simple-usb-creator.ps1" -ForegroundColor White
            Write-Host "   4. Use Rufus manually with Ubuntu ISO" -ForegroundColor White
        }
        "iso" {
            Write-Host "🔧 ISO DOWNLOAD ISSUES:" -ForegroundColor Yellow
            Write-Host "   1. Check internet connection" -ForegroundColor White
            Write-Host "   2. Download Ubuntu ISO manually from ubuntu.com" -ForegroundColor White
            Write-Host "   3. Use existing ISO with -ISOPath parameter" -ForegroundColor White
            Write-Host "   4. Try different Ubuntu version (20.04 LTS)" -ForegroundColor White
        }
        "disk" {
            Write-Host "🔧 DISK SPACE ISSUES:" -ForegroundColor Yellow
            Write-Host "   1. Run Disk Cleanup (cleanmgr.exe)" -ForegroundColor White
            Write-Host "   2. Uninstall unused programs" -ForegroundColor White
            Write-Host "   3. Move files to external storage" -ForegroundColor White
            Write-Host "   4. Use smaller Ubuntu partition size" -ForegroundColor White
        }
        "claude" {
            Write-Host "🔧 CLAUDE CODE ISSUES:" -ForegroundColor Yellow
            Write-Host "   1. Install: npm install -g @anthropic-ai/claude-code" -ForegroundColor White
            Write-Host "   2. Restart PowerShell after installation" -ForegroundColor White
            Write-Host "   3. Run with -SkipClaude parameter" -ForegroundColor White
            Write-Host "   4. Check npm and Node.js installation" -ForegroundColor White
        }
        default {
            Write-Host "🔧 GENERAL RECOVERY STEPS:" -ForegroundColor Yellow
            Write-Host "   1. Restart PowerShell as Administrator" -ForegroundColor White
            Write-Host "   2. Run: .\fine-tuned-dual-boot-wizard.ps1 -SkipClaude" -ForegroundColor White
            Write-Host "   3. Check TROUBLESHOOTING.md for specific issues" -ForegroundColor White
            Write-Host "   4. Use .\bill-sloth-complete-system-creator.ps1 alternative" -ForegroundColor White
        }
    }
    
    Write-Host ""
    Write-Host "📚 DOCUMENTATION:" -ForegroundColor Cyan
    Write-Host "   • Comprehensive guide: COMPLETE_SETUP_FROM_ZERO.md" -ForegroundColor White
    Write-Host "   • Known issues: TROUBLESHOOTING.md" -ForegroundColor White
    Write-Host "   • Encoding problems: ENCODING-ISSUES.md" -ForegroundColor White
    Write-Host ""
    
    # Emergency fallback options
    Write-Host "🆘 EMERGENCY FALLBACKS:" -ForegroundColor Red
    Write-Host "   1. Use simple-usb-creator.ps1 for basic USB creation" -ForegroundColor White
    Write-Host "   2. Manual Ubuntu installation without automation" -ForegroundColor White
    Write-Host "   3. WSL2 installation as temporary alternative" -ForegroundColor White
    Write-Host "   4. Contact support with error logs" -ForegroundColor White
    Write-Host ""
}

# Main troubleshooting execution
function Start-Troubleshooting {
    Write-Host "🔍 Starting comprehensive troubleshooting..." -ForegroundColor Green
    Write-Host ""
    
    # Phase 1: Error Analysis
    Write-Host "═══ PHASE 1: ERROR ANALYSIS ═══" -ForegroundColor Cyan
    $analysis = Get-ErrorAnalysis $LogFile
    
    if ($analysis.detected_issues.Count -gt 0) {
        Write-Host "❌ Issues detected:" -ForegroundColor Red
        foreach ($issue in $analysis.detected_issues) {
            Write-Host "   • $($issue.description)" -ForegroundColor White
        }
    } else {
        Write-Host "ℹ️  No specific error patterns detected" -ForegroundColor Yellow
    }
    
    # Phase 2: System Health Check
    Write-Host ""
    Write-Host "═══ PHASE 2: SYSTEM HEALTH CHECK ═══" -ForegroundColor Cyan
    $health = Test-SystemHealth
    
    Write-Host "🏥 System health: $($health.overall)" -ForegroundColor $(switch ($health.overall) {
        "healthy" { "Green" }
        "issues_found" { "Yellow" }
        "critical" { "Red" }
        default { "White" }
    })
    
    if ($health.issues.Count -gt 0) {
        foreach ($issue in $health.issues) {
            Write-Host "   ⚠️  $issue" -ForegroundColor Yellow
        }
    }
    
    # Phase 3: Auto-Repair (if requested)
    if ($AutoFix -and ($analysis.detected_issues.Count -gt 0 -or $health.issues.Count -gt 0)) {
        Write-Host ""
        Write-Host "═══ PHASE 3: AUTO-REPAIR ═══" -ForegroundColor Cyan
        $allIssues = $analysis.detected_issues + $health.issues
        $repairSuccess = Repair-CommonIssues $analysis.detected_issues
        
        if ($repairSuccess) {
            Write-Host "✅ All auto-fixable issues resolved!" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Some issues require manual intervention" -ForegroundColor Yellow
        }
    }
    
    # Phase 4: Claude Assistance (if requested)
    if ($SendToClaude) {
        Write-Host ""
        Write-Host "═══ PHASE 4: AI ASSISTANCE ═══" -ForegroundColor Cyan
        $claudeResponse = New-ClaudeTroubleshootingRequest $analysis $health
    }
    
    # Phase 5: Recovery Recommendations
    Write-Host ""
    Write-Host "═══ PHASE 5: RECOVERY RECOMMENDATIONS ═══" -ForegroundColor Cyan
    Show-RecoveryOptions $analysis $health
    
    return @{
        analysis = $analysis
        health = $health
        recovery_needed = ($analysis.detected_issues.Count -gt 0 -or $health.overall -ne "healthy")
    }
}

# Execute troubleshooting
$result = Start-Troubleshooting

if ($result.recovery_needed) {
    Write-Host "🔧 Manual intervention required - see recovery options above" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ System appears healthy - setup should work normally" -ForegroundColor Green
    exit 0
}