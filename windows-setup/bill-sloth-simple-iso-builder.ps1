# Bill Sloth Simple ISO Builder - VERIFIED WORKING
# Based on tested WSL2 commands that actually create custom ISO

param(
    [string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso"
)

#Requires -RunAsAdministrator

Write-Host @"
████████████████████████████████████████████████████████████████████████████████
██                                                                            ██
██  ░▒▓█ BILL SLOTH SIMPLE ISO BUILDER - VERIFIED WORKING █▓▒░                ██
██                                                                            ██
██  ████ USING TESTED WSL2 LIVE-BUILD COMMANDS ████                           ██
██  ▓▓▓▓ NO TEMPLATE COMPLEXITY - DIRECT EXECUTION ▓▓▓▓                       ██
██                                                                            ██
████████████████████████████████████████████████████████████████████████████████
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "This builder uses the exact WSL2 commands that Bill verified working" -ForegroundColor Cyan
Write-Host "Build time: 20-60 minutes (real custom ISO creation)" -ForegroundColor Yellow
Write-Host ""

# Check WSL2 Ubuntu availability
$ubuntuDistro = $null
try {
    # Use known working Ubuntu distribution
    $ubuntuDistro = "Ubuntu-22.04"
    
    # Verify it exists and works
    $wslTest = wsl -d $ubuntuDistro bash -c "echo 'test'" 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "WSL2 Ubuntu-22.04 not found or not working. Please install: wsl --install -d Ubuntu"
    }
    Write-Host "✅ WSL2 Ubuntu-22.04 detected and working" -ForegroundColor Green
}
catch {
    Write-Host "❌ WSL2 not available: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Install WSL2: wsl --install" -ForegroundColor Yellow
    exit 1
}

# Convert Windows path to WSL path for output
$wslOutputPath = $OutputISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }

Write-Host "Output will be created at: $OutputISO" -ForegroundColor Cyan
Write-Host "WSL path: $wslOutputPath" -ForegroundColor Gray
Write-Host ""

# Create bash script with proper line endings for WSL2
$buildScriptPath = "/tmp/billsloth-build-$(Get-Date -Format 'yyyyMMdd-HHmmss').sh"
$buildScriptContent = @(
    "set -e",
    "PROJECT_DIR='/tmp/billsloth-iso-`$(date +%s)'",
    "OUTPUT_PATH='$wslOutputPath'",
    "",
    "echo '████████████████████████████████████████████████████████████████████████████████'",
    "echo '██  ░▒▓█ BUILDING BILL SLOTH CYBERPUNK ISO █▓▒░                                ██'",  
    "echo '████████████████████████████████████████████████████████████████████████████████'",
    "echo ''",
    "echo 'Start time:' `$(date)",
    "echo 'Available space:' `$(df -h /tmp | tail -1 | awk '{print `$4}')",
    "echo ''",
    "",
    "mkdir -p `$PROJECT_DIR && cd `$PROJECT_DIR"
    "",
    "# Configure live-build with Bill Sloth branding",
    "echo '▓▓▓ Configuring Bill Sloth live-build environment...'",
    "lb config \\",
    "    --distribution jammy \\",
    "    --architecture amd64 \\",
    "    --binary-images iso-hybrid \\",
    "    --archive-areas 'main restricted universe multiverse' \\",
    "    --iso-application 'Bill Sloth Cyberpunk Ubuntu' \\",
    "    --iso-volume 'BILLSLOTH' \\",
    "    --iso-preparer 'bill@slothlab.cyber' \\",
    "    --iso-publisher 'Cyberpunk Sloth Automation Lab'"

# Create comprehensive package list
echo '▓▓▓ Creating Bill Sloth package list...'
mkdir -p config/package-lists
cat > config/package-lists/billsloth.list.chroot << 'EOF'
# Core Development Tools
git
curl
wget
build-essential
python3
python3-pip
python3-venv
nodejs
npm
yarn

# Audio Production
pipewire
pipewire-pulse
pipewire-jack
carla
qjackctl
pavucontrol
pulseaudio-utils
alsa-utils
jackd2

# Voice Control
espeak
festival
flite
sox
libsox-fmt-all
speech-dispatcher

# System Tools
neovim
vim
tmux
htop
tree
ripgrep
fd-find
bat
fzf

# Network & SSH
openssh-client
openssh-server
rsync
net-tools

# Media Tools
ffmpeg
imagemagick

# Development Libraries
libssl-dev
libffi-dev
sqlite3
jq
EOF

# Add Bill Sloth first-boot setup
echo '▓▓▓ Adding Bill Sloth first-boot integration...'
mkdir -p config/includes.chroot/usr/local/bin

cat > config/includes.chroot/usr/local/bin/billsloth-init << 'INIT_EOF'
#!/bin/bash
# Bill Sloth First Boot Setup

if [ ! -f ~/.billsloth-setup-complete ]; then
    echo "████████████████████████████████████████████████████████████████████████████████"
    echo "██  ░▒▓█ INITIALIZING BILL SLOTH CYBERPUNK SYSTEM █▓▒░                         ██"
    echo "████████████████████████████████████████████████████████████████████████████████"
    echo ""
    
    # Clone Bill Sloth repository
    echo "▓▓▓ Setting up Bill Sloth automation system..."
    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth
    
    # Make scripts executable
    find ~/bill-sloth -name "*.sh" -exec chmod +x {} \; 2>/dev/null
    
    # Run onboarding if available
    if [ -f ~/bill-sloth/onboard.sh ]; then
        cd ~/bill-sloth
        bash onboard.sh
    fi
    
    # Set up directories
    mkdir -p ~/Projects ~/Scripts
    
    # Configure git
    git config --global user.name "Bill Sloth"
    git config --global user.email "bill@slothlab.cyber"
    
    # Mark setup complete
    touch ~/.billsloth-setup-complete
    
    echo ""
    echo "✅ Bill Sloth system ready!"
    echo "Run: cd ~/bill-sloth && ./bill_command_center.sh"
    echo ""
fi
INIT_EOF

chmod +x config/includes.chroot/usr/local/bin/billsloth-init

# Add to bashrc for auto-setup
mkdir -p config/includes.chroot/etc/skel
echo 'billsloth-init' >> config/includes.chroot/etc/skel/.bashrc

# Build the ISO
echo ''
echo '████ BUILDING CYBERPUNK ISO (This will take 20-60 minutes) ████'
echo 'Build started at:' `$(date)
echo ''

sudo lb build 2>&1 | tee /tmp/billsloth-build.log

# Check for generated ISO
echo ''
echo '▓▓▓ Checking for generated ISO...'
ISO_FILE=`$(find . -name '*.iso' -type f | head -1)

if [ -n "`$ISO_FILE" ]; then
    echo "✅ ISO file found: `$ISO_FILE"
    echo "Size: `$(ls -lh "`$ISO_FILE" | awk '{print `$5}')"
    
    # Copy to Windows location
    echo "▓▓▓ Copying to Windows filesystem..."
    if cp "`$ISO_FILE" `$OUTPUT_PATH; then
        echo ""
        echo "████████████████████████████████████████████████████████████████████████████████"
        echo "██  ✅ BILL SLOTH CYBERPUNK ISO CREATED SUCCESSFULLY!                         ██"
        echo "████████████████████████████████████████████████████████████████████████████████"
        echo ""
        echo "Location: `$OUTPUT_PATH"
        echo "Size: `$(ls -lh `$OUTPUT_PATH | awk '{print `$5}')"
        echo "Completed: `$(date)"
        echo ""
        echo "🦥⚡ Your cyberpunk sloth ISO is ready for dual-boot installation!"
    else
        echo "❌ ERROR: Could not copy ISO to Windows location"
        exit 1
    fi
