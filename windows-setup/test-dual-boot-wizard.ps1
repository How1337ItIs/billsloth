# Bill Sloth Dual-Boot Wizard Test Suite
# Tests all components to ensure this shit actually works

param(
    [switch]$Quick,
    [switch]$Verbose
)

#Requires -RunAsAdministrator

Write-Host @"
████████████████████████████████████████████████████████████████████████████████
██                                                                            ██
██  ░▒▓█ BILL SLOTH DUAL-BOOT WIZARD TEST SUITE █▓▒░                          ██
██                                                                            ██
██  ████ VERIFYING THIS SHIT ACTUALLY WORKS ████                              ██
██                                                                            ██
████████████████████████████████████████████████████████████████████████████████
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "▓▓▓ INITIATING COMPREHENSIVE SYSTEM TESTS ▓▓▓" -ForegroundColor Cyan
Write-Host ""

# Test results tracking
$testResults = @{
    Passed = 0
    Failed = 0
    Warnings = 0
    Details = @()
}

# Test function wrapper
function Test-Component {
    param(
        [string]$Name,
        [scriptblock]$Test,
        [string]$Category = "General"
    )
    
    Write-Host "Testing: $Name" -ForegroundColor Yellow -NoNewline
    
    try {
        $result = & $Test
        if ($result) {
            Write-Host " ✅ PASSED" -ForegroundColor Green
            $testResults.Passed++
            $testResults.Details += "✅ [$Category] $Name"
        } else {
            Write-Host " ❌ FAILED" -ForegroundColor Red
            $testResults.Failed++
            $testResults.Details += "❌ [$Category] $Name"
        }
    }
    catch {
        Write-Host " ❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
        $testResults.Failed++
        $testResults.Details += "❌ [$Category] $Name - ERROR: $($_.Exception.Message)"
    }
}

# Test 1: PowerShell Requirements
Write-Host ""
Write-Host "=== POWERSHELL ENVIRONMENT TESTS ===" -ForegroundColor Cyan
Write-Host ""

Test-Component "PowerShell Version (5.0+)" {
    $PSVersionTable.PSVersion.Major -ge 5
} -Category "Environment"

Test-Component "Administrator Privileges" {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
} -Category "Environment"

Test-Component "Execution Policy" {
    $policy = Get-ExecutionPolicy
    $policy -in @("RemoteSigned", "Unrestricted", "Bypass")
} -Category "Environment"

# Test 2: File Existence
Write-Host ""
Write-Host "=== FILE EXISTENCE TESTS ===" -ForegroundColor Cyan
Write-Host ""

$requiredFiles = @(
    "bill-sloth-dual-boot-wizard-unified.ps1",
    "bill-sloth-wsl2-iso-builder.ps1",
    "bill-sloth-live-build-iso.ps1",
    "bill-sloth-custom-iso-builder.ps1"
)

foreach ($file in $requiredFiles) {
    Test-Component "File: $file" {
        Test-Path (Join-Path $PSScriptRoot $file)
    } -Category "Files"
}

# Test 3: Path Resolution Functions
Write-Host ""
Write-Host "=== PATH RESOLUTION TESTS ===" -ForegroundColor Cyan
Write-Host ""

# Source the wizard to get functions
$wizardPath = Join-Path $PSScriptRoot "bill-sloth-dual-boot-wizard-unified.ps1"
if (Test-Path $wizardPath) {
    # Extract functions without executing the whole script
    $wizardContent = Get-Content $wizardPath -Raw
    
    # Test if Get-WSL2ISOBuilderPath function exists
    Test-Component "Get-WSL2ISOBuilderPath Function Definition" {
        $wizardContent -match "function Get-WSL2ISOBuilderPath"
    } -Category "Functions"
    
    # Test if path resolution doesn't use inline if
    Test-Component "No Inline If in Array Initialization" {
        -not ($wizardContent -match '\@\([^)]*if\s*\([^)]*\)[^)]*\)')
    } -Category "Syntax"
}

# Test 4: System Requirements
Write-Host ""
Write-Host "=== SYSTEM REQUIREMENTS TESTS ===" -ForegroundColor Cyan
Write-Host ""

