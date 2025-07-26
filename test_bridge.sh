#!/bin/bash
# Test bridge system functionality

export CLAUDE_CODE=test
source lib/claude_interactive_bridge.sh

echo "🧪 BRIDGE SYSTEM TEST"
echo "===================="
echo ""

echo "1. Testing function availability:"
if command -v run_with_claude_bridge &>/dev/null; then
    echo "✅ run_with_claude_bridge function available"
else
    echo "❌ run_with_claude_bridge function missing"
    exit 1
fi

echo ""
echo "2. Testing Claude execution detection:"
if is_claude_execution; then
    echo "✅ Claude execution detected correctly"
else
    echo "❌ Claude execution detection failed"
    exit 1
fi

echo ""
echo "3. Testing module execution:"
echo "Running productivity suite with bridge..."

# Test with a simple module
if run_with_claude_bridge modules/productivity_suite_interactive.sh 2>&1 | head -10; then
    echo "✅ Module execution completed"
else
    echo "❌ Module execution failed"
fi