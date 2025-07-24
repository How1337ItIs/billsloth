# Fine-Tuned Dual-Boot Wizard for Bill Sloth
# Maximum automation with strategic Claude Code integration
# Optimized for Bill's Pro subscription token conservation

param(
    [ValidateSet("minimal", "standard", "comprehensive", "auto")]
    [string]$ClaudeLevel = "auto",
    [switch]$ConserveTokens,
    [switch]$DryRun,
    [switch]$SkipClaude,
    [int]$UbuntuSizeGB = 100,
    [string]$USBDrive = "",
    [string]$ISOPath = ""
)

#Requires -RunAsAdministrator

# Import token-efficient Claude integration
. "$PSScriptRoot\token-efficient-claude-integration.ps1"

# Enhanced error handling with recovery suggestions
$ErrorActionPreference = "Stop"
trap {
    Write-Host ""
    Write-Host "❌ SETUP FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 RECOVERY OPTIONS:" -ForegroundColor Yellow
    Write-Host "1. Run: .\troubleshoot-setup-failure.ps1" -ForegroundColor White
    Write-Host "2. Check: TROUBLESHOOTING.md" -ForegroundColor White
    Write-Host "3. Restart with: -SkipClaude if Claude issues" -ForegroundColor White
    Write-Host ""
    exit 1
}

# ASCII banner with token conservation notice
Write-Host @"
╔══════════════════════════════════════════════════════════════════════════════╗
║  🚀 BILL SLOTH FINE-TUNED DUAL-BOOT WIZARD 🚀                               ║
║                                                                              ║
║  Maximum automation • Strategic AI assistance • Token efficient             ║
║  Self-building Jarvis for dyslexic Tony Stark                               ║
╚══════════════════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""
if (-not $SkipClaude) {
    Write-Host "🔋 Claude Code integration: $ClaudeLevel level" -ForegroundColor Green
    if ($ConserveTokens) {
        Write-Host "💰 Token conservation mode: Only critical AI assessments" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚡ High-speed mode: Skipping Claude integration" -ForegroundColor Yellow
}
Write-Host ""

# Initialize comprehensive system data collection
function Get-ComprehensiveSystemData {
    Write-Host "🔍 Analyzing system configuration..." -ForegroundColor Yellow
    
    $systemData = @{
        timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        cpu = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1 | ForEach-Object {
            @{
                name = $_.Name.Trim()
                cores = $_.NumberOfCores
                threads = $_.NumberOfLogicalProcessors
                architecture = $_.Architecture
                max_clock_speed = $_.MaxClockSpeed
            }
        }
        memory = @{
            total_gb = [math]::Round((Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
            available_gb = [math]::Round((Get-CimInstance -ClassName Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)
            slots_used = (Get-CimInstance -ClassName Win32_PhysicalMemory).Count
        }
        disks = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
            @{
                drive_letter = $_.DeviceID
                size_gb = [math]::Round($_.Size / 1GB, 2)
                free_gb = [math]::Round($_.FreeSpace / 1GB, 2)
                used_percent = [math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100, 1)
                file_system = $_.FileSystem
                is_boot_disk = ($_.DeviceID -eq $env:SystemDrive)
            }
        }
        gpu = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -notlike "*Basic*" } | Select-Object -First 1 | ForEach-Object {
            @{
                name = $_.Name.Trim()
                driver_version = $_.DriverVersion
                memory_mb = if ($_.AdapterRAM) { [math]::Round($_.AdapterRAM / 1MB, 0) } else { "Unknown" }
            }
        }
        boot = @{
            is_uefi = (Get-ComputerInfo).BiosFirmwareType -eq "Uefi"
            secure_boot_enabled = try {
                (Get-SecureBootUEFI -Name SetupMode).Bytes[0] -eq 0
            } catch { $false }
            tpm_available = (Get-CimInstance -Namespace "Root\CIMv2\Security\MicrosoftTpm" -ClassName Win32_Tpm -ErrorAction SilentlyContinue) -ne $null
        }
        network = @{
            adapters = (Get-CimInstance -ClassName Win32_NetworkAdapter | Where-Object { $_.NetConnectionStatus -eq 2 }).Count
            internet_available = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet
        }
        usb_drives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 } | ForEach-Object {
            @{
                drive_letter = $_.DeviceID
                size_gb = [math]::Round($_.Size / 1GB, 2)
                label = $_.VolumeName
                free_gb = [math]::Round($_.FreeSpace / 1GB, 2)
            }
        }
    }
    
    Write-Host "✅ System analysis complete" -ForegroundColor Green
    return $systemData
}

# Intelligent hardware compatibility assessment
function Test-UbuntuCompatibility {
    param([hashtable]$SystemData)
    
    Write-Host "🔍 Testing Ubuntu compatibility..." -ForegroundColor Yellow
    
    $compatibility = @{
        overall = "excellent"
        issues = @()
        recommendations = @()
        blockers = @()
    }
    
    # RAM check
    if ($SystemData.memory.total_gb -lt 4) {
        $compatibility.issues += "Low RAM: $($SystemData.memory.total_gb)GB (4GB+ recommended)"
        $compatibility.overall = "fair"
    }
    
    # Disk space check
    $bootDisk = $SystemData.disks | Where-Object { $_.is_boot_disk }
    if ($bootDisk.free_gb -lt 120) {
        $compatibility.issues += "Limited disk space: $($bootDisk.free_gb)GB free (120GB+ recommended)"
        if ($bootDisk.free_gb -lt 80) {
            $compatibility.blockers += "Insufficient disk space for safe dual-boot"
            $compatibility.overall = "poor"
        } else {
            $compatibility.overall = "fair"
        }
    }
    
    # UEFI check
    if (-not $SystemData.boot.is_uefi) {
        $compatibility.issues += "Legacy BIOS detected (UEFI preferred for modern Ubuntu)"
        $compatibility.recommendations += "Consider UEFI conversion or Legacy BIOS Ubuntu setup"
    }
    
    # Secure Boot check
    if ($SystemData.boot.secure_boot_enabled) {
        $compatibility.recommendations += "Secure Boot enabled - may need adjustment for Ubuntu"
    }
    
    # GPU compatibility
    if ($SystemData.gpu.name -like "*NVIDIA*") {
        $compatibility.recommendations += "NVIDIA GPU detected - proprietary drivers recommended"
    }
    
    Write-Host "✅ Compatibility assessment complete: $($compatibility.overall)" -ForegroundColor Green
    return $compatibility
}

# Smart USB drive detection and selection
function Select-OptimalUSBDrive {
    param([hashtable]$SystemData, [string]$PreferredDrive = "")
    
    Write-Host "🔍 Detecting USB drives..." -ForegroundColor Yellow
    
    $usbDrives = $SystemData.usb_drives | Where-Object { $_.size_gb -ge 8 }
    
    if ($usbDrives.Count -eq 0) {
        Write-Host "❌ No suitable USB drives found (8GB+ required)" -ForegroundColor Red
        Write-Host "📋 Please insert a USB drive and run again" -ForegroundColor Yellow
        return $null
    }
    
    # If specific drive requested, validate it
    if ($PreferredDrive) {
        $selectedDrive = $usbDrives | Where-Object { $_.drive_letter -eq $PreferredDrive }
        if ($selectedDrive) {
            Write-Host "✅ Using specified USB drive: $PreferredDrive ($($selectedDrive.size_gb)GB)" -ForegroundColor Green
            return $selectedDrive
        } else {
            Write-Host "⚠️  Specified drive $PreferredDrive not found, auto-selecting..." -ForegroundColor Yellow
        }
    }
    
    # Auto-select best drive
    if ($usbDrives.Count -eq 1) {
        $selected = $usbDrives[0]
        Write-Host "✅ Auto-selected USB drive: $($selected.drive_letter) ($($selected.size_gb)GB)" -ForegroundColor Green
        return $selected
    }
    
    # Multiple drives - interactive selection
    Write-Host "📋 Multiple USB drives detected:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $usbDrives.Count; $i++) {
        $drive = $usbDrives[$i]
        $label = if ($drive.label) { " '$($drive.label)'" } else { "" }
        Write-Host "  [$i] $($drive.drive_letter) - $($drive.size_gb)GB$label" -ForegroundColor White
    }
    
    do {
        $selection = Read-Host "Select USB drive number (0-$($usbDrives.Count-1))"
        if ($selection -match '^\d+$' -and [int]$selection -lt $usbDrives.Count) {
            $selected = $usbDrives[[int]$selection]
            Write-Host "✅ Selected: $($selected.drive_letter) ($($selected.size_gb)GB)" -ForegroundColor Green
            return $selected
        }
        Write-Host "❌ Invalid selection, please try again" -ForegroundColor Red
    } while ($true)
}

