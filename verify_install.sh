#!/bin/bash
# Post-Installation Verification Script
# Verifies that Bill Sloth system is properly installed and working

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

echo ""
echo "🔍 Testing Bill Sloth components..."
echo ""

run_test "Bill Sloth directory structure" "[ -d ~/.bill-sloth ]"
run_test "Command center executable" "[ -x ./bill_command_center.sh ]"
run_test "Fresh installer executable" "[ -x ./fresh_ubuntu_installer.sh ]"
run_test "Module health checker" "[ -x ./lib/module_health_checker.sh ]"

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

# Test module syntax
echo ""
echo "🔍 Testing module syntax..."
echo ""

for module in modules/*.sh; do
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
    
    exit 1
fi