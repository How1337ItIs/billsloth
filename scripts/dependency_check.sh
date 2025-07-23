#!/bin/bash
# Bill Sloth Dependency Verification Script
# Checks for all required dependencies and provides installation guidance

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dependency tracking
MISSING_DEPS=()
AVAILABLE_DEPS=()
OPTIONAL_DEPS=()

print_header() {
    echo -e "${BLUE}"
    echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    echo "█  🔧 BILL SLOTH DEPENDENCY VERIFICATION 🔧                      █"
    echo "█  💀 ENSURING ALL SYSTEMS ARE OPERATIONAL 💀                    █"
    echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
    echo -e "${NC}"
    echo ""
}

check_command() {
    local cmd="$1"
    local description="$2"
    local required="${3:-true}"
    
    if command -v "$cmd" &>/dev/null; then
        local version=""
        case "$cmd" in
            "node") version=$(node --version 2>/dev/null || echo "unknown") ;;
            "python3") version=$(python3 --version 2>/dev/null || echo "unknown") ;;
            "git") version=$(git --version 2>/dev/null || echo "unknown") ;;
            "sqlite3") version=$(sqlite3 --version 2>/dev/null || echo "unknown") ;;
            "jq") version=$(jq --version 2>/dev/null || echo "unknown") ;;
            "curl") version=$(curl --version 2>/dev/null | head -1 || echo "unknown") ;;
            "wget") version=$(wget --version 2>/dev/null | head -1 || echo "unknown") ;;
            "rg") version=$(rg --version 2>/dev/null | head -1 || echo "unknown") ;;
            "just") version=$(just --version 2>/dev/null || echo "unknown") ;;
            *) version="installed" ;;
        esac
        
        echo -e "  ✅ ${GREEN}$cmd${NC} - $description ($version)"
        AVAILABLE_DEPS+=("$cmd")
    else
        if [ "$required" = "true" ]; then
            echo -e "  ❌ ${RED}$cmd${NC} - $description (MISSING - REQUIRED)"
            MISSING_DEPS+=("$cmd")
        else
            echo -e "  ⚠️  ${YELLOW}$cmd${NC} - $description (missing - optional)"
            OPTIONAL_DEPS+=("$cmd")
        fi
    fi
}

check_core_dependencies() {
    echo -e "${BLUE}🔧 CORE SYSTEM DEPENDENCIES${NC}"
    echo "=================================="
    echo ""
    
    check_command "bash" "Bash shell for all scripts" true
    check_command "curl" "HTTP client for downloads" true
    check_command "wget" "Alternative HTTP client" false
    check_command "git" "Version control system" true
    check_command "unzip" "Archive extraction" true
    check_command "tar" "Archive handling" true
    echo ""
}

check_data_dependencies() {
    echo -e "${BLUE}💾 DATA & DATABASE DEPENDENCIES${NC}"
    echo "=================================="
    echo ""
    
    check_command "sqlite3" "SQLite database for data persistence" true
    check_command "jq" "JSON processing for APIs and data" true
    echo ""
}

check_automation_dependencies() {
    echo -e "${BLUE}⚡ AUTOMATION & TASK DEPENDENCIES${NC}"
    echo "=================================="  
    echo ""
    
    check_command "just" "Task runner for Justfile automation" true
    check_command "cron" "System scheduler for automation" false
    check_command "systemctl" "System service management" false
    echo ""
}

check_development_dependencies() {
    echo -e "${BLUE}💻 DEVELOPMENT DEPENDENCIES${NC}"
    echo "=================================="
    echo ""
    
    check_command "node" "Node.js for Claude Code integration" true
    check_command "npm" "Node package manager" true
    check_command "python3" "Python for advanced automation" false
    check_command "pip3" "Python package manager" false
    echo ""
}

check_text_processing_dependencies() {
    echo -e "${BLUE}📝 TEXT PROCESSING DEPENDENCIES${NC}"
    echo "=================================="
    echo ""
    
    check_command "rg" "Ripgrep for fast text searching" true
    check_command "fd" "Fast file finder (fd-find)" false
    check_command "fzf" "Fuzzy finder for interactive selection" false
    check_command "tree" "Directory tree visualization" false
    echo ""
}

check_voice_control_dependencies() {
    echo -e "${BLUE}🎤 VOICE CONTROL DEPENDENCIES${NC}"
    echo "=================================="
    echo ""
    
    check_command "espeak" "Text-to-speech synthesis" false
    check_command "arecord" "Audio recording for voice input" false
    check_command "pactl" "PulseAudio control" false
    check_command "flutter" "Flutter framework for GUI" false
    echo ""
}

check_claude_code_integration() {
    echo -e "${BLUE}🤖 CLAUDE CODE INTEGRATION${NC}"
    echo "=================================="
    echo ""
    
    if command -v claude &>/dev/null; then
        local claude_version=$(claude --version 2>/dev/null || echo "unknown")
        echo -e "  ✅ ${GREEN}claude${NC} - Claude Code CLI ($claude_version)"
        AVAILABLE_DEPS+=("claude")
        
        # Check if authenticated
        if claude auth status &>/dev/null; then
            echo -e "  ✅ ${GREEN}claude-auth${NC} - Claude authentication is active"
        else
            echo -e "  ⚠️  ${YELLOW}claude-auth${NC} - Not authenticated (run: claude login)"
        fi
    else
        echo -e "  ❌ ${RED}claude${NC} - Claude Code CLI (MISSING - CRITICAL FOR AI FEATURES)"
        MISSING_DEPS+=("claude")
        echo -e "      📥 Install: ${YELLOW}npm install -g @anthropic-ai/claude-code${NC}"
    fi
    echo ""
}

check_bill_sloth_structure() {
    echo -e "${BLUE}🏠 BILL SLOTH PROJECT STRUCTURE${NC}"
    echo "=================================="
    echo ""
    
    local project_dirs=(
        "lib"
        "modules"
        "scripts" 
        "windows-setup"
        "tests"
    )
    
    for dir in "${project_dirs[@]}"; do
        if [ -d "$dir" ]; then
            local file_count=$(find "$dir" -type f | wc -l)
            echo -e "  ✅ ${GREEN}$dir/${NC} - Directory exists ($file_count files)"
        else
            echo -e "  ❌ ${RED}$dir/${NC} - Directory missing"
        fi
    done
    
    # Check key files
    local key_files=(
        "bill_command_center.sh"
        "onboard.sh"
        "fresh_ubuntu_installer.sh"
        "Justfile"
        "README.md"
    )
    
    echo ""
    echo "Key files:"
    for file in "${key_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "  ✅ ${GREEN}$file${NC} - Present"
        else
            echo -e "  ❌ ${RED}$file${NC} - Missing"
        fi
    done
    echo ""
}

generate_installation_guide() {
    if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
        return 0
    fi
    
    echo -e "${YELLOW}📦 MISSING DEPENDENCY INSTALLATION GUIDE${NC}"
    echo "=========================================="
    echo ""
    echo "The following dependencies need to be installed:"
    echo ""
    
    # Detect OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "🐧 Linux Installation Commands:"
        echo ""
        
        # Ubuntu/Debian commands
        echo "For Ubuntu/Debian systems:"
        echo "sudo apt update && sudo apt install -y \\"
        
        for dep in "${MISSING_DEPS[@]}"; do
            case "$dep" in
                "sqlite3") echo "  sqlite3 \\" ;;
                "jq") echo "  jq \\" ;;
                "rg") echo "  ripgrep \\" ;;
                "just") echo "  just \\" ;;
                "node") echo "  nodejs \\" ;;
                "npm") echo "  npm \\" ;;
                "fd") echo "  fd-find \\" ;;
                "fzf") echo "  fzf \\" ;;
                "tree") echo "  tree \\" ;;
                "curl") echo "  curl \\" ;;
                "wget") echo "  wget \\" ;;
                "git") echo "  git \\" ;;
                "unzip") echo "  unzip \\" ;;
                "python3") echo "  python3 python3-pip \\" ;;
                *) echo "  $dep \\" ;;
            esac
        done
        echo ""
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🍎 macOS Installation Commands:"
        echo ""
        echo "Using Homebrew:"
        echo "brew install \\"
        
        for dep in "${MISSING_DEPS[@]}"; do
            case "$dep" in
                "rg") echo "  ripgrep \\" ;;
                "fd") echo "  fd \\" ;;
                *) echo "  $dep \\" ;;
            esac
        done
        echo ""
        
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "🪟 Windows Installation Commands:"
        echo ""
        echo "Using package managers or direct downloads:"
        echo ""
        
        for dep in "${MISSING_DEPS[@]}"; do
            case "$dep" in
                "sqlite3") echo "• SQLite3: Download from https://sqlite.org/download.html" ;;
                "jq") echo "• jq: Download from https://github.com/stedolan/jq/releases" ;;
                "rg") echo "• ripgrep: Download from https://github.com/BurntSushi/ripgrep/releases" ;;
                "just") echo "• just: Download from https://github.com/casey/just/releases" ;;
                "node") echo "• Node.js: Download from https://nodejs.org/" ;;
                "git") echo "• Git: Download from https://git-scm.com/download/win" ;;
                *) echo "• $dep: Search for Windows installer" ;;
            esac
        done
        echo ""
    fi
    
    # Special installation instructions
    echo "🤖 Claude Code Installation:"
    echo "npm install -g @anthropic-ai/claude-code"
    echo "claude login  # To authenticate"
    echo ""
    
    if [[ " ${MISSING_DEPS[*]} " =~ " just " ]]; then
        echo "📋 Just Task Runner Installation:"
        echo "Alternative methods if package manager doesn't have 'just':"
        echo "curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/bin"
        echo "# Or download binary from: https://github.com/casey/just/releases"
        echo ""
    fi
}

