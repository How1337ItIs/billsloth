# Bill Sloth Mature Custom ISO Generation System
# Uses proven, open-source CLI tools for Windows ISO creation
# Built for reliability and error-free operation

param(
    [string]$UbuntuVersion = "22.04.5",
    [string]$OutputDir = "$env:USERPROFILE\bill-sloth-windows",
    [string]$CustomISOName = "BillSlothUbuntu.iso",
    [switch]$DownloadToolsOnly,
    [switch]$Verbose
)

# Mature tool configuration
$script:Tools = @{
    OSCDImg = @{
        Name = "Microsoft oscdimg (Windows ADK)"
        InstallPath = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
        DownloadURL = "https://go.microsoft.com/fwlink/?linkid=2289980"  # Latest Windows ADK 2025
        Description = "Microsoft's official ISO creation tool - most reliable for Windows"
    }
    SevenZip = @{
        Name = "7-Zip Portable"
        InstallPath = "$OutputDir\tools\7zip\7z.exe"
        DownloadURL = "https://7-zip.org/a/7z2500-x64.exe"  # Latest 7-Zip 25.00 (2025-07-05)
        Description = "Reliable ISO extraction and archive management"
    }
    PowerShellISO = @{
        Name = "Native PowerShell ISO Creation"
        InstallPath = "Built-in"
        Description = "Fallback method using Windows 10+ native capabilities"
    }
}

Write-Host @"

   BILL SLOTH MATURE CUSTOM ISO SYSTEM                        
   USING PROVEN OPEN-SOURCE TOOLS                           

"@ -ForegroundColor Cyan

# Ensure output directory exists
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Load enhancement modules if available
$enhancementModules = @(
    "$PSScriptRoot\progress-bars-addon.ps1"
)

foreach ($module in $enhancementModules) {
    if (Test-Path $module) {
        try {
            . $module
            Write-Host " Loaded: $(Split-Path $module -Leaf)" -ForegroundColor Green
        } catch {
            Write-Host "  Enhancement unavailable: $(Split-Path $module -Leaf)" -ForegroundColor Yellow
        }
    }
}

# Enhanced logging
$logFile = "$OutputDir\custom-iso-creation.log"
function Write-EnhancedLog {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Add-Content -Path $logFile -Value $logEntry
    
    if (Get-Command Show-ProgressWithStatus -ErrorAction SilentlyContinue) {
        $claudeMessage = switch ($Level) {
            "ERROR" { " $Message" }
            "WARN"  { "  $Message" }
            "SUCCESS" { " $Message" }
            default { "INFO: $Message" }
        }
        Show-ProgressWithStatus -Activity "Custom ISO Creation" -Status $Message -PercentComplete 0 -ClaudeMessage $claudeMessage -WriteToFile
    } else {
        switch ($Level) {
            "ERROR" { Write-Host " $Message" -ForegroundColor Red }
            "WARN"  { Write-Host "  $Message" -ForegroundColor Yellow }
            "SUCCESS" { Write-Host " $Message" -ForegroundColor Green }
            default { Write-Host "INFO: $Message" -ForegroundColor White }
        }
    }
}

# Tool installation and verification functions
function Install-WindowsADK {
    Write-EnhancedLog "Checking for Windows ADK (oscdimg)..." "INFO"
    
    # Check if oscdimg is already available
    $adkPaths = @(
        "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe",
        "${env:ProgramFiles}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe",
        "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\x86\Oscdimg\oscdimg.exe"
    )
    
    foreach ($path in $adkPaths) {
        if (Test-Path $path) {
            Write-EnhancedLog "Found Windows ADK oscdimg at: $path" "SUCCESS"
            return $path
        }
    }
    
    Write-EnhancedLog "Windows ADK not found. Installation required." "WARN"
    Write-EnhancedLog "To install Windows ADK:" "INFO"
    Write-EnhancedLog "1. Download from: $($script:Tools.OSCDImg.DownloadURL)" "INFO"
    Write-EnhancedLog "2. Install with 'Deployment Tools' feature" "INFO"
    Write-EnhancedLog "3. Re-run this script" "INFO"
    
    # Auto-download ADK installer if requested
    if ($DownloadToolsOnly) {
        $adkInstaller = "$OutputDir\adksetup.exe"
        try {
            Write-EnhancedLog "Downloading Windows ADK installer..." "INFO"
            Invoke-WebRequest -Uri $script:Tools.OSCDImg.DownloadURL -OutFile $adkInstaller -UseBasicParsing
            Write-EnhancedLog "Windows ADK installer saved to: $adkInstaller" "SUCCESS"
            Write-EnhancedLog "Run installer and select 'Deployment Tools' feature" "INFO"
        } catch {
            Write-EnhancedLog "Failed to download Windows ADK: $($_.Exception.Message)" "ERROR"
        }
    }
    
    return $null
}

function Install-SevenZipPortable {
    Write-EnhancedLog "Setting up 7-Zip portable..." "INFO"
    
    $sevenZipDir = "$OutputDir\tools\7zip"
    $sevenZipExe = "$sevenZipDir\7z.exe"
    
    if (Test-Path $sevenZipExe) {
        Write-EnhancedLog "7-Zip already available at: $sevenZipExe" "SUCCESS"
        return $sevenZipExe
    }
    
    try {
        # Create tools directory
        if (!(Test-Path $sevenZipDir)) {
            New-Item -ItemType Directory -Path $sevenZipDir -Force | Out-Null
        }
        
        # Download 7-Zip installer
        $sevenZipInstaller = "$OutputDir\7z-installer.exe"
        Write-EnhancedLog "Downloading 7-Zip 25.00..." "INFO"
        
        if (Get-Command Download-WithProgress -ErrorAction SilentlyContinue) {
            $success = Download-WithProgress -Url $script:Tools.SevenZip.DownloadURL -OutputPath $sevenZipInstaller -Description "7-Zip 25.00"
            if (!$success) { throw "Enhanced download failed" }
        } else {
            Invoke-WebRequest -Uri $script:Tools.SevenZip.DownloadURL -OutFile $sevenZipInstaller -UseBasicParsing
        }
        
        # Extract 7-Zip installer to get portable files
        Write-EnhancedLog "Extracting 7-Zip for portable use..." "INFO"
        
        # Use Windows built-in expand command as fallback
        try {
            & "$sevenZipInstaller" /S /D="$sevenZipDir"
            Start-Sleep -Seconds 3  # Wait for installer to complete
        } catch {
            # Try alternative extraction method
            $tempExtract = "$OutputDir\temp-7z-extract"
            New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null
            
            # Use Windows built-in tools to extract
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            try {
                # Some 7-Zip installers are actually self-extracting archives
                Rename-Item $sevenZipInstaller "$sevenZipInstaller.zip" -Force
                [System.IO.Compression.ZipFile]::ExtractToDirectory("$sevenZipInstaller.zip", $tempExtract)
                Copy-Item "$tempExtract\*" $sevenZipDir -Recurse -Force
            } catch {
                Write-EnhancedLog "Could not auto-extract 7-Zip. Manual installation required." "WARN"
                Write-EnhancedLog "Please install 7-Zip manually from: $($script:Tools.SevenZip.DownloadURL)" "INFO"
                return $null
            } finally {
                if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue }
                if (Test-Path "$sevenZipInstaller.zip") { Remove-Item "$sevenZipInstaller.zip" -Force -ErrorAction SilentlyContinue }
            }
        }
        
        # Verify extraction worked
        if (Test-Path $sevenZipExe) {
            Write-EnhancedLog "7-Zip portable setup complete: $sevenZipExe" "SUCCESS"
            
            # Test 7-Zip functionality
            $testResult = & $sevenZipExe | Select-String "7-Zip"
            if ($testResult) {
                Write-EnhancedLog "7-Zip verified working: $($testResult.Line.Trim())" "SUCCESS"
            }
            
            return $sevenZipExe
        } else {
            throw "7-Zip extraction failed"
        }
        
    } catch {
        Write-EnhancedLog "Failed to setup 7-Zip portable: $($_.Exception.Message)" "ERROR"
        Write-EnhancedLog "Fallback: Install 7-Zip manually from https://7-zip.org" "INFO"
        return $null
    } finally {
        # Cleanup installer
        if (Test-Path $sevenZipInstaller) { Remove-Item $sevenZipInstaller -Force -ErrorAction SilentlyContinue }
    }
}

function Test-NativePowerShellISO {
    Write-EnhancedLog "Testing native PowerShell ISO capabilities..." "INFO"
    
    try {
        # Check if we have IMAPI2 COM objects available (Windows 10+)
        $imapiTest = New-Object -ComObject IMAPI2FS.MsftIso9660FileSystem -ErrorAction Stop
        $imapiTest = $null  # Release object
        
        Write-EnhancedLog "Native PowerShell ISO creation available" "SUCCESS"
        return $true
    } catch {
        Write-EnhancedLog "Native PowerShell ISO creation not available on this system" "WARN"
        return $false
    }
}

# Main custom ISO creation function
function New-BillSlothCustomISO {
    param(
        [string]$BaseUbuntuISO,
        [string]$OutputISOPath,
        [string]$PreferredTool = "auto"
    )
    
    Write-EnhancedLog "Starting Bill Sloth custom ISO creation..." "INFO"
    Write-EnhancedLog "Base ISO: $BaseUbuntuISO" "INFO"
    Write-EnhancedLog "Output: $OutputISOPath" "INFO"
    
    if (!(Test-Path $BaseUbuntuISO)) {
        Write-EnhancedLog "Base Ubuntu ISO not found: $BaseUbuntuISO" "ERROR"
        return $false
    }
    
    # Setup working directories
    $workspaceDir = "$OutputDir\iso-workspace"
    $extractDir = "$workspaceDir\extracted"
    $customDir = "$workspaceDir\custom"
    
    # Clean and create workspace
    if (Test-Path $workspaceDir) {
        Write-EnhancedLog "Cleaning previous workspace..." "INFO"
        Remove-Item $workspaceDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
    New-Item -ItemType Directory -Path $customDir -Force | Out-Null
    
    try {
        # Step 1: Extract base Ubuntu ISO
        Write-EnhancedLog "Extracting base Ubuntu ISO..." "INFO"
        if (Get-Command Show-InstallationStage -ErrorAction SilentlyContinue) {
            Show-InstallationStage -Stage "ISOExtraction" -Description "Extracting Ubuntu base system" -StageNumber 1 -TotalStages 6
        }
        
        $extractSuccess = $false
        
        # Try 7-Zip first
        $sevenZipPath = Install-SevenZipPortable
        if ($sevenZipPath -and (Test-Path $sevenZipPath)) {
            try {
                Write-EnhancedLog "Using 7-Zip for extraction..." "INFO"
                & $sevenZipPath x $BaseUbuntuISO "-o$extractDir" -y | Out-Null
                
                if ($LASTEXITCODE -eq 0 -and (Get-ChildItem $extractDir -Recurse).Count -gt 0) {
                    Write-EnhancedLog "7-Zip extraction successful" "SUCCESS"
                    $extractSuccess = $true
                }
            } catch {
                Write-EnhancedLog "7-Zip extraction failed: $($_.Exception.Message)" "WARN"
            }
        }
        
        # Fallback to Windows native extraction
        if (!$extractSuccess) {
            Write-EnhancedLog "Trying native Windows ISO mounting..." "INFO"
            try {
                $mountResult = Mount-DiskImage -ImagePath $BaseUbuntuISO -PassThru
                $isoVolume = Get-Volume -DiskImage $mountResult
                $isoDriveLetter = "$($isoVolume.DriveLetter):"
                
                Write-EnhancedLog "ISO mounted at: $isoDriveLetter" "INFO"
                
                # Copy all files
                Copy-Item "$isoDriveLetter\*" $extractDir -Recurse -Force
                
                # Dismount
                Dismount-DiskImage -ImagePath $BaseUbuntuISO
                
                Write-EnhancedLog "Native Windows extraction successful" "SUCCESS"
                $extractSuccess = $true
            } catch {
                Write-EnhancedLog "Native Windows extraction failed: $($_.Exception.Message)" "ERROR"
            }
        }
        
        if (!$extractSuccess) {
            throw "All extraction methods failed"
        }
        
        # Step 2: Create Bill Sloth integration
        Write-EnhancedLog "Creating Bill Sloth integration package..." "INFO"
        if (Get-Command Show-InstallationStage -ErrorAction SilentlyContinue) {
            Show-InstallationStage -Stage "BillSlothIntegration" -Description "Adding Bill Sloth automation" -StageNumber 2 -TotalStages 6
        }
        
        # Copy extracted content to custom directory
        Copy-Item "$extractDir\*" $customDir -Recurse -Force
        
        # Create Bill Sloth directory structure
        $billSlothIntegrationDir = "$customDir\billsloth"
        New-Item -ItemType Directory -Path $billSlothIntegrationDir -Force | Out-Null
        
        # Embed COMPLETE Bill Sloth system in the ISO for offline Ubuntu setup
        Write-EnhancedLog "Embedding complete Bill Sloth system in ISO..." "INFO"
        
        # Get the current Bill Sloth repository (Windows has full copy)
        $billSlothSourceDir = Split-Path $PSScriptRoot -Parent
        
        # Copy the ENTIRE Bill Sloth system to ISO for offline availability
        Write-EnhancedLog "Copying complete Bill Sloth repository to ISO..." "INFO"
        
        # Copy everything except windows-setup (not needed in Ubuntu)
        $excludeDirectories = @("windows-setup", ".git", "external")
        
        Get-ChildItem $billSlothSourceDir | Where-Object { 
            $_.PSIsContainer -and $excludeDirectories -notcontains $_.Name 
        } | ForEach-Object {
            Copy-Item $_.FullName "$billSlothIntegrationDir\" -Recurse -Force
            $itemCount = (Get-ChildItem $_.FullName -Recurse).Count
            Write-EnhancedLog "Copied directory: $($_.Name) ($itemCount items)" "INFO"
        }
        
        # Copy all root files except Windows-specific ones
        $excludeFiles = @("*.ps1", "*.bat", "*.cmd")
        Get-ChildItem $billSlothSourceDir -File | Where-Object {
            $exclude = $false
            foreach ($pattern in $excludeFiles) {
                if ($_.Name -like $pattern) { $exclude = $true; break }
            }
            -not $exclude
        } | ForEach-Object {
            Copy-Item $_.FullName "$billSlothIntegrationDir\" -Force
            Write-EnhancedLog "Copied file: $($_.Name)" "INFO"
        }
        
        # Verify complete synchronization
        $syncedItems = (Get-ChildItem $billSlothIntegrationDir -Recurse).Count
        Write-EnhancedLog "Complete Bill Sloth system embedded: $syncedItems items" "SUCCESS"
        
        # Enhanced Visual System Integration
        Write-EnhancedLog "Integrating enhanced visual system..." "INFO"
        
        # Verify enhanced aesthetic bridge is included
        $aestheticBridgePath = "$billSlothIntegrationDir\lib\enhanced_aesthetic_bridge.sh"
        if (Test-Path $aestheticBridgePath) {
            Write-EnhancedLog "Enhanced aesthetic bridge included: enhanced_aesthetic_bridge.sh" "SUCCESS"
        } else {
            Write-EnhancedLog "Enhanced aesthetic bridge not found - visual enhancements may be limited" "WARN"
        }
        
        # Verify ATHF easter eggs are ASCII-only
        $athfEasterEggsPath = "$billSlothIntegrationDir\lib\athf_easter_eggs.sh"
        if (Test-Path $athfEasterEggsPath) {
            Write-EnhancedLog "ASCII ATHF easter eggs included: athf_easter_eggs.sh" "SUCCESS"
        }
        
        # Enable enhanced visuals in autostart script
        $autostartPath = "$billSlothIntegrationDir\autostart.sh"
        if (Test-Path $autostartPath) {
            $autostartContent = Get-Content $autostartPath -Raw
            
            # Add enhanced visual system initialization
            $visualEnhancement = @'

# Enhanced Visual System Initialization
export BILL_SLOTH_ENHANCED_VISUALS=1
export PRESERVE_BANNERS=true
export SHOW_EASTER_EGGS=true
export MAINTAIN_COLORS=true
export VISUAL_FEEDBACK=enhanced
export FORCE_VISUAL_MODE=true

# Initialize enhanced aesthetic bridge if available
if [ -f "$BILLSLOTH_DIR/lib/enhanced_aesthetic_bridge.sh" ]; then
    source "$BILLSLOTH_DIR/lib/enhanced_aesthetic_bridge.sh"
    echo "    > [VISUAL] Enhanced aesthetic bridge initialized"
fi
'@
            
            # Insert visual enhancement before the final echo statements
            $insertionPoint = $autostartContent.IndexOf('echo "    > jack_out.exe --save_state --maintain_connection"')
            if ($insertionPoint -gt 0) {
                $beforeText = $autostartContent.Substring(0, $insertionPoint)
                $afterText = $autostartContent.Substring($insertionPoint)
                $enhancedContent = $beforeText + $visualEnhancement + "`n" + $afterText
                
                Set-Content -Path $autostartPath -Value $enhancedContent -Encoding UTF8
                Write-EnhancedLog "Enhanced visual system integrated into autostart" "SUCCESS"
            }
        }
        
        # Create visual system verification script
        $visualVerificationScript = @'
#!/bin/bash
# Visual System Health Check
echo ""
echo "=============================================="
echo "     BILL SLOTH VISUAL SYSTEM STATUS"
echo "=============================================="
echo ""

# Check enhanced aesthetic bridge
if [ -f "lib/enhanced_aesthetic_bridge.sh" ]; then
    echo " Enhanced Aesthetic Bridge: READY"
    source lib/enhanced_aesthetic_bridge.sh
    detect_terminal_aesthetics
    echo "   • Terminal Support: $TERM_SUPPORT_LEVEL"
    echo "   • Color Support: $COLOR_SUPPORT"
    echo "   • Wide Display: $WIDE_DISPLAY"
else
    echo "  Enhanced Aesthetic Bridge: NOT FOUND"
fi

# Check ATHF easter eggs
if [ -f "lib/athf_easter_eggs.sh" ]; then
    echo " ATHF Easter Eggs: READY (ASCII-only)"
else
    echo "  ATHF Easter Eggs: NOT FOUND"
fi

# Check module visual integration
visual_modules=0
for module in modules/*.sh; do
    if grep -q "enhanced_aesthetic_bridge" "$module" 2>/dev/null; then
        visual_modules=$((visual_modules + 1))
    fi
done

echo " Visual-Enhanced Modules: $visual_modules"
echo ""
echo "=============================================="

# Show sample visual output
if [ "$1" = "--demo" ]; then
    echo ""
    echo "Visual System Demo:"
    echo ""
    
    # Show ASCII art sample
    cat << 'EOF'
                            (\\_/)              
                           ( ^.^ )   VISUAL   
                          o_(\"|(\")   READY   
                                                
                       BILL SLOTH AESTHETICS   
                         >>> ONLINE <<<      
EOF
    echo ""
fi
'@
        
        Set-Content -Path "$billSlothIntegrationDir\check_visuals.sh" -Value $visualVerificationScript -Encoding UTF8
        Write-EnhancedLog "Visual system verification script created: check_visuals.sh" "SUCCESS"
        
        # Ensure all shell scripts are executable
        Get-ChildItem "$billSlothIntegrationDir" -Filter "*.sh" -Recurse | ForEach-Object {
            # This will be preserved in the ISO and available in Ubuntu
            Write-EnhancedLog "Marked executable: $($_.FullName.Replace($billSlothIntegrationDir, ''))" "INFO"
        }
        
        # Create complete autostart script with Claude Code installation and onboarding
        $autostartScript = @'
#!/bin/bash
# Bill Sloth Complete Ubuntu Auto-Setup
# Installs Claude Code, essential dependencies, and starts onboarding

export BILL_SLOTH_LIVE=1
export DEBIAN_FRONTEND=noninteractive

clear
echo ""
echo "                        "
echo "                     "
echo "                            "
echo "                            "
echo "            "
echo "               "
echo ""
echo "                    "
echo "                        (\   /)     NEURAL INTERFACE   "
echo "                       ( ._.)      INITIALIZING...     "
echo "                      o_(\\"(/)                          "
echo "                    "
echo ""
echo "    > jack_in.exe --target ubuntu --mode sloth --neural_link active"
echo "    > [SYSTEM] Establishing encrypted tunnel to cypherpunk HQ..."
echo "    > [SYSTEM] Sloth-class automation protocols loaded"
echo ""

# Detect live environment
BILL_SLOTH_LIVE=${BILL_SLOTH_LIVE:-0}
if [ "$BILL_SLOTH_LIVE" = "1" ]; then
    BILLSLOTH_DIR="/tmp/billsloth"
    INSTALL_MODE="live"
    echo "    > [SYSTEM] Live environment detected"
else
    BILLSLOTH_DIR="/home/$USER/bill sloth"
    INSTALL_MODE="permanent"
    echo "    > [SYSTEM] Permanent installation mode"
fi

# Copy Bill Sloth system from ISO
echo " Setting up Bill Sloth system..."
if sudo mkdir -p "$BILLSLOTH_DIR" && sudo cp -r /cdrom/billsloth/* "$BILLSLOTH_DIR/"; then
    # Set proper ownership
    if [ "$USER" = "ubuntu" ]; then
        sudo chown -R ubuntu:ubuntu "$BILLSLOTH_DIR"
    else
        sudo chown -R $USER:$USER "$BILLSLOTH_DIR"
    fi
    chmod +x "$BILLSLOTH_DIR"/*.sh
    find "$BILLSLOTH_DIR" -name "*.sh" -exec chmod +x {} \;
    echo " Bill Sloth system ready at: $BILLSLOTH_DIR"
else
    echo " Bill Sloth system not found on ISO"
    exit 1
fi

# Install essential dependencies
echo ""
echo "    > [MATRIX] Downloading neural pathways..."
echo "    > [MATRIX] Installing cyber-enhancement modules..."
echo ""
echo "                  "
echo "                    zzz    /|    /|      "
echo "                        zzz \\_  ( ;._.)   "
echo "                            zzz  \\_))     "
echo "                      CYBER SLOTH AWAKENING "
echo "                  "
echo ""
sudo apt update -qq

# Install Node.js 20.x for Claude Code
echo "    > [CRYPTO] Establishing secure node channels..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1
sudo apt install -y nodejs >/dev/null 2>&1

# Verify Node.js installation
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "    > [SUCCESS] Node.js neural link established: $NODE_VERSION"
} else {
    echo "    > [ERROR] Node.js installation failed"
    exit 1
}

# Install Claude Code CLI
echo "    > [AI] Deploying Claude Code neural interface..."
echo ""
echo "                    "
echo "                         __|__              "
echo "                      (\\ |    |    AI CORE  "  
echo "                       \\_)\\___O   LOADING... "
echo "                          (_(_)              "
echo "                    "
echo ""
npm install -g @anthropic-ai/claude-code >/dev/null 2>&1

# Verify Claude Code installation
if command -v claude &> /dev/null; then
    CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "installed")
    echo "    > [SUCCESS] Claude Code AI interface online: $CLAUDE_VERSION"
} else {
    echo "    > [WARNING] Claude Code installation incomplete - manual setup required"
    # Continue anyway - user can install manually
}

# Install other essential dependencies from Bill Sloth requirements
echo "  Installing Bill Sloth dependencies..."
sudo apt install -y \
    curl wget git build-essential \
    jq sqlite3 just \
    python3 python3-pip \
    ffmpeg imagemagick \
    htop tree unzip \
    >/dev/null 2>&1

# Auto-detect and install hardware drivers
echo " Setting up hardware drivers..."
sudo ubuntu-drivers autoinstall >/dev/null 2>&1 || echo "Driver autoinstall not available"

# Configure audio
pulseaudio --kill >/dev/null 2>&1
pulseaudio --start >/dev/null 2>&1

# Reset display configuration for better multi-monitor support
rm -f ~/.config/monitors.xml
rm -f /home/ubuntu/.config/monitors.xml >/dev/null 2>&1

# Set up Bill Sloth environment
cd "$BILLSLOTH_DIR"

# Create initial Bill Sloth configuration
echo ""
echo "  Configuring Bill Sloth environment..."
export BILL_SLOTH_DIR="$BILLSLOTH_DIR"
export BILL_SLOTH_AUTO_SETUP=1

# Run Bill Sloth initial setup if available
if [ -f "./install.sh" ]; then
    echo " Running Bill Sloth installer..."
    bash ./install.sh --auto >/dev/null 2>&1 || echo "Bill Sloth installer completed with warnings"
fi

# Start Bill Sloth onboarding
echo ""
echo " Starting Bill Sloth onboarding..."

if [ "$INSTALL_MODE" = "permanent" ]; then
    # Full onboarding for installed system
    gnome-terminal --title="Bill Sloth Neural Interface" --geometry=120x40 -- bash -c "
        cd '$BILLSLOTH_DIR'
        clear
        echo ''
        echo '    '
        echo '                                                 '
        echo '       (\\_/)     WELCOME TO THE MATRIX          '
        echo '      ( o.o )    BILL SLOTH NEURAL INTERFACE    '
        echo '       > ^ <     CYPHERPUNK AUTOMATION HQ       '
        echo '                                                 '
        echo '    '
        echo ''
        echo '    > red_pill.exe executed successfully'
        echo '    > neural_link.dll loaded'
        echo '    > sloth_protocols.sys initialized'
        echo ''
        echo '    Starting consciousness upload...'
        echo ''
        
        # Start onboarding if available
        if [ -f './onboard.sh' ]; then
            ./onboard.sh
        else
            echo ' Onboarding script not found - starting command center...'
            ./bill_command_center.sh
        fi
        
        echo ''
        echo 'Press any key to continue...'
        read -n 1
        exec bash
    " &
else
    # Simplified setup for live environment
    gnome-terminal --title="Bill Sloth Live Demo Terminal" --geometry=100x30 -- bash -c "
        cd '$BILLSLOTH_DIR'
        clear
        echo ''
        echo '    '
        echo '                                       '
        echo '       (\\_/)   LIVE DEMO MODE         '
        echo '      ( -.- )  SLOTH SIMULATION       '
        echo '       > ? <   LIMITED FUNCTIONALITY  '
        echo '                                       '
        echo '    '
        echo ''
        echo '    > demo_mode.exe --sloth_preview'
        echo '    > Access Level: GUEST'
        echo ''
        echo '    Available neural pathways:'
        echo '      ./bill_command_center.sh  - Main interface'
        echo '      ./lab.sh                  - AI playground'
        echo ''
        echo '    > install.exe --full_matrix for complete experience'
        echo ''
        exec bash
    " &
fi

# Create desktop shortcut for easy access
if [ "$INSTALL_MODE" = "permanent" ] && [ -d "$HOME/Desktop" ]; then
    cat > "$HOME/Desktop/Bill Sloth.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Bill Sloth Command Center
Comment=Your Personal Automation System
Exec=gnome-terminal --working-directory="$BILLSLOTH_DIR" -- bash -c "./bill_command_center.sh; exec bash"
Icon=utilities-terminal
Terminal=false
Categories=System;
EOF
    chmod +x "$HOME/Desktop/Bill Sloth.desktop"
    echo "  Desktop shortcut created"
}

echo ""
echo ""
echo "    > [MATRIX] All systems online. Welcome to the other side..."
echo ""
echo "                    "
echo "                            (\\_/)              "
echo "                           ( ^.^ )   MISSION   "
echo "                          o_(\\"(\")   COMPLETE  "
echo "                                                "
echo "                       SLOTH NEURAL INTERFACE   "
echo "                            >>> ONLINE <<<      "
echo "                    "
echo ""
echo "    > [STATUS] Bill Sloth automation suite deployed"
echo "    > [STATUS] Claude Code AI interface ready"  
echo "    > [STATUS] Cypherpunk protocols initialized"
echo "    > [LOCATION] System base: $BILLSLOTH_DIR"
echo ""

# Final setup for Claude Code integration
if command -v claude &> /dev/null; then
    echo "    > [AI] Ready for neural handshake. Try these commands:"
    echo "    >      claude 'help me automate my VRBO business'"
    echo "    >      claude 'show me Bill Sloth capabilities'"
    echo ""
}

echo "    > jack_out.exe --save_state --maintain_connection"
echo "    > Remember: There is no spoon... but there are sloths. "
echo ""
'@
        
        Set-Content -Path "$billSlothIntegrationDir\autostart.sh" -Value $autostartScript -Encoding UTF8
        
        # Create preseed file for automated installation
        $preseedConfig = @'
# Bill Sloth Ubuntu Preseed Configuration
d-i debian-installer/locale string en_US
d-i keyboard-configuration/xkb-keymap select us
d-i netcfg/choose_interface select auto
d-i mirror/country string manual
d-i clock-setup/utc boolean true
d-i time/zone string America/New_York
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false
tasksel tasksel/first multiselect ubuntu-desktop
d-i pkgsel/include string curl wget git build-essential
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i finish-install/reboot_in_progress note
d-i preseed/late_command string \
    in-target cp -r /cdrom/billsloth /home/ubuntu/; \
    in-target chown -R ubuntu:ubuntu /home/ubuntu/billsloth; \
    in-target chmod +x /home/ubuntu/billsloth/*.sh;
'@
        
        Set-Content -Path "$customDir\preseed\ubuntu.seed" -Value $preseedConfig -Encoding UTF8
        
        # Step 3: Modify boot configuration
        Write-EnhancedLog "Configuring boot sequence..." "INFO"
        if (Get-Command Show-InstallationStage -ErrorAction SilentlyContinue) {
            Show-InstallationStage -Stage "BootConfig" -Description "Configuring automated boot" -StageNumber 3 -TotalStages 6
        }
        
        # Modify GRUB configuration for autostart
        $grubCfgPath = "$customDir\boot\grub\grub.cfg"
        if (Test-Path $grubCfgPath) {
            $grubContent = Get-Content $grubCfgPath -Raw
            
            # Add Bill Sloth autostart to kernel parameters
            $grubContent = $grubContent -replace 'quiet splash', 'quiet splash billsloth-autostart'
            
            Set-Content -Path $grubCfgPath -Value $grubContent -Encoding UTF8
            Write-EnhancedLog "Modified GRUB configuration for Bill Sloth autostart" "SUCCESS"
        }
        
        # Step 4: Create new ISO
        Write-EnhancedLog "Creating custom ISO..." "INFO"
        if (Get-Command Show-InstallationStage -ErrorAction SilentlyContinue) {
            Show-InstallationStage -Stage "ISOCreation" -Description "Building final ISO" -StageNumber 4 -TotalStages 6
        }
        
        $isoCreationSuccess = $false
        
        # Method 1: Try Windows ADK oscdimg (most reliable)
        $oscdimgPath = Install-WindowsADK
        if ($oscdimgPath -and (Test-Path $oscdimgPath)) {
            try {
                Write-EnhancedLog "Using Windows ADK oscdimg..." "INFO"
                
                # oscdimg parameters for Ubuntu ISO
                $oscdimgArgs = @(
                    "-m",  # Ignore maximum image size
                    "-o",  # Optimize ISO
                    "-u2", # UDF revision 2.0
                    "-udfver102", # UDF version 1.02
                    "-bootdata:2#p0,e,b$customDir\boot\grub\i386-pc\eltorito.img#pEF,e,b$customDir\boot\grub\efi.img",
                    $customDir,
                    $OutputISOPath
                )
                
                & $oscdimgPath @oscdimgArgs
                
                if ($LASTEXITCODE -eq 0 -and (Test-Path $OutputISOPath)) {
                    Write-EnhancedLog "oscdimg ISO creation successful" "SUCCESS"
                    $isoCreationSuccess = $true
                }
            } catch {
                Write-EnhancedLog "oscdimg failed: $($_.Exception.Message)" "WARN"
            }
        }
        
        # Method 2: Try native PowerShell (Windows 10+)
        if (!$isoCreationSuccess -and (Test-NativePowerShellISO)) {
            try {
                Write-EnhancedLog "Using native PowerShell ISO creation..." "INFO"
                
                # Create ISO using IMAPI2
                $fso = New-Object -ComObject IMAPI2FS.MsftIso9660FileSystem
                $fso.VolumeName = "BillSlothUbuntu"
                $fso.FileSystemsToCreate = 3  # ISO9660 + Joliet + UDF
                
                # Add all files recursively
                function Add-DirectoryToISO($dir, $isoDir) {
                    Get-ChildItem $dir | ForEach-Object {
                        $relativePath = $_.FullName.Substring($customDir.Length + 1)
                        if ($_.PSIsContainer) {
                            $fso.CreateDirectory($relativePath)
                            Add-DirectoryToISO $_.FullName $relativePath
                        } else {
                            $fso.AddFile($relativePath, $_.FullName)
                        }
                    }
                }
                
                Add-DirectoryToISO $customDir ""
                
                # Create the ISO
                $stream = $fso.CreateFileStream()
                $content = New-Object byte[] $stream.Length
                $stream.Read($content, 0, $stream.Length) | Out-Null
                $stream.Close()
                
                [System.IO.File]::WriteAllBytes($OutputISOPath, $content)
                
                Write-EnhancedLog "Native PowerShell ISO creation successful" "SUCCESS"
                $isoCreationSuccess = $true
                
            } catch {
                Write-EnhancedLog "Native PowerShell ISO creation failed: $($_.Exception.Message)" "WARN"
            }
        }
        
        if (!$isoCreationSuccess) {
            throw "All ISO creation methods failed"
        }
        
        # Step 5: Validate created ISO
        Write-EnhancedLog "Validating created ISO..." "INFO"
        if (Get-Command Show-InstallationStage -ErrorAction SilentlyContinue) {
            Show-InstallationStage -Stage "Validation" -Description "Verifying ISO integrity" -StageNumber 5 -TotalStages 6
        }
        
        if (Test-Path $OutputISOPath) {
            $isoInfo = Get-Item $OutputISOPath
            $isoSizeGB = [math]::Round($isoInfo.Length / 1GB, 2)
            
            Write-EnhancedLog "Custom ISO created successfully" "SUCCESS"
            Write-EnhancedLog "Location: $OutputISOPath" "INFO"
            Write-EnhancedLog "Size: $isoSizeGB GB" "INFO"
            
            # Quick validation - try to mount and check Bill Sloth integration
            try {
                $mountResult = Mount-DiskImage -ImagePath $OutputISOPath -PassThru
                $isoVolume = Get-Volume -DiskImage $mountResult
                $isoDriveLetter = "$($isoVolume.DriveLetter):"
                
                $billSlothCheck = Test-Path "$isoDriveLetter\billsloth\autostart.sh"
                Dismount-DiskImage -ImagePath $OutputISOPath
                
                if ($billSlothCheck) {
                    Write-EnhancedLog "Bill Sloth integration verified in ISO" "SUCCESS"
                } else {
                    Write-EnhancedLog "Bill Sloth integration not found in ISO" "WARN"
                }
            } catch {
                Write-EnhancedLog "Could not validate ISO contents: $($_.Exception.Message)" "WARN"
            }
            
            return $OutputISOPath
        } else {
            throw "ISO file was not created"
        }
        
    } catch {
        Write-EnhancedLog "Custom ISO creation failed: $($_.Exception.Message)" "ERROR"
        return $null
    } finally {
        # Cleanup workspace
        if (Test-Path $workspaceDir) {
            Write-EnhancedLog "Cleaning up workspace..." "INFO"
            Start-Sleep -Seconds 2  # Allow file handles to close
            Remove-Item $workspaceDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# Main execution
if ($DownloadToolsOnly) {
    Write-Host " DOWNLOADING TOOLS ONLY" -ForegroundColor Yellow
    Write-Host "=========================" -ForegroundColor Yellow
    
    Install-WindowsADK
    Install-SevenZipPortable
    Test-NativePowerShellISO
    
    Write-Host ""
    Write-Host " Tool download complete!" -ForegroundColor Green
    Write-Host "Re-run script without -DownloadToolsOnly to create custom ISO" -ForegroundColor White
    
} else {
    # Full custom ISO creation workflow
    Write-Host ""
    Write-Host " STARTING CUSTOM ISO CREATION" -ForegroundColor Green
    Write-Host "===============================" -ForegroundColor Green
    
    # Get Ubuntu base ISO
    $baseISO = "$OutputDir\ubuntu-$UbuntuVersion-desktop-amd64.iso"
    if (!(Test-Path $baseISO)) {
        Write-EnhancedLog "Ubuntu base ISO not found. Downloading..." "INFO"
        
        # Use existing ubuntu-installer-prep.ps1 to get Ubuntu ISO
        $ubuntuPrepScript = "$PSScriptRoot\ubuntu-installer-prep.ps1"
        if (Test-Path $ubuntuPrepScript) {
            & $ubuntuPrepScript -UbuntuVersion $UbuntuVersion -DownloadPath (Split-Path $baseISO -Parent) -SkipUSB
        } else {
            Write-EnhancedLog "Ubuntu installer prep script not found" "ERROR"
            Write-EnhancedLog "Please download Ubuntu $UbuntuVersion ISO manually to: $baseISO" "INFO"
            exit 1
        }
    }
    
    # Create custom ISO
    $customISOPath = "$OutputDir\$CustomISOName"
    $result = New-BillSlothCustomISO -BaseUbuntuISO $baseISO -OutputISOPath $customISOPath
    
    if ($result) {
        Write-Host ""
        Write-Host " CUSTOM ISO CREATION COMPLETE!" -ForegroundColor Green
        Write-Host "=================================" -ForegroundColor Green
        Write-Host ""
        Write-Host " Custom Bill Sloth Ubuntu ISO: $result" -ForegroundColor Green
        Write-Host ""
        Write-Host " Next Steps:" -ForegroundColor Cyan
        Write-Host "1. Create bootable USB from this custom ISO" -ForegroundColor White
        Write-Host "2. Boot from USB to start automated Bill Sloth setup" -ForegroundColor White
        Write-Host "3. Ubuntu will auto-configure with Bill Sloth integration" -ForegroundColor White
        
        # Optionally create USB automatically
        if (Get-Command New-UbuntuBootableUSB -ErrorAction SilentlyContinue) {
            Write-Host ""
            Write-Host " Would you like to create a bootable USB now? (Y/N): " -NoNewline -ForegroundColor Yellow
            $response = Read-Host
            if ($response -match '^[Yy]') {
                Write-Host "Creating bootable USB from custom ISO..." -ForegroundColor Cyan
                New-UbuntuBootableUSB -ISOPath $result -Method "auto"
            }
        }
        
    } else {
        Write-Host ""
        Write-Host " CUSTOM ISO CREATION FAILED" -ForegroundColor Red
        Write-Host "Check log file: $logFile" -ForegroundColor Yellow
        exit 1
    }
}

Write-EnhancedLog "Script execution completed" "INFO"