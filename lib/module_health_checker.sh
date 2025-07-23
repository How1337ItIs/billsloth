#!/bin/bash
# Module Health Checker - Validates all Bill Sloth modules
# Checks for missing dependencies, syntax errors, and basic functionality

# Enable error handling
set -euo pipefail

# Health check results
HEALTH_RESULTS=()
CRITICAL_ISSUES=0
WARNING_ISSUES=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Log health issue
log_health_issue() {
    local level="$1"
    local module="$2"
    local issue="$3"
    
    case "$level" in
        "CRITICAL")
            echo -e "${RED}❌ [CRITICAL] $module: $issue${NC}"
            ((CRITICAL_ISSUES++))
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠️  [WARNING] $module: $issue${NC}"
            ((WARNING_ISSUES++))
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️  [INFO] $module: $issue${NC}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}✅ [OK] $module: $issue${NC}"
            ;;
    esac
    
    HEALTH_RESULTS+=("$level|$module|$issue")
}

# Check if a command exists
check_command() {
    local cmd="$1"
    if command -v "$cmd" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Check module syntax
check_module_syntax() {
    local module_file="$1"
    local module_name=$(basename "$module_file" .sh)
    
    if [ ! -f "$module_file" ]; then
        log_health_issue "CRITICAL" "$module_name" "Module file not found"
        return 1
    fi
    
    # Check bash syntax
    if bash -n "$module_file" 2>/dev/null; then
        log_health_issue "SUCCESS" "$module_name" "Syntax check passed"
    else
        log_health_issue "CRITICAL" "$module_name" "Syntax errors detected"
        return 1
    fi
    
    return 0
}

# Check module dependencies
check_module_dependencies() {
    local module_file="$1"
    local module_name=$(basename "$module_file" .sh)
    
    # Extract sourced files
    local sources=$(grep -E "^source " "$module_file" 2>/dev/null || true)
    
    if [ -n "$sources" ]; then
        while IFS= read -r source_line; do
            # Extract the file path from source command
            local source_file=$(echo "$source_line" | sed -E 's/source[[:space:]]+['\''"]?([^'\''"\s]+)['\''"]?.*/\1/')
            
            # Skip conditional sources with ||
            if [[ "$source_line" =~ "||" ]]; then
                continue
            fi
            
            # Expand variables in path
            source_file=$(eval echo "$source_file" 2>/dev/null || echo "$source_file")
            
            # Check if file exists
            if [ ! -f "$source_file" ]; then
                log_health_issue "CRITICAL" "$module_name" "Missing dependency: $source_file"
            fi
        done <<< "$sources"
    fi
}

# Check core system dependencies
check_core_dependencies() {
    local module="Core System"
    
    # Essential commands
    local core_commands=("bash" "git" "curl" "wget")
    for cmd in "${core_commands[@]}"; do
        if check_command "$cmd"; then
            log_health_issue "SUCCESS" "$module" "$cmd available"
        else
            log_health_issue "CRITICAL" "$module" "$cmd missing"
        fi
    done
    
    # Bill Sloth specific tools
    local bill_commands=("jq" "sqlite3" "ripgrep" "fd")
    for cmd in "${bill_commands[@]}"; do
        if check_command "$cmd"; then
            log_health_issue "SUCCESS" "$module" "$cmd available"
        else
            log_health_issue "WARNING" "$module" "$cmd missing (run fresh_ubuntu_installer.sh)"
        fi
    done
    
    # Node.js and Claude Code
    if check_command "node"; then
        local node_version=$(node --version 2>/dev/null || echo "unknown")
        log_health_issue "SUCCESS" "$module" "Node.js $node_version available"
    else
        log_health_issue "CRITICAL" "$module" "Node.js missing"
    fi
    
    if check_command "claude"; then
        log_health_issue "SUCCESS" "$module" "Claude Code available"
    else
        log_health_issue "WARNING" "$module" "Claude Code not installed"
    fi
}

# Check directory structure
check_directory_structure() {
    local module="Directory Structure"
    
    local required_dirs=(
        "$HOME/.bill-sloth"
        "$HOME/.bill-sloth/command-center"
        "$HOME/.bill-sloth/vrbo-automation"
        "$HOME/.bill-sloth/workflows"
        "$HOME/.bill-sloth/backups"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            log_health_issue "SUCCESS" "$module" "Directory exists: $dir"
        else
            log_health_issue "WARNING" "$module" "Missing directory: $dir"
        fi
    done
}

# Check module files
check_all_modules() {
    local modules_dir="$(dirname "$0")/../modules"
    
    if [ ! -d "$modules_dir" ]; then
        log_health_issue "CRITICAL" "Module System" "Modules directory not found: $modules_dir"
        return 1
    fi
    
    # Find all .sh files in modules directory
    while IFS= read -r -d '' module_file; do
        check_module_syntax "$module_file"
        check_module_dependencies "$module_file"
    done < <(find "$modules_dir" -name "*.sh" -type f -print0)
}

# Main health check function
run_health_check() {
    echo -e "${BLUE}🏥 BILL SLOTH SYSTEM HEALTH CHECK${NC}"
    echo "=================================="
    echo ""
    
    echo "Checking core dependencies..."
    check_core_dependencies
    echo ""
    
    echo "Checking directory structure..."
    check_directory_structure
    echo ""
    
    echo "Checking module files..."
    check_all_modules
    echo ""
    
    # Summary
    echo "🏥 HEALTH CHECK SUMMARY"
    echo "======================"
    
    if [ $CRITICAL_ISSUES -eq 0 ] && [ $WARNING_ISSUES -eq 0 ]; then
        echo -e "${GREEN}✅ System is healthy! No issues detected.${NC}"
    else
        echo -e "${RED}❌ Critical Issues: $CRITICAL_ISSUES${NC}"
        echo -e "${YELLOW}⚠️  Warning Issues: $WARNING_ISSUES${NC}"
        
        if [ $CRITICAL_ISSUES -gt 0 ]; then
            echo ""
            echo "🚨 CRITICAL ISSUES MUST BE FIXED:"
            for result in "${HEALTH_RESULTS[@]}"; do
                if [[ "$result" =~ ^CRITICAL ]]; then
                    echo "   • $(echo "$result" | cut -d'|' -f2-3 | tr '|' ': ')"
                fi
            done
        fi
        
        if [ $WARNING_ISSUES -gt 0 ]; then
            echo ""
            echo "⚠️  WARNINGS (RECOMMENDED FIXES):"
            for result in "${HEALTH_RESULTS[@]}"; do
                if [[ "$result" =~ ^WARNING ]]; then
                    echo "   • $(echo "$result" | cut -d'|' -f2-3 | tr '|' ': ')"
                fi
            done
        fi
    fi
    
    echo ""
    echo "💡 TO FIX ISSUES:"
    echo "• Run: ./fresh_ubuntu_installer.sh (for missing dependencies)"
    echo "• Check: COMPREHENSIVE_AUDIT_2025.md (for detailed fixes)"
    echo "• Contact: Claude Code for assistance with module issues"
    
    return $CRITICAL_ISSUES
}

# Export functions
export -f run_health_check check_module_syntax check_core_dependencies

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_health_check
fi