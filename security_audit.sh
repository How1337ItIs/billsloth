#!/bin/bash
# LLM_CAPABILITY: local_ok
# Security Audit Script for Bill Sloth System
# Comprehensive security testing and validation

# Load safety mechanisms
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/safety_mechanisms.sh" 2>/dev/null || {
    echo "⚠️  Safety mechanisms not available"
    exit 1
}

enable_safe_mode "security_audit"

echo "🔐 BILL SLOTH SECURITY AUDIT"
echo "============================="
echo ""

# Track issues found
SECURITY_ISSUES=0
WARNINGS=0

# Test 1: Bridge System Safety
echo "🧪 Testing Bridge System Safety..."
if source "$SCRIPT_DIR/lib/claude_interactive_bridge.sh" 2>/dev/null; then
    echo "  ✅ Bridge system loads without errors"
    
    # Test safe execution detection
    if command -v is_claude_execution &>/dev/null; then
        echo "  ✅ Claude execution detection available"
        
        # Test with different contexts
        export CLAUDE_CODE="test"
        if is_claude_execution; then
            echo "  ✅ Correctly detects Claude Code environment"
        else
            echo "  ❌ Failed to detect Claude Code environment"
            ((SECURITY_ISSUES++))
        fi
        unset CLAUDE_CODE
        
        # Test default behavior (should default to human)
        if ! is_claude_execution; then
            echo "  ✅ Correctly defaults to human interaction"
        else
            echo "  ⚠️  May incorrectly detect AI execution" 
            ((WARNINGS++))
        fi
    else
        echo "  ❌ Claude execution detection function missing"
        ((SECURITY_ISSUES++))
    fi
else
    echo "  ❌ Bridge system failed to load"
    ((SECURITY_ISSUES++))
fi

echo ""

# Test 2: Input Validation
echo "🧪 Testing Input Validation..."
if source "$SCRIPT_DIR/lib/input_validation.sh" 2>/dev/null; then
    echo "  ✅ Input validation library loads"
    
    if command -v safe_read &>/dev/null; then
        echo "  ✅ Safe read function available"
        
        # Test input length validation (simulated)
        if command -v validate_menu_choice &>/dev/null; then
            echo "  ✅ Menu choice validation available"
            
            # Test valid choices
            if validate_menu_choice "1" "0-9"; then
                echo "  ✅ Valid menu choice accepted"
            else
                echo "  ❌ Valid menu choice rejected"
                ((SECURITY_ISSUES++))
            fi
            
            # Test invalid choices
            if ! validate_menu_choice "99" "0-9"; then
                echo "  ✅ Invalid menu choice rejected"
            else
                echo "  ❌ Invalid menu choice accepted"
                ((SECURITY_ISSUES++))
            fi
        else
            echo "  ❌ Menu choice validation missing"
            ((SECURITY_ISSUES++))
        fi
    else
        echo "  ❌ Safe read function missing"
        ((SECURITY_ISSUES++))
    fi
else
    echo "  ❌ Input validation library failed to load"
    ((SECURITY_ISSUES++))
fi

echo ""

# Test 3: Path Sanitization
echo "🧪 Testing Path Sanitization..."
if command -v sanitize_path &>/dev/null; then
    echo "  ✅ Path sanitization function available"
    
    # Test safe path
    if sanitized=$(sanitize_path "$HOME/test" "$HOME" 2>/dev/null); then
        echo "  ✅ Safe path accepted: $sanitized"
    else
        echo "  ⚠️  Safe path handling may be too restrictive"
        ((WARNINGS++))
    fi
    
    # Test dangerous path (should fail)
    if ! sanitize_path "../../../etc/passwd" "$HOME" 2>/dev/null; then
        echo "  ✅ Dangerous path rejected"
    else
        echo "  ❌ CRITICAL: Dangerous path accepted"
        ((SECURITY_ISSUES++))
    fi
else
    echo "  ❌ Path sanitization not available"
    ((SECURITY_ISSUES++))
fi

echo ""

# Test 4: Command Validation
echo "🧪 Testing Command Validation..."
if command -v validate_command &>/dev/null; then
    echo "  ✅ Command validation function available"
    
    # Test safe command
    if validate_command "bash script.sh" "bash,sh,python3" 2>/dev/null; then
        echo "  ✅ Safe command accepted"
    else
        echo "  ⚠️  Safe command rejected - may be too restrictive"
        ((WARNINGS++))
    fi
    
    # Test dangerous command
    if ! validate_command "rm -rf /" "bash,sh,python3" 2>/dev/null; then
        echo "  ✅ Dangerous command rejected"
    else
        echo "  ❌ CRITICAL: Dangerous command accepted"
        ((SECURITY_ISSUES++))
    fi
else
    echo "  ❌ Command validation not available"
    ((SECURITY_ISSUES++))
fi

echo ""

# Test 5: File Permissions
echo "🧪 Testing File Permissions..."
CRITICAL_FILES=(
    "$SCRIPT_DIR/lib/claude_interactive_bridge.sh"
    "$SCRIPT_DIR/lib/universal_interactive_bridge.sh"
    "$SCRIPT_DIR/lib/input_validation.sh"
    "$SCRIPT_DIR/lib/safety_mechanisms.sh"
    "$SCRIPT_DIR/bill_command_center.sh"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        perms=$(stat -c %a "$file" 2>/dev/null || echo "unknown")
        if [[ "$perms" == "755" ]] || [[ "$perms" == "644" ]]; then
            echo "  ✅ $(basename "$file"): Safe permissions ($perms)"
        else
            echo "  ⚠️  $(basename "$file"): Unusual permissions ($perms)"
            ((WARNINGS++))
        fi
    else
        echo "  ❌ Missing critical file: $(basename "$file")"
        ((SECURITY_ISSUES++))
    fi
done

echo ""

# Test 6: Environment Variable Safety
echo "🧪 Testing Environment Variable Safety..."
DANGEROUS_VARS=("LD_PRELOAD" "LD_LIBRARY_PATH" "PATH")

for var in "${DANGEROUS_VARS[@]}"; do
    if [[ -n "${!var:-}" ]]; then
        echo "  ⚠️  $var is set: ${!var}"
        ((WARNINGS++))
    else
        echo "  ✅ $var is not set"
    fi
done

echo ""

# Test 7: System Health Check
echo "🧪 Running System Health Check..."
if command -v system_health_check &>/dev/null; then
    if system_health_check; then
        echo "  ✅ System health check passed"
    else
        echo "  ⚠️  System health check found issues"
        ((WARNINGS++))
    fi
else
    echo "  ❌ System health check not available"
    ((SECURITY_ISSUES++))
fi

echo ""

# Final Assessment
echo "🏁 SECURITY AUDIT RESULTS"
echo "========================="
echo ""

if [[ $SECURITY_ISSUES -eq 0 ]]; then
    echo "✅ No critical security issues found"
else
    echo "❌ CRITICAL: $SECURITY_ISSUES security issues found"
fi

if [[ $WARNINGS -eq 0 ]]; then
    echo "✅ No warnings"
else
    echo "⚠️  $WARNINGS warnings found"
fi

echo ""

# Deployment recommendation
if [[ $SECURITY_ISSUES -eq 0 ]]; then
    if [[ $WARNINGS -le 2 ]]; then
        echo "🚀 RECOMMENDATION: SAFE FOR DEPLOYMENT"
        echo "The system has passed security audit with minimal warnings."
    else
        echo "⚠️  RECOMMENDATION: CAUTION - REVIEW WARNINGS"
        echo "The system is mostly secure but has several warnings to review."
    fi
else
    echo "🛑 RECOMMENDATION: NOT SAFE FOR DEPLOYMENT"
    echo "Critical security issues must be resolved before deployment."
fi

# Return appropriate exit code
if [[ $SECURITY_ISSUES -eq 0 ]]; then
    exit 0
else
    exit 1
fi