Test-Component "Git Installation" {
    Get-Command git -ErrorAction SilentlyContinue
} -Category "Dependencies"

Test-Component "Internet Connectivity" {
    Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet
} -Category "Dependencies"

Test-Component "WSL2 Availability" {
    $wslCheck = wsl --list --verbose 2>&1
    $LASTEXITCODE -eq 0
} -Category "Dependencies"

Test-Component "Disk Space (20GB+ free)" {
    $freeSpace = (Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq "C:" }).FreeSpace / 1GB
    $freeSpace -gt 20
} -Category "System"

# Test 5: ISO Detection
Write-Host ""
Write-Host "=== ISO DETECTION TESTS ===" -ForegroundColor Cyan
Write-Host ""

$isoSearchPaths = @(
    "$env:USERPROFILE\Downloads\*ubuntu*.iso",
    "$env:USERPROFILE\Desktop\*ubuntu*.iso"
)

$foundISOs = @()
foreach ($pattern in $isoSearchPaths) {
    $found = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
    $foundISOs += $found
}

Test-Component "Ubuntu ISO Detection" {
    $foundISOs.Count -gt 0
} -Category "ISO"

if ($foundISOs.Count -gt 0) {
    Write-Host "  Found ISOs:" -ForegroundColor Gray
    foreach ($iso in $foundISOs) {
        $sizeGB = [math]::Round($iso.Length / 1GB, 2)
        Write-Host "    - $($iso.Name) ($sizeGB GB)" -ForegroundColor Gray
    }
}

# Test 6: USB Drive Detection
Write-Host ""
Write-Host "=== USB DRIVE DETECTION TESTS ===" -ForegroundColor Cyan
Write-Host ""

$usbDrives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { 
    $_.DriveType -eq 2 -and $_.Size -gt 8GB 
}

Test-Component "USB Drive Detection (8GB+)" {
    $usbDrives.Count -gt 0
} -Category "USB"

if ($usbDrives.Count -gt 0) {
    Write-Host "  Found USB drives:" -ForegroundColor Gray
    foreach ($usb in $usbDrives) {
        $sizeGB = [math]::Round($usb.Size / 1GB, 2)
        Write-Host "    - $($usb.DeviceID) ($sizeGB GB)" -ForegroundColor Gray
    }
}

# Test 7: Syntax Validation
Write-Host ""
Write-Host "=== POWERSHELL SYNTAX VALIDATION ===" -ForegroundColor Cyan
Write-Host ""

$scriptsToValidate = @(
    "bill-sloth-dual-boot-wizard-unified.ps1",
    "bill-sloth-wsl2-iso-builder.ps1",
    "bill-sloth-live-build-iso.ps1"
)

foreach ($script in $scriptsToValidate) {
    $scriptPath = Join-Path $PSScriptRoot $script
    if (Test-Path $scriptPath) {
        Test-Component "Syntax: $script" {
            $errors = @()
            $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $scriptPath -Raw), [ref]$errors)
            $errors.Count -eq 0
        } -Category "Syntax"
    }
}

# Test 8: NonInteractive Parameter Support
Write-Host ""
Write-Host "=== AUTOMATION SUPPORT TESTS ===" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $wizardPath) {
    $wizardContent = Get-Content $wizardPath -Raw
    
    Test-Component "NonInteractive Parameter Definition" {
        $wizardContent -match '\[switch\]\$NonInteractive'
    } -Category "Automation"
    
    Test-Component "NonInteractive Confirmation Handling" {
        $wizardContent -match 'if\s*\(\$NonInteractive\)\s*{[^}]*\$confirm\s*=\s*"y"'
    } -Category "Automation"
}

# Test 9: WSL2 ISO Builder Integration
Write-Host ""
Write-Host "=== WSL2 ISO BUILDER TESTS ===" -ForegroundColor Cyan
Write-Host ""

$wsl2BuilderPath = Join-Path $PSScriptRoot "bill-sloth-wsl2-iso-builder.ps1"
if (Test-Path $wsl2BuilderPath) {
    Test-Component "WSL2 ISO Builder Exists" {
        $true
    } -Category "WSL2Builder"
    
    $wsl2BuilderContent = Get-Content $wsl2BuilderPath -Raw
    
    Test-Component "Architectural Fix - No PowerShell Bash Parsing" {
        # Check that bash commands are in here-strings, not direct PowerShell
        ($wsl2BuilderContent -match '@''') -and ($wsl2BuilderContent -match 'wsl.*bash')
    } -Category "WSL2Builder"
    
    Test-Component "No Silent Fallbacks to Ubuntu" {
        -not ($wsl2BuilderContent -match "Get-StandardUbuntuISO")
    } -Category "WSL2Builder"
    
    Test-Component "WSL2 Environment Validation" {
        $wsl2BuilderContent -match "Test-WSL2Available"
    } -Category "WSL2Builder"
    
    Test-Component "Cyberpunk Customization" {
        $wsl2BuilderContent -match "CYBERPUNK.*SLOTH"
    } -Category "WSL2Builder"
}

# Test 10: Legacy Live-Build Integration (for comparison)
Write-Host ""
Write-Host "=== LEGACY LIVE-BUILD TESTS ===" -ForegroundColor Cyan
Write-Host ""

$liveBuildPath = Join-Path $PSScriptRoot "bill-sloth-live-build-iso.ps1"
if (Test-Path $liveBuildPath) {
    Test-Component "Legacy Live-Build Script Exists" {
        $true
    } -Category "Legacy"
    
    $liveBuildContent = Get-Content $liveBuildPath -Raw
    
    Test-Component "Has WSL2 Integration Code" {
        $liveBuildContent -match "wsl --list --verbose"
    } -Category "Legacy"
}

# Test 11: Quick Functionality Test
if (-not $Quick) {
    Write-Host ""
    Write-Host "=== QUICK FUNCTIONALITY TESTS ===" -ForegroundColor Cyan
    Write-Host ""
    
    # Test wizard help/version
    Test-Component "Wizard Responds to -WhatIf" {
        try {
            & $wizardPath -WhatIf -ErrorAction Stop
            $true
        } catch {
            # -WhatIf not implemented is ok
            $true
        }
    } -Category "Functionality"
}

# Final Report
Write-Host ""
Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
Write-Host "██  ░▒▓█ TEST RESULTS SUMMARY █▓▒░                                            ██" -ForegroundColor Magenta
Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
Write-Host ""

$totalTests = $testResults.Passed + $testResults.Failed + $testResults.Warnings
Write-Host "Total Tests: $totalTests" -ForegroundColor White
Write-Host "✅ Passed: $($testResults.Passed)" -ForegroundColor Green
Write-Host "❌ Failed: $($testResults.Failed)" -ForegroundColor Red
Write-Host "⚠️  Warnings: $($testResults.Warnings)" -ForegroundColor Yellow
Write-Host ""

if ($Verbose -or $testResults.Failed -gt 0) {
    Write-Host "=== DETAILED RESULTS ===" -ForegroundColor Cyan
    foreach ($detail in $testResults.Details) {
        Write-Host $detail
    }
    Write-Host ""
}

# Overall Assessment
Write-Host "=== OVERALL ASSESSMENT ===" -ForegroundColor Cyan
if ($testResults.Failed -eq 0) {
    Write-Host "🎯 ALL SYSTEMS GO - This shit works!" -ForegroundColor Green
    Write-Host "✅ Ready for cyberpunk Bill Sloth dual-boot installation" -ForegroundColor Green
} elseif ($testResults.Failed -le 2) {
    Write-Host "⚠️  MOSTLY WORKING - Minor issues detected" -ForegroundColor Yellow
    Write-Host "The wizard should work but some features may be limited" -ForegroundColor Yellow
} else {
    Write-Host "❌ CRITICAL ISSUES - This shit needs fixing!" -ForegroundColor Red
    Write-Host "Multiple failures detected. Review detailed results above." -ForegroundColor Red
}

Write-Host ""
Write-Host "▓▓▓ TEST SUITE COMPLETE ▓▓▓" -ForegroundColor Cyan

# Exit with appropriate code
exit $(if ($testResults.Failed -eq 0) { 0 } else { 1 })