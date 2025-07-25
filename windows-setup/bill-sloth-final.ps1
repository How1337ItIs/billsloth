# Bill Sloth Final Working ISO Builder
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso")

Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
Write-Host "██  BILL SLOTH FINAL ISO BUILDER - FIXES LINE ENDING ISSUES                    ██" -ForegroundColor Magenta
Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
Write-Host ""

# Test WSL2
$test = wsl -d Ubuntu-22.04 echo "WSL2 working"
if ($LASTEXITCODE -ne 0) { 
    Write-Host "❌ WSL2 failed" -ForegroundColor Red
    exit 1 
}
Write-Host "✅ WSL2 Ubuntu-22.04 verified" -ForegroundColor Green

# Clean and create build directory  
wsl -d Ubuntu-22.04 rm -rf /tmp/billsloth
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/package-lists
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/includes.chroot/usr/local/bin
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/includes.chroot/etc/skel

Write-Host "✅ Build directories created" -ForegroundColor Green

# Create build script line by line to avoid line ending issues
wsl -d Ubuntu-22.04 bash -c 'echo "#!/bin/bash" > /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "set -e" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "cd /tmp/billsloth" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "echo \"Building Bill Sloth Cyberpunk ISO...\"" >> /tmp/billsloth/build.sh'

# Configure live-build
wsl -d Ubuntu-22.04 bash -c 'echo "lb config --distribution jammy --architecture amd64 --binary-images iso-hybrid --archive-areas \"main restricted universe multiverse\" --iso-application \"Bill Sloth Cyberpunk Ubuntu\" --iso-volume \"BILLSLOTH\"" >> /tmp/billsloth/build.sh'

# Create package list file
wsl -d Ubuntu-22.04 bash -c 'cat > /tmp/billsloth/config/package-lists/billsloth.list.chroot << EOF
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
pipewire
pipewire-pulse
pipewire-jack
carla
qjackctl
pavucontrol
pulseaudio-utils
alsa-utils
jackd2
espeak
festival
flite
sox
libsox-fmt-all
speech-dispatcher
neovim
vim
tmux
htop
tree
ripgrep
fd-find
bat
fzf
openssh-client
openssh-server
rsync
net-tools
ffmpeg
imagemagick
libssl-dev
libffi-dev
sqlite3
jq
EOF'

# Create Bill Sloth init script
wsl -d Ubuntu-22.04 bash -c 'cat > /tmp/billsloth/config/includes.chroot/usr/local/bin/billsloth-init << EOF
#!/bin/bash
if [ ! -f ~/.billsloth-setup-complete ]; then
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
    
    touch ~/.billsloth-setup-complete
    
    echo ""
    echo "✅ Bill Sloth system ready!"
    echo "Run: cd ~/bill-sloth && ./bill_command_center.sh"
    echo ""
fi
EOF'

# Make init script executable
wsl -d Ubuntu-22.04 chmod +x /tmp/billsloth/config/includes.chroot/usr/local/bin/billsloth-init

# Add to bashrc for auto-setup
wsl -d Ubuntu-22.04 bash -c 'echo "billsloth-init" > /tmp/billsloth/config/includes.chroot/etc/skel/.bashrc'

# Add build command to script
wsl -d Ubuntu-22.04 bash -c 'echo "echo \"Starting ISO build (20-60 minutes)...\"" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "sudo lb build 2>&1 | tee /tmp/billsloth-build.log" >> /tmp/billsloth/build.sh'

# Add ISO check and copy
wsl -d Ubuntu-22.04 bash -c 'echo "ISO_FILE=\$(find . -name \"*.iso\" -type f | head -1)" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "if [ -n \"\$ISO_FILE\" ]; then" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "  echo \"✅ ISO created: \$ISO_FILE\"" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "  echo \"Size: \$(du -h \"\$ISO_FILE\" | cut -f1)\"" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "else" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "  echo \"❌ No ISO generated\"" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "  exit 1" >> /tmp/billsloth/build.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "fi" >> /tmp/billsloth/build.sh'

# Make build script executable
wsl -d Ubuntu-22.04 chmod +x /tmp/billsloth/build.sh

Write-Host "✅ Build script created with all Bill Sloth features" -ForegroundColor Green
Write-Host ""
Write-Host "Starting ISO build (20-60 minutes)..." -ForegroundColor Yellow
Write-Host "This creates a REAL custom ISO with:" -ForegroundColor Cyan
Write-Host "  ▓ 40+ packages for development, audio, and voice control" -ForegroundColor White
Write-Host "  ▓ Bill Sloth repository auto-cloned on first boot" -ForegroundColor White  
Write-Host "  ▓ Cyberpunk branding and volume labels" -ForegroundColor White
Write-Host "  ▓ No fallback to standard Ubuntu" -ForegroundColor White
Write-Host ""

# Run the build
wsl -d Ubuntu-22.04 bash /tmp/billsloth/build.sh

if ($LASTEXITCODE -eq 0) {
    # Find and copy the ISO
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
        Write-Host "✅ All Bill Sloth features preserved and integrated!" -ForegroundColor Green
        Write-Host "✅ No fallback to standard Ubuntu - actual custom build!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🦥⚡ Your cyberpunk sloth ISO is ready for dual-boot installation!" -ForegroundColor Magenta
    } else {
        Write-Host "❌ Failed to copy ISO to Windows" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "❌ CUSTOM ISO BUILD FAILED!" -ForegroundColor Red
    Write-Host "Check build log with: wsl -d Ubuntu-22.04 cat /tmp/billsloth-build.log" -ForegroundColor Yellow
    exit 1
}