#!/bin/bash
# Bill Sloth System Health Check
# Verifies all components are properly installed and configured

echo "🔍 BILL SLOTH SYSTEM HEALTH CHECK"
echo "================================="
echo ""

HEALTH_SCORE=0
MAX_SCORE=0
ISSUES=()
WARNINGS=()

# Function to check component
check_component() {
    local component="$1"
    local check_command="$2"
    local required="$3"  # true/false
    
    MAX_SCORE=$((MAX_SCORE + 1))
    
    if eval "$check_command" &>/dev/null; then
        echo "✅ $component"
        HEALTH_SCORE=$((HEALTH_SCORE + 1))
    else
        if [ "$required" = "true" ]; then
            echo "❌ $component (REQUIRED)"
            ISSUES+=("Missing required component: $component")
        else
            echo "⚠️  $component (Optional)"
            WARNINGS+=("Optional component not installed: $component")
        fi
    fi
}

echo "📋 CORE SYSTEM COMPONENTS:"
echo "-------------------------"

# Core requirements
check_component "Claude Code CLI" "command -v claude" "true"
check_component "Node.js (v18+)" "node --version | grep -E 'v1[89]|v[2-9][0-9]'" "true"
check_component "Git" "command -v git" "true"
check_component "Bash 4+" "bash --version | head -1 | grep -E 'version [4-9]'" "true"

echo ""
echo "🧠 ADAPTIVE LEARNING SYSTEM:"
echo "----------------------------"

# Adaptive learning components
check_component "Adaptive learning library" "[ -f ./lib/adaptive_learning.sh ]" "true"
check_component "Learning directories" "[ -d ~/.bill-sloth ]" "false"
check_component "Bill Sloth command" "command -v bill-sloth" "false"
check_component "Adaptation management" "command -v adapt-modules" "false"

echo ""
echo "💻 POWER-USER MODULES:"
echo "---------------------"

# Core power-user modules
check_component "Clipboard mastery module" "[ -f ./modules/clipboard_mastery_interactive.sh ]" "true"
check_component "Text expansion module" "[ -f ./modules/text_expansion_interactive.sh ]" "true"  
check_component "File mastery module" "[ -f ./modules/file_mastery_interactive.sh ]" "true"
check_component "Launcher mastery module" "[ -f ./modules/launcher_mastery_interactive.sh ]" "true"
check_component "Window mastery module" "[ -f ./modules/window_mastery_interactive.sh ]" "true"
check_component "System doctor module" "[ -f ./modules/system_doctor_interactive.sh ]" "true"
check_component "Defensive cyber module" "[ -f ./modules/defensive_cyber_interactive.sh ]" "true"

echo ""
echo "🛠️  POWER-USER TOOLS:"
echo "--------------------"

# Power-user tools (optional but recommended)
check_component "CopyQ clipboard manager" "command -v copyq" "false"
check_component "Espanso text expander" "command -v espanso" "false"
check_component "Rofi launcher" "command -v rofi" "false"
check_component "fd file finder" "command -v fd || command -v fdfind" "false"
check_component "ripgrep search" "command -v rg" "false"
check_component "fzf fuzzy finder" "command -v fzf" "false"

echo ""
echo "🛡️  SECURITY TOOLS:"
echo "------------------"

# Security tools (optional)
check_component "nmap scanner" "command -v nmap" "false"
check_component "wireshark analyzer" "command -v wireshark" "false"
check_component "john password cracker" "command -v john" "false"
check_component "nikto web scanner" "command -v nikto" "false"

echo ""
echo "📊 HEALTH SUMMARY:"
echo "=================="
echo ""

# Calculate health percentage
HEALTH_PERCENTAGE=$((HEALTH_SCORE * 100 / MAX_SCORE))

echo "🎯 Overall Health Score: $HEALTH_SCORE/$MAX_SCORE ($HEALTH_PERCENTAGE%)"
echo ""

if [ $HEALTH_PERCENTAGE -ge 90 ]; then
    echo "🎉 EXCELLENT! Your Bill Sloth system is in perfect health!"
    STATUS_ICON="🎉"
