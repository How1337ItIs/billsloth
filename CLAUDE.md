# Bill Sloth Project - Claude Code Memory

## Project Overview
Bill Sloth is a comprehensive Linux automation system designed specifically for neurodivergent users (ADHD, dyslexia). It functions as a "self-building Jarvis for poor dyslexic Tony Stark."

### Team Structure
- **Dev (Midas Marsupius Whale):** Primary developer with final repository control
- **User (Nick "Bill Sloth"):** Co-developer providing feedback and testing (refuses to acknowledge his real name is Bill)  
- **Assistant:** Also called Bill Sloth due to early AI misunderstandings - we just ran with it

## Project Architecture

### Core Philosophy
- **Mature-First, Local-First:** Prefer robust open-source tools over custom solutions
- **Progressive Independence:** System learns and reduces Claude Code dependency over time
- **Pattern Learning & Adaptive Suggestions:** Local analytics track usage and suggest optimizations
- **ADHD/Dyslexia-Optimized UX:** ASCII art, color, motivational language, memory aids

### Key Components
- **Command Center:** `bill_command_center.sh` - Unified entry point for all operations
- **Onboarding System:** `onboard.sh` - Comprehensive user introduction and assessment
- **Module System:** `modules/` - Interactive toolkits for specific use cases
- **Library System:** `lib/` - Shared functionality and utilities
- **Voice Control:** Integrated Linux Voice Control system
- **Adaptive Learning:** Pattern recognition and auto-suggestion systems

### Critical Files to Understand First
1. `BILL_SLOTH_GIGA_DOC.md` - Complete project documentation
2. `bill_command_center.sh` - Main application entry point
3. `onboard.sh` - User experience and assessment system
4. `lib/` directory - Core functionality libraries
5. `modules/` directory - User-facing interactive tools

## Development Workflow

### Build and Test Commands
```bash
# System health check
bash bill_command_center.sh

# Test integration suite
bash tests/run_tests.sh

# Quick module test
bash tests/quick_integration_test.sh

# Generate documentation
bash scripts/generate_module_docs.sh
```

### Code Conventions
- All scripts include `# LLM_CAPABILITY: local_ok` header for AI compatibility
- ADHD-friendly interfaces with clear visual separation
- Error handling through centralized `lib/error_handling.sh`
- Data persistence via SQLite and JSON structures
- Modular, interchangeable components following Unix philosophy
- **NO UNICODE/EMOJIS in scripts** - Use ASCII only to prevent encoding issues

## Claude Code Session Management

### Session Corruption Prevention
- Use `/clear` before switching between different modules
- Save progress to project's data persistence system before major operations
- Integrate with Bill Sloth's existing backup and monitoring infrastructure

### Project-Specific Recovery
```bash
# Use Bill Sloth's backup system
source lib/backup_management.sh
create_emergency_backup

# Restore from Bill Sloth data persistence
source lib/data_persistence.sh  
restore_session_context

# Health monitoring integration
source lib/system_health_monitoring.sh
check_system_health
```

### Context Management Strategy
- Leverage existing `prompts/claude_context.md` for project context
- Use Bill Sloth's adaptive learning logs for session continuity
- Integrate with the project's task runner and workflow orchestration

## Current Development Focus

### Active Areas
- Voice control integration and optimization
- Local LLM transition planning
- Module system expansion and refinement
- Adaptive learning algorithm improvements
- Testing and documentation automation

### Recent Changes
- Integrated comprehensive GIGA DOC documentation
- Enhanced onboarding experience with personalization
- Improved module interconnection and data sharing
- Added voice control via Linux Voice Control integration
- Created comprehensive enhanced visual system with cyberpunk/retro gaming aesthetic
- Added auto-installation system for ISO customizations
- Implemented game development and vibe coding modules
- Added audit system and bug fixes for production readiness

## Working with This Project

### Before Major Changes
1. Run health check: `bash scripts/health_check.sh`
2. Create backup: `source lib/backup_management.sh && create_backup`
3. Review relevant module documentation in `BILL_SLOTH_GIGA_DOC.md`

### When Context Gets Full
1. Save current progress to Bill Sloth data persistence
2. Use project's workflow orchestration to checkpoint current task
3. Clear context and restore minimal necessary context
4. Continue with established project patterns and conventions

### Integration Points
- Data persistence system tracks all changes
- Notification system provides user feedback
- Workflow orchestration manages complex operations  
- Adaptive learning captures patterns for future optimization

This project represents a sophisticated approach to making technology accessible and empowering for neurodivergent users.

## PowerShell + WSL2 ISO Builder Rules - UPDATED

### ✅ **CURRENT STATUS (July 2025): WORKING SOLUTIONS AVAILABLE**

**Working ISO Builders:**
- `bill-sloth-RECOMMENDED-iso-builder.ps1` - ✅ **WORKING** (Bootloader fixed)
- `bill-sloth-CURSOR-AGENT-ROBUST-iso-builder.ps1` - ✅ **WORKING** (Most robust)

### 🚨 **CRITICAL: Multi-System Integration Guidelines**

**Before working on PowerShell + WSL2 + Linux integration, read:** `FUTURE-PREVENTION-GUIDELINES.md`

#### **🔍 MANDATORY Platform Verification:**
```bash
# Always verify platform versions and file paths FIRST
wsl -d Ubuntu-22.04 bash -c "lsb_release -a"  # Confirm Ubuntu version
wsl -d Ubuntu-22.04 bash -c "ls -la /mnt/ubuntu-iso/boot/grub/i386-pc/eltorito.img"  # Verify boot files exist
wsl -d Ubuntu-22.04 bash -c "ls -la /mnt/ubuntu-iso/EFI/boot/bootx64.efi"  # Verify EFI files exist
```

#### **🧹 MANDATORY State Management:**
```powershell
# ALWAYS start with aggressive cleanup for stateful operations
wsl -d Ubuntu-22.04 bash -c "sudo umount /mnt/ubuntu-iso 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/billsloth* 2>/dev/null || true"

# Use unique identifiers to prevent conflicts
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$buildDir = "/tmp/build-$timestamp"
```

#### **✅ MANDATORY Validation Pattern:**
```powershell
# Never mark anything as "WORKING" without metrics-based validation
$fileCount = (wsl -d Ubuntu-22.04 bash -c "find $buildDir -type f | wc -l").Trim()
if ([int]$fileCount -lt 1000) {
    Write-Host "ERROR: Validation failed - only $fileCount files (expected >1000)" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Validation passed: $fileCount files" -ForegroundColor Green
```

### 📚 **ISO Builder Specific Guidelines**

#### **Known Working Ubuntu 22.04.5 Boot Structure:**
```bash
# CORRECT boot files (verified to exist):
/mnt/ubuntu-iso/boot/grub/i386-pc/eltorito.img    # BIOS boot
/mnt/ubuntu-iso/EFI/boot/bootx64.efi              # EFI boot

# INCORRECT paths (do NOT exist in modern Ubuntu):
/mnt/ubuntu-iso/isolinux/isolinux.bin             # Legacy, removed
```

#### **Working xorriso Command (Verified):**
```bash
# Use this EXACT command for Ubuntu 22.04.5:
xorriso -as mkisofs -r -V 'BILLSLOTH' -o ../custom.iso \
    -J -l \
    -b boot/grub/i386-pc/eltorito.img \
    -c boot.catalog \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot \
    -e EFI/boot/bootx64.efi \
    -no-emul-boot -isohybrid-gpt-basdat \
    .
```

### 🚫 **Anti-Patterns to Avoid**
- ❌ Assuming file paths exist without verification
- ❌ Using ISOLINUX commands for modern Ubuntu
- ❌ Skipping cleanup between test runs
- ❌ Marking as "WORKING" without quantified validation
- ❌ Complex here-strings with bash commands in PowerShell

### 📋 **Required Testing Before Claiming "WORKING"**
1. **Syntax Test:** PowerShell parses without errors
2. **Path Verification:** All file paths exist in target system  
3. **Process Test:** Each major step completes successfully
4. **Size Validation:** Final ISO is reasonable size (3-5GB)
5. **File Count:** Contains expected number of files (100K+)

