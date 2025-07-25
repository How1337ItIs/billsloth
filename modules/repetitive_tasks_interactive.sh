#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: DEPRECATED - Redirects to automation_mastery_interactive.sh
# CLAUDE_PROMPTS: Redirect notification
# CLAUDE_DEPENDENCIES: none (deprecated module)
# DEPRECATED: This module has been replaced by automation_mastery_interactive.sh
# Redirecting to the new comprehensive automation module

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

echo "🔁 TASK AUTOMATION - REDIRECTING TO ENHANCED MODULE"
echo "================================================"
echo ""
echo "🚀 This module has been upgraded!"
echo "You're being redirected to the new comprehensive automation mastery module."
echo ""
echo "🎆 NEW FEATURES:"
echo "• Comprehensive education about automation platforms"
echo "• Personal workflow assessment"
echo "• Zapier, IFTTT, and Node-RED setup guides"
echo "• Home Assistant integration concepts"
echo "• ATHF personality and ADHD-friendly design"
echo ""
echo "Launching automation_mastery_interactive.sh..."
echo ""

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Launch the new automation mastery module
exec "$SCRIPT_DIR/automation_mastery_interactive.sh"