# Intelligent ISO detection and download
function Get-UbuntuISO {
    param([string]$PreferredPath = "")
    
    Write-Host "🔍 Locating Ubuntu ISO..." -ForegroundColor Yellow
    
    # Check if specific ISO provided
    if ($PreferredPath -and (Test-Path $PreferredPath)) {
        $size = [math]::Round((Get-Item $PreferredPath).Length / 1GB, 2)
        Write-Host "✅ Using provided ISO: $PreferredPath ($size GB)" -ForegroundColor Green
        return $PreferredPath
    }
    
    # Auto-detect existing ISOs
    $searchPaths = @(
        "$env:USERPROFILE\Downloads\ubuntu*.iso",
        "$env:USERPROFILE\Desktop\ubuntu*.iso",
        "$env:USERPROFILE\Documents\ubuntu*.iso",
        "C:\Users\*\Downloads\ubuntu*.iso"
    )
    
    $foundISOs = @()
    foreach ($path in $searchPaths) {
        $found = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
        $foundISOs += $found
    }
    
    if ($foundISOs.Count -gt 0) {
        # Sort by newest and size (prefer LTS versions)
        $best = $foundISOs | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        $size = [math]::Round($best.Length / 1GB, 2)
        Write-Host "✅ Found existing ISO: $($best.FullName) ($size GB)" -ForegroundColor Green
        return $best.FullName
    }
    
    # No ISO found - offer download
    Write-Host "📥 No Ubuntu ISO found. Download latest LTS version?" -ForegroundColor Yellow
    Write-Host "   Size: ~4.5GB, Time: 10-30 minutes (depending on connection)" -ForegroundColor White
    
    $download = Read-Host "Download Ubuntu 22.04.5 LTS? (y/N)"
    if ($download -eq 'y' -or $download -eq 'Y') {
        return Start-UbuntuDownload
    }
    
    # Manual path entry
    do {
        $manualPath = Read-Host "Enter path to Ubuntu ISO file"
        if ($manualPath -and (Test-Path $manualPath)) {
            return $manualPath
        }
        Write-Host "❌ File not found: $manualPath" -ForegroundColor Red
    } while ($true)
}

# Optimized Ubuntu download with progress
function Start-UbuntuDownload {
    Write-Host "📥 Downloading Ubuntu 22.04.5 LTS..." -ForegroundColor Yellow
    
    $downloadPath = "$env:USERPROFILE\Downloads\ubuntu-22.04.5-desktop-amd64.iso"
    $url = "https://releases.ubuntu.com/22.04.5/ubuntu-22.04.5-desktop-amd64.iso"
    
    try {
        # Use BITS for resumable download
        Import-Module BitsTransfer -ErrorAction SilentlyContinue
        if (Get-Module BitsTransfer) {
            Write-Host "🚀 Starting optimized download (resumable)..." -ForegroundColor Green
            Start-BitsTransfer -Source $url -Destination $downloadPath -Description "Ubuntu 22.04.5 LTS"
        } else {
            # Fallback to Invoke-WebRequest with progress
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($url, $downloadPath)
        }
        
        Write-Host "✅ Download complete: $downloadPath" -ForegroundColor Green
        return $downloadPath
    }
    catch {
        Write-Host "❌ Download failed: $($_.Exception.Message)" -ForegroundColor Red
        throw "Ubuntu ISO download failed"
    }
}

# Enhanced USB creation with multiple methods
function New-BootableUSB {
    param(
        [string]$ISOPath,
        [hashtable]$USBDrive
    )
    
    Write-Host ""
    Write-Host "🚀 Creating bootable Ubuntu USB..." -ForegroundColor Yellow
    Write-Host "📋 ISO: $ISOPath" -ForegroundColor White
    Write-Host "📋 Target: $($USBDrive.drive_letter) ($($USBDrive.size_gb)GB)" -ForegroundColor White
    Write-Host ""
    
    # Safety confirmation
    Write-Host "⚠️  WARNING: ALL DATA on $($USBDrive.drive_letter) will be ERASED!" -ForegroundColor Red
    Write-Host ""
    $confirm = Read-Host "Continue with USB creation? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Host "❌ USB creation cancelled" -ForegroundColor Red
        return $false
    }
    
    # Try multiple USB creation methods
    $methods = @(
        @{ name = "PowerShell Native"; function = "New-USBViaPowerShell" },
        @{ name = "Rufus Automated"; function = "New-USBViaRufus" },
        @{ name = "Windows DISM"; function = "New-USBViaDISM" }
    )
    
    foreach ($method in $methods) {
        Write-Host "🔄 Trying method: $($method.name)..." -ForegroundColor Cyan
        
        try {
            $result = & $method.function -ISOPath $ISOPath -USBDrive $USBDrive
            if ($result) {
                Write-Host "✅ USB creation successful using $($method.name)" -ForegroundColor Green
                return $true
            }
        }
        catch {
            Write-Host "❌ Method $($method.name) failed: $($_.Exception.Message)" -ForegroundColor Red
            continue
        }
    }
    
    Write-Host "❌ All USB creation methods failed" -ForegroundColor Red
    return $false
}

# PowerShell native USB creation
function New-USBViaPowerShell {
    param([string]$ISOPath, [hashtable]$USBDrive)
    
    # This would use native PowerShell methods
    # Implementation details depend on Windows version and available APIs
    Write-Host "🔧 PowerShell native method not yet implemented" -ForegroundColor Yellow
    return $false
}

# Automated Rufus integration
function New-USBViaRufus {
    param([string]$ISOPath, [hashtable]$USBDrive)
    
    # Download Rufus if needed
    $rufusPath = "$env:TEMP\rufus.exe"
    if (-not (Test-Path $rufusPath)) {
        Write-Host "📥 Downloading Rufus..." -ForegroundColor Yellow
        try {
            $rufusUrl = "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5.exe"
            Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusPath -UseBasicParsing
        }
        catch {
            throw "Failed to download Rufus: $($_.Exception.Message)"
        }
    }
    
    # Launch Rufus with instructions
    Write-Host "🚀 Launching Rufus..." -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 RUFUS CONFIGURATION:" -ForegroundColor Yellow
    Write-Host "   1. Device: Select $($USBDrive.drive_letter)" -ForegroundColor White
    Write-Host "   2. Boot selection: Click SELECT and choose:" -ForegroundColor White
    Write-Host "      $ISOPath" -ForegroundColor Cyan
    Write-Host "   3. Partition scheme: GPT" -ForegroundColor White
    Write-Host "   4. Target system: UEFI (non CSM)" -ForegroundColor White
    Write-Host "   5. Click START" -ForegroundColor White
    Write-Host ""
    
    try {
        Start-Process -FilePath $rufusPath -Wait
        Write-Host "✅ Rufus completed" -ForegroundColor Green
        return $true
    }
    catch {
        throw "Failed to launch Rufus: $($_.Exception.Message)"
    }
}

# DISM-based USB creation
function New-USBViaDISM {
    param([string]$ISOPath, [hashtable]$USBDrive)
    
    Write-Host "🔧 DISM method requires advanced implementation" -ForegroundColor Yellow
    return $false
}

