#!/bin/bash
# Test AI mastery with fixed bridge

export CLAUDE_CODE=test
source lib/claude_interactive_bridge.sh

echo "🧪 TESTING AI MASTERY WITH FIXED BRIDGE"
echo "======================================="
echo ""

echo "Running AI mastery module..."
run_with_claude_bridge modules/ai_mastery_interactive.sh