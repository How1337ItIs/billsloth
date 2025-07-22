#!/bin/bash
# LLM_CAPABILITY: auto
# Automation Mastery Interactive Module v2.0 - Modular Architecture
# "I'm gonna automate everything and become the ultimate efficiency machine!" - Meatwad

# Source the main controller which loads all components
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTROLLER_PATH="$SCRIPT_DIR/automation_mastery/controller.sh"

if [ -f "$CONTROLLER_PATH" ]; then
    source "$CONTROLLER_PATH"
else
    echo "❌ ERROR: Automation mastery components not found!"
    echo "Expected: $CONTROLLER_PATH"
    echo ""
    echo "🔧 To fix this:"
    echo "1. Ensure the automation_mastery/ directory exists"
    echo "2. Run the module decomposition script"
    echo "3. Or use the original automation_mastery_interactive.sh"
    exit 1
fi

# Main entry point - just call the controller
main() {
    automation_main_menu
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi