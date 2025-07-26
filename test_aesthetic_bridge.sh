#!/bin/bash
# Test script for aesthetic bridge functionality

# Load the enhanced bridge
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/lib/enhanced_aesthetic_bridge.sh"

echo "[TEST] Aesthetic Bridge Test Suite"
echo "=================================="
echo ""

# Test 1: Terminal detection
echo "[TEST 1] Terminal Capabilities"
detect_terminal_aesthetics
echo "   Color Support: ${COLOR_SUPPORT}"
echo "   Wide Display: ${WIDE_DISPLAY}"
echo "   Support Level: ${TERM_SUPPORT_LEVEL}"
echo ""

# Test 2: Color variables
echo "[TEST 2] Color Variables"
echo -e "   ${RED}Red${NC} ${GREEN}Green${NC} ${BLUE}Blue${NC} ${PURPLE}Purple${NC}"
echo -e "   ${BRED}Bright Red${NC} ${BGREEN}Bright Green${NC} ${BCYAN}Bright Cyan${NC}"
echo ""

# Test 3: ATHF Easter Egg (ASCII)
echo "[TEST 3] ATHF Easter Egg System"
source "$SOURCE_DIR/lib/athf_easter_eggs.sh" 2>/dev/null || true
if declare -f random_athf_easter_egg > /dev/null; then
    echo "   [SUCCESS] Easter egg system loaded"
    echo "   [INFO] Triggering test easter egg..."
    RANDOM=0  # Force trigger for test
    random_athf_easter_egg
else
    echo "   [ERROR] Easter egg system not available"
fi

echo ""
echo "[INFO] Aesthetic bridge test complete!"
echo "   All visual enhancements should display properly"
echo "   in both human and Claude Code execution modes."