generate_summary_report() {
    echo -e "${BLUE}📊 DEPENDENCY SUMMARY REPORT${NC}"
    echo "============================="
    echo ""
    
    echo -e "✅ ${GREEN}Available Dependencies:${NC} ${#AVAILABLE_DEPS[@]}"
    echo -e "❌ ${RED}Missing Required Dependencies:${NC} ${#MISSING_DEPS[@]}"
    echo -e "⚠️  ${YELLOW}Missing Optional Dependencies:${NC} ${#OPTIONAL_DEPS[@]}"
    echo ""
    
    if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
        echo -e "🎉 ${GREEN}ALL REQUIRED DEPENDENCIES ARE AVAILABLE!${NC}"
        echo ""
        echo "Your Bill Sloth installation should work correctly."
        echo "You can now run the main command center:"
        echo "  ./bill_command_center.sh"
        echo ""
    else
        echo -e "⚠️  ${YELLOW}MISSING REQUIRED DEPENDENCIES DETECTED${NC}"
        echo ""
        echo "The following critical dependencies are missing:"
        for dep in "${MISSING_DEPS[@]}"; do
            echo -e "  • ${RED}$dep${NC}"
        done
        echo ""
        echo "Please install these dependencies before running Bill Sloth."
        echo "See the installation guide above for specific commands."
        echo ""
    fi
    
    if [ ${#OPTIONAL_DEPS[@]} -gt 0 ]; then
        echo -e "ℹ️  ${BLUE}Optional Dependencies:${NC}"
        echo "The following optional features won't be available:"
        for dep in "${OPTIONAL_DEPS[@]}"; do
            echo -e "  • ${YELLOW}$dep${NC}"
        done
        echo ""
        echo "These can be installed later to unlock additional features."
        echo ""
    fi
}

save_dependency_report() {
    local report_file="$HOME/.bill-sloth/dependency-report.md"
    local report_dir="$(dirname "$report_file")"
    
    # Create directory if it doesn't exist
    mkdir -p "$report_dir"
    
    cat > "$report_file" << EOF
# Bill Sloth Dependency Report

**Generated:** $(date)
**System:** $(uname -a 2>/dev/null || echo "Unknown")

## Summary

- ✅ Available Dependencies: ${#AVAILABLE_DEPS[@]}
- ❌ Missing Required: ${#MISSING_DEPS[@]}
- ⚠️ Missing Optional: ${#OPTIONAL_DEPS[@]}

## Available Dependencies

$(for dep in "${AVAILABLE_DEPS[@]}"; do echo "- ✅ $dep"; done)

## Missing Required Dependencies

$(for dep in "${MISSING_DEPS[@]}"; do echo "- ❌ $dep"; done)

## Missing Optional Dependencies

$(for dep in "${OPTIONAL_DEPS[@]}"; do echo "- ⚠️ $dep"; done)

## Installation Status

$(if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
    echo "🎉 **READY TO USE** - All required dependencies are available!"
else
    echo "⚠️ **NEEDS SETUP** - ${#MISSING_DEPS[@]} required dependencies must be installed."
fi)

## Next Steps

$(if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
    echo "1. Run: \`./bill_command_center.sh\` to start Bill Sloth"
    echo "2. Complete onboarding: \`./onboard.sh\`"
    echo "3. Explore automation modules"
else
    echo "1. Install missing dependencies (see installation guide)"
    echo "2. Re-run dependency check: \`./scripts/dependency_check.sh\`"
    echo "3. Once all dependencies are available, start with: \`./bill_command_center.sh\`"
fi)

---
Report saved to: $report_file
EOF
    
    echo -e "${BLUE}📄 Dependency report saved to:${NC} $report_file"
    echo ""
}

# Main execution
main() {
    print_header
    
    echo "Checking Bill Sloth system dependencies..."
    echo "This will verify all required tools and libraries are available."
    echo ""
    
    check_core_dependencies
    check_data_dependencies  
    check_automation_dependencies
    check_development_dependencies
    check_text_processing_dependencies
    check_voice_control_dependencies
    check_claude_code_integration
    check_bill_sloth_structure
    
    generate_installation_guide
    generate_summary_report
    save_dependency_report
    
    # Exit with appropriate code
    if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"