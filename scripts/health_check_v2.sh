#!/bin/bash
# Bill Sloth Enhanced System Health Check v2
# Features: weighted scoring, machine-readable output, detailed diagnostics

# Source error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# Health output files
HEALTH_JSON="$HOME/.bill-sloth/health.json"
HEALTH_LOG="$HOME/.bill-sloth/logs/health_check.log"

# Ensure directories exist
create_directory "$(dirname "$HEALTH_JSON")"
create_directory "$(dirname "$HEALTH_LOG")"

# Component categories with weights
declare -A COMPONENT_WEIGHTS=(
    ["critical"]=10    # Essential for basic functionality
    ["important"]=5    # Major features, significant impact
    ["recommended"]=3  # Nice to have, moderate impact
    ["optional"]=1     # Enhancement tools, minimal impact
)

# Health tracking variables
TOTAL_WEIGHTED_SCORE=0
MAX_WEIGHTED_SCORE=0
RAW_SCORE=0
MAX_RAW_SCORE=0
declare -A CATEGORY_SCORES
declare -A CATEGORY_MAX_SCORES
declare -a ISSUES=()
declare -a WARNINGS=()
declare -a SUGGESTIONS=()

# Enhanced component checking with weights and categories
check_component() {
    local component="$1"
    local check_command="$2"
    local category="$3"         # critical/important/recommended/optional
    local required="$4"         # true/false for backward compatibility
    local description="$5"      # Optional description
    local fix_suggestion="$6"   # Optional fix suggestion
    
    # Get weight for this category
    local weight="${COMPONENT_WEIGHTS[$category]:-1}"
    
    # Initialize category tracking
    if [ -z "${CATEGORY_SCORES[$category]:-}" ]; then
        CATEGORY_SCORES[$category]=0
        CATEGORY_MAX_SCORES[$category]=0
    fi
    
    # Update counters
    MAX_WEIGHTED_SCORE=$((MAX_WEIGHTED_SCORE + weight))
    MAX_RAW_SCORE=$((MAX_RAW_SCORE + 1))
    CATEGORY_MAX_SCORES[$category]=$((CATEGORY_MAX_SCORES[$category] + weight))
    
    # Perform the check
    local status_icon=""
    local status_text=""
    local result=0
    
    if eval "$check_command" &>/dev/null; then
        # Component is available
        status_icon="✅"
        status_text="$component"
        TOTAL_WEIGHTED_SCORE=$((TOTAL_WEIGHTED_SCORE + weight))
        RAW_SCORE=$((RAW_SCORE + 1))
        CATEGORY_SCORES[$category]=$((CATEGORY_SCORES[$category] + weight))
        result=0
    else
        # Component is missing
        case "$category" in
            "critical")
                status_icon="❌"
                status_text="$component (CRITICAL)"
                ISSUES+=("CRITICAL: $component missing - $description")
                if [ -n "$fix_suggestion" ]; then
                    SUGGESTIONS+=("Fix: $fix_suggestion")
                fi
                ;;
            "important")
                status_icon="⚠️"
                status_text="$component (IMPORTANT)"
                ISSUES+=("IMPORTANT: $component missing - $description")
                if [ -n "$fix_suggestion" ]; then
                    SUGGESTIONS+=("Install: $fix_suggestion")
                fi
                ;;
            "recommended")
                status_icon="⚠️"
                status_text="$component (Recommended)"
                WARNINGS+=("Recommended: $component - $description")
                if [ -n "$fix_suggestion" ]; then
                    SUGGESTIONS+=("Consider: $fix_suggestion")
                fi
                ;;
            "optional")
                status_icon="ℹ️"
                status_text="$component (Optional)"
                if [ -n "$description" ]; then
                    WARNINGS+=("Optional: $component - $description")
                fi
                ;;
        esac
        result=1
    fi
    
    # Display result
    echo "$status_icon $status_text"
    
    # Log detailed information
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] CHECK: $component | Category: $category | Weight: $weight | Result: $result | Command: $check_command" >> "$HEALTH_LOG"
    
    return $result
}

# Calculate health percentages
calculate_health_scores() {
    if [ $MAX_WEIGHTED_SCORE -gt 0 ]; then
        WEIGHTED_PERCENTAGE=$((TOTAL_WEIGHTED_SCORE * 100 / MAX_WEIGHTED_SCORE))
    else
        WEIGHTED_PERCENTAGE=0
    fi
    
    if [ $MAX_RAW_SCORE -gt 0 ]; then
        RAW_PERCENTAGE=$((RAW_SCORE * 100 / MAX_RAW_SCORE))
    else
        RAW_PERCENTAGE=0
    fi
}

# Generate machine-readable health report
generate_health_json() {
    local timestamp=$(date -Iseconds)
    
    # Calculate category percentages
    local category_data=""
    for category in critical important recommended optional; do
        if [ -n "${CATEGORY_SCORES[$category]:-}" ]; then
            local score=${CATEGORY_SCORES[$category]}
            local max_score=${CATEGORY_MAX_SCORES[$category]}
            local percentage=0
            
            if [ $max_score -gt 0 ]; then
                percentage=$((score * 100 / max_score))
            fi
            
            if [ -n "$category_data" ]; then
                category_data="$category_data,"
            fi
            category_data="$category_data\"$category\":{\"score\":$score,\"max_score\":$max_score,\"percentage\":$percentage}"
        fi
    done
    
    # Create JSON report
    cat > "$HEALTH_JSON" << EOF
{
    "timestamp": "$timestamp",
    "version": "2.0",
    "overall": {
        "weighted_score": $TOTAL_WEIGHTED_SCORE,
        "max_weighted_score": $MAX_WEIGHTED_SCORE,
        "weighted_percentage": $WEIGHTED_PERCENTAGE,
        "raw_score": $RAW_SCORE,
        "max_raw_score": $MAX_RAW_SCORE,
        "raw_percentage": $RAW_PERCENTAGE
    },
    "categories": {$category_data},
    "issues": {
        "critical": ${#ISSUES[@]},
        "warnings": ${#WARNINGS[@]},
        "suggestions": ${#SUGGESTIONS[@]}
    },
    "status": "$(get_health_status)"
}
EOF

    log_success "Health report saved to: $HEALTH_JSON"
}

# Determine overall health status
get_health_status() {
    if [ $WEIGHTED_PERCENTAGE -ge 90 ]; then
        echo "excellent"
    elif [ $WEIGHTED_PERCENTAGE -ge 75 ]; then
        echo "good"
    elif [ $WEIGHTED_PERCENTAGE -ge 50 ]; then
        echo "fair"
    elif [ $WEIGHTED_PERCENTAGE -ge 25 ]; then
        echo "poor"
    else
        echo "critical"
    fi
}

# Enhanced health check with categorized components
run_health_check() {
    print_header "🔍 BILL SLOTH ENHANCED HEALTH CHECK v2"
    
    log_info "Checking system health with weighted scoring..."
    echo ""
    
    # Core System Components (CRITICAL)
    print_separator "-" 40
    echo "📋 CORE SYSTEM COMPONENTS (Critical):"
    print_separator "-" 40
    
    check_component "Claude Code CLI" "command -v claude" "critical" "true" \
        "Required for AI functionality" "npm install -g @anthropic-ai/claude-code"
    
    check_component "Node.js (v18+)" "node --version | grep -E 'v1[89]|v[2-9][0-9]'" "critical" "true" \
        "Required for Claude Code CLI" "Visit https://nodejs.org"
    
    check_component "Git" "command -v git" "critical" "true" \
        "Required for version control" "sudo apt install git"
    
    check_component "Bash 4+" "bash --version | head -1 | grep -E 'version [4-9]'" "critical" "true" \
        "Required for advanced shell features" "Update bash: sudo apt install bash"
    
    echo ""
    
    # Adaptive Learning System (IMPORTANT)
    print_separator "-" 40
    echo "🧠 ADAPTIVE LEARNING SYSTEM (Important):"
    print_separator "-" 40
    
    check_component "Adaptive learning library" "[ -f ./lib/adaptive_learning.sh ]" "important" "true" \
        "Core adaptive functionality" "Re-run install.sh"
    
    check_component "Error handling library" "[ -f ./lib/error_handling.sh ]" "important" "true" \
        "Standardized error management" "Re-run install.sh"
    
    check_component "Enhanced LLM router" "[ -f ./lib/call_llm_v2.sh ]" "important" "false" \
        "Improved AI routing with timeouts" "Update system libraries"
    
    check_component "Learning directories" "[ -d ~/.bill-sloth ]" "important" "false" \
        "Data storage for adaptive learning" "mkdir -p ~/.bill-sloth"
    
    check_component "Bill Sloth command" "command -v bill-sloth" "recommended" "false" \
        "Command-line interface" "Run ./install.sh"
    
    echo ""
    
    # Power-User Modules (IMPORTANT)
    print_separator "-" 40
    echo "💻 POWER-USER MODULES (Important):"
    print_separator "-" 40
    
    check_component "Clipboard mastery module" "[ -f ./modules/clipboard_mastery_interactive.sh ]" "important" "true" \
        "Advanced clipboard management" "Re-run install.sh"
    
    check_component "Text expansion module" "[ -f ./modules/text_expansion_interactive.sh ]" "important" "true" \
        "Text expansion and snippets" "Re-run install.sh"
    
    check_component "File mastery module" "[ -f ./modules/file_mastery_interactive.sh ]" "important" "true" \
        "Advanced file operations" "Re-run install.sh"
    
    check_component "Launcher mastery module" "[ -f ./modules/launcher_mastery_interactive.sh ]" "important" "true" \
        "Application launching" "Re-run install.sh"
    
    check_component "Window mastery module" "[ -f ./modules/window_mastery_interactive.sh ]" "important" "true" \
        "Window management" "Re-run install.sh"
    
    check_component "System doctor module" "[ -f ./modules/system_doctor_interactive.sh ]" "important" "true" \
        "System diagnostics" "Re-run install.sh"
    
    check_component "Defensive cyber module" "[ -f ./modules/defensive_cyber_interactive.sh ]" "important" "true" \
        "Security and penetration testing" "Re-run install.sh"
    
    echo ""
    
    # Power-User Tools (RECOMMENDED)
    print_separator "-" 40
    echo "🛠️ POWER-USER TOOLS (Recommended):"
    print_separator "-" 40
    
    check_component "CopyQ clipboard manager" "command -v copyq" "recommended" "false" \
        "Advanced clipboard management" "sudo apt install copyq"
    
    check_component "Espanso text expander" "command -v espanso" "recommended" "false" \
        "Text expansion automation" "Run clipboard_mastery_interactive module"
    
    check_component "Rofi launcher" "command -v rofi" "recommended" "false" \
        "Application launcher" "sudo apt install rofi"
    
    check_component "fd file finder" "command -v fd || command -v fdfind" "recommended" "false" \
        "Fast file search" "sudo apt install fd-find"
    
    check_component "ripgrep search" "command -v rg" "recommended" "false" \
        "Fast text search" "sudo apt install ripgrep"
    
    check_component "fzf fuzzy finder" "command -v fzf" "recommended" "false" \
        "Interactive filtering" "sudo apt install fzf"
    
    echo ""
    
    # Security Tools (OPTIONAL)
    print_separator "-" 40
    echo "🛡️ SECURITY TOOLS (Optional):"
    print_separator "-" 40
    
    check_component "nmap scanner" "command -v nmap" "optional" "false" \
        "Network scanning and discovery" "sudo apt install nmap"
    
    check_component "wireshark analyzer" "command -v wireshark" "optional" "false" \
        "Network traffic analysis" "sudo apt install wireshark"
    
    check_component "john password cracker" "command -v john" "optional" "false" \
        "Password security testing" "sudo apt install john"
    
    check_component "nikto web scanner" "command -v nikto" "optional" "false" \
        "Web vulnerability scanning" "sudo apt install nikto"
    
    echo ""
    
    # Calculate final scores
    calculate_health_scores
    
    # Display enhanced health summary
    display_health_summary
    
    # Generate machine-readable report
    generate_health_json
    
    # Show next steps
    show_next_steps
}

# Enhanced health summary display
display_health_summary() {
    print_header "📊 ENHANCED HEALTH SUMMARY"
    
    local status_icon=""
    local status_message=""
    local status=$(get_health_status)
    
    case "$status" in
        "excellent")
            status_icon="🎉"
            status_message="EXCELLENT! Your Bill Sloth system is in perfect health!"
            ;;
        "good")
            status_icon="👍"
            status_message="GOOD! Your system is working well with minor components missing."
            ;;
        "fair")
            status_icon="⚠️"
            status_message="FAIR! Your system works but is missing some important components."
            ;;
        "poor")
            status_icon="❌"
            status_message="POOR! Several important components are missing."
            ;;
        "critical")
            status_icon="💀"
            status_message="CRITICAL! Essential components are missing - system may not function properly."
            ;;
    esac
    
    echo -e "${CYAN}🎯 Weighted Health Score: $TOTAL_WEIGHTED_SCORE/$MAX_WEIGHTED_SCORE ($WEIGHTED_PERCENTAGE%)${NC}"
    echo -e "${BLUE}📊 Raw Component Score: $RAW_SCORE/$MAX_RAW_SCORE ($RAW_PERCENTAGE%)${NC}"
    echo ""
    echo -e "$status_icon $status_message"
    echo ""
    
    # Category breakdown
    echo "📋 CATEGORY BREAKDOWN:"
    echo "--------------------"
    for category in critical important recommended optional; do
        if [ -n "${CATEGORY_SCORES[$category]}" ]; then
            local score=${CATEGORY_SCORES[$category]}
            local max_score=${CATEGORY_MAX_SCORES[$category]}
            local percentage=0
            
            if [ $max_score -gt 0 ]; then
                percentage=$((score * 100 / max_score))
            fi
            
            local category_icon=""
            case "$category" in
                "critical") category_icon="💀" ;;
                "important") category_icon="⚠️" ;;
                "recommended") category_icon="👍" ;;
                "optional") category_icon="ℹ️" ;;
            esac
            
            printf "%-12s %s %2d/%2d (%3d%%)\n" "$category:" "$category_icon" "$score" "$max_score" "$percentage"
        fi
    done
    echo ""
}

# Show actionable next steps
show_next_steps() {
    # Show critical issues first
    if [ ${#ISSUES[@]} -gt 0 ]; then
        print_separator
        echo -e "${RED}🔥 CRITICAL ISSUES TO FIX:${NC}"
        echo "------------------------"
        for issue in "${ISSUES[@]}"; do
            echo -e "${RED}❌ $issue${NC}"
        done
        echo ""
    fi
    
    # Show fix suggestions
    if [ ${#SUGGESTIONS[@]} -gt 0 ]; then
        echo -e "${GREEN}💡 QUICK FIXES:${NC}"
        echo "-------------"
        for suggestion in "${SUGGESTIONS[@]}"; do
            echo -e "${GREEN}• $suggestion${NC}"
        done
        echo ""
    fi
    
    # Show warnings
    if [ ${#WARNINGS[@]} -gt 0 ]; then
        echo -e "${YELLOW}⚠️ OPTIONAL IMPROVEMENTS:${NC}"
        echo "------------------------"
        for warning in "${WARNINGS[@]}"; do
            echo -e "${YELLOW}⚠️ $warning${NC}"
        done
        echo ""
    fi
    
    # Adaptive learning status
    echo -e "${CYAN}🧠 ADAPTIVE LEARNING STATUS:${NC}"
    echo "----------------------------"
    
    if [ -d ~/.bill-sloth ]; then
        local learning_files
        learning_files=$(find ~/.bill-sloth -name "*.log" -o -name "*.txt" 2>/dev/null | wc -l)
        if [ "$learning_files" -gt 0 ]; then
            log_success "Learning system active with $learning_files data files"
        else
            log_info "Learning system ready (no usage data yet)"
        fi
    else
        log_info "Learning system will initialize on first module use"
    fi
    
    echo ""
    
    # Next steps based on health score
    print_separator
    echo -e "${BLUE}🎯 RECOMMENDED NEXT STEPS:${NC}"
    echo "========================"
    
    if [ $WEIGHTED_PERCENTAGE -ge 75 ]; then
        echo -e "${GREEN}🚀 Your system is ready! Try these:${NC}"
        echo "• Run any module: clipboard_mastery_interactive"
        echo "• Check learning: bill-sloth dashboard"
        echo "• Get help: claude 'Show me what Bill Sloth can do'"
    else
        echo -e "${YELLOW}🔧 Fix critical issues first:${NC}"
        echo "• Ask Claude: 'Help me fix the Bill Sloth health check issues'"
        echo "• Install missing components shown above"
        echo "• Re-run this health check: ./scripts/health_check_v2.sh"
    fi
    
    echo ""
    echo -e "${PURPLE}📄 Machine-readable report: $HEALTH_JSON${NC}"
    echo -e "${PURPLE}📋 Detailed logs: $HEALTH_LOG${NC}"
}

# Main function
main() {
    # Clear previous log
    echo "# Bill Sloth Health Check Log - $(date)" > "$HEALTH_LOG"
    
    # Set up error handling
    set -euo pipefail
    
    # Run the health check
    run_health_check
    
    # Return appropriate exit code
    if [ $WEIGHTED_PERCENTAGE -ge 75 ]; then
        exit 0  # Success
    elif [ $WEIGHTED_PERCENTAGE -ge 50 ]; then
        exit 1  # Warnings
    else
        exit 2  # Critical issues
    fi
}

# Export functions for external use
export -f check_component calculate_health_scores generate_health_json
export -f get_health_status display_health_summary

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi