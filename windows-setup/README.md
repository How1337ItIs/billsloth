# Bill Sloth Windows Dual-Boot Setup Package

This package provides comprehensive Windows-based tools to prepare for Ubuntu dual-boot installation with full Claude Code integration.

## 🚀 Quick Start

### **For Claude Code Users (Recommended - One-Click Setup):**

Copy and paste this prompt into Claude Code:
```
Help me set up dual-boot Ubuntu on my Windows system using the Bill Sloth automation suite from https://github.com/How1337ItIs/billsloth/tree/main/windows-setup. I need you to handle the technical details and make this as automated as possible.

What I want you to do:
1. Download and run the Bill Sloth Windows preparation scripts from the repository
2. Analyze my Windows system for dual-boot compatibility 
3. Help me prepare partitions safely without data loss
4. Download Ubuntu ISO and create bootable USB with Bill Sloth integration
5. Guide me through the process with clear, ADHD-friendly instructions

Please start by downloading the Bill Sloth auto-setup script and running the automated system analysis. I'll confirm any major changes but otherwise handle the technical details automatically.
```

### **For Manual Setup:**

Run as Administrator in PowerShell:

```powershell
# ⭐ NEW: Fine-tuned dual-boot wizard (maximum automation + token efficiency)
.\fine-tuned-dual-boot-wizard.ps1

# Token conservation mode for Pro subscriptions
.\fine-tuned-dual-boot-wizard.ps1 -ClaudeLevel minimal -ConserveTokens

# High-speed mode (skip Claude integration)
.\fine-tuned-dual-boot-wizard.ps1 -SkipClaude

# ALTERNATIVE: Complete system creator (includes full Bill Sloth automation)
.\bill-sloth-complete-system-creator.ps1

# Traditional approach:
# Complete setup with Claude assistance
.\bill-sloth-claude-assisted-setup.ps1 -Interactive

# Just analyze system without changes
.\bill-sloth-claude-assisted-setup.ps1 -CheckOnly

# Auto-prepare partitions
.\disk-partition-manager.ps1 -AutoShrink -UbuntuSizeGB 100

# Download Ubuntu and create USB
.\ubuntu-installer-prep.ps1 -Interactive
```

## 📁 Package Contents

### Core Scripts

#### `fine-tuned-dual-boot-wizard.ps1` **⭐ NEW & RECOMMENDED**
**Maximum automation dual-boot wizard with token-efficient Claude integration**
- 🚀 Comprehensive system analysis and compatibility checking
- 🤖 Strategic Claude Code integration with token conservation for Pro subscriptions
- 🎯 Intelligent Ubuntu ISO detection and automated download
- 💾 Smart USB drive selection with multiple creation methods  
- 📦 Complete Bill Sloth automation system integration
- 🔧 Built-in troubleshooting and error recovery
- ⚡ High-speed mode option (skip Claude for maximum performance)
- 🧠 ADHD/dyslexia optimized with clear progress indicators

**Usage Examples:**
```powershell
# Standard mode with smart Claude usage
.\fine-tuned-dual-boot-wizard.ps1

# Token conservation mode for Pro subscriptions  
.\fine-tuned-dual-boot-wizard.ps1 -ClaudeLevel minimal -ConserveTokens

# Maximum speed mode
.\fine-tuned-dual-boot-wizard.ps1 -SkipClaude
```

#### `bill-sloth-complete-system-creator.ps1` **⭐ ALTERNATIVE**
**Complete Bill Sloth automation system deployment**
- 🚀 Creates Ubuntu USB with full Bill Sloth system pre-loaded
- 🎯 Auto-detects Ubuntu ISOs and USB drives
- 📦 Includes complete automation, onboarding, and command center
- 🤖 ASCII-only output for Windows PowerShell compatibility
- 🔄 Auto-launch scripts for immediate system activation
- 📚 Comprehensive documentation and desktop launcher
- 🧠 ADHD/dyslexia optimized interface design

#### `bill-sloth-claude-assisted-setup.ps1`
**Main orchestration script with Claude Code integration**
- 🤖 AI-powered system analysis and recommendations
- 🔍 Comprehensive hardware and software compatibility checking
- 💽 Intelligent partition planning with Claude assistance
- 📚 Generates personalized installation guides
- 🆘 Creates emergency recovery packages

**Parameters:**
- `-Interactive` - Interactive mode with user prompts
- `-CheckOnly` - System analysis only, no changes
- `-AIAssisted $true` - Enable Claude Code integration (default)
- `-UbuntuSizeGB 100` - Target Ubuntu partition size

#### `disk-partition-manager.ps1` 
**Advanced partition management with automated shrinking**
- 💾 Detailed disk analysis with fragmentation detection
- 📊 Intelligent shrink potential calculation
- ⚙️ Automated system optimization for partitioning
- 🔧 Safe partition shrinking with rollback protection
- 📋 Comprehensive partition reports

**Parameters:**
- `-AnalyzeOnly` - Disk analysis without modifications
- `-AutoShrink` - Automatically optimize and shrink
- `-Interactive` - Require user confirmation for operations
- `-UbuntuSizeGB 100` - Required space for Ubuntu
- `-TargetDrive "C"` - Drive to shrink

#### `ubuntu-installer-prep.ps1`
**Ubuntu ISO download and USB creation automation with intelligent ISO detection**
- 🔍 **Smart ISO Detection** - Automatically finds existing Ubuntu ISOs in common locations
- 📥 Automated Ubuntu LTS ISO download with progress tracking
- 🔐 SHA256 integrity verification and validation
- 💿 Automated Rufus integration for USB creation
- 📦 Bill Sloth startup package creation
- ⏱️ BITS-enabled resumable downloads
- 💾 **Existing USB Enhancement** - Detects and enhances existing Ubuntu installer USBs

**Parameters:**
- `-UbuntuVersion "22.04.3"` - Ubuntu version to download
- `-ExistingISO "path\to\ubuntu.iso"` - Use specific existing ISO file
- `-SkipDownload` - Skip download, search for existing ISOs only
- `-CreateUSBOnly` - Only create USB from existing ISO
- `-CheckExistingUSB` - Analyze and enhance existing Ubuntu USB drives
- `-Interactive $true` - Interactive mode with prompts and options

**Enhanced Features:**
- **Automatic ISO Detection**: Scans Downloads, Desktop, Documents, and common ISO folders
- **ISO Validation**: Checks filename patterns, file sizes, and SHA256 hashes
- **Interactive Selection**: Choose from multiple found ISOs or browse for specific files
- **USB Analysis**: Detects existing Ubuntu installer USBs and validates their bootability
- **Smart Enhancement**: Adds Bill Sloth startup files to existing USBs without recreation
- **Progress Integration**: Works with progress-bars-addon.ps1 for enhanced visual feedback
- **Rufus Automation**: Can use automated-rufus-addon.ps1 for hands-free USB creation

## 🎯 Recommended Workflow

### Optional: Enhanced Features Setup
If you want enhanced progress tracking and automation:
```powershell
# Download and dot-source the addon scripts for enhanced functionality
. (iwr -useb 'https://raw.githubusercontent.com/how1337itis/billsloth/main/progress-bars-addon.ps1')
. (iwr -useb 'https://raw.githubusercontent.com/how1337itis/billsloth/main/automated-rufus-addon.ps1')
```

### Phase 1: Analysis & Planning
```powershell
# 1. Run Claude-assisted analysis
.\bill-sloth-claude-assisted-setup.ps1 -CheckOnly -Interactive

# 2. Review system analysis and Claude recommendations
# Check generated files in $env:USERPROFILE\bill-sloth-windows\
```

### Phase 2: Preparation
```powershell
# 3. Prepare partitions (if needed)
.\disk-partition-manager.ps1 -Interactive -UbuntuSizeGB 100

# 4. Download Ubuntu and create USB
.\ubuntu-installer-prep.ps1 -Interactive
```

### Phase 3: Complete Setup
```powershell
# 5. Run full preparation with Claude guidance
.\bill-sloth-claude-assisted-setup.ps1 -Interactive
```

## 🤖 Claude Code Integration

### Prerequisites
```bash
npm install -g @anthropic-ai/claude-code
claude login
```

### AI-Powered Features
- **System Analysis**: Claude analyzes your specific hardware configuration
- **Partition Planning**: AI recommends optimal partition strategies
- **Risk Assessment**: Intelligent evaluation of dual-boot compatibility
- **Personalized Guides**: Custom installation instructions for your system
- **Error Recovery**: AI-powered troubleshooting recommendations

### Claude Context
Scripts automatically build context including:
- Hardware specifications and compatibility
- Current disk configuration and usage
- Partition recommendations and rationale  
- Installation progress and decision points
- Error conditions and recovery options

## 🔌 Additional Scripts (Repository Root)

### Enhanced Functionality Scripts

#### `windows-bootstrap.ps1`
**Emergency bootstrap script for quick deployment**
- Minimal system requirements checking
- Downloads full windows-setup package automatically
- Provides fallback instructions if downloads fail
- Can be run directly from web:
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/how1337itis/billsloth/main/windows-bootstrap.ps1'))
```

#### `progress-bars-addon.ps1`
**Enhanced progress tracking for Claude Code integration**
- Visual progress bars for all major operations
- Claude Code status reporting with special formatting
- Real-time status file updates for monitoring
- Functions included:
  - `Show-ProgressWithStatus` - Main progress display with Claude messages
  - `Download-WithProgress` - Enhanced download tracking
  - `Show-DiskProgress` - Disk operation progress
  - `Show-USBProgress` - USB creation stages
  - `Show-AnalysisProgress` - System analysis tracking
  - `Report-ErrorToClaude` - Error reporting with suggestions
  - `Report-SuccessToClaude` - Success notifications

#### `automated-rufus-addon.ps1`
**Fully automated USB creation with Rufus**
- Downloads and configures Rufus 4.4 automatically
- Command-line USB creation (no manual interaction required)
- Intelligent fallback to manual Rufus mode if automation fails
- Alternative PowerShell-based USB creation method
- Functions included:
  - `Install-AutomatedRufus` - Downloads Rufus if needed
  - `New-AutomatedUbuntuUSB` - Automated USB creation
  - `New-PowerShellUbuntuUSB` - Native PowerShell method
  - `New-UbuntuBootableUSB` - Main function with method selection

## 📊 Generated Files

### Reports & Guides
- `CLAUDE-ASSISTED-INSTALL-GUIDE.md` - Personalized installation walkthrough
- `PARTITION-REPORT.md` - Detailed disk analysis and modifications
- `BILL-SLOTH-SETUP-REPORT.md` - Complete preparation summary
- `TRANSITION-GUIDE.md` - Windows-to-Ubuntu transition instructions

### Recovery & Support
- `emergency-recovery/` - Boot repair scripts and recovery instructions
- `bill-sloth-startup/` - Ubuntu post-install automation scripts
- Various `.log` files with detailed operation records

### Context & Analysis
- `claude-context.json` - AI session context and recommendations
- `system-analysis.json` - Complete system hardware/software inventory

## ⚠️ Important Prerequisites

### System Requirements
- **Administrator Privileges** - Required for partition operations
- **8GB+ USB Drive** - For Ubuntu installation media
- **100GB+ Free Space** - Recommended for Ubuntu (configurable)
- **UEFI System** - Preferred (Legacy BIOS supported)
- **Internet Connection** - For downloads and Claude Code integration

### Before Running
1. **Backup Important Data** - Scripts create restore points but manual backup recommended
2. **Close All Programs** - Especially during partition operations
3. **Plug in Laptop** - Ensure stable power during operations
4. **Disable Antivirus** - Temporarily disable real-time protection

## 🔧 Advanced Usage

### Custom Ubuntu Versions & ISO Handling
```powershell
# Download specific Ubuntu version
.\ubuntu-installer-prep.ps1 -UbuntuVersion "24.04" -Interactive

# Use specific existing ISO file
.\ubuntu-installer-prep.ps1 -ExistingISO "C:\Downloads\ubuntu-22.04.5-desktop-amd64.iso"

# Search for existing ISOs only (no download)
.\ubuntu-installer-prep.ps1 -SkipDownload -Interactive

# Check and enhance existing Ubuntu USB drives
.\ubuntu-installer-prep.ps1 -CheckExistingUSB

# Use existing ISO file for USB creation only
.\ubuntu-installer-prep.ps1 -ExistingISO "path\to\ubuntu.iso" -CreateUSBOnly
```

### Partition Management
```powershell
# Analyze disk without modifications
.\disk-partition-manager.ps1 -AnalyzeOnly

# Auto-shrink with specific parameters
.\disk-partition-manager.ps1 -AutoShrink -UbuntuSizeGB 150 -TargetDrive "D"
```

### Claude Integration Control
```powershell
# Disable AI assistance (fallback mode)
.\bill-sloth-claude-assisted-setup.ps1 -AIAssisted $false

# Custom Claude binary location
.\bill-sloth-claude-assisted-setup.ps1 -ClaudeBinary "custom-claude-path"
```

## 🆘 Troubleshooting

### PowerShell Script Issues

**📋 See comprehensive troubleshooting guide: `TROUBLESHOOTING.md`**
**📋 Encoding issues documentation: `ENCODING-ISSUES.md`**

### Common Issues

**"Execution policy" errors:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Claude Code not found:**
```bash
npm install -g @anthropic-ai/claude-code
# Restart PowerShell after installation
```

**Insufficient permissions:**
```powershell
# Right-click PowerShell → "Run as Administrator"
```

**PowerShell encoding errors with Unicode characters:**
```powershell
# Use the complete system creator for ASCII-only output
.\bill-sloth-complete-system-creator.ps1
```

**USB drive detection failures:**
```powershell
# Use simple USB creator for specific drives
.\simple-usb-creator.ps1  # (available in repository root)

# Or run setup troubleshooter
.\troubleshoot-setup-failure.ps1 -IssueType usb
```

**Any setup failures:**
```powershell
# Automated troubleshooting and recovery
.\troubleshoot-setup-failure.ps1

# Auto-fix common issues
.\troubleshoot-setup-failure.ps1 -AutoFix

# Get Claude assistance for complex issues
.\troubleshoot-setup-failure.ps1 -SendToClaude
```

**Partition shrink fails:**
- Free up more disk space
- Defragment target drive
- Disable page file temporarily
- Check for unmovable files

**USB creation issues:**
- Use different USB drive
- Manually run Rufus with provided ISO
- Check USB drive for errors

### Recovery Options

**System won't boot after changes:**
1. Use Windows Recovery Environment
2. System Restore to "Bill Sloth Pre-Setup" point
3. Run emergency recovery scripts from package

**Ubuntu installation fails:**
1. Verify USB boot in BIOS/UEFI settings
2. Disable Secure Boot if needed
3. Check partition table isn't corrupted

## 📞 Support Resources

- **Windows Issues**: Windows built-in troubleshooting
- **Ubuntu Installation**: https://ubuntu.com/tutorials/install-ubuntu-desktop
- **Dual-Boot Help**: https://help.ubuntu.com/community/WindowsDualBoot
- **ADHD-Friendly Tech Support**: Take breaks, don't rush, ask for help
- **Bill Sloth Issues**: Check repository documentation

## 🔄 Updates

This package is designed to work with:
- **Windows 10/11** - Full compatibility
- **Ubuntu 22.04.5 LTS** - Current recommended version (updated from 22.04.3)
- **Claude Code** - Latest version
- **UEFI Systems** - Preferred (Legacy BIOS supported)
- **Repository**: https://github.com/how1337itis/billsloth (updated from placeholder URLs)

---

## 📋 Quick Reference

### Essential Commands
```powershell
# Check system readiness
.\bill-sloth-claude-assisted-setup.ps1 -CheckOnly

# Full preparation
.\bill-sloth-claude-assisted-setup.ps1 -Interactive

# Emergency disk analysis
.\disk-partition-manager.ps1 -AnalyzeOnly
```

### File Locations
- **Working Directory**: `%USERPROFILE%\bill-sloth-windows\`
- **Logs**: `bill-sloth-windows\*.log`
- **Reports**: `bill-sloth-windows\*.md`
- **Recovery**: `bill-sloth-windows\emergency-recovery\`

### Next Steps After Running
1. Follow generated installation guide
2. Boot from created USB drive
3. Install Ubuntu alongside Windows
4. Run Bill Sloth Ubuntu setup scripts
5. Access full VRBO automation capabilities

---

**Generated by Bill Sloth Windows Dual-Boot Preparation System**  
**Claude Code Integration**: AI-powered setup assistance  
**Target**: Ubuntu dual-boot for vacation rental business automation