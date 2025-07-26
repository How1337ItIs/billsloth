# WSL2 Build Debug Analysis

**Date:** July 24, 2025  
**Issue:** WSL2 live-build attempting to use Ubuntu 12.04 "precise" instead of Ubuntu 22.04 "jammy"  
**Status:** Configuration not being applied properly in build script  
**Root Cause:** Script template substitution or configuration error

## Problem Details

### Error Observed
```
E: Failed getting release file http://archive.ubuntu.com/ubuntu/dists/precise/Release
```

### Expected Behavior
Should be downloading from:
```
http://archive.ubuntu.com/ubuntu/dists/jammy/Release
```

### Configuration Test Results
```bash
# Manual config works correctly:
lb config --distribution jammy --architecture amd64 --binary-images iso-hybrid
# Result: Creates proper jammy config

# Build without config defaults to precise:
sudo lb build
# Result: Tries to download precise (Ubuntu 12.04)
```

## Issue Analysis

### Template Substitution Problem
The WSL2 builder script has template placeholders:
```bash
UBUNTU_VERSION="{UBUNTU_VERSION}"
```

These should be replaced with actual values:
```bash
UBUNTU_VERSION="jammy"
```

### Possible Causes
1. **PowerShell string replacement** not working correctly
2. **Script template** contains unreplaced placeholders
3. **live-build config** not being initialized before build
4. **Wrong working directory** for build execution

## Fix Required

### Check Template Replacement
The PowerShell script should be doing:
```powershell
$buildScript = $buildScript -replace '{UBUNTU_VERSION}', $UbuntuVersion
```

### Verify Configuration Application
The bash script should run:
```bash
lb config --distribution "$UBUNTU_VERSION" --architecture amd64
# BEFORE running:
sudo lb build
```

## Next Steps

1. **Debug the template substitution** in PowerShell script
2. **Verify configuration is applied** before build
3. **Ensure proper working directory** for live-build
4. **Add more detailed error reporting** from WSL2 execution

---

**Status:** Configuration issue - live-build not using correct Ubuntu version  
**Priority:** High - prevents custom ISO creation  
**Fix Required:** Correct template substitution and configuration sequence