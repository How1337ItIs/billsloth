#!/bin/bash
set -e  # Exit on any error - no silent failures!

PROJECT_DIR="/tmp/billsloth-debug-$(date +%s)"
OUTPUT_PATH="/mnt/c/Users/Sloth/Desktop/BillSloth-Debug-Test.iso"
UBUNTU_VERSION="jammy"

echo "████ BILL SLOTH DEBUG ISO BUILD ████"
echo "Running in: $(uname -a)"
echo "Project dir: $PROJECT_DIR"
echo "Output path: $OUTPUT_PATH"
echo "Ubuntu version: $UBUNTU_VERSION"
echo ""

# Ensure we're in Linux
if [[ ! -f /proc/version ]] || [[ ! $(grep -i linux /proc/version) ]]; then
    echo "ERROR: Not running in Linux environment!"
    exit 1
fi

echo "✅ Running in Linux environment"

# Check live-build
if ! command -v lb &> /dev/null; then
    echo "❌ ERROR: live-build not installed!"
    exit 1
fi

echo "✅ live-build available: $(which lb)"
echo "Version: $(lb --version 2>/dev/null || echo 'version check failed')"

# Create project directory
echo "Creating project structure..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
echo "Working in: $(pwd)"

# Initialize live-build project
echo "Initializing live-build configuration..."
lb config \
    --distribution "$UBUNTU_VERSION" \
    --architecture amd64 \
    --binary-images iso-hybrid \
    --archive-areas "main restricted universe multiverse" \
    --apt-indices false \
    --apt-recommends true \
    --memtest none \
    --win32-loader false \
    --iso-application "Bill Sloth Debug Test" \
    --iso-volume "BILLSLOTH" \
    --iso-preparer "bill@slothlab.cyber" \
    --iso-publisher "Cyberpunk Sloth Automation Lab"

echo "✅ Configuration completed"
echo "Config directory contents:"
ls -la config/

echo ""
echo "DEBUG: Starting minimal build test..."
echo "This should fail early if there are permission/environment issues"

# Run just the bootstrap stage to test
echo "Testing bootstrap stage..."
sudo lb bootstrap 2>&1 | head -20

echo ""
echo "If we got here, basic live-build functionality works!"
echo "Issue is likely in the full build process or template substitution"