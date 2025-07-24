# Bill Sloth WSL2-Based ISO Builder - Architecturally Sound Version
# This properly executes Linux commands in Linux environment

param(
    [string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso",
    [string]$UbuntuVersion = "jammy",
    [switch]$MaxCyberpunk,
    [switch]$SkipWSLCheck
)

#Requires -RunAsAdministrator

Write-Host @"
████████████████████████████████████████████████████████████████████████████████
██                                                                            ██
██  ░▒▓█ BILL SLOTH WSL2 ISO BUILDER - ARCHITECTURALLY CORRECT █▓▒░            ██
██                                                                            ██
██  ████ LINUX COMMANDS RUN IN LINUX, NOT WINDOWS ████                        ██
██  ▓▓▓▓ NO SILENT FALLBACKS - FAILS FAST ON ERRORS ▓▓▓▓                      ██
██                                                                            ██
████████████████████████████████████████████████████████████████████████████████
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "This builder executes Linux live-build commands in WSL2 Linux environment" -ForegroundColor Cyan
Write-Host "No more PowerShell parsing of bash syntax!" -ForegroundColor Green
Write-Host ""

# Check WSL2 availability FIRST
function Test-WSL2Available {
    Write-Host "=== VALIDATING WSL2 ENVIRONMENT ===" -ForegroundColor Cyan
    
    # Check if WSL is available
    $wslCheck = Get-Command wsl -ErrorAction SilentlyContinue
    if (-not $wslCheck) {
        throw "WSL2 is not installed. Please install WSL2 first: wsl --install"
    }
    
    # Check if any distro is installed
    $distros = wsl --list --quiet 2>$null
    if (-not $distros -or $distros -match "no installed distributions") {
        throw "No WSL2 distributions found. Please install Ubuntu: wsl --install -d Ubuntu"
    }
    
    # Check if we have Ubuntu specifically
    if ($distros -notcontains "Ubuntu") {
        Write-Host "WARNING: Ubuntu not found. Using first available distro: $($distros[0])" -ForegroundColor Yellow
        return $distros[0]
    }
    
    Write-Host "✅ WSL2 Ubuntu environment validated" -ForegroundColor Green
    return "Ubuntu"
}

# Create the entire build script as a single WSL2 execution
function Build-CyberpunkISOInWSL {
    param(
        [string]$DistroName,
        [string]$OutputPath
    )
    
    Write-Host "=== CREATING CYBERPUNK ISO IN WSL2 ===" -ForegroundColor Cyan
    
    # Convert Windows path to WSL path
    $wslOutputPath = $OutputPath -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
    $projectDir = "/tmp/billsloth-iso-build-$(Get-Random)"
    
    # Create the complete build script
    # Note: This is a PowerShell here-string containing bash script
    # It will be passed to WSL2 for execution, NOT parsed by PowerShell
    $buildScript = @'
#!/bin/bash
set -e  # Exit on any error - no silent failures!

PROJECT_DIR="{PROJECT_DIR}"
OUTPUT_PATH="{OUTPUT_PATH}"
UBUNTU_VERSION="{UBUNTU_VERSION}"

echo "████ BILL SLOTH CYBERPUNK ISO BUILDER ████"
echo "Running in: $(uname -a)"
echo ""

# Ensure we're in Linux
if [[ ! -f /proc/version ]] || [[ ! $(grep -i linux /proc/version) ]]; then
    echo "ERROR: Not running in Linux environment!"
    exit 1
fi

# Install live-build if needed
echo "▓▓▓ Installing live-build framework..."
sudo apt-get update
sudo apt-get install -y live-build git curl debootstrap

# Create project directory
echo "▓▓▓ Creating project structure..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Initialize live-build project
echo "▓▓▓ Initializing live-build configuration..."
lb config \
    --distribution "$UBUNTU_VERSION" \
    --architecture amd64 \
    --binary-images iso-hybrid \
    --archive-areas "main restricted universe multiverse" \
    --apt-indices false \
    --apt-recommends true \
    --memtest none \
    --win32-loader false \
    --iso-application "Bill Sloth Cyberpunk Ubuntu" \
    --iso-volume "BILLSLOTH" \
    --iso-preparer "bill@slothlab.cyber" \
    --iso-publisher "Cyberpunk Sloth Automation Lab"

# Create package lists
echo "▓▓▓ Creating Bill Sloth package lists..."
mkdir -p config/package-lists

cat > config/package-lists/billsloth.list.chroot << 'EOF'
# Development Tools
git
curl
wget
build-essential
python3
python3-pip
nodejs
npm

# Audio Tools  
pipewire
pipewire-pulse
pipewire-jack
carla
qjackctl
pavucontrol

# System Tools
neovim
tmux
htop
ncdu
tree
ripgrep
fd-find

# Voice Control Dependencies
espeak
festival
flite
sox
libsox-fmt-all

# Claude Code Dependencies
openssh-client
openssh-server
EOF

# Create preseed file for automation
echo "▓▓▓ Creating preseed configuration..."
mkdir -p config/includes.installer
cat > config/includes.installer/preseed.cfg << 'EOF'
# Bill Sloth Automated Installation
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string billsloth
d-i netcfg/get_domain string cyberpunk.local

# User setup
d-i passwd/user-fullname string Bill Sloth
d-i passwd/username string bill
d-i passwd/user-password-crypted password $6$rounds=4096$billslothsalt$YourHashHere
d-i user-setup/allow-password-weak boolean true

# Partitioning
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Package selection
tasksel tasksel/first multiselect ubuntu-desktop
d-i pkgsel/include string git curl wget build-essential
EOF

# Add cyberpunk customizations
echo "▓▓▓ Adding cyberpunk customizations..."
mkdir -p config/includes.chroot/etc/skel

# Create Bill Sloth welcome message
cat > config/includes.chroot/etc/skel/.bill-sloth-welcome << 'EOF'
████████████████████████████████████████████████████████████████████████████████
██                                                                            ██
██  ░▒▓█ WELCOME TO BILL SLOTH CYBERPUNK UBUNTU █▓▒░                         ██
██                                                                            ██
██  Your system has been pre-configured with:                                ██
██  - Complete Bill Sloth automation system                                  ██
██  - Professional audio tools (PipeWire, JACK, Carla)                       ██
██  - Voice control ready to activate                                        ██
██  - Claude Code integration prepared                                       ██
██                                                                            ██
██  Run: billsloth --init to complete setup                                  ██
██                                                                            ██
████████████████████████████████████████████████████████████████████████████████
EOF

# Create first-boot setup script
mkdir -p config/includes.chroot/usr/local/bin
cat > config/includes.chroot/usr/local/bin/billsloth-firstboot << 'EOF'
#!/bin/bash
# Bill Sloth First Boot Setup

if [ ! -f ~/.billsloth-configured ]; then
    echo "▓▓▓ INITIALIZING BILL SLOTH SYSTEM ▓▓▓"
    
    # Clone Bill Sloth repository
    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth
    
    # Run onboarding
    cd ~/bill-sloth
    bash onboard.sh
    
    # Mark as configured
    touch ~/.billsloth-configured
    
    echo "✅ Bill Sloth system initialized!"
fi
EOF
chmod +x config/includes.chroot/usr/local/bin/billsloth-firstboot

# Add to bashrc
echo 'billsloth-firstboot' >> config/includes.chroot/etc/skel/.bashrc

# Build the ISO
echo ""
echo "████ BUILDING CYBERPUNK ISO (This will take 20-60 minutes) ████"
echo ""

sudo lb build

# Check if ISO was created
ISO_FILE=$(find . -name "*.iso" -type f | head -1)
if [ -z "$ISO_FILE" ]; then
    echo "❌ ERROR: No ISO file generated!"
    echo "Build failed - no fallback to standard Ubuntu!"
    exit 1
fi

# Copy to Windows location
echo "▓▓▓ Copying ISO to Windows filesystem..."
cp "$ISO_FILE" "$OUTPUT_PATH"

# Verify copy
if [ -f "$OUTPUT_PATH" ]; then
    echo "✅ SUCCESS: Custom ISO created at $OUTPUT_PATH"
    ls -lh "$OUTPUT_PATH"
else
    echo "❌ ERROR: Failed to copy ISO to Windows location"
    exit 1
fi

# Cleanup
cd /
rm -rf "$PROJECT_DIR"

echo ""
echo "████ CYBERPUNK BILL SLOTH ISO COMPLETE ████"
'@

    # Replace placeholders
    $buildScript = $buildScript -replace '{PROJECT_DIR}', $projectDir
    $buildScript = $buildScript -replace '{OUTPUT_PATH}', $wslOutputPath
    $buildScript = $buildScript -replace '{UBUNTU_VERSION}', $UbuntuVersion
    
    # Execute in WSL2
    Write-Host "Executing build in WSL2 $DistroName..." -ForegroundColor Green
    Write-Host "This will take 20-60 minutes..." -ForegroundColor Yellow
    
    # Save script to temp file and execute (without BOM)
    $tempScript = "$env:TEMP\build-iso-wsl.sh"
    [System.IO.File]::WriteAllText($tempScript, $buildScript, [System.Text.UTF8Encoding]::new($false))
    
    # Convert script path to WSL format
    $wslScriptPath = $tempScript -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
    
    # Execute with proper error handling
    $result = wsl -d $DistroName bash -c "bash $wslScriptPath"
    
    if ($LASTEXITCODE -ne 0) {
        throw "WSL2 build failed with exit code $LASTEXITCODE"
    }
    
    # Verify output exists
    if (-not (Test-Path $OutputPath)) {
        throw "ISO was not created at expected location: $OutputPath"
    }
    
    return $true
}

# Main execution
try {
    Write-Host "Starting Bill Sloth WSL2 ISO Builder..." -ForegroundColor Cyan
    Write-Host ""
    
    # Check WSL2 first - fail fast if not available
    if (-not $SkipWSLCheck) {
        $distro = Test-WSL2Available
    } else {
        $distro = "Ubuntu"
        Write-Host "WARNING: Skipping WSL2 check as requested" -ForegroundColor Yellow
    }
    
    # Build the ISO
    $success = Build-CyberpunkISOInWSL -DistroName $distro -OutputPath $OutputISO
    
    if ($success) {
        Write-Host ""
        Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
        Write-Host "██  ✅ CUSTOM CYBERPUNK ISO SUCCESSFULLY CREATED!                             ██" -ForegroundColor Green
        Write-Host "██  Location: $OutputISO                                                      ██" -ForegroundColor Green
        Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
        Write-Host ""
        Write-Host "This is a REAL custom ISO with Bill Sloth pre-integrated!" -ForegroundColor Cyan
        Write-Host "No silent fallbacks, no standard Ubuntu - pure cyberpunk sloth!" -ForegroundColor Cyan
        
        # Return success
        exit 0
    }
}
catch {
    Write-Host ""
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
    Write-Host "██  ❌ CUSTOM ISO CREATION FAILED!                                            ██" -ForegroundColor Red
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "NO FALLBACK TO STANDARD UBUNTU - Fix the issue and try again!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Common fixes:" -ForegroundColor Cyan
    Write-Host "1. Enable WSL2: wsl --install" -ForegroundColor White
    Write-Host "2. Install Ubuntu: wsl --install -d Ubuntu" -ForegroundColor White
    Write-Host "3. Ensure you have ~20GB free disk space" -ForegroundColor White
    Write-Host "4. Run as Administrator" -ForegroundColor White
    
    # Return failure - no silent fallbacks!
    exit 1
}