elif [ $HEALTH_PERCENTAGE -ge 75 ]; then
    echo "👍 GOOD! Your system is working well with minor optional components missing."
    STATUS_ICON="👍"
elif [ $HEALTH_PERCENTAGE -ge 50 ]; then
    echo "⚠️  OKAY! Your system works but is missing some important components."
    STATUS_ICON="⚠️"
else
    echo "❌ NEEDS ATTENTION! Several important components are missing."
    STATUS_ICON="❌"
fi

echo ""

# Show issues
if [ ${#ISSUES[@]} -gt 0 ]; then
    echo "🔥 CRITICAL ISSUES TO FIX:"
    echo "--------------------------"
    for issue in "${ISSUES[@]}"; do
        echo "❌ $issue"
    done
    echo ""
    
    echo "💡 QUICK FIXES:"
    echo "---------------"
    if [[ " ${ISSUES[@]} " =~ "Claude Code CLI" ]]; then
        echo "• Install Claude Code: npm install -g @anthropic-ai/claude-code"
    fi
    if [[ " ${ISSUES[@]} " =~ "Node.js" ]]; then
        echo "• Install Node.js 18+: Visit https://nodejs.org"
    fi
    if [[ " ${ISSUES[@]} " =~ "Git" ]]; then
        echo "• Install Git: sudo apt install git (Ubuntu/Debian)"
    fi
    echo ""
fi

# Show warnings
if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo "⚠️  OPTIONAL IMPROVEMENTS:"
    echo "-------------------------"
    for warning in "${WARNINGS[@]}"; do
        echo "⚠️  $warning"
    done
    echo ""
    
    echo "💡 ENHANCEMENT SUGGESTIONS:"
    echo "---------------------------"
    echo "• Run individual modules to install missing tools"
    echo "• Use: claude 'Help me install the missing Bill Sloth components'"
    echo "• Or manually run: clipboard_mastery_interactive, launcher_mastery_interactive, etc."
    echo ""
fi

# Show adaptive learning status
echo "🧠 ADAPTIVE LEARNING STATUS:"
echo "----------------------------"

if [ -d ~/.bill-sloth ]; then
    LEARNING_FILES=$(find ~/.bill-sloth -name "*.log" -o -name "*.txt" 2>/dev/null | wc -l)
    if [ $LEARNING_FILES -gt 0 ]; then
        echo "✅ Learning system active with $LEARNING_FILES data files"
        
        # Show recent learning activity
        if [ -f ~/.bill-sloth/usage/feedback_simple.log ]; then
            RECENT_FEEDBACK=$(tail -5 ~/.bill-sloth/usage/feedback_simple.log 2>/dev/null | wc -l)
            echo "📊 Recent feedback entries: $RECENT_FEEDBACK"
        fi
        
        if [ -f ~/.bill-sloth/adaptations/pending_adaptations.log ]; then
            PENDING_ADAPTATIONS=$(grep -c "^MODULE:" ~/.bill-sloth/adaptations/pending_adaptations.log 2>/dev/null || echo "0")
            echo "🔄 Pending adaptations: $PENDING_ADAPTATIONS"
        fi
    else
        echo "🌱 Learning system ready (no usage data yet)"
    fi
    
    echo ""
    echo "💡 Try these learning commands:"
    echo "   bill-sloth dashboard     # View learning insights"
    echo "   adapt-modules status     # Check module satisfaction"
else
    echo "🌱 Learning system will initialize on first module use"
fi

echo ""
echo "🎯 NEXT STEPS:"
echo "============="

if [ $HEALTH_PERCENTAGE -ge 75 ]; then
    echo "🚀 Your system is ready! Try these:"
    echo "• Run any module: clipboard_mastery_interactive"
    echo "• Check learning: bill-sloth dashboard"
    echo "• Get help: claude 'Show me what Bill Sloth can do'"
else
    echo "🔧 Fix critical issues first:"
    echo "• Ask Claude: 'Help me fix the Bill Sloth health check issues'"
    echo "• Install missing components shown above"
    echo "• Re-run this health check: ./scripts/health_check.sh"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo "$STATUS_ICON Bill Sloth Health Check Complete ($HEALTH_PERCENTAGE% healthy)"
echo "═══════════════════════════════════════════════════════"