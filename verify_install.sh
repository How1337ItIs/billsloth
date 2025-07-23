#!/bin/bash
# Post-Installation Verification Script
# Verifies that Bill Sloth system is properly installed and working

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
cat << 'EOF'
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  🔍 BILL SLOTH INSTALLATION VERIFICATION 🔍                     █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
EOF
echo -e "${NC}"

TESTS_PASSED=0
TESTS_FAILED=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing $test_name... "
    
    if eval "$test_command" &>/dev/null; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Critical tests
echo "🔍 Running critical system tests..."
echo ""

run_test "Node.js installation" "command -v node"
run_test "NPM installation" "command -v npm"
run_test "Git installation" "command -v git"
run_test "Core utilities (jq)" "command -v jq"
run_test "Search tools (ripgrep)" "command -v rg"
run_test "File finder (fd)" "command -v fd"
run_test "SQLite database" "command -v sqlite3"
run_test "Fuzzy finder (fzf)" "command -v fzf"

echo ""
echo "🔍 Testing Bill Sloth components..."
echo ""

run_test "Bill Sloth directory structure" "[ -d ~/.bill-sloth ]"
run_test "Command center executable" "[ -x ./bill_command_center.sh ]"
run_test "Fresh installer executable" "[ -x ./fresh_ubuntu_installer.sh ]"
run_test "Module health checker" "[ -x ./lib/module_health_checker.sh ]"
run_test "Error handling library" "[ -f ./lib/error_handling.sh ]"
run_test "Input sanitization library" "[ -f ./lib/input_sanitization.sh ]"
run_test "Overlay system" "[ -f ./lib/overlay_system.sh ]"
run_test "AI model registry" "[ -f ./lib/ai_model_registry.sh ]"
run_test "VRBO API integration" "[ -f ./lib/vrbo_api_integration.sh ]"

# Test Claude Code if available
if command -v claude &>/dev/null; then
    echo ""
    echo "🤖 Testing Claude Code..."
    echo ""
    
    run_test "Claude Code available" "command -v claude"
    run_test "Claude Code version check" "claude --version"
else
    echo ""
    echo -e "${YELLOW}⚠️  Claude Code not found - install with: npm install -g @anthropic-ai/claude-code${NC}"
    echo ""
fi

# Test library syntax
echo ""
echo "🔍 Testing library syntax..."
echo ""

for lib in lib/*.sh; do
    if [ -f "$lib" ]; then
        lib_name=$(basename "$lib" .sh)
        run_test "Library syntax: $lib_name" "bash -n '$lib'"
    fi
done

# Test module syntax (sample)
echo ""
echo "🔍 Testing key module syntax..."
echo ""

key_modules=(
    "modules/intelligent_automation_advisor.sh"
    "modules/vacation_rental_manager_interactive.sh"
    "modules/elite_hacker_arsenal.sh"
)

for module in "${key_modules[@]}"; do
    if [ -f "$module" ]; then
        module_name=$(basename "$module" .sh)
        run_test "Module syntax: $module_name" "bash -n '$module'"
    fi
done

# Summary
echo ""
echo "📊 VERIFICATION SUMMARY"
echo "======================"

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED! ($TESTS_PASSED/$TOTAL_TESTS)${NC}"
    echo ""
    echo -e "${GREEN}✅ Your Bill Sloth installation is ready for digital supremacy!${NC}"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Start the command center: ./bill_command_center.sh"
    echo "2. If you have Claude Code: claude login"
    echo "3. Run a health check: ./bill_command_center.sh → type 'health'"
    echo "4. Test overlay system: ./lib/overlay_system.sh list"
    echo "5. Initialize AI models: ./lib/ai_model_registry.sh recommend"
    
    exit 0
else
    echo -e "${RED}❌ TESTS FAILED: $TESTS_FAILED/$TOTAL_TESTS${NC}"
    echo -e "${GREEN}✅ TESTS PASSED: $TESTS_PASSED/$TOTAL_TESTS${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Your installation needs attention!${NC}"
    echo ""
    echo "🔧 Recommended fixes:"
    echo "1. Run: ./fresh_ubuntu_installer.sh (fixes most issues)"
    echo "2. Check: COMPREHENSIVE_AUDIT_2025.md"
    echo "3. Run health check: ./lib/module_health_checker.sh"
    echo "4. Fix permissions: chmod +x ./lib/*.sh ./modules/*.sh"
    echo "5. Install missing dependencies: sudo apt install sqlite3 jq ripgrep fd-find fzf"
    
    exit 1
fi