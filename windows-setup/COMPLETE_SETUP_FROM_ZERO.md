# Bill Sloth Complete Setup From Zero
**For people who don't have ANYTHING installed yet**

This guide assumes you have a Windows computer and want to set up everything from scratch to get Bill Sloth running with dual-boot Ubuntu.

## 🎯 What You'll Have When Done
- Dual-boot Windows + Ubuntu system
- Claude Code installed and working
- Git for downloading projects
- Bill Sloth fully functional for VRBO automation
- AI-powered business tools running locally

## ⏱️ How Long This Takes
- **If everything goes smoothly**: 2-3 hours
- **If you run into issues**: 4-6 hours
- **Spread across multiple sessions**: Totally fine! Save your progress

---

## 📋 STEP 1: Install Essential Tools (30 minutes)

### 1.1 Install Git (Required to download Bill Sloth)

**What is Git?** Git lets you download code projects from the internet.

1. **Go to**: https://git-scm.com/download/win
2. **Download** the Windows version (it will detect your system automatically)
3. **Run the installer** with these settings:
   - ✅ Use Git from the Windows Command Prompt
   - ✅ Use the native Windows Secure Channel library
   - ✅ Checkout Windows-style, commit Unix-style line endings
   - ✅ Use Windows' default console window
   - ✅ Default (fast-forward or merge)
   - ✅ Git Credential Manager
   - ✅ Enable file system caching
4. **Finish installation** and close the installer

**Test it worked:**
1. Press `Windows Key + R`
2. Type: `cmd` and press Enter
3. Type: `git --version` and press Enter
4. You should see something like: `git version 2.43.0.windows.1`

### 1.2 Install Node.js (Required for Claude Code)

**What is Node.js?** It's what Claude Code needs to run.

1. **Go to**: https://nodejs.org/en/download/
2. **Download** the Windows Installer (.msi) - LTS version
3. **Run the installer** with default settings:
   - ✅ Add to PATH (should be checked automatically)
   - ✅ Install npm package manager
4. **Restart your computer** after installation

**Test it worked:**
1. Press `Windows Key + R`
2. Type: `cmd` and press Enter
3. Type: `node --version` and press Enter
4. You should see something like: `v20.10.0`
5. Type: `npm --version` and press Enter
6. You should see something like: `10.2.3`

### 1.3 Install Claude Code

**What is Claude Code?** The AI assistant that will help you set everything up.

1. **Open Command Prompt as Administrator:**
   - Press `Windows Key`
   - Type: `cmd`
   - **Right-click** on "Command Prompt"
   - Choose "Run as administrator"
   - Click "Yes" if Windows asks for permission

2. **Install Claude Code:**
   ```cmd
   npm install -g @anthropic-ai/claude-code
   ```
   
   This will take 2-3 minutes. You'll see lots of text scrolling - that's normal!

3. **Test it worked:**
   ```cmd
   claude --version
   ```
   You should see version information.

4. **Login to Claude Code:**
   ```cmd
   claude login
   ```
   
   This will:
   - Open your web browser
   - Ask you to login to Claude (create account if needed)
   - Give you a code to paste back in the command prompt

**If you get errors:**
- Close Command Prompt and open a new one as Administrator
- Try the commands again
- Make sure your internet is working

---

## 📋 STEP 2: Download Bill Sloth Project (10 minutes)

### 2.1 Choose Where to Put Bill Sloth

**Recommended location:** `C:\Users\YourName\bill-sloth`

1. **Open Command Prompt** (as Administrator)
2. **Navigate to your user folder:**
   ```cmd
   cd %USERPROFILE%
   ```
3. **Download Bill Sloth:**
   ```cmd
   git clone https://github.com/How1337ItIs/billsloth.git bill-sloth
   ```
   
   This downloads the entire project. It takes 2-3 minutes.

4. **Go into the project:**
   ```cmd
   cd bill-sloth
   ```

5. **Check it worked:**
   ```cmd
   dir
   ```
   
   You should see folders like: `modules`, `lib`, `windows-setup`, etc.

---

## 📋 STEP 3: Run Windows Setup (1-2 hours)

### 3.1 Open PowerShell as Administrator

**Important:** PowerShell is different from Command Prompt - we need PowerShell for the setup scripts.

1. **Press Windows Key**
2. **Type:** `powershell`
3. **Right-click** on "Windows PowerShell"
4. **Choose** "Run as administrator"
5. **Click "Yes"** when Windows asks for permission

### 3.2 Allow Scripts to Run

**What this does:** By default, Windows blocks scripts for security. We need to allow them.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Type `Y` and press Enter when it asks for confirmation.

### 3.3 Navigate to Windows Setup

```powershell
cd "%USERPROFILE%\bill-sloth\windows-setup"
```

### 3.4 Run the Complete Setup

**RECOMMENDED - Complete System Creator:**
```powershell
.\bill-sloth-complete-system-creator.ps1
```

**OR Traditional Setup:**
```powershell
.\bill-sloth-claude-assisted-setup.ps1 -Interactive
```

**What the Complete System Creator does:**
- Auto-detects Ubuntu ISO files and USB drives
- Creates bootable Ubuntu USB with Rufus
- Installs complete Bill Sloth automation system on USB
- Creates auto-launch scripts for immediate activation
- Includes onboarding, command center, and all modules
- ADHD/dyslexia optimized with ASCII-only output

**What the Traditional Setup does:**
- Analyzes your computer for dual-boot compatibility  
- Helps prepare your hard drive for Ubuntu
- Downloads Ubuntu installer
- Creates a bootable USB drive
- Sets up everything with AI assistance

**Follow the prompts** - the script will:
- Ask questions about what you want to do
- Show you what it found on your computer
- Recommend how much space to use for Ubuntu
- Guide you through each step

### 3.5 If Something Goes Wrong

**"Script not found" error:**
```powershell
# Check you're in the right place
dir
# You should see files like bill-sloth-claude-assisted-setup.ps1
```

**"Execution policy" error:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

**"Claude not found" error:**
- Close PowerShell
- Open new PowerShell as Administrator
- Try again

---

## 📋 STEP 4: Create Ubuntu USB and Install (30-60 minutes)

### 4.1 USB Creation

The setup script will:
1. **Download Ubuntu ISO** (about 4GB - takes 10-30 minutes depending on internet)
2. **Create bootable USB** (needs an 8GB+ USB drive)
3. **Add Bill Sloth startup files** to the USB

**You'll need:**
- USB drive (8GB or larger) - **will be completely erased**
- About 1-2 hours of uninterrupted time

### 4.2 Install Ubuntu

1. **Insert the USB drive** the script created
2. **Restart your computer**
3. **Boot from USB** (usually press F12, F2, or Del during startup)
4. **Choose "Install Ubuntu"**
5. **Select "Install Ubuntu alongside Windows"** (dual-boot option)
6. **Follow the installation wizard**

**Important settings:**
- ✅ Download updates during installation
- ✅ Install third-party software
- Username: whatever you want
- Password: something you'll remember!

### 4.3 First Boot into Ubuntu

After Ubuntu installs:
1. **Restart** and choose Ubuntu from the boot menu
2. **Open Terminal** (Ctrl+Alt+T)
3. **Navigate to the Bill Sloth startup files:**
   ```bash
   cd /media/*/UBUNTU*/bill-sloth-startup/
   ```
4. **Run the setup:**
   ```bash
   chmod +x setup-bill-sloth.sh
   ./setup-bill-sloth.sh
   ```

---

## 📋 STEP 5: Complete Bill Sloth Setup in Ubuntu (30-60 minutes)

### 5.1 Run Dependency Installation

```bash
cd ~/bill-sloth
./scripts/linux_dependency_validator.sh
```

If there are missing dependencies:
```bash
./scripts/dependency_installer.sh
```

### 5.2 Run Deployment Readiness Check

```bash
./scripts/deployment_readiness_check.sh
```

This checks if everything is ready to go.

### 5.3 Set Up Local AI (Optional but Recommended)

```bash
./bin/setup-local-ai
```

Choose option 1 (Express Setup) for most people.

### 5.4 Start Bill Sloth

```bash
./bill_command_center.sh
```

Follow the onboarding process!

---

## 🆘 If You Get Stuck

### Common Issues and Solutions

**Git command not found:**
- Restart your computer after installing Git
- Make sure you installed Git for Windows from git-scm.com

**Node.js or npm not found:**
- Restart your computer after installing Node.js
- Open a new command prompt/PowerShell window

**Claude Code won't install:**
- Make sure you're running as Administrator
- Check your internet connection
- Try: `npm install -g @anthropic-ai/claude-code --force`

**PowerShell script won't run:**
- Make sure you're in PowerShell (not Command Prompt)
- Run as Administrator
- Set execution policy: `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`

**PowerShell encoding errors with special characters:**
- Use the complete system creator: `.\bill-sloth-complete-system-creator.ps1`
- It uses ASCII-only output for Windows compatibility

**Computer won't boot from USB:**
- Press F12 (or F2, F10, Del) during startup to access boot menu
- Look for "UEFI" or "Legacy" boot options
- Disable "Secure Boot" in BIOS if needed
- Make sure USB is plugged in before restarting

**Ubuntu installation fails:**
- Free up more space on your hard drive (need 100GB+)
- Turn off "Fast Startup" in Windows power settings
- Disable antivirus temporarily during installation

### Getting Help

**If you're completely stuck:**
1. **Take a screenshot** of any error messages
2. **Note exactly what step you were on**
3. **Try restarting** and running the command again
4. **Search the error message** online
5. **Ask for help** - include the screenshot and what you were trying to do

### Take Breaks!

This is a lot to do in one sitting. It's totally fine to:
- ✅ Stop after any major step
- ✅ Come back later to continue
- ✅ Ask someone for help
- ✅ Take your time understanding each step

---

## 🎉 Success! What You Can Do Now

Once everything is set up, you'll have:

### ✅ **Dual-Boot System**
- Switch between Windows and Ubuntu at startup
- Keep all your Windows programs and files
- Full Ubuntu system for development and automation

### ✅ **Claude Code Integration**
- AI assistant available in terminal
- Help with coding and system management
- Automated problem-solving

### ✅ **Bill Sloth Business Automation**
- VRBO property management
- Guest communication automation
- Revenue tracking and analytics
- Partnership management tools

### ✅ **Local AI Independence**
- No more paying for AI API calls
- Private AI processing on your computer
- Voice control and automation

**Your next steps:**
1. **Run the onboarding:** `./onboard.sh`
2. **Set up your VRBO properties** in the business automation
3. **Configure email templates** for guest communication
4. **Start automating your vacation rental business!**

---

## 📞 Quick Reference

### Essential Commands

**Windows (PowerShell):**
```powershell
# Check if tools are installed
git --version
node --version
claude --version

# Download Bill Sloth
git clone https://github.com/How1337ItIs/billsloth.git bill-sloth

# Run Windows setup
cd bill-sloth\windows-setup
.\bill-sloth-claude-assisted-setup.ps1 -Interactive
```

**Ubuntu (Terminal):**
```bash
# Basic setup
cd ~/bill-sloth
./scripts/linux_dependency_validator.sh
./scripts/dependency_installer.sh

# Check readiness
./scripts/deployment_readiness_check.sh

# Set up AI
./bin/setup-local-ai

# Start Bill Sloth
./bill_command_center.sh
```

### File Locations

**Windows:**
- Bill Sloth project: `C:\Users\YourName\bill-sloth\`
- Windows setup files: `C:\Users\YourName\bill-sloth\windows-setup\`
- Setup logs: `C:\Users\YourName\bill-sloth-windows\`

**Ubuntu:**
- Bill Sloth project: `~/bill-sloth/`
- Configuration: `~/.local/share/bill-sloth/`
- Logs: Various `.log` files in the project

---

**This guide gets you from absolutely nothing to a fully functional Bill Sloth system for vacation rental automation. Take your time, follow each step, and don't hesitate to take breaks or ask for help!**