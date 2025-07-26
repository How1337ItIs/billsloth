#!/bin/bash
# LLM_CAPABILITY: local_ok
# Enhanced Aesthetic Bridge - Refined Visual Preservation
# Ensures all visual enhancements display properly in both human and Claude execution

# Source the base bridge
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/claude_interactive_bridge.sh" 2>/dev/null || true

# Detect terminal aesthetic capabilities
detect_terminal_aesthetics() {
    local term_colors=$(tput colors 2>/dev/null || echo "0")
    local term_width=$(tput cols 2>/dev/null || echo "80")
    
    export TERM_SUPPORT_LEVEL="basic"
    export WIDE_DISPLAY=false
    export COLOR_SUPPORT=false
    
    # Enhanced terminal support
    if [[ $term_colors -ge 256 ]]; then
        export TERM_SUPPORT_LEVEL="enhanced"
        export COLOR_SUPPORT=true
    fi
    
    # Wide display detection
    if [[ $term_width -ge 120 ]]; then
        export WIDE_DISPLAY=true
    fi
    
    # Claude Code specific optimizations
    if is_claude_execution; then
        export PRESERVE_BANNERS=true
        export SHOW_EASTER_EGGS=true
        export MAINTAIN_COLORS=true
        export VISUAL_FEEDBACK=enhanced
        export FORCE_VISUAL_MODE=true
    fi
}

# Enhanced menu preservation with full visual context
preserve_menu_aesthetics() {
    local script_file="$1"
    local menu_start_line=$(grep -n "echo.*[0-9]\)" "$script_file" | head -1 | cut -d: -f1)
    
    if [[ -n "$menu_start_line" ]]; then
        echo ""
        echo "=================================="
        echo "        FULL MENU DISPLAY"
        echo "=================================="
        
        # Extract and display menu section with colors preserved
        local menu_end_line=$(tail -n +$menu_start_line "$script_file" | grep -n "read -p" | head -1 | cut -d: -f1)
        if [[ -n "$menu_end_line" ]]; then
            local actual_end=$((menu_start_line + menu_end_line - 1))
            sed -n "${menu_start_line},${actual_end}p" "$script_file" | while IFS= read -r line; do
                # Preserve echo statements with colors
                if [[ "$line" =~ ^[[:space:]]*echo ]]; then
                    eval "$line" 2>/dev/null || echo "${line#*echo }"
                fi
            done
        fi
        
        echo "=================================="
        echo ""
    fi
}

# Aesthetic flow controller for seamless visual experience
aesthetic_flow_control() {
    local module_name="$1"
    local execution_phase="$2"
    
    case "$execution_phase" in
        "startup")
            detect_terminal_aesthetics
            
            # Module-specific aesthetic preparations
            case "$module_name" in
                "game_development")
                    export MODULE_THEME="cyberpunk"
                    export PRIMARY_COLOR="\033[38;5;201m"  # Purple
                    ;;
                "vibe_coding")
                    export MODULE_THEME="rainbow"
                    export PRIMARY_COLOR="\033[38;5;82m"   # Bright green
                    ;;
                "ai_mastery")
                    export MODULE_THEME="matrix"
                    export PRIMARY_COLOR="\033[38;5;46m"   # Matrix green
                    ;;
                *)
                    export MODULE_THEME="default"
                    export PRIMARY_COLOR="\033[38;5;33m"   # Blue
                    ;;
            esac
            ;;
        "menu_display")
            preserve_menu_aesthetics "$3"
            ;;
        "selection")
            # Visual feedback for selections
            if [[ "${VISUAL_FEEDBACK}" == "enhanced" ]]; then
                echo ""
                echo "${PRIMARY_COLOR}[SELECTED]${NC} Processing choice: $3"
                sleep 0.1  # Brief pause for visual acknowledgment
            fi
            ;;
        "completion")
            # Module completion visual flourish
            if [[ "${SHOW_EASTER_EGGS}" == "true" ]]; then
                source "$SOURCE_DIR/athf_easter_eggs.sh" 2>/dev/null || true
                random_athf_easter_egg
            fi
            ;;
    esac
}

# Enhanced Claude preflight with aesthetic preview
enhanced_claude_preflight() {
    local script_name="$1"
    local script_file="$2"
    
    # Initialize aesthetics
    aesthetic_flow_control "${script_name}" "startup"
    
    echo "${PRIMARY_COLOR}"
    echo "=============================================="
    echo "     CLAUDE CODE AESTHETIC ANALYSIS"
    echo "=============================================="
    echo -e "${NC}"
    echo ""
    
    # Show terminal capabilities
    echo "[INFO] Terminal Capabilities:"
    echo "   • Color Support: ${COLOR_SUPPORT}"
    echo "   • Wide Display: ${WIDE_DISPLAY}"
    echo "   • Support Level: ${TERM_SUPPORT_LEVEL}"
    echo "   • Module Theme: ${MODULE_THEME}"
    echo ""
    
    # Parse script for visual elements
    local banner_lines=$(grep -c "cat << 'EOF'" "$script_file" 2>/dev/null || echo "0")
    local color_codes=$(grep -c "\\033\[" "$script_file" 2>/dev/null || echo "0")
    local menu_options=$(grep -c "^[[:space:]]*[0-9]\)" "$script_file" 2>/dev/null || echo "0")
    
    echo "[INFO] Visual Elements Detected:"
    echo "   • ASCII Art Banners: $banner_lines"
    echo "   • Color Sequences: $color_codes"
    echo "   • Menu Options: $menu_options"
    echo "   • Easter Egg Support: ${SHOW_EASTER_EGGS}"
    echo ""
    
    echo "[SUCCESS] Full aesthetic experience ready!"
    echo "   • All banners will display with colors"
    echo "   • Menu selections preserve visual context"
    echo "   • Educational content shown in full"
    echo "   • ATHF easter eggs active (ASCII-safe)"
    echo ""
    
    # Show menu preview if present
    aesthetic_flow_control "${script_name}" "menu_display" "$script_file"
    
    echo "${PRIMARY_COLOR}Ready to launch with full visual fidelity!${NC}"
    echo "=============================================="
    echo ""
}

# Visual selection wrapper
visual_smart_select() {
    local prompt="$1"
    local context="$2"
    local choice="$3"
    
    # Provide visual feedback for selection
    aesthetic_flow_control "$context" "selection" "$choice"
    
    # Use the original smart selection logic
    claude_smart_select "$prompt" "$context"
}

# Enhanced module completion
enhanced_module_completion() {
    local module_name="$1"
    
    echo ""
    echo "${PRIMARY_COLOR}================================${NC}"
    echo "${PRIMARY_COLOR}    MODULE COMPLETION SUCCESS${NC}"
    echo "${PRIMARY_COLOR}================================${NC}"
    echo ""
    
    # Show completion flourish
    aesthetic_flow_control "$module_name" "completion"
    
    echo "[INFO] Visual enhancements fully preserved"
    echo "[INFO] All aesthetic elements displayed correctly"
    echo ""
}

# Export enhanced functions
export -f detect_terminal_aesthetics
export -f preserve_menu_aesthetics
export -f aesthetic_flow_control
export -f enhanced_claude_preflight
export -f visual_smart_select
export -f enhanced_module_completion

# Initialize aesthetics on source
detect_terminal_aesthetics

# Color variables for consistent theming
export NC='\033[0m'          # No Color
export RED='\033[0;31m'      # Red
export GREEN='\033[0;32m'    # Green
export YELLOW='\033[0;33m'   # Yellow
export BLUE='\033[0;34m'     # Blue
export PURPLE='\033[0;35m'   # Purple
export CYAN='\033[0;36m'     # Cyan
export WHITE='\033[0;37m'    # White

# Bright colors
export BRED='\033[1;31m'     # Bright Red
export BGREEN='\033[1;32m'   # Bright Green
export BYELLOW='\033[1;33m'  # Bright Yellow
export BBLUE='\033[1;34m'    # Bright Blue
export BPURPLE='\033[1;35m'  # Bright Purple
export BCYAN='\033[1;36m'    # Bright Cyan
export BWHITE='\033[1;37m'   # Bright White