---

## Complex Integration Best Practices

### 🛡️ **Prevention Framework for Multi-System Work**

**Before starting any complex integration (PowerShell + WSL2 + Linux, etc.):**

#### **The Big 4 Prevention Rules:**
1. **🔍 VERIFY FIRST** - Check platform versions and file paths before assuming
2. **🧹 CLEAN AGGRESSIVELY** - Remove all previous state with unique identifiers  
3. **✅ VALIDATE QUANTIFIABLY** - Use measurable success criteria (file counts, sizes)
4. **📝 DOCUMENT EVIDENCE** - Record actual test results with dates

#### **Required Pre-Implementation Checks:**
- [ ] Platform versions documented and verified
- [ ] All assumed file paths confirmed to exist
- [ ] Cleanup strategy planned for stateful operations
- [ ] Success criteria defined with quantifiable metrics
- [ ] Fallback methods identified for critical operations

#### **Implementation Patterns:**
```bash
# Always verify platform versions first
wsl -d Ubuntu-22.04 bash -c "lsb_release -a"

# Use aggressive cleanup with error suppression
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/build-* 2>/dev/null || true"

# Use unique identifiers to prevent conflicts
timestamp=$(date +%Y%m%d-%H%M%S)
buildDir="/tmp/build-$timestamp"

# Validate results with quantifiable metrics
fileCount=$(find $buildDir -type f | wc -l)
if [ $fileCount -lt 1000 ]; then
    echo "ERROR: Validation failed - only $fileCount files"
    exit 1
fi
```

#### **Documentation Requirements:**
```markdown
## [Component] Status - [Date]
**Tested:** [Date] on [Platform Version]
**Results:**
- Process: ✅ All steps completed successfully
- Metrics: ✅ [Actual quantified results]
- Function: ✅/⚠️/❌ [Actual functional test results]
**Known Limitations:** [What wasn't tested]
```

### 🚨 **Emergency Recovery Procedures**

**If complex integration fails:**
1. **Test each layer separately** - PowerShell, WSL2, Linux operations
2. **Verify platform versions** - Check for recent updates/changes
3. **Clean state aggressively** - Remove all previous build artifacts  
4. **Check file system permissions** - Are there lock or permission issues?
5. **Use force flags carefully** - Override existing files when safe
6. **Implement incremental testing** - Verify each step before proceeding

**Red flags that indicate systematic issues:**
- Multiple "File exists" errors across different operations
- Platform-specific commands failing unexpectedly  
- Inconsistent results between test runs
- Missing files that should exist based on documentation

## Script Development Guidelines

### Unicode and Character Encoding
- **NEVER use Unicode characters (emojis, special symbols) in shell scripts**
- Use ASCII-only characters to prevent encoding issues across environments
- Replace visual elements with:
  - Text prefixes: `[INFO]`, `[SUCCESS]`, `[ERROR]`, `[WARNING]`
  - ASCII art for visual appeal where appropriate
  - Simple symbols: `*`, `+`, `-`, `>` for bullets and formatting
  - Standard text formatting and colors via ANSI codes

### Why This Matters
- Different terminal encodings can break Unicode characters
- Automated build systems often use minimal character sets
- SSH connections may not support Unicode properly
- CI/CD pipelines can fail on Unicode parsing
- Different Linux distributions handle encoding differently

### Acceptable Visual Enhancement
```bash
# Good: ASCII-based visual formatting
echo "=================================================="
echo "         BILL SLOTH SYSTEM INITIALIZING"
echo "=================================================="
echo ""
echo "[INFO] Starting system health check..."
echo "[SUCCESS] All systems operational"
echo "[ERROR] Database connection failed"

# Bad: Unicode characters that can cause encoding issues
echo "🚀 Starting system..."  # Can break in different environments
```

### Testing Script Compatibility
- Test scripts in minimal environments (basic terminals, SSH connections)
- Verify functionality in automated build systems
- Check compatibility across different Linux distributions
- Ensure scripts work in both interactive and non-interactive modes