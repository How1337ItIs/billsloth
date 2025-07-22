#!/bin/bash
# LLM_CAPABILITY: auto
# EdBoiGames Business Toolkit v2 - Modular Edition
# "Time to get rad and make some moolah!" - Carl Brutananadilewski

# Source libraries and components
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/interactive.sh" 2>/dev/null || {
    echo "🎮 EDBOIGAMES BUSINESS TOOLKIT"
    echo "============================="
}

source "$SCRIPT_DIR/../lib/adaptive_learning.sh" 2>/dev/null || {
    echo "⚠️  Adaptive learning not available - using default content"
}

# Load all components
source "$SCRIPT_DIR/edboigames/controller.sh" 2>/dev/null || {
    echo "❌ ERROR: Could not load EdBoiGames components"
    echo "Expected components in: $SCRIPT_DIR/edboigames/"
    exit 1
}

# Main execution - delegate to controller
main() {
    main_menu "$@"
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi