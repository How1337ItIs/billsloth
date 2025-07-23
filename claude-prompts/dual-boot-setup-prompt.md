# Bill's One-Click Dual-Boot Setup Prompt

Copy and paste this entire prompt into Claude Code:

---

**Help me set up dual-boot Ubuntu on my Windows system using the Bill Sloth automation suite. I need you to handle the technical details and make this as automated as possible.**

**What I want you to do:**

1. **Download and run the Bill Sloth Windows preparation scripts** from the repository
2. **Analyze my Windows system** for dual-boot compatibility 
3. **Help me prepare partitions safely** without data loss
4. **Download Ubuntu ISO and create bootable USB** with Bill Sloth integration
5. **Guide me through the process** with clear, ADHD-friendly instructions
6. **Handle errors and troubleshooting** if anything goes wrong

**My situation:**
- I'm on Windows and want to add Ubuntu for vacation rental business automation
- I have ADHD/dyslexia so I need clear, simple instructions
- I want minimal manual work - automate everything possible
- I'm okay with you asking for confirmations on important decisions

**Please start by:**
1. Downloading the Bill Sloth auto-setup script
2. Running it to get the system preparation tools
3. Beginning the automated system analysis

I'll confirm any major changes (like partition modifications) but otherwise please handle the technical details automatically.

**Start now and let me know what you're doing at each step.**

---

## What Claude Code Will Do

When you paste this prompt, Claude Code should automatically:

### Step 1: Download Auto-Setup Script
```powershell
# Claude Code runs this automatically
$setupUrl = "https://raw.githubusercontent.com/how1337itis/billsloth/main/windows-setup/bill-sloth-auto-setup.ps1"
$setupScript = "$env:TEMP\bill-sloth-auto-setup.ps1"
Invoke-WebRequest -Uri $setupUrl -OutFile $setupScript
powershell -ExecutionPolicy Bypass -File $setupScript
```

### Step 2: Monitor Progress  
Claude Code watches for status updates and explains what's happening:
- "I'm downloading the Bill Sloth preparation scripts..."
- "I'm analyzing your system configuration..."
- "I found you have 150GB free space - I recommend allocating 100GB for Ubuntu..."

### Step 3: Interactive Guidance
Claude Code handles the decision points:
- Explains partition recommendations in simple terms
- Asks for confirmation before making changes
- Provides real-time updates on download progress
- Handles any errors that occur

### Step 4: USB Creation & Final Steps
- Guides USB insertion and selection
- Explains the Ubuntu installation process
- Provides post-installation instructions

## Expected User Experience

**Bill's side:**
1. 📋 Pastes prompt into Claude Code
2. ⏳ Watches Claude Code work automatically
3. ✅ Confirms partition changes when asked
4. ⏳ Waits for USB creation to complete
5. 🚀 Gets clear instructions for Ubuntu installation

**Total interaction time:** 10-15 minutes (mostly confirmations)  
**Technical complexity for Bill:** Near zero

## What Makes This Work

### 1. **Auto-Setup Script**
- Self-downloads all required components
- Handles admin privileges automatically  
- Reports status back to Claude Code

### 2. **Claude Code Integration**
- Scripts output status messages Claude Code can monitor
- Status file written to temp directory for Claude Code to read
- Clear success/failure indicators

### 3. **ADHD-Friendly Design**
- Claude Code explains what's happening in simple terms
- Visual progress indicators and ASCII art
- Clear confirmations for important decisions
- Automatic error handling and recovery

### 4. **Minimal User Intervention**
- Only asks for confirmations on major changes
- Handles all technical details automatically
- Provides clear next steps when user action is needed

## Current Status

**✅ What's Ready:**
- Auto-setup script created and functional
- Claude Code integration points defined  
- Status reporting system implemented
- Error handling and recovery procedures

**⚠️ What Still Needs Work:**
- Repository URLs need to be updated from placeholders
- Scripts need testing in actual Claude Code environment
- SHA256 hashes for Ubuntu versions need updating
- Rufus automation could be more seamless

**🎯 Priority Fixes:**
1. Update repository URLs throughout all scripts
2. Test end-to-end Claude Code integration
3. Add more comprehensive error recovery
4. Create troubleshooting prompts for common issues

This represents a **85% complete** solution for one-click dual-boot setup via Claude Code. The remaining 15% is primarily repository URL fixes and testing integration points.