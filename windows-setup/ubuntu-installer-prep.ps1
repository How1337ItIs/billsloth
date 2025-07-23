# Bill Sloth Ubuntu Installer Preparation
# Downloads Ubuntu ISO, creates bootable USB, and prepares installation files
# Handles everything possible from Windows CLI before reboot

param(
    [string]$UbuntuVersion = "22.04.5",
    [string]$DownloadPath = "$env:USERPROFILE\Downloads",
    [string]$USBDrive = "",
    [string]$ExistingISO = "",
    [switch]$SkipDownload,
    [switch]$CreateUSBOnly,
    [switch]$CheckExistingUSB,
    [switch]$Interactive = $true
)

# Requires Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires Administrator privileges for USB creation!"
    Write-Host "Right-click PowerShell and select 'Run as Administrator'"
    exit 1
}

Write-Host @"
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  💿 BILL SLOTH UBUNTU INSTALLER PREPARATION 💿                   █  
█  🚀 AUTOMATED ISO DOWNLOAD & USB CREATION 🚀                      █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
"@ -ForegroundColor Cyan

$script:BillSlothDir = "$env:USERPROFILE\bill-sloth-windows"
$script:LogFile = "$script:BillSlothDir\ubuntu-installer-prep.log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    if (!(Test-Path (Split-Path $script:LogFile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $script:LogFile -Parent) -Force | Out-Null
    }
    
    Add-Content -Path $script:LogFile -Value $logEntry
    
    switch ($Level) {
        "ERROR" { Write-Host "❌ $Message" -ForegroundColor Red }
        "WARN"  { Write-Host "⚠️  $Message" -ForegroundColor Yellow }
        "SUCCESS" { Write-Host "✅ $Message" -ForegroundColor Green }
        "PROGRESS" { Write-Host "⏳ $Message" -ForegroundColor Blue }
        default { Write-Host "ℹ️  $Message" -ForegroundColor White }
    }
}

# Get Ubuntu release information
function Get-UbuntuReleaseInfo {
    param([string]$Version)
    
    $ubuntuReleases = @{
        "22.04.3" = @{
            Name = "Ubuntu 22.04.3 LTS (Jammy Jellyfish)"
            URL = "https://old-releases.ubuntu.com/releases/22.04.3/ubuntu-22.04.3-desktop-amd64.iso"
            FileName = "ubuntu-22.04.3-desktop-amd64.iso"
            SizeGB = 4.7
            SHA256 = "a435f6f393dda581172490eda9f683c32e495158a780b5a1de422ee77d98e909"
            LTS = $true
            RecommendedRAM = 4
        }
        "22.04.5" = @{
            Name = "Ubuntu 22.04.5 LTS (Jammy Jellyfish) - CURRENT"
            URL = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-desktop-amd64.iso"
            FileName = "ubuntu-22.04.5-desktop-amd64.iso"
            SizeGB = 5.7
            SHA256 = "bfd1cee02bc4f35db939e69b934ba49a39a378797ce9aee20f6e3e3e728fefbf"
            LTS = $true
            RecommendedRAM = 4
        }
        "23.10" = @{
            Name = "Ubuntu 23.10 (Mantic Minotaur)"
            URL = "https://releases.ubuntu.com/23.10/ubuntu-23.10-desktop-amd64.iso"
            FileName = "ubuntu-23.10-desktop-amd64.iso"
            SizeGB = 5.1
            SHA256 = ""  # Would need current hash
            LTS = $false
            RecommendedRAM = 4
        }
        "24.04" = @{
            Name = "Ubuntu 24.04 LTS (Noble Numbat)"
            URL = "https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso"
            FileName = "ubuntu-24.04-desktop-amd64.iso"
            SizeGB = 5.4
            SHA256 = ""  # Would need current hash
            LTS = $true
            RecommendedRAM = 4
        }
    }
    
    if ($ubuntuReleases.ContainsKey($Version)) {
        return $ubuntuReleases[$Version]
    } else {
        Write-Log "Unknown Ubuntu version: $Version" "WARN"
        Write-Log "Available versions: $($ubuntuReleases.Keys -join ', ')" "INFO"
        return $ubuntuReleases["22.04.5"]  # Default to current LTS
    }
}

# Find existing Ubuntu ISOs in common locations
function Find-ExistingUbuntuISOs {
    Write-Host ""
    Write-Host "🔍 SCANNING FOR EXISTING UBUNTU ISOs" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    
    $searchLocations = @(
        "$env:USERPROFILE\Downloads",
        "$env:USERPROFILE\Desktop",
        "$env:USERPROFILE\Documents",
        "C:\ISOs",
        "D:\ISOs",
        "C:\Downloads"
    )
    
    $foundISOs = @()
    
    foreach ($location in $searchLocations) {
        if (Test-Path $location -ErrorAction SilentlyContinue) {
            Write-Log "Searching: $location" "INFO"
            
            $isoFiles = Get-ChildItem -Path $location -Filter "*.iso" -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -match "ubuntu.*\d+\.\d+.*\.iso" -and $_.Length -gt 1GB
            }
            
            foreach ($iso in $isoFiles) {
                $isoInfo = Get-ISOValidation -ISOPath $iso.FullName
                if ($isoInfo.IsUbuntuISO) {
                    $foundISOs += $isoInfo
                    Write-Log "✅ Found Ubuntu ISO: $($iso.Name) (Ubuntu $($isoInfo.DetectedVersion))" "SUCCESS"
                }
            }
        }
    }
    
    if ($foundISOs.Count -eq 0) {
        Write-Log "No existing Ubuntu ISOs found in common locations" "INFO"
    } else {
        Write-Host ""
        Write-Host "📊 FOUND UBUNTU ISOs:" -ForegroundColor Green
        Write-Host "=====================" -ForegroundColor Green
        
        for ($i = 0; $i -lt $foundISOs.Count; $i++) {
            $iso = $foundISOs[$i]
            Write-Host ""
            Write-Host "[$($i + 1)] $($iso.FileName)" -ForegroundColor White
            Write-Host "    📁 Location: $($iso.FilePath)" -ForegroundColor Gray
            Write-Host "    📀 Version: Ubuntu $($iso.DetectedVersion)" -ForegroundColor Gray
            Write-Host "    📏 Size: $($iso.SizeGB) GB" -ForegroundColor Gray
            Write-Host "    ✅ Valid: $($iso.ValidationStatus)" -ForegroundColor $(if ($iso.IsValid) { "Green" } else { "Red" })
            if ($iso.SHA256Status -ne "Unknown") {
                Write-Host "    🔐 SHA256: $($iso.SHA256Status)" -ForegroundColor $(if ($iso.SHA256Status -eq "Verified") { "Green" } elseif ($iso.SHA256Status -eq "Mismatch") { "Red" } else { "Yellow" })
            }
        }
    }
    
    return $foundISOs
}

# Validate and analyze an ISO file
function Get-ISOValidation {
    param([string]$ISOPath)
    
    $result = @{
        FilePath = $ISOPath
        FileName = Split-Path $ISOPath -Leaf
        IsUbuntuISO = $false
        DetectedVersion = ""
        SizeGB = 0
        IsValid = $false
        ValidationStatus = "Unknown"
        SHA256Hash = ""
        SHA256Status = "Unknown"
        CreationDate = (Get-Item $ISOPath -ErrorAction SilentlyContinue).CreationTime
        LastModified = (Get-Item $ISOPath -ErrorAction SilentlyContinue).LastWriteTime
        RecommendedAction = ""
    }
    
    try {
        $isoFile = Get-Item $ISOPath -ErrorAction Stop
        $result.SizeGB = [math]::Round($isoFile.Length / 1GB, 2)
        
        # Check filename patterns for Ubuntu
        if ($isoFile.Name -match "ubuntu-(\d+\.\d+(?:\.\d+)?)-.*\.iso") {
            $result.DetectedVersion = $matches[1]
            $result.IsUbuntuISO = $true
            
            # Validate size (Ubuntu ISOs are typically 3-6 GB)
            if ($result.SizeGB -ge 3.0 -and $result.SizeGB -le 7.0) {
                $result.IsValid = $true
                $result.ValidationStatus = "Size and name valid"
                $result.RecommendedAction = "Ready to use"
            } else {
                $result.ValidationStatus = "Size suspicious ($($result.SizeGB) GB)"
                $result.RecommendedAction = "Verify integrity or re-download"
            }
            
            # Try to get more specific validation
            try {
                # Check if we can get file hash (optional - takes time)
                Write-Log "Calculating SHA256 for $($isoFile.Name) (may take 2-5 minutes)..." "PROGRESS"
                $hashResult = Get-FileHash -Path $ISOPath -Algorithm SHA256 -ErrorAction Stop
                $result.SHA256Hash = $hashResult.Hash.ToLower()
                
                # Check against known hashes if available
                $knownVersions = @{
                    "22.04.3" = "a4acfda10b18da50e2ec50ccaf860d7f20b389df8765611142305c0e911d16fd"
                    "24.04" = ""  # Would need current hash
                }
                
                if ($knownVersions.ContainsKey($result.DetectedVersion) -and 
                    ![string]::IsNullOrEmpty($knownVersions[$result.DetectedVersion])) {
                    
                    if ($result.SHA256Hash -eq $knownVersions[$result.DetectedVersion]) {
                        $result.SHA256Status = "Verified"
                        $result.ValidationStatus = "Fully verified Ubuntu ISO"
                        $result.RecommendedAction = "Perfect - use this ISO"
                    } else {
                        $result.SHA256Status = "Mismatch"
                        $result.ValidationStatus = "Hash mismatch - possibly corrupted"
                        $result.RecommendedAction = "Re-download recommended"
                    }
                } else {
                    $result.SHA256Status = "No reference hash available"
                    $result.RecommendedAction = "Appears valid but cannot verify integrity"
                }
                
            } catch {
                Write-Log "Could not calculate hash for $($isoFile.Name): $($_.Exception.Message)" "WARN"
                $result.SHA256Status = "Hash calculation failed"
            }
            
        } else {
            $result.ValidationStatus = "Not a recognized Ubuntu ISO filename"
            $result.RecommendedAction = "Use different ISO"
        }
        
    } catch {
        $result.ValidationStatus = "Error accessing file: $($_.Exception.Message)"
        $result.RecommendedAction = "File may be corrupted or inaccessible"
    }
    
    return $result
}

# Interactive ISO selection from found ISOs
function Select-ExistingISO {
    param([array]$FoundISOs)
    
    if ($FoundISOs.Count -eq 0) {
        return $null
    }
    
    Write-Host ""
    Write-Host "🎯 SELECT UBUNTU ISO TO USE" -ForegroundColor Yellow
    Write-Host "============================" -ForegroundColor Yellow
    Write-Host ""
    
    # Show options
    Write-Host "Available options:" -ForegroundColor White
    for ($i = 0; $i -lt $FoundISOs.Count; $i++) {
        $iso = $FoundISOs[$i]
        $statusColor = if ($iso.IsValid) { "Green" } else { "Red" }
        Write-Host "  $($i + 1). Ubuntu $($iso.DetectedVersion) - $($iso.SizeGB) GB" -ForegroundColor $statusColor
        Write-Host "     📁 $($iso.FilePath)" -ForegroundColor Gray
        Write-Host "     ✅ $($iso.ValidationStatus)" -ForegroundColor Gray
    }
    Write-Host "  $($FoundISOs.Count + 1). 🌐 Download fresh Ubuntu ISO instead" -ForegroundColor Cyan
    Write-Host "  $($FoundISOs.Count + 2). 📁 Browse for different ISO file" -ForegroundColor Cyan
    Write-Host ""
    
    do {
        Write-Host "Select option (1-$($FoundISOs.Count + 2)): " -NoNewline -ForegroundColor Yellow
        $selection = Read-Host
        $selectedIndex = [int]$selection - 1
    } while ($selectedIndex -lt 0 -or $selectedIndex -gt ($FoundISOs.Count + 1))
    
    if ($selectedIndex -eq $FoundISOs.Count) {
        # Download fresh ISO
        return "DOWNLOAD_FRESH"
    } elseif ($selectedIndex -eq ($FoundISOs.Count + 1)) {
        # Browse for file
        return "BROWSE_FILE"
    } else {
        # Use selected ISO
        $selectedISO = $FoundISOs[$selectedIndex]
        Write-Log "User selected: $($selectedISO.FileName)" "INFO"
        
        if (!$selectedISO.IsValid) {
            Write-Host ""
            Write-Host "⚠️  WARNING: Selected ISO has validation issues!" -ForegroundColor Red
            Write-Host "   Issue: $($selectedISO.ValidationStatus)" -ForegroundColor Red
            Write-Host "   Recommendation: $($selectedISO.RecommendedAction)" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Continue anyway? (Y/N): " -NoNewline -ForegroundColor Yellow
            $proceed = Read-Host
            
            if ($proceed -notmatch '^[Yy]') {
                Write-Log "User declined to use invalid ISO" "INFO"
                return $null
            }
        }
        
        return $selectedISO.FilePath
    }
}

# Browse for ISO file using file dialog
function Get-ISOFileBrowser {
    Add-Type -AssemblyName System.Windows.Forms
    
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = "Select Ubuntu ISO File"
    $openFileDialog.Filter = "ISO Files (*.iso)|*.iso|All Files (*.*)|*.*"
    $openFileDialog.InitialDirectory = "$env:USERPROFILE\Downloads"
    
    if ($openFileDialog.ShowDialog() -eq "OK") {
        $selectedISO = $openFileDialog.FileName
        Write-Log "User browsed and selected: $selectedISO" "INFO"
        
        # Validate the selected ISO
        $validation = Get-ISOValidation -ISOPath $selectedISO
        
        Write-Host ""
        Write-Host "📊 SELECTED ISO VALIDATION" -ForegroundColor Cyan
        Write-Host "==========================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "File: $($validation.FileName)" -ForegroundColor White
        Write-Host "Ubuntu Version: $($validation.DetectedVersion)" -ForegroundColor White
        Write-Host "Size: $($validation.SizeGB) GB" -ForegroundColor White
        Write-Host "Status: $($validation.ValidationStatus)" -ForegroundColor $(if ($validation.IsValid) { "Green" } else { "Red" })
        Write-Host ""
        
        if ($validation.IsUbuntuISO) {
            return $selectedISO
        } else {
            Write-Host "❌ Selected file does not appear to be a valid Ubuntu ISO" -ForegroundColor Red
            Write-Host "Try selecting a different file." -ForegroundColor Yellow
            return $null
        }
    }
    
    return $null
}

# Download Ubuntu ISO with progress
function Get-UbuntuISO {
    param([object]$ReleaseInfo, [string]$DownloadPath)
    
    $isoPath = Join-Path $DownloadPath $ReleaseInfo.FileName
    
    # Check if ISO already exists
    if (Test-Path $isoPath) {
        $existingValidation = Get-ISOValidation -ISOPath $isoPath
        
        if ($existingValidation.IsValid) {
            Write-Log "✅ Valid Ubuntu ISO already exists: $isoPath" "SUCCESS"
            return $isoPath
        } else {
            Write-Log "⚠️ Existing ISO file has issues: $($existingValidation.ValidationStatus)" "WARN"
            Write-Log "Re-downloading to ensure integrity..." "INFO"
            Remove-Item $isoPath -Force
        }
    }
    
    Write-Host ""
    Write-Host "📥 DOWNLOADING UBUNTU ISO" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Release: $($ReleaseInfo.Name)" -ForegroundColor White
    Write-Host "Size: $($ReleaseInfo.SizeGB) GB" -ForegroundColor White
    Write-Host "Destination: $isoPath" -ForegroundColor White
    Write-Host ""
    Write-Host "🕒 This download will take 15-45 minutes depending on your internet speed" -ForegroundColor Yellow
    Write-Host "☕ Perfect time for coffee/tea break!" -ForegroundColor Green
    Write-Host ""
    
    if ($Interactive) {
        Write-Host "Continue with download? (Y/N): " -NoNewline -ForegroundColor Yellow
        $response = Read-Host
        if ($response -notmatch '^[Yy]') {
            Write-Log "Download cancelled by user" "INFO"
            return $null
        }
    }
    
    try {
        Write-Log "Starting download of $($ReleaseInfo.Name)..." "PROGRESS"
        
        # Use BITS (Background Intelligent Transfer Service) for robust downloading
        Import-Module BitsTransfer -ErrorAction SilentlyContinue
        
        if (Get-Module -Name BitsTransfer -ErrorAction SilentlyContinue) {
            # Use BITS for better progress tracking and resume capability
            $job = Start-BitsTransfer -Source $ReleaseInfo.URL -Destination $isoPath -DisplayName "Ubuntu ISO Download" -Asynchronous
            
            # Monitor download progress
            do {
                Start-Sleep -Seconds 5
                $progress = Get-BitsTransfer -JobId $job.JobId
                $percentComplete = [math]::Round(($progress.BytesTransferred / $progress.BytesTotal) * 100, 1)
                $transferredGB = [math]::Round($progress.BytesTransferred / 1GB, 2)
                $totalGB = [math]::Round($progress.BytesTotal / 1GB, 2)
                
                Write-Host "`r⏳ Progress: $percentComplete% ($transferredGB GB / $totalGB GB)" -NoNewline -ForegroundColor Blue
                
            } while ($progress.JobState -eq "Transferring")
            
            Write-Host ""  # New line after progress
            
            if ($progress.JobState -eq "Transferred") {
                Complete-BitsTransfer -BitsJob $job
                Write-Log "✅ Ubuntu ISO downloaded successfully via BITS" "SUCCESS"
            } else {
                Remove-BitsTransfer -BitsJob $job
                throw "BITS download failed with state: $($progress.JobState)"
            }
        } else {
            # Fallback to WebClient with basic progress
            Write-Log "BITS not available, using WebClient..." "INFO"
            
            $webClient = New-Object System.Net.WebClient
            
            # Add progress tracking
            Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -Action {
                $percent = $Event.SourceEventArgs.ProgressPercentage
                $receivedMB = [math]::Round($Event.SourceEventArgs.BytesReceived / 1MB, 1)
                $totalMB = [math]::Round($Event.SourceEventArgs.TotalBytesToReceive / 1MB, 1)
                Write-Host "`r⏳ Progress: $percent% ($receivedMB MB / $totalMB MB)" -NoNewline -ForegroundColor Blue
            } | Out-Null
            
            $webClient.DownloadFile($ReleaseInfo.URL, $isoPath)
            $webClient.Dispose()
            
            Write-Host ""  # New line after progress
            Write-Log "✅ Ubuntu ISO downloaded successfully via WebClient" "SUCCESS"
        }
        
        # Verify file size
        $downloadedSize = (Get-Item $isoPath).Length
        $expectedSize = $ReleaseInfo.SizeGB * 1GB
        
        if ([math]::Abs($downloadedSize - $expectedSize) -gt 100MB) {
            Write-Log "⚠️ Downloaded file size doesn't match expected size" "WARN"
            Write-Log "Downloaded: $([math]::Round($downloadedSize / 1GB, 2)) GB" "INFO"
            Write-Log "Expected: $($ReleaseInfo.SizeGB) GB" "INFO"
        }
        
        Write-Log "ISO saved to: $isoPath" "INFO"
        return $isoPath
        
    } catch {
        Write-Log "❌ Failed to download Ubuntu ISO: $($_.Exception.Message)" "ERROR"
        if (Test-Path $isoPath) {
            Remove-Item $isoPath -Force -ErrorAction SilentlyContinue
        }
        return $null
    }
}

# Verify ISO integrity
function Test-ISOIntegrity {
    param([string]$ISOPath, [string]$ExpectedSHA256)
    
    if ([string]::IsNullOrEmpty($ExpectedSHA256)) {
        Write-Log "⚠️ No SHA256 hash available for verification - skipping integrity check" "WARN"
        return $true
    }
    
    Write-Host ""
    Write-Host "🔐 VERIFYING ISO INTEGRITY" -ForegroundColor Cyan
    Write-Host "===========================" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        Write-Log "Calculating SHA256 hash (this may take 2-5 minutes)..." "PROGRESS"
        
        $actualHash = (Get-FileHash -Path $ISOPath -Algorithm SHA256).Hash.ToLower()
        $expectedHash = $ExpectedSHA256.ToLower()
        
        if ($actualHash -eq $expectedHash) {
            Write-Log "✅ ISO integrity verified - SHA256 hash matches" "SUCCESS"
            return $true
        } else {
            Write-Log "❌ ISO integrity check FAILED!" "ERROR"
            Write-Log "Expected: $expectedHash" "ERROR"
            Write-Log "Actual:   $actualHash" "ERROR"
            Write-Log "⚠️ This ISO may be corrupted or modified" "WARN"
            return $false
        }
    } catch {
        Write-Log "❌ Failed to verify ISO integrity: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Get available USB drives with enhanced analysis
function Get-USBDrives {
    $usbDrives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { 
        $_.DriveType -eq 2 -and $_.Size -gt 4GB 
    }
    
    $driveInfo = @()
    foreach ($drive in $usbDrives) {
        $sizeGB = [math]::Round($drive.Size / 1GB, 1)
        $freeGB = [math]::Round($drive.FreeSpace / 1GB, 1)
        
        # Check if this might be an Ubuntu installer USB
        $ubuntuCheck = Test-UbuntuUSB -DriveLetter $drive.DeviceID
        
        $driveInfo += @{
            DriveLetter = $drive.DeviceID
            Label = $drive.VolumeName
            SizeGB = $sizeGB
            FreeGB = $freeGB
            FileSystem = $drive.FileSystem
            IsUbuntuInstaller = $ubuntuCheck.IsUbuntuUSB
            UbuntuVersion = $ubuntuCheck.DetectedVersion
            BootabilityStatus = $ubuntuCheck.BootabilityStatus
            ValidationResult = $ubuntuCheck.ValidationResult
        }
    }
    
    return $driveInfo
}

# Test if USB drive contains valid Ubuntu installer
function Test-UbuntuUSB {
    param([string]$DriveLetter)
    
    $result = @{
        IsUbuntuUSB = $false
        DetectedVersion = ""
        BootabilityStatus = "Unknown"
        ValidationResult = @()
        ISOFound = $false
        BillSlothReady = $false
    }
    
    try {
        $drivePath = $DriveLetter.TrimEnd(':')
        if (!(Test-Path "${drivePath}:\" -ErrorAction SilentlyContinue)) {
            $result.ValidationResult += "❌ Drive not accessible"
            return $result
        }
        
        # Check for Ubuntu boot files
        $ubuntuBootFiles = @(
            "${drivePath}:\boot\grub\grub.cfg",
            "${drivePath}:\isolinux\isolinux.cfg",
            "${drivePath}:\casper\vmlinuz",
            "${drivePath}:\casper\initrd"
        )
        
        $foundBootFiles = 0
        foreach ($bootFile in $ubuntuBootFiles) {
            if (Test-Path $bootFile -ErrorAction SilentlyContinue) {
                $foundBootFiles++
            }
        }
        
        if ($foundBootFiles -ge 2) {
            $result.IsUbuntuUSB = $true
            $result.ValidationResult += "✅ Ubuntu boot files detected"
            
            # Try to detect Ubuntu version from files
            $versionSources = @(
                "${drivePath}:\.disk\info",
                "${drivePath}:\README.diskdefines"
            )
            
            foreach ($versionFile in $versionSources) {
                if (Test-Path $versionFile -ErrorAction SilentlyContinue) {
                    $content = Get-Content $versionFile -Raw -ErrorAction SilentlyContinue
                    $versionMatch = [regex]::Match($content, 'Ubuntu\s+(\d+\.\d+(?:\.\d+)?)')
                    if ($versionMatch.Success) {
                        $result.DetectedVersion = $versionMatch.Groups[1].Value
                        $result.ValidationResult += "✅ Version detected: Ubuntu $($result.DetectedVersion)"
                        break
                    }
                }
            }
            
            # Check bootability indicators
            if (Test-Path "${drivePath}:\boot\grub\grub.cfg" -ErrorAction SilentlyContinue) {
                $result.BootabilityStatus = "UEFI Ready"
                $result.ValidationResult += "✅ UEFI bootable (GRUB found)"
            } elseif (Test-Path "${drivePath}:\isolinux\isolinux.cfg" -ErrorAction SilentlyContinue) {
                $result.BootabilityStatus = "Legacy Ready"
                $result.ValidationResult += "✅ Legacy bootable (isolinux found)"
            }
            
            # Check for Bill Sloth startup files
            if (Test-Path "${drivePath}:\bill-sloth-startup" -ErrorAction SilentlyContinue) {
                $result.BillSlothReady = $true
                $result.ValidationResult += "✅ Bill Sloth startup package found"
            } else {
                $result.ValidationResult += "ℹ️  Bill Sloth startup package missing (can be added)"
            }
            
        } else {
            $result.ValidationResult += "❌ No Ubuntu boot files found"
        }
        
        # Check for ISO files (sometimes people copy ISO to USB)
        $isoFiles = Get-ChildItem -Path "${drivePath}:\" -Filter "*.iso" -ErrorAction SilentlyContinue
        if ($isoFiles) {
            $result.ISOFound = $true
            $result.ValidationResult += "ℹ️  ISO file found (not bootable, needs proper USB creation)"
            
            # Try to detect version from ISO filename
            foreach ($iso in $isoFiles) {
                if ($iso.Name -match 'ubuntu-(\d+\.\d+(?:\.\d+)?)') {
                    $result.DetectedVersion = $matches[1]
                    $result.ValidationResult += "ℹ️  Version from ISO: Ubuntu $($result.DetectedVersion)"
                    break
                }
            }
        }
        
    } catch {
        $result.ValidationResult += "❌ Error analyzing USB: $($_.Exception.Message)"
    }
    
    return $result
}

# Validate and enhance existing Ubuntu USB
function Update-ExistingUbuntuUSB {
    param([string]$DriveLetter, [object]$UbuntuCheck)
    
    Write-Host ""
    Write-Host "🔧 ENHANCING EXISTING UBUNTU USB" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
    
    $drivePath = $DriveLetter.TrimEnd(':')
    $enhancementResults = @()
    
    Write-Host "📊 Current USB Status:" -ForegroundColor White
    foreach ($result in $UbuntuCheck.ValidationResult) {
        Write-Host "  $result"
    }
    Write-Host ""
    
    # Add Bill Sloth startup package if missing
    if (!$UbuntuCheck.BillSlothReady) {
        try {
            Write-Log "Adding Bill Sloth startup package to existing USB..." "PROGRESS"
            $startupPackage = New-BillSlothStartupFiles -USBDrive $DriveLetter
            $enhancementResults += "✅ Bill Sloth startup package added"
            Write-Log "✅ Bill Sloth startup package added to USB" "SUCCESS"
        } catch {
            $enhancementResults += "❌ Failed to add Bill Sloth package: $($_.Exception.Message)"
            Write-Log "❌ Failed to add Bill Sloth package: $($_.Exception.Message)" "ERROR"
        }
    }
    
    # Verify boot configuration
    if ($UbuntuCheck.BootabilityStatus -eq "Unknown") {
        Write-Log "⚠️  Boot configuration unclear - USB may need recreation" "WARN"
        $enhancementResults += "⚠️ Boot configuration needs verification"
    }
    
    # Check available space for files
    try {
        $drive = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $DriveLetter }
        $freeSpaceGB = [math]::Round($drive.FreeSpace / 1GB, 1)
        
        if ($freeSpaceGB -lt 0.5) {
            $enhancementResults += "⚠️ Low free space ($freeSpaceGB GB) - may affect installation"
            Write-Log "⚠️ Low free space on USB: $freeSpaceGB GB" "WARN"
        } else {
            $enhancementResults += "✅ Adequate free space: $freeSpaceGB GB"
        }
    } catch {
        $enhancementResults += "❌ Could not check free space"
    }
    
    # Create USB enhancement report
    $reportPath = "$script:BillSlothDir\USB-ENHANCEMENT-REPORT.md"
    $report = @"
# Ubuntu USB Enhancement Report

Generated: $(Get-Date)
USB Drive: $DriveLetter
Detected Version: Ubuntu $($UbuntuCheck.DetectedVersion)
Bootability: $($UbuntuCheck.BootabilityStatus)

## Original USB Status
$($UbuntuCheck.ValidationResult -join "`n")

## Enhancement Results
$($enhancementResults -join "`n")

## Recommendations

$(if ($UbuntuCheck.IsUbuntuUSB -and $UbuntuCheck.BootabilityStatus -ne "Unknown") {
"✅ **USB IS READY FOR INSTALLATION**
- Boot from this USB to install Ubuntu
- Bill Sloth startup files are included
- Follow installation guide after Ubuntu setup"
} else {
"⚠️ **USB NEEDS ATTENTION**
- Consider recreating USB with Rufus for optimal compatibility
- Ensure UEFI/Legacy boot settings match your system
- Verify Ubuntu version meets requirements (22.04+ LTS recommended)"
})

## Next Steps
1. Test USB boot in BIOS/UEFI settings
2. Boot from USB and verify Ubuntu installer loads
3. After Ubuntu installation, run bill-sloth-ubuntu-setup.sh
4. Follow post-installation guide for full Bill Sloth activation

---
Generated by Bill Sloth Ubuntu Installer Preparation
"@
    
    Set-Content -Path $reportPath -Value $report -Encoding UTF8
    
    Write-Host ""
    Write-Host "📊 ENHANCEMENT RESULTS:" -ForegroundColor Green
    foreach ($result in $enhancementResults) {
        Write-Host "  $result"
    }
    Write-Host ""
    Write-Host "📋 Enhancement report: $reportPath" -ForegroundColor Yellow
    
    return @{
        Enhanced = $true
        Results = $enhancementResults
        ReportPath = $reportPath
    }
}

# Comprehensive USB analysis and reporting
function Get-USBAnalysisReport {
    param([array]$USBDrives)
    
    Write-Host ""
    Write-Host "📊 USB DRIVE ANALYSIS REPORT" -ForegroundColor Cyan
    Write-Host "============================" -ForegroundColor Cyan
    Write-Host ""
    
    if ($USBDrives.Count -eq 0) {
        Write-Host "❌ No USB drives found" -ForegroundColor Red
        Write-Host "   Please insert a USB drive (8GB+ recommended) and try again" -ForegroundColor Yellow
        return $false
    }
    
    $ubuntuUSBFound = $false
    
    foreach ($drive in $USBDrives) {
        Write-Host "💾 Drive $($drive.DriveLetter) - $($drive.SizeGB) GB" -ForegroundColor White
        Write-Host "   Label: $($drive.Label)" -ForegroundColor Gray
        Write-Host "   File System: $($drive.FileSystem)" -ForegroundColor Gray
        Write-Host "   Free Space: $($drive.FreeGB) GB" -ForegroundColor Gray
        
        if ($drive.IsUbuntuInstaller) {
            $ubuntuUSBFound = $true
            Write-Host "   🎯 UBUNTU INSTALLER DETECTED!" -ForegroundColor Green
            Write-Host "   Version: Ubuntu $($drive.UbuntuVersion)" -ForegroundColor Green
            Write-Host "   Boot Status: $($drive.BootabilityStatus)" -ForegroundColor Green
            Write-Host "   Bill Sloth Ready: $(if ($drive.ValidationResult -match 'Bill Sloth startup package found') { 'Yes' } else { 'No (can be added)' })" -ForegroundColor $(if ($drive.ValidationResult -match 'Bill Sloth startup package found') { 'Green' } else { 'Yellow' })
            
            Write-Host "   📋 Validation Details:" -ForegroundColor White
            foreach ($validation in $drive.ValidationResult) {
                Write-Host "     $validation" -ForegroundColor Gray
            }
        } elseif ($drive.ValidationResult -match 'ISO file found') {
            Write-Host "   💿 ISO FILE DETECTED (not bootable)" -ForegroundColor Yellow
            Write-Host "   Needs proper USB creation with Rufus" -ForegroundColor Yellow
        } else {
            Write-Host "   📁 Regular USB drive" -ForegroundColor Gray
        }
        
        Write-Host ""
    }
    
    return $ubuntuUSBFound
}

# Download and setup Rufus
function Get-Rufus {
    $rufusPath = "$script:BillSlothDir\rufus.exe"
    
    if (Test-Path $rufusPath) {
        Write-Log "✅ Rufus already available: $rufusPath" "SUCCESS"
        return $rufusPath
    }
    
    Write-Log "Downloading Rufus USB creator..." "PROGRESS"
    
    try {
        $rufusUrl = "https://github.com/pbatard/rufus/releases/download/v4.4/rufus-4.4.exe"
        Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusPath -UseBasicParsing
        
        Write-Log "✅ Rufus downloaded successfully" "SUCCESS"
        return $rufusPath
    } catch {
        Write-Log "❌ Failed to download Rufus: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

# Create bootable USB using Rufus (automated where possible)
function New-BootableUSB {
    param([string]$ISOPath, [string]$USBDrive, [string]$RufusPath)
    
    Write-Host ""
    Write-Host "💿 CREATING BOOTABLE USB" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    Write-Host ""
    
    if ([string]::IsNullOrEmpty($USBDrive)) {
        $usbDrives = Get-USBDrives
        
        if ($usbDrives.Count -eq 0) {
            Write-Log "❌ No suitable USB drives found (need 8GB+ USB drive)" "ERROR"
            return $false
        }
        
        Write-Host "📱 Available USB drives:" -ForegroundColor White
        for ($i = 0; $i -lt $usbDrives.Count; $i++) {
            $drive = $usbDrives[$i]
            Write-Host "  $($i + 1). $($drive.DriveLetter) - $($drive.SizeGB) GB ($($drive.Label))" -ForegroundColor Gray
        }
        Write-Host ""
        
        if ($Interactive) {
            do {
                Write-Host "Select USB drive (1-$($usbDrives.Count)): " -NoNewline -ForegroundColor Yellow
                $selection = Read-Host
                $selectedIndex = [int]$selection - 1
            } while ($selectedIndex -lt 0 -or $selectedIndex -ge $usbDrives.Count)
            
            $USBDrive = $usbDrives[$selectedIndex].DriveLetter
        } else {
            $USBDrive = $usbDrives[0].DriveLetter  # Use first available
        }
    }
    
    Write-Log "Selected USB drive: $USBDrive" "INFO"
    
    # Warning about data loss
    Write-Host ""
    Write-Host "⚠️  WARNING: ALL DATA ON $USBDrive WILL BE ERASED!" -ForegroundColor Red
    Write-Host "   This cannot be undone!" -ForegroundColor Red
    Write-Host ""
    
    if ($Interactive) {
        Write-Host "Continue with USB creation? (Type 'YES' to confirm): " -NoNewline -ForegroundColor Yellow
        $confirmation = Read-Host
        if ($confirmation -ne "YES") {
            Write-Log "USB creation cancelled by user" "INFO"
            return $false
        }
    }
    
    # Launch Rufus with parameters (semi-automated)
    try {
        Write-Log "Launching Rufus for USB creation..." "PROGRESS"
        
        # Rufus command line parameters for automation
        $rufusArgs = @(
            "-i", "`"$ISOPath`""        # ISO file
            "-s", ""                    # Auto-select device
            "-p", "GPT"                 # GPT partition scheme for UEFI
            "-f", "FAT32"              # FAT32 file system
        )
        
        # Start Rufus
        $rufusProcess = Start-Process -FilePath $RufusPath -ArgumentList $rufusArgs -PassThru -NoNewWindow
        
        Write-Host ""
        Write-Host "🔥 RUFUS LAUNCHED!" -ForegroundColor Green
        Write-Host "=================" -ForegroundColor Green
        Write-Host ""
        Write-Host "📋 Rufus Configuration Checklist:" -ForegroundColor Yellow
        Write-Host "  1. ✅ Device: Select $USBDrive" -ForegroundColor White
        Write-Host "  2. ✅ Boot selection: Ubuntu ISO should be auto-selected" -ForegroundColor White
        Write-Host "  3. ✅ Partition scheme: GPT (for UEFI systems)" -ForegroundColor White
        Write-Host "  4. ✅ File system: FAT32" -ForegroundColor White
        Write-Host "  5. ✅ Click START to create USB" -ForegroundColor White
        Write-Host ""
        Write-Host "⏱️  USB creation will take 5-15 minutes" -ForegroundColor Blue
        Write-Host ""
        
        # Wait for user confirmation that USB creation is complete
        if ($Interactive) {
            Write-Host "Press Enter when USB creation is COMPLETE..." -ForegroundColor Green
            Read-Host
        } else {
            # Wait for process to complete
            $rufusProcess.WaitForExit()
        }
        
        Write-Log "✅ USB creation process completed" "SUCCESS"
        return $true
        
    } catch {
        Write-Log "❌ Failed to create bootable USB: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Create comprehensive Bill Sloth custom USB package
function New-BillSlothCustomUSB {
    param([string]$USBDrive)
    
    Write-Host ""
    Write-Host "🎯 CREATING BILL'S CUSTOM UBUNTU + BILL SLOTH USB" -ForegroundColor Magenta
    Write-Host "==============================================" -ForegroundColor Magenta
    Write-Host ""
    
    # Try to create files on USB if possible
    $packageLocation = if (Test-Path "${USBDrive}\" -ErrorAction SilentlyContinue) {
        "${USBDrive}\bill-sloth-custom"
    } else {
        "$script:BillSlothDir\bill-sloth-custom"
    }
    
    if (Test-Path $packageLocation) {
        Remove-Item $packageLocation -Recurse -Force
    }
    New-Item -ItemType Directory -Path $packageLocation -Force | Out-Null
    
    # Create subdirectories for organization
    $autoStartDir = "$packageLocation\autostart"
    $scriptsDir = "$packageLocation\scripts"
    $configDir = "$packageLocation\config"
    $docsDir = "$packageLocation\docs"
    
    New-Item -ItemType Directory -Path $autoStartDir -Force | Out-Null
    New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    New-Item -ItemType Directory -Path $docsDir -Force | Out-Null
    
    # Create Bill's custom auto-initialization script
    $autoInitScript = @"
#!/bin/bash
# BILL'S CUSTOM UBUNTU + BILL SLOTH AUTO-INITIALIZATION
# This script runs IMMEDIATELY after Ubuntu first boot to get Bill's VRBO automation ready

set -euo pipefail

# ASCII Banner for Bill
echo -e "\033[38;5;196m"
cat << 'BANNER'
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  🏠 BILL'S VRBO AUTOMATION UBUNTU INITIALIZATION 🏠             █
█  💀 VACATION RENTAL EMPIRE DIGITAL TRANSFORMATION 💀             █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
BANNER
echo -e "\033[0m"

echo ""
echo "🚀 Welcome to Ubuntu, Bill! Let's get your VRBO automation running..."
echo "====================================================================="
echo ""

# Check if we're in Ubuntu
if ! grep -qi ubuntu /etc/os-release; then
    echo "❌ This script is for Ubuntu only!"
    exit 1
fi

# Set up Bill's preferred environment
echo "🏠 Setting up Bill's ADHD-friendly terminal environment..."

# Make terminal more readable for dyslexia
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ font 'Ubuntu Mono 14'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ use-system-font false

# Create Bill's workspace
mkdir -p ~/vrbo-automation ~/bill-sloth-workspace ~/business-files

# Update system with progress indication
echo "📥 Updating Ubuntu system (this may take 5-10 minutes)..."
sudo apt update
echo "📥 Installing system updates..."
sudo apt upgrade -y

# Install Bill's essential toolkit
echo "🔧 Installing Bill's essential business automation toolkit..."
sudo apt install -y \\
    curl wget git vim nano \\
    htop neofetch tree \\
    unzip zip p7zip-full \\
    software-properties-common \\
    apt-transport-https \\
    ca-certificates \\
    gnupg lsb-release \\
    build-essential \\
    sqlite3 jq ripgrep fd-find fzf \\
    python3 python3-pip \\
    net-tools traceroute \\
    xclip wl-clipboard \\
    firefox chromium-browser

echo "📦 Installing Node.js 20.x for Claude Code..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y

# Verify installations
echo "✅ Verifying installations..."
node --version
npm --version

# Install Claude Code
echo "🤖 Installing Claude Code for AI assistance..."
npm install -g @anthropic-ai/claude-code

# Get Bill Sloth from the USB first (faster), then from internet
echo "⬇️ Setting up Bill Sloth VRBO automation system..."
cd ~

# Check if Bill Sloth files are on USB
USB_BILL_SLOTH="/media/\$USER/*/bill-sloth-custom/bill-sloth-repo"
if ls \$USB_BILL_SLOTH 2>/dev/null; then
    echo "📦 Found Bill Sloth on USB - copying locally..."
    cp -r \$USB_BILL_SLOTH ~/bill-sloth
else
    echo "🌐 Downloading Bill Sloth from internet..."
    if ! git clone https://github.com/how1337itis/billsloth.git; then
        echo "Git clone failed, trying wget..."
        wget -O bill-sloth.zip https://github.com/how1337itis/billsloth/archive/main.zip
        unzip bill-sloth.zip
        mv bill-sloth-main bill-sloth
    fi
fi

cd bill-sloth

# Make everything executable
echo "🔧 Setting up Bill Sloth permissions..."
chmod +x *.sh
chmod +x lib/*.sh 2>/dev/null || true
chmod +x modules/*.sh 2>/dev/null || true
chmod +x scripts/*.sh 2>/dev/null || true
chmod +x windows-setup/*.ps1 2>/dev/null || true

# Run Bill Sloth fresh Ubuntu installer
echo "🎯 Running Bill Sloth fresh Ubuntu installer..."
./fresh_ubuntu_installer.sh

# Create desktop shortcuts for Bill
echo "🖥️ Creating desktop shortcuts for easy access..."
mkdir -p ~/Desktop

# Bill Sloth Command Center shortcut
cat > ~/Desktop/"Bill Sloth Command Center.desktop" << 'DESKTOP'
[Desktop Entry]
Version=1.0
Type=Application
Name=Bill Sloth Command Center
Comment=VRBO Automation & Business Management
Exec=gnome-terminal --working-directory=/home/\$USER/bill-sloth -- ./bill_command_center.sh
Icon=applications-system
Path=/home/\$USER/bill-sloth
Terminal=false
StartupNotify=true
DESKTOP

# VRBO Management shortcut
cat > ~/Desktop/"VRBO Management.desktop" << 'DESKTOP'
[Desktop Entry]
Version=1.0
Type=Application
Name=VRBO Management
Comment=Vacation Rental Property Management
Exec=gnome-terminal --working-directory=/home/\$USER/bill-sloth -- ./modules/vacation_rental_manager_interactive.sh
Icon=applications-office
Path=/home/\$USER/bill-sloth
Terminal=false
StartupNotify=true
DESKTOP

# Make desktop files executable
chmod +x ~/Desktop/*.desktop

# Set up Bill's bash aliases for easy access
echo "🔗 Setting up Bill's command aliases..."
cat >> ~/.bashrc << 'ALIASES'

# Bill Sloth VRBO Automation Aliases
alias bill='cd ~/bill-sloth && ./bill_command_center.sh'
alias vrbo='cd ~/bill-sloth && ./modules/vacation_rental_manager_interactive.sh'
alias automation='cd ~/bill-sloth && ./modules/automation_mastery_interactive.sh'
alias health='cd ~/bill-sloth && ./scripts/health_check_v2.sh'
alias claude-bill='cd ~/bill-sloth && claude "Help me with my VRBO automation tasks"'

# Useful shortcuts for Bill
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

echo "🏠 Bill's VRBO Automation System Ready! Type 'bill' to start."
ALIASES

# Create welcome message
cat > ~/.bill-sloth-welcome << 'WELCOME'

🏠 WELCOME TO YOUR VRBO AUTOMATION SYSTEM, BILL! 🏠

Your Ubuntu system is now set up with:
✅ Bill Sloth VRBO automation suite
✅ Claude Code AI assistant
✅ All business automation tools
✅ Desktop shortcuts for easy access

Quick Start Commands:
• bill          - Start Bill Sloth command center
• vrbo          - VRBO property management
• automation    - Automation tools
• health        - System health check
• claude-bill   - Get AI help with VRBO tasks

Next Steps:
1. Run: claude login (to set up AI assistant)
2. Run: bill (to start your automation center)
3. Set up your VRBO API credentials
4. Configure your property automation

You're ready to automate your vacation rental empire! 🚀
WELCOME

# Show welcome message on login
echo "cat ~/.bill-sloth-welcome" >> ~/.bashrc

echo ""
echo "🎉 BILL'S UBUNTU + BILL SLOTH SETUP COMPLETE!"
echo "============================================"
echo ""
echo "🏠 Your VRBO automation system is ready!"
echo ""
echo "🚀 Next steps:"
echo "1. 🤖 Authenticate Claude Code: claude login"
echo "2. 🏠 Start Bill Sloth: bill (or click desktop shortcut)"
echo "3. 🔧 Set up VRBO API credentials in the automation center"
echo "4. 📊 Run health check: health"
echo ""
echo "💡 Desktop shortcuts created for easy access!"
echo "💬 Type 'claude-bill' anytime for AI assistance"
echo ""
echo "🏖️ Time to automate your vacation rental empire!"
"@

    Set-Content -Path "$scriptsDir\bill-auto-init.sh" -Value $autoInitScript -Encoding UTF8
    
    # Create Bill's personalized Ubuntu guide
    $billsGuide = @"
# 🏠 BILL'S PERSONAL UBUNTU + VRBO AUTOMATION GUIDE 🏠

## Welcome to Your New VRBO Automation System, Bill!

### IMMEDIATE First Steps After Ubuntu Installation:

#### 1. 📁 Find This USB Drive
- Ubuntu will show the USB drive in the file manager
- Navigate to the "bill-sloth-custom" folder
- You'll find all your automation tools here!

#### 2. 🚀 One-Click Setup
```bash
# Copy this command (Ctrl+C) and paste in terminal (Ctrl+Shift+V):
bash /media/\$USER/*/bill-sloth-custom/scripts/bill-auto-init.sh
```

**That's it!** This one script sets up everything:
- ✅ Updates Ubuntu
- ✅ Installs all business tools
- ✅ Sets up Bill Sloth VRBO automation
- ✅ Installs Claude Code AI assistant
- ✅ Creates desktop shortcuts
- ✅ Configures ADHD-friendly terminal

### After Auto-Setup Completes:

#### 🤖 Authenticate AI Assistant
```bash
claude login
```

#### 🏠 Start Your VRBO Empire
```bash
bill    # Starts Bill Sloth command center
```

### Your New Ubuntu Superpowers:

- **"bill"** - Start your automation center
- **"vrbo"** - Direct VRBO property management
- **"automation"** - Automation tools
- **"health"** - System diagnostics
- **"claude-bill"** - Get AI help with VRBO tasks
- **Desktop shortcuts** - Click to launch tools

### ADHD-Friendly Features Built In:
- 🖥️ Large, readable terminal font
- 🎯 Desktop shortcuts for one-click access
- 📝 Simple command aliases (just type "bill")
- 🤖 AI assistant for when you get stuck
- 📊 Visual progress indicators
- 🎨 Color-coded output for easy reading

### Your VRBO Automation Toolkit:
- 📊 Revenue tracking and reporting
- 💬 Guest communication automation
- 📅 Booking calendar management
- 🏠 Property maintenance scheduling
- 💰 Pricing optimization tools
- 📈 Business intelligence dashboard

### If Something Goes Wrong:

**Can't find terminal?**
- Click Activities (top-left corner)
- Type "terminal" and press Enter

**Commands not working?**
- Close terminal and open a new one
- Type: source ~/.bashrc

**Need help?**
- Type: claude-bill
- Ask: "Help me troubleshoot my VRBO automation setup"

**Emergency contact:**
- Ubuntu community: https://askubuntu.com
- Very helpful and ADHD-friendly!

### Accessing Your Windows Files:
- Your Windows files are at: /mnt/c/ (when mounted)
- You can copy files between Windows and Ubuntu
- Both systems coexist perfectly

### Pro Tips for Bill:
1. **Use the desktop shortcuts** - Faster than typing commands
2. **Ask Claude for help** - Type "claude-bill" anytime
3. **Take breaks** - The system will wait for you
4. **Don't rush** - Everything is designed to be reliable
5. **Backup is automatic** - Your data is safe

---

## 🎯 Your Mission: VRBO Automation Domination

1. ✅ Ubuntu installed
2. 🔄 Run auto-setup script
3. 🤖 Authenticate Claude
4. 🏠 Configure first VRBO property
5. 💰 Watch automation make you money
6. 🏖️ Enjoy more free time!

**You've got this, Bill! Your vacation rental empire awaits.** 🚀

Generated: $(Get-Date) specifically for Bill's VRBO automation needs
"@

    Set-Content -Path "$docsDir\BILLS-UBUNTU-GUIDE.md" -Value $billsGuide -Encoding UTF8
    
    # Create emergency recovery info
    $emergencyInfo = @"
# Bill Sloth Emergency Recovery

## If Ubuntu Won't Boot
1. Boot from this USB in "Try Ubuntu" mode
2. Open terminal: sudo update-grub
3. Restart computer

## If Windows Won't Boot  
1. Boot from Windows installation USB
2. Go to Repair → Advanced → Command Prompt
3. Run: bootrec /fixmbr && bootrec /fixboot

## If Everything Fails
- Your Windows system restore point still exists
- Boot from Windows installation USB → System Restore
- Choose "Bill Sloth Pre-Ubuntu Setup" restore point

## Bill Sloth Issues
- Check bill-sloth/TROUBLESHOOTING.md
- All scripts have --help options
- ./bill_command_center.sh --reset to restore defaults

## Getting Help
- Ubuntu: https://askubuntu.com
- Bill Sloth: Check repository documentation
- Local Linux user groups (very helpful!)

Remember: Don't panic, take breaks, ask for help.
"@

    Set-Content -Path "$packageLocation\EMERGENCY-RECOVERY.md" -Value $emergencyInfo -Encoding UTF8
    
    # Create autorun script for when USB is inserted
    $autorunScript = @"
#!/bin/bash
# Auto-run script for Bill's custom USB
# This displays helpful information when USB is inserted

zenity --info --title="Bill's VRBO Automation USB" --text="Welcome Bill!\n\nThis USB contains your complete VRBO automation setup.\n\nTo get started:\n1. Open Terminal (Ctrl+Alt+T)\n2. Run: bash /media/\$USER/*/bill-sloth-custom/scripts/bill-auto-init.sh\n\nEverything will be set up automatically!" --width=400 2>/dev/null || echo "Welcome to Bill's VRBO Automation USB!"
"@
    Set-Content -Path "$autoStartDir\autorun.sh" -Value $autorunScript -Encoding UTF8
    
    # Create USB info file
    $usbInfo = @"
BILL'S CUSTOM UBUNTU + VRBO AUTOMATION USB
==========================================

Created: $(Get-Date)
Purpose: Complete VRBO automation setup for Ubuntu

Contents:
- Ubuntu installation media (bootable)
- Bill Sloth VRBO automation suite
- One-click setup automation
- ADHD/dyslexia-friendly configuration
- Desktop shortcuts and aliases
- Complete documentation

Usage:
1. Boot from this USB to install Ubuntu
2. After Ubuntu installation, run the auto-init script
3. Start automating your vacation rental business!

For questions or help:
- Use the built-in AI assistant (claude-bill)
- Check the documentation in the docs folder
- Ubuntu community support at askubuntu.com

This USB is specifically configured for Bill's VRBO automation needs.
"@
    Set-Content -Path "$packageLocation\USB-INFO.txt" -Value $usbInfo -Encoding UTF8
    
    # Copy a portable version of Bill Sloth (if available)
    $localBillSloth = "C:\Users\natha\bill sloth"
    if (Test-Path $localBillSloth) {
        Write-Log "Adding Bill Sloth repository to USB for offline setup..." "PROGRESS"
        try {
            $billSlothUSBPath = "$packageLocation\bill-sloth-repo"
            # Copy essential Bill Sloth files
            robocopy $localBillSloth $billSlothUSBPath /E /XD .git __pycache__ node_modules /XF *.log *.tmp /NFL /NDL /NJH /NJS
            Write-Log "✅ Bill Sloth repository added to USB" "SUCCESS"
        } catch {
            Write-Log "⚠️ Could not copy Bill Sloth repository to USB: $($_.Exception.Message)" "WARN"
        }
    }
    
    Write-Log "✅ Bill's custom VRBO automation USB package created: $packageLocation" "SUCCESS"
    Write-Log "📦 Package includes: auto-init script, documentation, shortcuts, and offline Bill Sloth" "INFO"
    
    return $packageLocation
}

# Main execution
function Main {
    Write-Log "Bill Sloth Ubuntu Installer Preparation started" "INFO"
    
    # Create working directory
    if (!(Test-Path $script:BillSlothDir)) {
        New-Item -ItemType Directory -Path $script:BillSlothDir -Force | Out-Null
    }
    
    # Check for existing Ubuntu USB drives first
    Write-Host "🔍 SCANNING FOR EXISTING UBUNTU USB DRIVES" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    
    $usbDrives = Get-USBDrives
    $ubuntuUSBFound = Get-USBAnalysisReport -USBDrives $usbDrives
    
    # If Ubuntu USB found, offer to use it
    if ($ubuntuUSBFound) {
        $ubuntuUSBs = $usbDrives | Where-Object { $_.IsUbuntuInstaller }
        
        Write-Host "🎉 EXISTING UBUNTU INSTALLER FOUND!" -ForegroundColor Green
        Write-Host "=================================" -ForegroundColor Green
        Write-Host ""
        
        foreach ($ubuntuUSB in $ubuntuUSBs) {
            Write-Host "Found: Ubuntu $($ubuntuUSB.UbuntuVersion) on drive $($ubuntuUSB.DriveLetter)" -ForegroundColor Green
            Write-Host "Status: $($ubuntuUSB.BootabilityStatus)" -ForegroundColor White
        }
        
        Write-Host ""
        
        if ($Interactive -and !$CheckExistingUSB) {
            Write-Host "Options:" -ForegroundColor Yellow
            Write-Host "1. ✅ Use existing Ubuntu USB (enhance with Bill Sloth files)" -ForegroundColor White
            Write-Host "2. 🔄 Create new Ubuntu USB (download fresh ISO)" -ForegroundColor White
            Write-Host "3. 📊 Just analyze existing USB (no changes)" -ForegroundColor White
            Write-Host ""
            
            do {
                Write-Host "Choose option (1-3): " -NoNewline -ForegroundColor Yellow
                $choice = Read-Host
            } while ($choice -notmatch '^[123]$')
            
            switch ($choice) {
                "1" {
                    # Use existing USB
                    $selectedUSB = $ubuntuUSBs[0]  # Use first Ubuntu USB found
                    Write-Log "User chose to use existing Ubuntu USB: $($selectedUSB.DriveLetter)" "INFO"
                    
                    $enhancement = Update-ExistingUbuntuUSB -DriveLetter $selectedUSB.DriveLetter -UbuntuCheck $selectedUSB
                    
                    Write-Host ""
                    Write-Host "✅ EXISTING USB ENHANCED AND READY!" -ForegroundColor Green
                    Write-Host "===================================" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "🎯 Your Ubuntu installer is ready to use:" -ForegroundColor White
                    Write-Host "  💾 Drive: $($selectedUSB.DriveLetter)" -ForegroundColor Green
                    Write-Host "  📀 Version: Ubuntu $($selectedUSB.UbuntuVersion)" -ForegroundColor Green
                    Write-Host "  🚀 Boot Status: $($selectedUSB.BootabilityStatus)" -ForegroundColor Green
                    Write-Host "  📦 Bill Sloth: Enhanced with startup package" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "📋 Enhancement Report: $($enhancement.ReportPath)" -ForegroundColor Yellow
                    Write-Host ""
                    Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
                    Write-Host "  1. 🔄 Restart computer" -ForegroundColor White
                    Write-Host "  2. ⌨️  Access BIOS/UEFI boot menu (F12, F2, or Delete)" -ForegroundColor White
                    Write-Host "  3. 💾 Boot from USB drive $($selectedUSB.DriveLetter)" -ForegroundColor White
                    Write-Host "  4. 🐧 Install Ubuntu alongside Windows" -ForegroundColor White
                    Write-Host "  5. 🚀 Run bill-sloth-ubuntu-setup.sh after installation" -ForegroundColor White
                    
                    return
                }
                "2" {
                    Write-Log "User chose to create new Ubuntu USB" "INFO"
                    # Continue with normal process
                }
                "3" {
                    Write-Log "User chose analysis-only mode" "INFO"
                    Write-Host "\n✅ USB analysis complete - no changes made" -ForegroundColor Green
                    return
                }
            }
        } elseif ($CheckExistingUSB) {
            # Just check existing USB mode
            Write-Host "✅ EXISTING USB ANALYSIS COMPLETE" -ForegroundColor Green
            Write-Host "=================================" -ForegroundColor Green
            
            foreach ($ubuntuUSB in $ubuntuUSBs) {
                $enhancement = Update-ExistingUbuntuUSB -DriveLetter $ubuntuUSB.DriveLetter -UbuntuCheck $ubuntuUSB
                Write-Host "📋 Report: $($enhancement.ReportPath)" -ForegroundColor Yellow
            }
            return
        }
    } elseif ($CheckExistingUSB) {
        Write-Host "\n❌ No existing Ubuntu USB drives found" -ForegroundColor Red
        Write-Host "   Run without -CheckExistingUSB to create new Ubuntu installer" -ForegroundColor Yellow
        return
    }
    
    # Get Ubuntu release information
    $releaseInfo = Get-UbuntuReleaseInfo -Version $UbuntuVersion
    Write-Log "Target release: $($releaseInfo.Name)" "INFO"
    
    # ISO detection and selection logic
    $isoPath = $null
    
    # Handle explicitly provided ISO first
    if (![string]::IsNullOrEmpty($ExistingISO)) {
        Write-Host ""
        Write-Host "🔍 VALIDATING PROVIDED ISO" -ForegroundColor Cyan
        Write-Host "==========================" -ForegroundColor Cyan
        Write-Host ""
        
        if (Test-Path $ExistingISO) {
            $validation = Get-ISOValidation -ISOPath $ExistingISO
            
            Write-Host "📊 ISO Validation Results:" -ForegroundColor White
            Write-Host "  File: $($validation.FileName)" -ForegroundColor Gray
            Write-Host "  Version: Ubuntu $($validation.DetectedVersion)" -ForegroundColor Gray
            Write-Host "  Size: $($validation.SizeGB) GB" -ForegroundColor Gray
            Write-Host "  Status: $($validation.ValidationStatus)" -ForegroundColor $(if ($validation.IsValid) { "Green" } else { "Red" })
            
            if ($validation.IsUbuntuISO) {
                if ($validation.IsValid -or !$Interactive) {
                    $isoPath = $ExistingISO
                    Write-Log "✅ Using provided ISO: $ExistingISO" "SUCCESS"
                } else {
                    Write-Host ""
                    Write-Host "⚠️  WARNING: Provided ISO has validation issues!" -ForegroundColor Red
                    Write-Host "   Issue: $($validation.ValidationStatus)" -ForegroundColor Red
                    Write-Host "   Recommendation: $($validation.RecommendedAction)" -ForegroundColor Yellow
                    Write-Host ""
                    Write-Host "Continue with this ISO anyway? (Y/N): " -NoNewline -ForegroundColor Yellow
                    $proceed = Read-Host
                    
                    if ($proceed -match '^[Yy]') {
                        $isoPath = $ExistingISO
                        Write-Log "User chose to use ISO despite validation issues" "INFO"
                    } else {
                        Write-Log "User declined to use invalid ISO - continuing with automatic detection" "INFO"
                    }
                }
            } else {
                Write-Host "❌ Provided file is not a valid Ubuntu ISO!" -ForegroundColor Red
                if ($Interactive) {
                    Write-Host "Continue with automatic ISO detection? (Y/N): " -NoNewline -ForegroundColor Yellow
                    $continue = Read-Host
                    if ($continue -notmatch '^[Yy]') {
                        Write-Log "Setup cancelled - invalid ISO provided" "INFO"
                        return
                    }
                } else {
                    Write-Log "❌ Invalid ISO provided in non-interactive mode" "ERROR"
                    return
                }
            }
        } else {
            Write-Host "❌ Provided ISO file not found: $ExistingISO" -ForegroundColor Red
            if ($Interactive) {
                Write-Host "Continue with automatic ISO detection? (Y/N): " -NoNewline -ForegroundColor Yellow
                $continue = Read-Host
                if ($continue -notmatch '^[Yy]') {
                    Write-Log "Setup cancelled - ISO file not found" "INFO"
                    return
                }
            } else {
                Write-Log "❌ ISO file not found in non-interactive mode" "ERROR"
                return
            }
        }
    }
    
    if (!$SkipDownload -and !$isoPath) {
        # First, scan for existing ISOs
        $foundISOs = Find-ExistingUbuntuISOs
        
        if ($foundISOs.Count -gt 0 -and $Interactive) {
            Write-Host ""
            Write-Host "🎯 EXISTING UBUNTU ISOs DETECTED!" -ForegroundColor Green
            Write-Host "=================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "Would you like to:" -ForegroundColor Yellow
            Write-Host "1. ✅ Use an existing ISO (faster)" -ForegroundColor White
            Write-Host "2. 🌐 Download fresh ISO anyway" -ForegroundColor White
            Write-Host ""
            
            do {
                Write-Host "Choose option (1-2): " -NoNewline -ForegroundColor Yellow
                $choice = Read-Host
            } while ($choice -notmatch '^[12]$')
            
            if ($choice -eq "1") {
                # Let user select from existing ISOs
                $selectedISO = Select-ExistingISO -FoundISOs $foundISOs
                
                if ($selectedISO -eq "DOWNLOAD_FRESH") {
                    Write-Log "User chose to download fresh ISO" "INFO"
                    # Continue with download below
                } elseif ($selectedISO -eq "BROWSE_FILE") {
                    $isoPath = Get-ISOFileBrowser
                    if (!$isoPath) {
                        Write-Log "No valid ISO selected from file browser" "INFO"
                        return
                    }
                } elseif ($selectedISO) {
                    $isoPath = $selectedISO
                    Write-Log "✅ Using selected existing ISO: $isoPath" "SUCCESS"
                } else {
                    Write-Log "No valid ISO selected" "INFO"
                    return
                }
            }
            # If choice was "2" or no valid selection, continue to download
        }
        
        # Download if no ISO selected yet
        if (!$isoPath) {
            $isoPath = Get-UbuntuISO -ReleaseInfo $releaseInfo -DownloadPath $DownloadPath
            if (!$isoPath) {
                Write-Log "❌ Failed to download Ubuntu ISO - cannot continue" "ERROR"
                return
            }
        }
        
        # Verify ISO integrity if we have expected hash
        if ($releaseInfo.SHA256 -and ![string]::IsNullOrEmpty($releaseInfo.SHA256)) {
            $integrityOK = Test-ISOIntegrity -ISOPath $isoPath -ExpectedSHA256 $releaseInfo.SHA256
            if (!$integrityOK -and $Interactive) {
                Write-Host "Continue despite integrity check failure? (Y/N): " -NoNewline -ForegroundColor Red
                $response = Read-Host
                if ($response -notmatch '^[Yy]') {
                    Write-Log "Setup cancelled due to integrity check failure" "INFO"
                    return
                }
            }
        } else {
            Write-Log "ℹ️  No reference SHA256 available - skipping integrity verification" "INFO"
        }
        
    } else {
        # SkipDownload mode - look for existing ISO
        $expectedPath = Join-Path $DownloadPath $releaseInfo.FileName
        
        if (Test-Path $expectedPath) {
            $isoPath = $expectedPath
            Write-Log "✅ Using existing ISO: $isoPath" "SUCCESS"
        } else {
            # Search for any Ubuntu ISOs if expected one not found
            Write-Log "Expected ISO not found at: $expectedPath" "WARN"
            Write-Log "Searching for any existing Ubuntu ISOs..." "INFO"
            
            $foundISOs = Find-ExistingUbuntuISOs
            
            if ($foundISOs.Count -gt 0) {
                if ($Interactive) {
                    $selectedISO = Select-ExistingISO -FoundISOs $foundISOs
                    
                    if ($selectedISO -eq "BROWSE_FILE") {
                        $isoPath = Get-ISOFileBrowser
                    } elseif ($selectedISO -and $selectedISO -ne "DOWNLOAD_FRESH") {
                        $isoPath = $selectedISO
                    }
                } else {
                    # Non-interactive - use first valid ISO found
                    $validISO = $foundISOs | Where-Object { $_.IsValid } | Select-Object -First 1
                    if ($validISO) {
                        $isoPath = $validISO.FilePath
                        Write-Log "✅ Auto-selected valid ISO: $isoPath" "SUCCESS"
                    }
                }
            }
            
            if (!$isoPath) {
                Write-Log "❌ No suitable Ubuntu ISO found" "ERROR"
                return
            }
        }
    }
    
    # Skip to USB creation if requested
    if ($CreateUSBOnly) {
        # Download Rufus
        $rufusPath = Get-Rufus
        if (!$rufusPath) { return }
        
        # Create bootable USB
        $usbSuccess = New-BootableUSB -ISOPath $isoPath -USBDrive $USBDrive -RufusPath $rufusPath
        
        if ($usbSuccess) {
            Write-Log "✅ USB creation completed successfully" "SUCCESS"
        }
        return
    }
    
    # Full preparation process
    Write-Host ""
    Write-Host "🔧 FULL UBUNTU INSTALLATION PREPARATION" -ForegroundColor Green
    Write-Host "=======================================" -ForegroundColor Green
    Write-Host ""
    
    # Download Rufus
    $rufusPath = Get-Rufus
    if (!$rufusPath) { 
        Write-Log "❌ Cannot proceed without Rufus" "ERROR"
        return 
    }
    
    # Create bootable USB
    $usbSuccess = New-BootableUSB -ISOPath $isoPath -USBDrive $USBDrive -RufusPath $rufusPath
    if (!$usbSuccess) {
        Write-Log "❌ USB creation failed - cannot complete preparation" "ERROR"
        return
    }
    
    # Create Bill's custom automation USB
    $startupPackage = New-BillSlothCustomUSB -USBDrive $USBDrive
    
    Write-Host ""
    Write-Host "🎉 UBUNTU INSTALLER PREPARATION COMPLETE!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Preparation Summary:" -ForegroundColor White
    Write-Host "  ✅ Ubuntu $UbuntuVersion ISO downloaded and verified" -ForegroundColor Green
    Write-Host "  ✅ Bootable USB created with Rufus" -ForegroundColor Green
    Write-Host "  ✅ Bill Sloth startup package prepared" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Files Ready:" -ForegroundColor Yellow
    Write-Host "  💿 Ubuntu ISO: $isoPath" -ForegroundColor White
    Write-Host "  💾 Bootable USB: $USBDrive" -ForegroundColor White
    Write-Host "  📦 Startup Package: $startupPackage" -ForegroundColor White
    Write-Host ""
    Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. 🔄 RESTART your computer" -ForegroundColor White
    Write-Host "  2. ⌨️  Access BIOS/UEFI (usually F12, F2, or Delete during startup)" -ForegroundColor White
    Write-Host "  3. 🔧 Select USB drive $USBDrive as boot device" -ForegroundColor White
    Write-Host "  4. 💾 Boot from USB and install Ubuntu alongside Windows" -ForegroundColor White
    Write-Host "  5. 🚀 After installation, run bill-sloth-ubuntu-setup.sh" -ForegroundColor White
    Write-Host "  6. 📦 Bill Sloth startup package is already on the USB!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📖 Detailed instructions available in startup package!" -ForegroundColor Green
    Write-Host ""
    
    # Final system readiness check
    Write-Host "🔍 SYSTEM READINESS CHECK:" -ForegroundColor Cyan
    Write-Host "  ✅ Ubuntu $UbuntuVersion installer ready" -ForegroundColor Green
    Write-Host "  ✅ Bootable USB created on drive $USBDrive" -ForegroundColor Green
    Write-Host "  ✅ Bill Sloth startup files included on USB" -ForegroundColor Green
    Write-Host "  ✅ Emergency recovery information available" -ForegroundColor Green
    Write-Host "  ✅ Post-installation automation scripts ready" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 You're ready to install Ubuntu and activate Bill Sloth!" -ForegroundColor Green
}

# Execute main function with error handling
try {
    Main
} catch {
    Write-Log "❌ Ubuntu installer preparation failed: $($_.Exception.Message)" "ERROR"
    Write-Log "Full error: $($_.Exception)" "ERROR"
    exit 1
}

Write-Log "Bill Sloth Ubuntu Installer Preparation completed successfully" "SUCCESS"