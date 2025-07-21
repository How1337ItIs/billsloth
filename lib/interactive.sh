#!/bin/bash
# Interactive Menu Helper Library
# Reduces boilerplate in interactive modules

# Color codes
export RED='\033[31m'
export GREEN='\033[32m'
export YELLOW='\033[33m'
export BLUE='\033[34m'
export PURPLE='\033[35m'
export CYAN='\033[36m'
export WHITE='\033[37m'
export RESET='\033[0m'

# Show a themed banner with ASCII art
show_banner() {
    local title="$1"
    local subtitle="$2"
    local color="$3"
    
    echo -e "${color}"
    case "$title" in
        "GAMING")
            cat << 'BANNER'
    ██████╗  █████╗ ███╗   ███╗███████╗    ██████╗  ██████╗  ██████╗ ███████╗████████╗
    ██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔══██╗██╔═══██╗██╔═══██╗██╔════╝╚══██╔══╝
    ██║  ███╗███████║██╔████╔██║█████╗      ██████╔╝██║   ██║██║   ██║███████╗   ██║   
    ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██╔══██╗██║   ██║██║   ██║╚════██║   ██║   
    ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ██████╔╝╚██████╔╝╚██████╔╝███████║   ██║   
     ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝    ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝   ╚═╝   
BANNER
            ;;
        "PIRATE")
            cat << 'BANNER'
    ██████╗ ██╗██████╗  █████╗ ████████╗███████╗    ██████╗  █████╗ ████████╗ █████╗ 
    ██╔══██╗██║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝    ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
    ██████╔╝██║██████╔╝███████║   ██║   █████╗      ██║  ██║███████║   ██║   ███████║
    ██╔═══╝ ██║██╔══██╗██╔══██║   ██║   ██╔══╝      ██║  ██║██╔══██║   ██║   ██╔══██║
    ██║     ██║██║  ██║██║  ██║   ██║   ███████╗    ██████╔╝██║  ██║   ██║   ██║  ██║
    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
BANNER
            ;;
        "AI")
            cat << 'BANNER'
     █████╗ ██╗    ██████╗ ██╗      █████╗ ██╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗ 
    ██╔══██╗██║    ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝ ██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗
    ███████║██║    ██████╔╝██║     ███████║ ╚████╔╝ ██║  ███╗██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║
    ██╔══██║██║    ██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██║   ██║██╔══██╗██║   ██║██║   ██║██║╚██╗██║██║  ██║
    ██║  ██║██║    ██║     ███████╗██║  ██║   ██║   ╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝
    ╚═╝  ╚═╝╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ 
BANNER
            ;;
        "PRODUCTIVITY")
            cat << 'BANNER'
    ██████╗ ██████╗  ██████╗ ██████╗ ██╗   ██╗ ██████╗████████╗██╗██╗   ██╗██╗████████╗██╗   ██╗
    ██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██║   ██║██╔════╝╚══██╔══╝██║██║   ██║██║╚══██╔══╝╚██╗ ██╔╝
    ██████╔╝██████╔╝██║   ██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██║   ██║    ╚████╔╝ 
    ██╔═══╝ ██╔══██╗██║   ██║██║  ██║██║   ██║██║        ██║   ██║╚██╗ ██╔╝██║   ██║     ╚██╔╝  
    ██║     ██║  ██║╚██████╔╝██████╔╝╚██████╔╝╚██████╗   ██║   ██║ ╚████╔╝ ██║   ██║      ██║   
    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝  ╚═════╝   ╚═╝   ╚═╝  ╚═══╝  ╚═╝   ╚═╝      ╚═╝   
BANNER
            ;;
        *)
            echo "    $title"
            echo "    $(echo "$title" | sed 's/./#/g')"
            ;;
    esac
    echo -e "${RESET}"
    echo ""
    if [ -n "$subtitle" ]; then
        echo "$subtitle"
        echo ""
    fi
}

# Prompt for user choice with validation
prompt_choice() {
    local prompt="$1"
    local valid_choices="$2"
    local choice
    
    while true; do
        read -p "$prompt" choice
        if [[ "$valid_choices" == *"$choice"* ]] || [[ "$choice" == "other" ]] || [[ "$choice" == "Other" ]] || [[ "$choice" == "OTHER" ]]; then
            echo "$choice"
            return 0
        else
            echo "❌ Invalid choice. Please try again."
        fi
    done
}

# Log user choice with timestamp
log_choice() {
    local module="$1"
    local choice="$2" 
    local description="$3"
    local log_file="$HOME/${module}/assistant.log"
    
    mkdir -p "$(dirname "$log_file")"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Bill chose: $choice - $description" >> "$log_file"
}

# Show completion message
show_completion() {
    local action="$1"
    local next_steps="$2"
    
    echo ""
    echo "✅ $action completed!"
    if [ -n "$next_steps" ]; then
        echo "📋 Next steps:"
        echo "$next_steps"
    fi
    echo ""
    echo "🔄 You can always re-run this assistant to try different tools!"
}

# Export functions for use in modules
export -f show_banner prompt_choice log_choice show_completion