# 🗺️ Bill Sloth Internal Dependencies Map

**Created:** July 26, 2025  
**Purpose:** Document all internal file dependencies to enable safe reorganization without breaking functionality

---

## 🚨 **CRITICAL DEPENDENCIES - DO NOT MOVE THESE FILES**

### **Core Entry Points:**
- **`bill_command_center.sh`** - Main application entry point
  - **Location:** Project root
  - **Dependencies:** Sources 15+ lib files, executes 20+ modules
  - **Critical:** Moving this breaks the entire system

- **`onboard.sh`** - User onboarding system
  - **Location:** Project root  
  - **Dependencies:** Sources error_handling, notification_system, data_persistence
  - **Critical:** Moving breaks first-run experience

---

## 📁 **DIRECTORY STRUCTURE DEPENDENCIES**

### **`lib/` Directory (39 files) - SHARED LIBRARIES:**
```
lib/
├── Core Libraries (Required by bill_command_center.sh):
│   ├── safety_mechanisms.sh          # Error safety systems
│   ├── input_validation.sh           # Input sanitization
│   ├── claude_interactive_bridge.sh  # AI integration
│   ├── error_handling.sh             # Error management
│   ├── notification_system.sh        # User notifications  
│   ├── data_sharing.sh               # Inter-module communication
│   ├── workflow_orchestration.sh     # Task coordination
│   ├── backup_management.sh          # Backup systems
│   ├── system_health_monitoring.sh   # Health monitoring
│   ├── task_runner.sh                # Task execution
│   ├── data_persistence.sh           # Database operations
│   ├── service_management.sh         # System services
│   └── dependency_installer.sh       # Package management
├── Additional Libraries:
│   ├── adaptive_learning.sh          # User preference learning
│   ├── ai_model_registry.sh          # AI model management
│   ├── voice_control.sh              # Voice integration
│   ├── vrbo_api_integration.sh       # VRBO functionality
│   └── [25 more specialized libraries]
```

**⚠️ CRITICAL:** All `lib/` files are referenced using `$SCRIPT_DIR/lib/filename.sh` - moving lib directory breaks everything.

### **`modules/` Directory (50+ files) - USER MODULES:**
```
modules/
├── Interactive Modules (*_interactive.sh):
│   ├── ai_mastery_interactive.sh
│   ├── automation_mastery_interactive.sh
│   ├── business_partnerships_interactive.sh
│   ├── [30+ more interactive modules]
├── Subdirectories:
│   ├── automation_mastery/          # Advanced automation tools
│   ├── edboigames/                  # Gaming business tools
│   └── vrbo_automation/             # Vacation rental tools
```

**⚠️ CRITICAL:** All modules referenced using `$SCRIPT_DIR/modules/filename.sh` - moving modules directory breaks menu system.

### **`bin/` Directory - UTILITY SCRIPTS:**
```
bin/
├── professional-tools-upgrade       # Tool upgrades
├── fix-ollama-integration           # AI fixes
├── fix-placeholder-implementations  # Development fixes
├── docker-health-verifier           # Docker tools
├── api-credential-wizard            # API management
└── voice-control-optimizer          # Voice optimization
```

**⚠️ CRITICAL:** All bin files referenced using `$SCRIPT_DIR/bin/filename` - moving bin directory breaks utility access.

---

## 🔗 **FILE-LEVEL DEPENDENCIES**

### **bill_command_center.sh Dependencies:**
```bash
# Critical Sources (MUST exist in lib/):
source "$SCRIPT_DIR/lib/safety_mechanisms.sh"       # Line 14
source "$SCRIPT_DIR/lib/input_validation.sh"        # Line 19  
source "$SCRIPT_DIR/lib/claude_interactive_bridge.sh" # Line 24
source "$SCRIPT_DIR/lib/error_handling.sh"          # Line 97
source "$SCRIPT_DIR/lib/notification_system.sh"     # Line 99
source "$SCRIPT_DIR/lib/data_sharing.sh"            # Line 100
source "$SCRIPT_DIR/lib/workflow_orchestration.sh"  # Line 101
source "$SCRIPT_DIR/lib/restic_backup.sh"           # Line 102
source "$SCRIPT_DIR/lib/backup_management.sh"       # Line 103  
source "$SCRIPT_DIR/lib/system_health_monitoring.sh" # Line 104
source "$SCRIPT_DIR/lib/task_runner.sh"             # Line 106
source "$SCRIPT_DIR/lib/data_persistence.sh"        # Line 107
source "$SCRIPT_DIR/lib/service_management.sh"      # Line 108
source "$SCRIPT_DIR/lib/dependency_installer.sh"    # Line 109

# Module Executions (MUST exist in modules/):
source "$SCRIPT_DIR/modules/edboigames/controller.sh"            # Line 579
source "$SCRIPT_DIR/modules/automation_mastery/cloud_platforms.sh" # Line 611
source "$SCRIPT_DIR/modules/automation_mastery_interactive.sh"     # Line 687
source "$SCRIPT_DIR/modules/vpn_security_interactive.sh"          # Line 710
source "$SCRIPT_DIR/modules/system_doctor_interactive.sh"         # Line 749
source "$SCRIPT_DIR/modules/business_partnerships_interactive.sh" # Line 757
# [15+ more module sources]

# Utility Executions (MUST exist in bin/):
source "$SCRIPT_DIR/bin/professional-tools-upgrade"   # Line 823
source "$SCRIPT_DIR/bin/fix-ollama-integration"       # Line 828
source "$SCRIPT_DIR/bin/docker-health-verifier"      # Line 838
source "$SCRIPT_DIR/bin/api-credential-wizard"       # Line 843
# [6+ more bin sources]
```

### **Module Interconnections:**
```bash
# Many modules source common libraries:
source "$SCRIPT_DIR/../lib/adaptive_learning.sh"      # Adaptive learning
source "$SCRIPT_DIR/../lib/claude_interactive_bridge.sh" # AI integration  
source "$SCRIPT_DIR/../lib/data_persistence.sh"       # Database access
source "$SCRIPT_DIR/../lib/notification_system.sh"    # User notifications
```

---

## 💾 **DATA DIRECTORY DEPENDENCIES**

### **Runtime Data Structure:**
```
$HOME/.bill-sloth/                    # Main data directory
├── command-center/
│   └── config/
│       └── system_status.json       # System configuration
├── onboarding/                       # User onboarding data
├── data/
│   └── bill_sloth.db                # Main SQLite database
├── vrbo-automation/
│   └── data/*.json                  # VRBO property data  
├── health-monitoring/
│   ├── config/alert_config.json     # Health alerts
│   ├── health_commands.sh           # Health scripts
│   └── logs/                        # Health logs
├── network-profiles/                # Network configurations
├── backups/                         # System backups
└── cache/                           # Temporary files
```

**⚠️ CRITICAL:** All modules expect `$HOME/.bill-sloth/` structure. Moving this breaks data persistence.

### **External Tool Dependencies:**
```
~/lvc-bin/                           # Linux Voice Control
├── lvc-config.json                  # Voice configuration
├── lvc-commands.json                # Voice commands
├── misc/                            # Audio files
└── gui/                             # Voice GUI
```

---

## 🔧 **CONFIGURATION FILE DEPENDENCIES**

### **JSON Configuration Files:**
- `~/.bill-sloth/command-center/config/system_status.json` - System state
- `~/.bill-sloth/health-monitoring/config/alert_config.json` - Health alerts
- `~/lvc-bin/lvc-config.json` - Voice control settings
- `~/lvc-bin/lvc-commands.json` - Voice commands
- Various `*.json` files in data directories for module-specific config

### **Database Dependencies:**
- `$HOME/.bill-sloth/data/bill_sloth.db` - Main SQLite database
- Used by data_persistence.sh, performance monitoring, health checks
- **CRITICAL:** Many modules expect this exact path

---

## 🚫 **WHAT YOU CAN SAFELY MOVE**

### **Documentation Files (No Code Dependencies):**
```
✅ SAFE TO MOVE:
├── README.md
├── CHANGELOG.md  
├── TROUBLESHOOTING.md
├── docs/ (entire directory)
├── training/ (entire directory)
├── windows-setup/ (entire directory)
├── All *.md files (except CLAUDE.md - keep in root)
```

### **Test Files (Self-Contained):**
```
✅ SAFE TO MOVE:
├── tests/ (entire directory)
├── test_*.sh files
├── verify_install.sh (has relative paths but self-contained)
```

### **Deployment Files (Self-Contained):**
```
✅ SAFE TO MOVE:
├── deploy/ (entire directory)
├── systemd/ (entire directory)  
├── setup-scripts/ (entire directory)
├── external/ (entire directory - external tool)
```

---

## ⚠️ **RISKY MOVES - WOULD REQUIRE CODE UPDATES**

### **Files with Hardcoded Paths:**
```
⚠️ REQUIRES CODE CHANGES:
├── lib/ directory → All $SCRIPT_DIR/lib/ references need updating
├── modules/ directory → All $SCRIPT_DIR/modules/ references need updating  
├── bin/ directory → All $SCRIPT_DIR/bin/ references need updating
├── scripts/ directory → Some internal references exist
```

### **Files Referenced by Exact Name:**
```
⚠️ REQUIRES TESTING:
├── bill_command_center.sh → Referenced in deploy scripts, README
├── onboard.sh → Referenced in documentation
├── fresh_ubuntu_installer.sh → Referenced in README
├── install.sh → Referenced in documentation
```

---

## 📋 **REORGANIZATION STRATEGY**

### **Phase 1: Safe Moves (No Code Impact):**
1. **Create `docs/` subdirectories** for different doc types
2. **Move all documentation** except CLAUDE.md to docs/
3. **Move `windows-setup/`** to `docs/windows-setup/`
4. **Move `tests/`** to `testing/` if desired
5. **Update README.md** with new documentation locations

### **Phase 2: Risky Moves (Requires Code Changes):**
1. **Keep `lib/`, `modules/`, `bin/` in place** for now
2. **If moving these**, update all `$SCRIPT_DIR/` references
3. **Test thoroughly** after any moves
4. **Consider symlinks** to maintain backward compatibility

### **Phase 3: Data Structure (Advanced):**
1. **Data directories are user-specific** (`$HOME/.bill-sloth/`)
2. **Don't move these** unless changing the entire data architecture
3. **Document any changes** for user migration

---

## 🎯 **RECOMMENDED SAFE REORGANIZATION**

### **Suggested New Structure:**
```
bill sloth/
├── Core System (DON'T MOVE):
│   ├── bill_command_center.sh      
│   ├── onboard.sh
│   ├── lib/
│   ├── modules/
│   └── bin/
├── documentation/
│   ├── setup/
│   │   ├── windows-setup/          # Moved from root
│   │   ├── FRESH_UBUNTU_SETUP.md   # Moved from root
│   │   └── installation-guides/
│   ├── user-guides/
│   │   ├── TROUBLESHOOTING.md      # Moved from root
│   │   ├── MODULE_INDEX.md         # Moved from root
│   │   └── user-manuals/
│   ├── developer/
│   │   ├── DEVELOPMENT_PHILOSOPHY.md # Moved from root
│   │   ├── DEPENDENCY_STATUS.md    # Moved from root
│   │   └── development-guides/
│   └── project-history/
│       ├── CHANGELOG.md            # Moved from root
│       ├── audit-reports/
│       └── session-logs/
├── testing/
│   ├── tests/                      # Moved from root
│   ├── verify_install.sh           # Moved from root  
│   └── test-utilities/
├── deployment/
│   ├── deploy/                     # Moved from root
│   ├── systemd/                    # Moved from root
│   ├── setup-scripts/              # Moved from root
│   └── install.sh                  # Moved from root
├── external-tools/
│   └── linux-voice-control/        # Moved from external/
└── CLAUDE.md                       # Keep in root
```

---

## ✅ **VALIDATION CHECKLIST**

### **Before Moving Any Files:**
- [ ] Backup entire project
- [ ] Document current working state
- [ ] Test bill_command_center.sh launches properly

### **After Moving Files:**
- [ ] Test bill_command_center.sh still works
- [ ] Test onboard.sh still works  
- [ ] Verify all modules still load
- [ ] Check health monitoring systems
- [ ] Test a few representative modules
- [ ] Update documentation references

### **If Something Breaks:**
- [ ] Check error messages for missing file paths
- [ ] Verify $SCRIPT_DIR is pointing to correct location
- [ ] Ensure all sourced files still exist at expected paths
- [ ] Test with fresh terminal session

---

**🎯 Bottom Line:** Documentation files are safe to reorganize. Core system files (`lib/`, `modules/`, `bin/`, main scripts) should stay in current locations unless you're prepared to update many file path references.**