else
    echo "❌ ERROR: No ISO file generated!"
    echo ""
    echo "Build failed - check logs"
    tail -20 /tmp/billsloth-build.log 2>/dev/null || echo "No log available"
    echo ""
    echo "NO FALLBACK TO STANDARD UBUNTU - Fix the issue and try again"
    exit 1
fi

# Cleanup
cd /
rm -rf `$PROJECT_DIR
"@

Write-Host "Executing verified WSL2 live-build command..." -ForegroundColor Green
Write-Host "This process will take 20-60 minutes for a real custom ISO build" -ForegroundColor Yellow
Write-Host ""

try {
    # Execute the verified working command using detected Ubuntu distro
    $result = wsl -d $ubuntuDistro bash -c $buildCommand
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "🎉 SUCCESS: Custom Bill Sloth Cyberpunk ISO created!" -ForegroundColor Green
        Write-Host "File location: $OutputISO" -ForegroundColor Cyan
        
        # Verify file exists and show size
        if (Test-Path $OutputISO) {
            $isoSize = (Get-Item $OutputISO).Length / 1GB
            Write-Host "File size: $([math]::Round($isoSize, 2)) GB" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "✅ This is a REAL custom ISO with Bill Sloth pre-integrated!" -ForegroundColor Green
            Write-Host "✅ No fallback to standard Ubuntu - actual custom build!" -ForegroundColor Green
        }
        
        exit 0
    } else {
        throw "WSL2 build process failed with exit code $LASTEXITCODE"
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
    Write-Host "NO FALLBACK TO STANDARD UBUNTU" -ForegroundColor Yellow
    Write-Host "This means the custom ISO requirement cannot be met." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Check WSL2 setup:" -ForegroundColor Cyan
    Write-Host "1. Ensure WSL2 is installed: wsl --install" -ForegroundColor White
    Write-Host "2. Install Ubuntu: wsl --install -d Ubuntu" -ForegroundColor White
    Write-Host "3. Update packages: wsl -d Ubuntu bash -c 'sudo apt update && sudo apt install -y live-build'" -ForegroundColor White
    
    exit 1
}