#!/bin/bash
set -e

echo "████████████████████████████████████████████████████████████████████████████████"
echo "██  🚀 BUILDING CUSTOM BILL SLOTH CYBERPUNK ISO                               ██"  
echo "████████████████████████████████████████████████████████████████████████████████"
echo ""

PROJECT_DIR="/tmp/billsloth-final-$(date +%s)"
OUTPUT_PATH="/mnt/c/Users/Sloth/Desktop/BillSloth-Cyberpunk-Ubuntu.iso"

echo "▓▓▓ Creating project directory: $PROJECT_DIR"
mkdir -p "$PROJECT_DIR" && cd "$PROJECT_DIR"
echo "▓▓▓ Working in: $(pwd)"

echo "▓▓▓ Configuring live-build for Ubuntu 22.04 jammy..."
lb config \
    --distribution jammy \
    --architecture amd64 \
    --binary-images iso-hybrid \
    --archive-areas "main restricted universe multiverse" \
    --iso-application "Bill Sloth Cyberpunk Ubuntu" \
    --iso-volume "BILLSLOTH" \
    --iso-preparer "bill@slothlab.cyber" \
    --iso-publisher "Cyberpunk Sloth Automation Lab"

echo "✅ Configuration completed"

echo "▓▓▓ Creating Bill Sloth package list..."
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

# System Tools  
neovim
tmux
htop
tree
ripgrep

# Audio Tools
pipewire
pipewire-pulse
carla
qjackctl
pavucontrol

# Voice Control
espeak
festival
flite
sox

# Network & SSH
openssh-client
openssh-server
rsync
EOF

echo "✅ Package list created"
echo "▓▓▓ Package count: $(wc -l < config/package-lists/billsloth.list.chroot) packages"

echo ""
echo "████████████████████████████████████████████████████████████████████████████████"
echo "██  🔥 STARTING CUSTOM ISO BUILD - THIS WILL TAKE 20-60 MINUTES              ██"
echo "████████████████████████████████████████████████████████████████████████████████"
echo "Start time: $(date)"
echo "Build directory: $PROJECT_DIR"
echo "Output location: $OUTPUT_PATH"
echo ""

# Start the build with logging
sudo lb build 2>&1 | tee /tmp/billsloth-build.log
BUILD_EXIT_CODE=${PIPESTATUS[0]}

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    echo ""
    echo "▓▓▓ Build completed successfully! Checking for ISO file..."
    
    ISO_FILE=$(find . -name "*.iso" -type f | head -1)
    if [ -n "$ISO_FILE" ]; then
        echo "✅ ISO file found: $ISO_FILE"
        echo "▓▓▓ File size: $(ls -lh "$ISO_FILE" | awk '{print $5}')"
        
        echo "▓▓▓ Copying to Windows desktop..."
        if cp "$ISO_FILE" "$OUTPUT_PATH"; then
            echo ""
            echo "████████████████████████████████████████████████████████████████████████████████"
            echo "██  ✅ SUCCESS: CUSTOM BILL SLOTH ISO CREATED!                                ██"
            echo "████████████████████████████████████████████████████████████████████████████████"
            echo "Location: $OUTPUT_PATH"
            echo "Size: $(ls -lh "$OUTPUT_PATH" | awk '{print $5}')"
            echo "Completion time: $(date)"
            echo ""
            echo "🚀 CUSTOM CYBERPUNK ISO READY FOR DUAL BOOT INSTALLATION! 🦥⚡"
        else
            echo "❌ Failed to copy ISO to Windows desktop"
            exit 1
        fi
    else
        echo "❌ No ISO file generated"
        echo "Build log tail:"
        tail -20 /tmp/billsloth-build.log
        exit 1
    fi
else
    echo "❌ Build failed with exit code: $BUILD_EXIT_CODE"
    echo "Build log tail:"
    tail -30 /tmp/billsloth-build.log
    exit 1
fi