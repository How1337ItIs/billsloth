#!/bin/bash
# Test all critical modules with bridge system

export CLAUDE_CODE=test
source lib/claude_interactive_bridge.sh

echo "🧪 TESTING ALL CRITICAL MODULES"
echo "==============================="
echo ""

modules=(
    "productivity_suite_interactive"
    "ai_mastery_interactive" 
    "gaming_boost_interactive"
    "privacy_tools_interactive"
    "system_ops_interactive"
    "data_hoarding_interactive"
    "creative_coding_interactive"
    "file_mastery_interactive"
)

passed=0
failed=0

for module in "${modules[@]}"; do
    echo "Testing $module..."
    
    if run_with_claude_bridge "modules/$module.sh" >/dev/null 2>&1; then
        echo "✅ $module - PASS"
        ((passed++))
    else
        echo "❌ $module - FAIL"
        ((failed++))
    fi
done

echo ""
echo "📊 RESULTS:"
echo "✅ Passed: $passed"
echo "❌ Failed: $failed"
echo "📈 Success Rate: $((passed * 100 / (passed + failed)))%"

if [[ $failed -eq 0 ]]; then
    echo "🎉 ALL MODULES WORKING WITH BRIDGE SYSTEM!"
else
    echo "⚠️  Some modules need fixes"
fi