# Bill Sloth Working ISO Builder
param(
    [string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso"
)

#Requires -RunAsAdministrator

Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
Write-Host "██  ░▒▓█ BILL SLOTH WORKING ISO BUILDER █▓▒░                                   ██" -ForegroundColor Magenta
Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
Write-Host ""
Write-Host "Creating custom Bill Sloth cyberpunk ISO..." -ForegroundColor Cyan
Write-Host "Build time: 20-60 minutes (real custom ISO creation)" -ForegroundColor Yellow
Write-Host ""

# Test WSL2
try {
    $wslTest = wsl -d Ubuntu-22.04 bash -c "echo 'WSL2 test successful'"
    if ($LASTEXITCODE -ne 0) {
        throw "WSL2 Ubuntu-22.04 not working"
    }
    Write-Host "✅ WSL2 Ubuntu-22.04 verified" -ForegroundColor Green
}
catch {
    Write-Host "❌ WSL2 not available" -ForegroundColor Red
    exit 1
}

# Convert output path
$wslOutputPath = $OutputISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
Write-Host "Output: $OutputISO" -ForegroundColor Cyan
Write-Host ""

# Create build script
$buildScript = 'set -e
PROJECT_DIR="/tmp/billsloth-iso-$(date +%s)"
OUTPUT_PATH="' + $wslOutputPath + '"

echo "████ BILL SLOTH CYBERPUNK ISO BUILDER ████"
echo "Starting at: $(date)"
echo ""

# Create build directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Configure live-build
echo "▓▓▓ Configuring live-build..."
lb config \
    --distribution jammy \
    --architecture amd64 \
    --binary-images iso-hybrid \
    --archive-areas "main restricted universe multiverse" \
    --iso-application "Bill Sloth Cyberpunk Ubuntu" \
    --iso-volume "BILLSLOTH"

# Create package list
echo "▓▓▓ Creating package list..."
mkdir -p config/package-lists
cat > config/package-lists/billsloth.list.chroot << EOF
git
curl
wget
build-essential
python3
python3-pip
nodejs
npm
pipewire
pipewire-pulse
carla
qjackctl
pavucontrol
espeak
festival
flite
sox
neovim
tmux
htop
tree
ripgrep
openssh-client
openssh-server
rsync
ffmpeg
imagemagick
jq
EOF

# Add Bill Sloth setup script
echo "▓▓▓ Adding Bill Sloth first-boot setup..."
mkdir -p config/includes.chroot/usr/local/bin

cat > config/includes.chroot/usr/local/bin/billsloth-init << "INIT_EOF"
#!/bin/bash
if [ ! -f ~/.billsloth-setup-complete ]; then
    echo "████ INITIALIZING BILL SLOTH SYSTEM ████"
    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth || true
    find ~/bill-sloth -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    if [ -f ~/bill-sloth/onboard.sh ]; then
        cd ~/bill-sloth && bash onboard.sh || true
    fi
    mkdir -p ~/Projects ~/Scripts
    git config --global user.name "Bill Sloth" || true
    git config --global user.email "bill@slothlab.cyber" || true
    touch ~/.billsloth-setup-complete
    echo "✅ Bill Sloth system ready!"
fi
INIT_EOF

chmod +x config/includes.chroot/usr/local/bin/billsloth-init

# Add to bashrc
mkdir -p config/includes.chroot/etc/skel
echo "billsloth-init" >> config/includes.chroot/etc/skel/.bashrc

# Build the ISO
echo ""
echo "████ BUILDING ISO (20-60 minutes) ████"
echo "Build started: $(date)"
echo ""

sudo lb build 2>&1 | tee /tmp/billsloth-build.log

# Check for ISO
ISO_FILE=$(find . -name "*.iso" -type f | head -1)
if [ -n "$ISO_FILE" ]; then
    echo ""
    echo "✅ ISO created: $ISO_FILE"
    echo "Size: $(ls -lh "$ISO_FILE" | awk '"'"'{print $5}'"'"')"
    
    # Copy to Windows
    echo "▓▓▓ Copying to Windows..."
    cp "$ISO_FILE" "$OUTPUT_PATH"
    
    if [ -f "$OUTPUT_PATH" ]; then
        echo ""
        echo "████████████████████████████████████████████████████████████████████████████████"
        echo "██  ✅ BILL SLOTH CYBERPUNK ISO CREATED SUCCESSFULLY!                         ██"
        echo "████████████████████████████████████████████████████████████████████████████████"
        echo "Location: $OUTPUT_PATH"
        echo "Size: $(ls -lh "$OUTPUT_PATH" | awk '"'"'{print $5}'"'"')"
        echo "Completed: $(date)"
        echo ""
        echo "🦥⚡ Custom cyberpunk ISO ready for dual-boot installation!"
    else
        echo "❌ Failed to copy to Windows"
        exit 1
    fi
else
    echo "❌ No ISO generated"
    echo "Build log (last 20 lines):"
    tail -20 /tmp/billsloth-build.log 2>/dev/null || echo "No log available"
    exit 1
fi

# Cleanup
cd /
rm -rf "$PROJECT_DIR"'

Write-Host "Executing ISO build in WSL2..." -ForegroundColor Green
Write-Host "This will take 20-60 minutes..." -ForegroundColor Yellow
Write-Host ""

try {
    $result = wsl -d Ubuntu-22.04 bash -c $buildScript
    
    if ($LASTEXITCODE -eq 0 -and (Test-Path $OutputISO)) {
        $isoSize = (Get-Item $OutputISO).Length / 1GB
        Write-Host ""
        Write-Host "🎉 SUCCESS: Custom Bill Sloth ISO created!" -ForegroundColor Green
        Write-Host "File: $OutputISO" -ForegroundColor Cyan
        Write-Host "Size: $([math]::Round($isoSize, 2)) GB" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "✅ This is a REAL custom ISO with Bill Sloth pre-integrated!" -ForegroundColor Green
        Write-Host "✅ No fallback to standard Ubuntu - actual custom build!" -ForegroundColor Green
    } else {
        throw "Build failed or ISO not created"
    }
}
catch {
    Write-Host ""
    Write-Host "❌ CUSTOM ISO CREATION FAILED!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "NO FALLBACK TO STANDARD UBUNTU" -ForegroundColor Yellow
    exit 1
}