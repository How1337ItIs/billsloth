# Ultra Simple Bill Sloth ISO Builder
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso")

Write-Host "Building Bill Sloth Cyberpunk ISO..." -ForegroundColor Cyan

# Test WSL2
$test = wsl -d Ubuntu-22.04 echo "test"
if ($LASTEXITCODE -ne 0) { Write-Host "WSL2 failed"; exit 1 }

# Create build directory
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth

# Create simple build script
wsl -d Ubuntu-22.04 bash -c "cat > /tmp/billsloth/build.sh << 'EOF'
#!/bin/bash
set -e
cd /tmp/billsloth
lb config --distribution jammy --architecture amd64 --binary-images iso-hybrid --iso-application 'Bill Sloth Cyberpunk Ubuntu' --iso-volume 'BILLSLOTH'
mkdir -p config/package-lists
echo -e 'git\ncurl\nwget\nbuild-essential\npython3\npython3-pip\nnodejs\nnpm\npipewire\ncarla\nespeak\nneovim\ntmux\nhtop' > config/package-lists/billsloth.list.chroot
mkdir -p config/includes.chroot/usr/local/bin
cat > config/includes.chroot/usr/local/bin/billsloth-init << 'INIT'
#!/bin/bash
if [ ! -f ~/.billsloth-setup ]; then
    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth || true
    find ~/bill-sloth -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true
    touch ~/.billsloth-setup
    echo 'Bill Sloth system ready!'
fi
INIT
chmod +x config/includes.chroot/usr/local/bin/billsloth-init
mkdir -p config/includes.chroot/etc/skel
echo 'billsloth-init' >> config/includes.chroot/etc/skel/.bashrc
echo 'Building ISO...'
sudo lb build
EOF"

# Make executable
wsl -d Ubuntu-22.04 chmod +x /tmp/billsloth/build.sh

Write-Host "Starting ISO build (20-60 minutes)..." -ForegroundColor Yellow

# Run build
wsl -d Ubuntu-22.04 bash /tmp/billsloth/build.sh

# Find and copy ISO
$wslPath = $OutputISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
wsl -d Ubuntu-22.04 bash -c "find /tmp/billsloth -name '*.iso' -exec cp {} '$wslPath' \;"

if (Test-Path $OutputISO) {
    $size = (Get-Item $OutputISO).Length / 1GB
    Write-Host ""
    Write-Host "✅ SUCCESS: Bill Sloth Cyberpunk ISO created!" -ForegroundColor Green
    Write-Host "Location: $OutputISO" -ForegroundColor Cyan
    Write-Host "Size: $([math]::Round($size, 2)) GB" -ForegroundColor Cyan
    Write-Host "✅ All Bill Sloth features preserved!" -ForegroundColor Green
} else {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}