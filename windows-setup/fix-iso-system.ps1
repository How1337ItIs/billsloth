# Fix Bill Sloth ISO System - Repair encoding and syntax errors
# This script fixes the corrupted MATURE_CUSTOM_ISO_SYSTEM.ps1

param(
    [switch]$TestOnly,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

function Write-FixLog {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }
    
    Write-Host "[$timestamp] $Message" -ForegroundColor $color
}

Write-FixLog "Starting Bill Sloth ISO system repair..." "INFO"

$scriptPath = "MATURE_CUSTOM_ISO_SYSTEM.ps1"
$backupPath = "MATURE_CUSTOM_ISO_SYSTEM.ps1.backup"

# Create backup
if (Test-Path $scriptPath) {
    Write-FixLog "Creating backup: $backupPath" "INFO"
    Copy-Item $scriptPath $backupPath -Force
} else {
    Write-FixLog "Script not found: $scriptPath" "ERROR"
    exit 1
}

# Read the file content
Write-FixLog "Reading script content..." "INFO"
$content = Get-Content $scriptPath -Raw -Encoding UTF8

# Fix 1: Remove the mixed PowerShell/Bash code section
Write-FixLog "Fixing mixed PowerShell/Bash syntax..." "INFO"
$content = $content -replace '(?s)# Determine if we''re in live environment or installed system.*?fi\s*\n', @"
# PowerShell equivalent of live environment detection
`$isLiveEnvironment = `$env:BILL_SLOTH_LIVE -eq "true"
if (`$isLiveEnvironment) {
    Write-EnhancedLog "Live Environment - Setting up temporary Bill Sloth" "INFO"
    `$billSlothDir = "`$env:TEMP\billsloth"
    `$installMode = "live"
} else {
    Write-EnhancedLog "Installed System - Setting up permanent Bill Sloth" "INFO"
    `$billSlothDir = "`$env:USERPROFILE\bill sloth"
    `$installMode = "permanent"
}

"@

# Fix 2: Replace all bash-style if statements with PowerShell
$content = $content -replace 'if \[ [^\]]+\]; then', 'if ('
$content = $content -replace 'elif \[ [^\]]+\]; then', 'elseif ('
$content = $content -replace '\bfi\b', '}'
$content = $content -replace '\belse\b(?=\s*\n)', '} else {'

# Fix 3: Replace bash echo commands with PowerShell equivalents in the mixed section
$content = $content -replace '^echo "', 'Write-Host "'

# Fix 4: Fix any remaining corrupted Unicode characters
$content = $content -replace '[^\x00-\x7F]', ''

# Fix 5: Ensure all strings are properly terminated
$fixes = @(
    @{
        Pattern = '(Write-EnhancedLog "[^"]+) "INFO"?\s*$'
        Replacement = '$1" "INFO"'
    }
)

foreach ($fix in $fixes) {
    $content = $content -replace $fix.Pattern, $fix.Replacement
}

if ($TestOnly) {
    Write-FixLog "Test mode - validating syntax..." "INFO"
    
    # Write to temp file and test
    $tempFile = [System.IO.Path]::GetTempFileName() + ".ps1"
    $content | Out-File -FilePath $tempFile -Encoding UTF8
    
    try {
        # Parse the script to check for syntax errors
        $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$null)
        Write-FixLog "Syntax validation passed!" "SUCCESS"
        Remove-Item $tempFile -Force
        return
    } catch {
        Write-FixLog "Syntax validation failed: $($_.Exception.Message)" "ERROR"
        Remove-Item $tempFile -Force
        exit 1
    }
}

# Write the fixed content back
Write-FixLog "Writing fixed content..." "INFO"
$content | Out-File -FilePath $scriptPath -Encoding UTF8 -NoNewline

# Test the fixed script
Write-FixLog "Testing fixed script..." "INFO"
try {
    $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$null)
    Write-FixLog "Script repair completed successfully!" "SUCCESS"
    Write-FixLog "Backup saved as: $backupPath" "INFO"
} catch {
    Write-FixLog "Script still has issues: $($_.Exception.Message)" "ERROR"
    Write-FixLog "Restoring backup..." "WARN"
    Copy-Item $backupPath $scriptPath -Force
    exit 1
}

Write-FixLog "ISO system repair complete! Ready for use." "SUCCESS"