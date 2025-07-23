# Deploy Windows Setup to Repository

## Current Status: CRITICAL BLOCKER
The windows-setup directory exists only locally and needs to be uploaded to the repository for the one-click system to work.

## Files That Need to Be Uploaded:

### Core Scripts (REQUIRED):
- `bill-sloth-auto-setup.ps1` - One-click downloader and launcher
- `ubuntu-installer-prep.ps1` - Main dual-boot preparation script  
- `bill-sloth-windows-bootstrap.ps1` - System analysis and preparation
- `bill-sloth-claude-assisted-setup.ps1` - Claude Code integration

### Supporting Files:
- `README.md` - Windows setup instructions
- `ONE_CLICK_SETUP_STATUS.md` - Implementation status
- `claude-prompts/dual-boot-setup-prompt.md` - Claude Code prompt

### Documentation:
- `BILL_SLOTH_FUNCTIONALITY_AUDIT.md` - System audit report
- `DEPENDENCY_STATUS.md` - Dependency documentation

## Deployment Steps:

### Option 1: Manual GitHub Upload
1. Go to https://github.com/how1337itis/billsloth
2. Create new directory: `windows-setup`
3. Upload all files from `C:\Users\natha\bill sloth\windows-setup\`
4. Commit changes

### Option 2: Git Command Line
```bash
# From repository root
git add windows-setup/
git commit -m "Add Windows dual-boot preparation system

- One-click Claude Code integration
- Automated Ubuntu ISO download and USB creation  
- System analysis and partition preparation
- Emergency recovery procedures
- ADHD-friendly user experience

🤖 Generated with Claude Code"
git push origin main
```

### Option 3: Alternative Bootstrap (IMMEDIATE FIX)
Modify existing `install.sh` to include Windows detection and redirect:

```bash
# Add to beginning of install.sh
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    echo "Windows system detected - redirecting to dual-boot setup..."
    echo "Copy and paste this into PowerShell as Administrator:"
    echo ""
    echo "Set-ExecutionPolicy Bypass -Scope Process -Force"  
    echo "iex (iwr -useb 'https://raw.githubusercontent.com/how1337itis/billsloth/main/windows-bootstrap.ps1')"
    exit 0
fi
```

Then create minimal `windows-bootstrap.ps1` in repository root.

## RECOMMENDED IMMEDIATE ACTION:

Create a minimal bootstrap script that can be uploaded immediately:

**File: `windows-bootstrap.ps1`** (Place in repository root)
```powershell
# Bill Sloth Windows Dual-Boot Bootstrap
# Minimal script to download and run full Windows setup

Write-Host "🚀 Bill Sloth Windows Dual-Boot Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

$setupDir = "$env:USERPROFILE\bill-sloth-windows" 
if (!(Test-Path $setupDir)) { New-Item -ItemType Directory -Path $setupDir -Force | Out-Null }

# Download main scripts (these would need to be uploaded to repo)
$scripts = @(
    "ubuntu-installer-prep.ps1",
    "bill-sloth-windows-bootstrap.ps1"
)

foreach ($script in $scripts) {
    try {
        $url = "https://raw.githubusercontent.com/how1337itis/billsloth/main/windows-setup/$script"
        $localPath = "$setupDir\$script"
        Invoke-WebRequest -Uri $url -OutFile $localPath
        Write-Host "✅ Downloaded: $script" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to download: $script" -ForegroundColor Red
        Write-Host "Manual download required from repository" -ForegroundColor Yellow
        exit 1
    }
}

# Run main setup
& "$setupDir\ubuntu-installer-prep.ps1" -FullSetup
```

## URL Updates Needed After Upload:
Once files are uploaded, all scripts are already configured with correct URLs:
- `https://raw.githubusercontent.com/how1337itis/billsloth/main/windows-setup/...`

## Testing After Upload:
```powershell
# Test the one-click setup
iex (iwr -useb 'https://raw.githubusercontent.com/how1337itis/billsloth/main/windows-setup/bill-sloth-auto-setup.ps1')
```

**CURRENT BLOCKER**: Files exist locally but not in repository - preventing one-click functionality.
**RESOLUTION TIME**: 5-10 minutes to upload files
**IMPACT**: System goes from 95% to 100% functional