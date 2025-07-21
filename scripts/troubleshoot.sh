#!/bin/bash
# Bill Sloth Advanced Troubleshooting System
# Diagnoses and fixes common issues with adaptive learning and modules

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

ISSUE_COUNT=0
FIX_COUNT=0

log_issue() {
    ISSUE_COUNT=$((ISSUE_COUNT + 1))
    echo -e "${RED}❌ ISSUE $ISSUE_COUNT: $1${NC}"
}

log_fix() {
    FIX_COUNT=$((FIX_COUNT + 1))
    echo -e "${GREEN}✅ FIXED: $1${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_header() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
  _____ _____   ____  _    _  ____  _      ______  _____ _    _  ____   ____ _______ 
 |_   _|  __ \ / __ \| |  | |/ __ \| |    |  ____|/ ____| |  | |/ __ \ / __ \__   __|
   | | | |__) | |  | | |  | | |  | | |    | |__  | (___ | |__| | |  | | |  | | | |   
   | | |  _  /| |  | | |  | | |  | | |    |  __|  \___ \|  __  | |  | | |  | | | |   
  _| |_| | \ \| |__| | |__| | |__| | |____| |____ ____) | |  | | |__| | |__| | | |   
 |_____|_|  \_\\____/ \____/ \____/|______|______|_____/|_|  |_|\____/ \____/  |_|   
                                                                                      
EOF
    echo -e "${NC}"
    echo -e "${PURPLE}🔧 Bill Sloth Advanced Troubleshooting System${NC}"
    echo ""
}

diagnose_claude_code() {
    echo -e "${CYAN}🤖 DIAGNOSING CLAUDE CODE ISSUES${NC}"
    echo "================================"
    echo ""
    
    # Check if Claude Code is installed
    if ! command -v claude &> /dev/null; then
        log_issue "Claude Code CLI not installed"
        echo "   Run: npm install -g @anthropic-ai/claude-code"
        return 1
    fi
    
    log_info "Claude Code CLI found"
    
    # Check Claude Code authentication
    if ! claude "test" &> /dev/null; then
        log_issue "Claude Code not authenticated"
        echo "   Run: claude"
        echo "   Then follow authentication prompts"
        return 1
    fi
    
    log_info "Claude Code authentication working"
    
    # Check token usage
    log_info "Testing Claude Code response..."
    CLAUDE_TEST=$(claude "Respond with just 'OK' if you're working" 2>&1)
    
    if [[ $CLAUDE_TEST == *"OK"* ]]; then
        echo -e "${GREEN}✅ Claude Code is working properly${NC}"
    elif [[ $CLAUDE_TEST == *"rate limit"* ]]; then
        log_warning "Rate limit reached - try again later"
    elif [[ $CLAUDE_TEST == *"quota"* ]]; then
        log_warning "Token quota exceeded - check your plan limits"
    else
        log_issue "Claude Code communication failed"
        echo "   Error: $CLAUDE_TEST"
    fi
    
    echo ""
}

diagnose_adaptive_learning() {
    echo -e "${CYAN}🧠 DIAGNOSING ADAPTIVE LEARNING SYSTEM${NC}"
    echo "======================================"
    echo ""
    
    # Check directories
    if [ ! -d ~/.bill-sloth ]; then
        log_issue "Bill Sloth learning directory missing"
        mkdir -p ~/.bill-sloth/{learning,usage,feedback,adaptations}
        log_fix "Created learning directories"
    else
        log_info "Learning directories exist"
    fi
    
    # Check adaptive learning library
    if [ ! -f "./lib/adaptive_learning.sh" ] && [ ! -f "../lib/adaptive_learning.sh" ]; then
        log_issue "Adaptive learning library not found"
        return 1
    fi
    
    log_info "Adaptive learning library found"
    
    # Check if any modules have adaptive learning
    ENHANCED_MODULES=0
    for module in ../modules/*_interactive.sh; do
        if [ -f "$module" ] && grep -q "adaptive_learning.sh" "$module"; then
            ENHANCED_MODULES=$((ENHANCED_MODULES + 1))
        fi
    done
    
    if [ $ENHANCED_MODULES -eq 0 ]; then
        log_issue "No modules have adaptive learning enabled"
        echo "   Run: ./scripts/batch_enhance_modules.sh"
    else
        log_info "$ENHANCED_MODULES modules have adaptive learning enabled"
    fi
    
    # Check learning data
    LEARNING_FILES=$(find ~/.bill-sloth -name "*.log" -o -name "*.txt" 2>/dev/null | wc -l)
    if [ $LEARNING_FILES -eq 0 ]; then
        log_info "No learning data yet (normal for new installations)"
    else
        log_info "$LEARNING_FILES learning data files found"
    fi
    
    echo ""
}

diagnose_power_tools() {
    echo -e "${CYAN}💻 DIAGNOSING POWER-USER TOOLS${NC}"
    echo "=============================="
    echo ""
    
    # Core power tools
    POWER_TOOLS=("copyq:Clipboard Manager" "espanso:Text Expander" "rofi:Application Launcher" 
                 "fd:File Finder" "rg:Text Search" "fzf:Fuzzy Finder")
    
    for tool_info in "${POWER_TOOLS[@]}"; do
        tool=$(echo $tool_info | cut -d':' -f1)
        name=$(echo $tool_info | cut -d':' -f2)
        
        if command -v $tool &> /dev/null; then
            log_info "$name ($tool) is installed"
        else
            log_warning "$name ($tool) not installed"
            case $tool in
                "copyq") echo "   Install: sudo apt install copyq" ;;
                "espanso") echo "   Install via module: clipboard_mastery_interactive" ;;
                "rofi") echo "   Install: sudo apt install rofi" ;;
                "fd") echo "   Install: sudo apt install fd-find" ;;
                "rg") echo "   Install: sudo apt install ripgrep" ;;
                "fzf") echo "   Install: sudo apt install fzf" ;;
            esac
        fi
    done
    
    echo ""
}

diagnose_modules() {
    echo -e "${CYAN}📦 DIAGNOSING BILL SLOTH MODULES${NC}"
    echo "==============================="
    echo ""
    
    MODULES_DIR="../modules"
    if [ ! -d "$MODULES_DIR" ]; then
        MODULES_DIR="./modules"
    fi
    
    if [ ! -d "$MODULES_DIR" ]; then
        log_issue "Modules directory not found"
        return 1
    fi
    
    # Count modules
    MODULE_COUNT=$(find "$MODULES_DIR" -name "*_interactive.sh" -type f | wc -l)
    log_info "Found $MODULE_COUNT Bill Sloth modules"
    
    # Check for broken modules
    BROKEN_MODULES=0
    for module in "$MODULES_DIR"/*_interactive.sh; do
        if [ -f "$module" ]; then
            # Basic syntax check
            if ! bash -n "$module" 2>/dev/null; then
                log_issue "Syntax error in $(basename "$module")"
                BROKEN_MODULES=$((BROKEN_MODULES + 1))
            fi
        fi
    done
    
    if [ $BROKEN_MODULES -eq 0 ]; then
        log_info "All modules pass syntax check"
    else
        log_warning "$BROKEN_MODULES modules have syntax errors"
    fi
    
    # Check permissions
    NON_EXECUTABLE=0
    for module in "$MODULES_DIR"/*_interactive.sh; do
        if [ -f "$module" ] && [ ! -x "$module" ]; then
            NON_EXECUTABLE=$((NON_EXECUTABLE + 1))
        fi
    done
    
    if [ $NON_EXECUTABLE -gt 0 ]; then
        log_warning "$NON_EXECUTABLE modules are not executable"
        echo "   Fix: chmod +x $MODULES_DIR/*.sh"
        
        read -p "Fix permissions now? (y/n): " fix_perms
        if [[ $fix_perms =~ ^[Yy]$ ]]; then
            chmod +x "$MODULES_DIR"/*.sh
            log_fix "Module permissions fixed"
        fi
    else
        log_info "All modules are executable"
    fi
    
    echo ""
}

diagnose_system_deps() {
    echo -e "${CYAN}🔧 DIAGNOSING SYSTEM DEPENDENCIES${NC}"
    echo "================================="
    echo ""
    
    # Core dependencies
    CORE_DEPS=("git:Version Control" "curl:HTTP Client" "wget:File Downloader" 
               "node:Node.js Runtime" "npm:Package Manager" "bash:Shell")
    
    MISSING_DEPS=0
    for dep_info in "${CORE_DEPS[@]}"; do
        dep=$(echo $dep_info | cut -d':' -f1)
        name=$(echo $dep_info | cut -d':' -f2)
        
        if command -v $dep &> /dev/null; then
            version=""
            case $dep in
                "node") version=" ($(node --version))" ;;
                "git") version=" ($(git --version | cut -d' ' -f3))" ;;
                "bash") version=" (${BASH_VERSION})" ;;
            esac
            log_info "$name is installed$version"
        else
            log_issue "$name ($dep) not installed"
            MISSING_DEPS=$((MISSING_DEPS + 1))
        fi
    done
    
    if [ $MISSING_DEPS -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}To install missing dependencies:${NC}"
        echo "sudo apt update && sudo apt install -y git curl wget nodejs npm"
    fi
    
    echo ""
}

diagnose_permissions() {
    echo -e "${CYAN}🔐 DIAGNOSING PERMISSIONS ISSUES${NC}"
    echo "==============================="
    echo ""
    
    # Check ~/.local/bin
    if [ ! -d ~/.local/bin ]; then
        log_issue "~/.local/bin directory missing"
        mkdir -p ~/.local/bin
        log_fix "Created ~/.local/bin directory"
    else
        log_info "~/.local/bin directory exists"
    fi
    
    # Check PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        log_warning "~/.local/bin not in PATH"
        echo "   Add to ~/.bashrc: export PATH=\"\$HOME/.local/bin:\$PATH\""
        
        read -p "Add to PATH now? (y/n): " fix_path
        if [[ $fix_path =~ ^[Yy]$ ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            export PATH="$HOME/.local/bin:$PATH"
            log_fix "Added ~/.local/bin to PATH"
        fi
    else
        log_info "~/.local/bin is in PATH"
    fi
    
    # Check Bill Sloth command
    if [ -f ~/.local/bin/bill-sloth ]; then
        if [ -x ~/.local/bin/bill-sloth ]; then
            log_info "bill-sloth command is executable"
        else
            log_issue "bill-sloth command not executable"
            chmod +x ~/.local/bin/bill-sloth
            log_fix "Made bill-sloth executable"
        fi
    else
        log_warning "bill-sloth command not installed"
        echo "   Copy from: ./bin/bill-sloth to ~/.local/bin/"
    fi
    
    echo ""
}

fix_common_issues() {
    echo -e "${CYAN}🔧 AUTOMATIC FIXES FOR COMMON ISSUES${NC}"
    echo "===================================="
    echo ""
    
    FIXES_APPLIED=0
    
    # Fix 1: Reset corrupted learning data
    if [ -f ~/.bill-sloth/corrupted_learning_data ]; then
        log_info "Detecting corrupted learning data..."
        rm -rf ~/.bill-sloth/{feedback,usage,adaptations}/*
        mkdir -p ~/.bill-sloth/{feedback,usage,adaptations}
        rm -f ~/.bill-sloth/corrupted_learning_data
        log_fix "Reset corrupted learning data"
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    fi
    
    # Fix 2: Repair module permissions
    if [ -d "../modules" ]; then
        NON_EXEC_COUNT=$(find ../modules -name "*.sh" ! -executable | wc -l)
        if [ $NON_EXEC_COUNT -gt 0 ]; then
            chmod +x ../modules/*.sh
            log_fix "Fixed permissions for $NON_EXEC_COUNT modules"
            FIXES_APPLIED=$((FIXES_APPLIED + 1))
        fi
    fi
    
    # Fix 3: Recreate missing directories
    for dir in ~/.bill-sloth ~/.local/bin ~/.config; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            log_fix "Created missing directory: $dir"
            FIXES_APPLIED=$((FIXES_APPLIED + 1))
        fi
    done
    
    # Fix 4: Repair adaptive learning integration
    if [ -f "./lib/adaptive_learning.sh" ] && [ -x "./scripts/batch_enhance_modules.sh" ]; then
        UNENHANCED=$(find ../modules -name "*_interactive.sh" -type f -exec grep -L "adaptive_learning.sh" {} \; | wc -l)
        if [ $UNENHANCED -gt 0 ]; then
            echo ""
            echo -e "${YELLOW}Found $UNENHANCED modules without adaptive learning.${NC}"
            read -p "Enhance them now? (y/n): " enhance_now
            if [[ $enhance_now =~ ^[Yy]$ ]]; then
                ./scripts/batch_enhance_modules.sh
                log_fix "Enhanced modules with adaptive learning"
                FIXES_APPLIED=$((FIXES_APPLIED + 1))
            fi
        fi
    fi
    
    if [ $FIXES_APPLIED -eq 0 ]; then
        log_info "No automatic fixes were needed"
    else
        echo ""
        echo -e "${GREEN}Applied $FIXES_APPLIED automatic fixes!${NC}"
    fi
    
    echo ""
}

generate_system_report() {
    echo -e "${CYAN}📋 GENERATING SYSTEM REPORT${NC}"
    echo "============================"
    echo ""
    
    REPORT_FILE="$HOME/bill-sloth-diagnostic-$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "Bill Sloth System Diagnostic Report"
        echo "Generated: $(date)"
        echo "========================================"
        echo ""
        
        echo "System Information:"
        echo "- OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")"
        echo "- Kernel: $(uname -r)"
        echo "- Bash Version: $BASH_VERSION"
        echo "- User: $USER"
        echo ""
        
        echo "Bill Sloth Installation:"
        echo "- Directory: $(pwd)"
        echo "- Modules found: $(find ../modules -name "*_interactive.sh" 2>/dev/null | wc -l)"
        echo "- Learning data files: $(find ~/.bill-sloth -name "*.log" -o -name "*.txt" 2>/dev/null | wc -l)"
        echo ""
        
        echo "Dependencies Status:"
        for cmd in git curl wget node npm claude copyq rofi; do
            if command -v $cmd &> /dev/null; then
                echo "- $cmd: ✅ Installed"
            else
                echo "- $cmd: ❌ Missing"
            fi
        done
        echo ""
        
        echo "Issues Found: $ISSUE_COUNT"
        echo "Fixes Applied: $FIX_COUNT"
        
    } > "$REPORT_FILE"
    
    echo -e "${GREEN}📄 Diagnostic report saved to: $REPORT_FILE${NC}"
    echo ""
    echo "Share this report when asking for help on GitHub or forums."
    echo ""
}

main() {
    print_header
    
    echo -e "${BLUE}This tool will diagnose and fix common Bill Sloth issues.${NC}"
    echo ""
    
    read -p "Run full diagnostic? (y/n): " run_diagnostic
    
    if [[ ! $run_diagnostic =~ ^[Yy]$ ]]; then
        echo "Diagnostic cancelled."
        exit 0
    fi
    
    echo ""
    
    # Run all diagnostics
    diagnose_system_deps
    diagnose_claude_code
    diagnose_adaptive_learning
    diagnose_power_tools
    diagnose_modules
    diagnose_permissions
    fix_common_issues
    generate_system_report
    
    echo -e "${CYAN}🎯 TROUBLESHOOTING SUMMARY${NC}"
    echo "=========================="
    echo ""
    
    if [ $ISSUE_COUNT -eq 0 ]; then
        echo -e "${GREEN}🎉 No issues found! Your Bill Sloth system is healthy.${NC}"
    else
        echo -e "${YELLOW}Found $ISSUE_COUNT issues. Check the details above.${NC}"
        echo ""
        echo -e "${BLUE}Common next steps:${NC}"
        echo "1. Install missing dependencies"
        echo "2. Run: ./scripts/health_check.sh"
        echo "3. Ask for help with the diagnostic report"
    fi
    
    if [ $FIX_COUNT -gt 0 ]; then
        echo ""
        echo -e "${GREEN}Applied $FIX_COUNT automatic fixes!${NC}"
    fi
    
    echo ""
    echo -e "${PURPLE}For more help: https://github.com/How1337ItIs/billsloth/issues${NC}"
}

# Run main troubleshooting
main "$@"