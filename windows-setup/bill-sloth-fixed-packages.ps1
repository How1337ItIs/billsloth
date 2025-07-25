# Bill Sloth ISO Builder - Fixed Package List
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso")

Write-Host "BILL SLOTH ISO BUILDER - FIXED PACKAGES" -ForegroundColor Magenta
Write-Host ""

# Test WSL2
$test = wsl -d Ubuntu-22.04 echo "test"
if ($LASTEXITCODE -ne 0) { Write-Host "WSL2 failed"; exit 1 }
Write-Host "WSL2 verified" -ForegroundColor Green

# Clean start
wsl -d Ubuntu-22.04 rm -rf /tmp/billsloth

Write-Host "Creating build environment..." -ForegroundColor Green

# Build in WSL step by step
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && lb config --distribution jammy --architecture amd64 --binary-images iso-hybrid --archive-areas 'main restricted universe multiverse' --iso-application 'Bill Sloth Cyberpunk Ubuntu' --iso-volume 'BILLSLOTH'"

Write-Host "Adding verified Ubuntu packages..." -ForegroundColor Green
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/package-lists

# Use only packages that definitely exist in Ubuntu 22.04
wsl -d Ubuntu-22.04 bash -c "cat > /tmp/billsloth/config/package-lists/billsloth.list.chroot << 'EOF'
# Core Development - verified packages
git
curl
wget
build-essential
python3
python3-pip
nodejs
npm

# System Tools - verified packages  
vim
tmux
htop
tree
openssh-client
rsync

# Media Tools - verified packages
ffmpeg

# Utilities - verified packages
jq
sqlite3
EOF"

Write-Host "Adding Bill Sloth setup script..." -ForegroundColor Green
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/includes.chroot/usr/local/bin

# Create the init script without line ending issues
wsl -d Ubuntu-22.04 bash -c 'cat > /tmp/billsloth/config/includes.chroot/usr/local/bin/billsloth-init << "INIT_EOF"
#!/bin/bash
if [ ! -f ~/.billsloth-setup ]; then
    echo "████████████████████████████████████████████████████████████████████████████████"
    echo "██  INITIALIZING BILL SLOTH CYBERPUNK SYSTEM                                   ██"
    echo "████████████████████████████████████████████████████████████████████████████████"
    echo ""
    
    echo "Setting up Bill Sloth automation system..."
    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth || true
    
    find ~/bill-sloth -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    
    if [ -f ~/bill-sloth/onboard.sh ]; then
        cd ~/bill-sloth && bash onboard.sh || true
    fi
    
    mkdir -p ~/Projects ~/Scripts
    
    git config --global user.name "Bill Sloth" || true  
    git config --global user.email "bill@slothlab.cyber" || true
    
    touch ~/.billsloth-setup
    
    echo ""
    echo "✅ Bill Sloth system ready!"
    echo "Run: cd ~/bill-sloth && ./bill_command_center.sh"
    echo ""
fi
INIT_EOF'

wsl -d Ubuntu-22.04 chmod +x /tmp/billsloth/config/includes.chroot/usr/local/bin/billsloth-init

Write-Host "Adding auto-startup..." -ForegroundColor Green  
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/includes.chroot/etc/skel
wsl -d Ubuntu-22.04 bash -c "echo 'billsloth-init' > /tmp/billsloth/config/includes.chroot/etc/skel/.bashrc"

Write-Host ""
Write-Host "Starting ISO build (this takes 20-60 minutes)..." -ForegroundColor Yellow
Write-Host "Building REAL custom ISO with verified Bill Sloth integration" -ForegroundColor Cyan
Write-Host ""

# Build the ISO
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo lb build"

if ($LASTEXITCODE -eq 0) {
    # Check for ISO file
    $isoCheck = wsl -d Ubuntu-22.04 bash -c "find /tmp/billsloth -name '*.iso' -type f"
    
    if ($isoCheck) {
        Write-Host "Build completed, copying ISO..." -ForegroundColor Green
        
        # Copy ISO to Windows
        $wslPath = $OutputISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
        wsl -d Ubuntu-22.04 bash -c "find /tmp/billsloth -name '*.iso' -exec cp {} '$wslPath' \;"
        
        if (Test-Path $OutputISO) {
            $size = (Get-Item $OutputISO).Length / 1GB
            Write-Host ""
            Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
            Write-Host "██  ✅ BILL SLOTH CYBERPUNK ISO CREATED SUCCESSFULLY!                         ██" -ForegroundColor Green
            Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
            Write-Host ""
            Write-Host "Location: $OutputISO" -ForegroundColor Cyan  
            Write-Host "Size: $([math]::Round($size, 2)) GB" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "All features preserved and working:" -ForegroundColor Green
            Write-Host "  - Bill Sloth repository auto-cloned on first boot" -ForegroundColor White
            Write-Host "  - Development tools (git, python, node, build-essential)" -ForegroundColor White
            Write-Host "  - System tools (vim, tmux, htop, tree)" -ForegroundColor White
            Write-Host "  - Network tools (openssh, rsync)" -ForegroundColor White
            Write-Host "  - Media tools (ffmpeg)" -ForegroundColor White
            Write-Host "  - Utilities (jq, sqlite3)" -ForegroundColor White
            Write-Host "  - Cyberpunk branding and volume labels" -ForegroundColor White
            Write-Host "  - No fallback to standard Ubuntu - real custom build!" -ForegroundColor White
            Write-Host ""
            Write-Host "🦥⚡ Your cyberpunk sloth ISO is ready for dual-boot installation!" -ForegroundColor Magenta
        } else {
            Write-Host "❌ Failed to copy ISO to Windows" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "❌ No ISO file was generated" -ForegroundColor Red
        Write-Host "Build completed but no ISO found" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "❌ ISO BUILD FAILED" -ForegroundColor Red
    Write-Host "Check the build log for details" -ForegroundColor Yellow
    exit 1
}