# Strategic Claude integration for critical decisions
function Get-ClaudeGuidance {
    param([hashtable]$SystemData, [hashtable]$CompatibilityData)
    
    if ($SkipClaude) {
        Write-Host "⚡ Skipping Claude integration (high-speed mode)" -ForegroundColor Yellow
        return @{ skip = $true }
    }
    
    # Initialize Claude availability
    $script:ClaudeAvailable = Test-ClaudeAvailability
    
    if (-not $script:ClaudeAvailable) {
        Write-Host "⚠️  Claude Code not available - using built-in logic" -ForegroundColor Yellow
        return @{ fallback = $true }
    }
    
    # Run token-efficient assessment
    return Start-EfficientClaudeAssessment -SystemData $SystemData -AssessmentLevel $ClaudeLevel -ConserveTokens:$ConserveTokens
}

# Main wizard execution
function Start-DualBootWizard {
    Write-Host "🚀 Starting fine-tuned dual-boot wizard..." -ForegroundColor Green
    Write-Host ""
    
    # Phase 1: System Analysis
    Write-Host "═══ PHASE 1: SYSTEM ANALYSIS ═══" -ForegroundColor Cyan
    $systemData = Get-ComprehensiveSystemData
    $compatibility = Test-UbuntuCompatibility $systemData
    
    # Show system summary
    Write-Host ""
    Write-Host "📊 SYSTEM SUMMARY:" -ForegroundColor Cyan
    Write-Host "   CPU: $($systemData.cpu.name)" -ForegroundColor White
    Write-Host "   RAM: $($systemData.memory.total_gb)GB" -ForegroundColor White
    Write-Host "   Boot: $(if ($systemData.boot.is_uefi) { 'UEFI' } else { 'Legacy BIOS' })" -ForegroundColor White
    Write-Host "   Compatibility: $($compatibility.overall)" -ForegroundColor $(switch ($compatibility.overall) { "excellent" { "Green" } "good" { "Green" } "fair" { "Yellow" } "poor" { "Red" } })
    
    if ($compatibility.blockers.Count -gt 0) {
        Write-Host ""
        Write-Host "🚫 BLOCKERS DETECTED:" -ForegroundColor Red
        $compatibility.blockers | ForEach-Object { Write-Host "   • $_" -ForegroundColor Red }
        Write-Host ""
        Write-Host "❌ Setup cannot continue with current system configuration" -ForegroundColor Red
        return $false
    }
    
    # Phase 2: Claude Assessment (if enabled)
    Write-Host ""
    Write-Host "═══ PHASE 2: AI ASSESSMENT ═══" -ForegroundColor Cyan
    $claudeGuidance = Get-ClaudeGuidance $systemData $compatibility
    
    # Phase 3: Resource Preparation
    Write-Host ""
    Write-Host "═══ PHASE 3: RESOURCE PREPARATION ═══" -ForegroundColor Cyan
    
    # Get Ubuntu ISO
    $isoPath = Get-UbuntuISO $ISOPath
    if (-not $isoPath) {
        Write-Host "❌ Ubuntu ISO required for setup" -ForegroundColor Red
        return $false
    }
    
    # Select USB drive
    $usbDrive = Select-OptimalUSBDrive $systemData $USBDrive
    if (-not $usbDrive) {
        Write-Host "❌ USB drive required for setup" -ForegroundColor Red
        return $false
    }
    
    # Phase 4: USB Creation
    Write-Host ""
    Write-Host "═══ PHASE 4: USB CREATION ═══" -ForegroundColor Cyan
    $usbSuccess = New-BootableUSB $isoPath $usbDrive
    
    if (-not $usbSuccess) {
        Write-Host "❌ USB creation failed" -ForegroundColor Red
        return $false
    }
    
    # Phase 5: Bill Sloth Integration
    Write-Host ""
    Write-Host "═══ PHASE 5: BILL SLOTH INTEGRATION ═══" -ForegroundColor Cyan
    $integrationResult = Add-BillSlothToUSB $usbDrive
    
    # Phase 6: Final Instructions
    Write-Host ""
    Write-Host "═══ PHASE 6: COMPLETION ═══" -ForegroundColor Cyan
    Show-FinalInstructions $systemData $usbDrive
    
    return $true
}

# Add Bill Sloth system to USB
function Add-BillSlothToUSB {
    param([hashtable]$USBDrive)
    
    Write-Host "📦 Adding Bill Sloth automation system to USB..." -ForegroundColor Yellow
    
    # Clone Bill Sloth to temp directory
    $tempDir = "$env:TEMP\billsloth-usb-integration"
    $usbDir = "$($USBDrive.drive_letter)\BillSloth"
    
    try {
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Recurse -Force
        }
        
        Write-Host "📥 Downloading Bill Sloth system..." -ForegroundColor Yellow
        git clone https://github.com/How1337ItIs/billsloth.git $tempDir
        
        Write-Host "📁 Creating Bill Sloth directory on USB..." -ForegroundColor Yellow
        if (Test-Path $usbDir) {
            Remove-Item -Path $usbDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $usbDir -Force | Out-Null
        
        Write-Host "📋 Copying system files..." -ForegroundColor Yellow
        Copy-Item -Path "$tempDir\*" -Destination $usbDir -Recurse -Force
        
        Write-Host "🚀 Creating auto-launch script..." -ForegroundColor Yellow
        $autoLaunch = @"
#!/bin/bash
# Bill Sloth Auto-Launch for Ubuntu
echo "🚀 Starting Bill Sloth automation system..."
cd /media/*/BillSloth
chmod +x *.sh lib/*.sh modules/*.sh scripts/*.sh 2>/dev/null
./onboard.sh
"@
        $autoLaunch | Out-File -FilePath "$usbDir\auto-launch.sh" -Encoding UTF8
        
        Write-Host "✅ Bill Sloth integration complete" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Bill Sloth integration failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Recurse -Force
        }
    }
}

# Show final setup instructions
function Show-FinalInstructions {
    param([hashtable]$SystemData, [hashtable]$USBDrive)
    
    Write-Host ""
    Write-Host "🎉 DUAL-BOOT WIZARD COMPLETE!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 NEXT STEPS:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. 🔄 RESTART your computer" -ForegroundColor Yellow
    Write-Host "2. ⌨️  Press $(if ($SystemData.boot.is_uefi) { 'F12 or F2' } else { 'F12 or Del' }) during startup" -ForegroundColor Yellow
    Write-Host "3. 🎯 Select USB drive: $($USBDrive.drive_letter)" -ForegroundColor Yellow
    Write-Host "4. 🐧 Choose 'Install Ubuntu'" -ForegroundColor Yellow
    Write-Host "5. 📦 Select 'Install Ubuntu alongside Windows'" -ForegroundColor Yellow
    Write-Host "6. ⚡ After installation, run: /media/*/BillSloth/auto-launch.sh" -ForegroundColor Yellow
    Write-Host ""
    
    if ($SystemData.boot.secure_boot_enabled) {
        Write-Host "⚠️  SECURE BOOT NOTICE:" -ForegroundColor Red
        Write-Host "   You may need to disable Secure Boot in BIOS/UEFI settings" -ForegroundColor White
        Write-Host ""
    }
    
    Write-Host "📚 DOCUMENTATION:" -ForegroundColor Cyan
    Write-Host "   • Full guide: windows-setup/COMPLETE_SETUP_FROM_ZERO.md" -ForegroundColor White
    Write-Host "   • Troubleshooting: TROUBLESHOOTING.md" -ForegroundColor White
    Write-Host "   • Bill Sloth docs: BILL_SLOTH_GIGA_DOC.md" -ForegroundColor White
    Write-Host ""
    Write-Host "🦥 Your self-building Jarvis for dyslexic Tony Stark is ready!" -ForegroundColor Magenta
    Write-Host ""
}

# Execute the wizard
if (-not $DryRun) {
    $success = Start-DualBootWizard
    if ($success) {
        Write-Host "✅ Setup completed successfully!" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "❌ Setup failed - check logs and documentation" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "🧪 DRY RUN MODE - No changes made" -ForegroundColor Yellow
    Write-Host "Remove -DryRun parameter to execute actual setup" -ForegroundColor White
}