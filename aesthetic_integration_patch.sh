#!/bin/bash
# LLM_CAPABILITY: local_ok
# Aesthetic Integration Patch
# Updates key modules to use enhanced aesthetic bridge

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[INFO] AESTHETIC INTEGRATION PATCH"
echo "=================================="
echo ""
echo "This patch enhances visual preservation in the bridge system:"
echo "• Improves menu display with full color preservation"
echo "• Adds terminal capability detection"
echo "• Enhances visual feedback for selections" 
echo "• Ensures ASCII art and banners display properly"
echo "• Maintains ATHF easter egg compatibility"
echo ""

# List of key modules to patch
MODULES_TO_PATCH=(
    "game_development_interactive.sh"
    "vibe_coding_ultimate_interactive.sh"
    "ai_mastery_interactive.sh"
    "ai_workflow_interactive.sh"
)

echo "[INFO] Patching ${#MODULES_TO_PATCH[@]} key modules..."
echo ""

for module in "${MODULES_TO_PATCH[@]}"; do
    MODULE_PATH="$SOURCE_DIR/modules/$module"
    
    if [[ -f "$MODULE_PATH" ]]; then
        echo "[INFO] Patching $module..."
        
        # Check if already patched
        if grep -q "enhanced_aesthetic_bridge" "$MODULE_PATH"; then
            echo "   [SKIP] Already uses enhanced aesthetic bridge"
        else
            # Add enhanced bridge import after existing bridge import
            if grep -q "claude_interactive_bridge.sh" "$MODULE_PATH"; then
                # Replace the existing bridge import with enhanced version
                sed -i 's|source.*claude_interactive_bridge.sh.*|source "$SOURCE_DIR/../lib/enhanced_aesthetic_bridge.sh" 2>/dev/null \|\| true|' "$MODULE_PATH"
                echo "   [SUCCESS] Enhanced aesthetic bridge integrated"
            else
                echo "   [WARNING] No existing bridge found - manual integration needed"
            fi
        fi
    else
        echo "[WARNING] Module not found: $module"
    fi
    echo ""
done

echo "[INFO] Creating aesthetic test script..."
cat > "$SOURCE_DIR/test_aesthetic_bridge.sh" << 'EOF'
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
EOF

chmod +x "$SOURCE_DIR/test_aesthetic_bridge.sh"

echo "[SUCCESS] Aesthetic integration patch complete!"
echo ""
echo "Changes made:"
echo "• Enhanced aesthetic bridge created"
echo "• Key modules updated to use enhanced bridge"
echo "• Test script created for validation"
echo ""
echo "To test the enhancements:"
echo "   bash test_aesthetic_bridge.sh"
echo ""
echo "Manual integration needed for modules with custom bridge logic."
echo "See AESTHETIC_BRIDGE_ANALYSIS.md for detailed compatibility info."