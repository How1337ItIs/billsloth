#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Aesthetic Functions Library
# Standardized visual elements for consistent ADHD-friendly design

# Existing color scheme (based on codebase analysis)
BRIGHT_RED='\033[38;5;196m'
BRIGHT_GREEN='\033[38;5;46m' 
BRIGHT_CYAN='\033[38;5;51m'
BRIGHT_YELLOW='\033[38;5;226m'
BRIGHT_MAGENTA='\033[38;5;129m'
MATRIX_GREEN='\033[32m'
RESET='\033[0m'

# Standard ASCII art elements found in codebase
ASCII_BORDER_CHAR="═"
ASCII_CORNER_TL="╔"
ASCII_CORNER_TR="╗"
ASCII_CORNER_BL="╚"
ASCII_CORNER_BR="╝"
ASCII_VERTICAL="║"
ASCII_BLOCK="█"
ASCII_SHADE="░"

# Banner width (standardized from existing banners)
BANNER_WIDTH=80

show_bill_sloth_banner() {
    echo -e "${BRIGHT_RED}"
    cat << 'EOF'
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░   ██████╗ ██╗██╗     ██╗         ███████╗██╗      ██████╗ ████████╗██╗  ██╗ ░
░   ██╔══██╗██║██║     ██║         ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║ ░
░   ██████╔╝██║██║     ██║         ███████╗██║     ██║   ██║   ██║   ███████║ ░
░   ██╔══██╗██║██║     ██║         ╚════██║██║     ██║   ██║   ██║   ██╔══██║ ░
░   ██████╔╝██║███████╗███████╗    ███████║███████╗╚██████╔╝   ██║   ██║  ██║ ░
░   ╚═════╝ ╚═╝╚══════╝╚══════╝    ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝ ░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
EOF
    echo -e "${RESET}"
}

show_ascii_sloth() {
    echo -e "${BRIGHT_GREEN}"
    cat << 'EOF'
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⠿⠿⠿⠻⠿⢿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡿⠟⠉⠈⠉⠉⠄⢠⠄⠄⢀⠄⠄⡬⠛⢿⢿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⡿⡿⠉⠄⠄⠄⠄⠄⠄⠅⠄⠅⠄⠐⠄⠄⠄⠁⠤⠄⠛⢿⢿⣿⣿⣿⣿
⣿⣿⣿⠍⠄⠄⠄⠄⠄⠄⠄⠄⣀⣀⠄⣀⣠⣀⠄⢈⣑⣢⣤⡄⠔⠫⢻⣿⣿⣿
⣿⡏⠂⠄⠄⢀⣠⣤⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣔⠂⡙⣿⣿
⡿⠄⠄⣠⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣈⣿
⠇⠄⢠⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠿⠿⢿⡿⣿⣿⣿⣿⣿⡧⣼
⠄⠄⠽⠿⠟⠋⠁⠙⠄⢠⣿⡿⢿⣿⣿⣿⣿⣿⣷⡠⢌⣧⠄⠈⠛⠉⠛⠐⡋⢹
⠄⠄⠄⠄⠄⠄⠄⢀⣠⣾⡿⠑⠚⠋⠛⠛⠻⢿⣿⣿⣶⣤⡄⢀⣀⣀⡀⠈⠄⢸
⣄⠄⠄⠄⢰⣾⠟⠋⠛⠛⠂⠄⠄⠄⠄⠒⠂⠛⡿⢟⠻⠃⠄⢼⣿⣿⣷⠤⠁⢸
⣿⡄⠄⢀⢝⢓⠄⠄⠄⠄⠄⠄⠄⠄⠠⠠⠶⢺⣿⣯⣵⣦⣴⣿⣿⣿⣿⡏⠄⢸
⣿⣿⡀⠄⠈⠄⠄⠄⠠⢾⣷⣄⢄⣀⡈⡀⠠⣾⣿⣿⣿⣿⣿⣿⣿⡿⠿⢏⣀⣾
⣿⣿⣷⣄⠄⠄⠄⢀⠈⠈⠙⠑⠗⠙⠙⠛⠄⠈⠹⠻⢿⡻⣿⠿⢿⣝⡑⢫⣾⣿
⣿⣿⣿⣿⣿⣆⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠑⠐⠚⣨⣤⣾⣿⣿
EOF
    echo -e "${RESET}"
}

show_module_banner() {
    local title="$1"
    local subtitle="${2:-}"
    local emoji="${3:-🚀}"
    
    echo -e "${BRIGHT_CYAN}"
    printf "${ASCII_CORNER_TL}"
    printf "${ASCII_BORDER_CHAR}%.0s" $(seq 1 $((BANNER_WIDTH-2)))
    printf "${ASCII_CORNER_TR}\n"
    
    local title_text="$emoji $title $emoji"
    local padding=$(((BANNER_WIDTH - ${#title_text}) / 2))
    printf "${ASCII_VERTICAL}%*s%s%*s${ASCII_VERTICAL}\n" $padding "" "$title_text" $padding ""
    
    if [ -n "$subtitle" ]; then
        local sub_padding=$(((BANNER_WIDTH - ${#subtitle}) / 2))
        printf "${ASCII_VERTICAL}%*s%s%*s${ASCII_VERTICAL}\n" $sub_padding "" "$subtitle" $sub_padding ""
    fi
    
    printf "${ASCII_CORNER_BL}"
    printf "${ASCII_BORDER_CHAR}%.0s" $(seq 1 $((BANNER_WIDTH-2)))
    printf "${ASCII_CORNER_BR}\n"
    echo -e "${RESET}"
}

show_pirate_banner() {
    local title="$1"
    
    echo -e "${BRIGHT_YELLOW}"
    cat << 'EOF'
🏴‍☠️ ═══════════════════════════════════════════════════════════ 🏴‍☠️
   ██████╗ ██╗██████╗  █████╗ ████████╗███████╗    ██████╗  █████╗ ████████╗ █████╗ 
   ██╔══██╗██║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝    ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
   ██████╔╝██║██████╔╝███████║   ██║   █████╗      ██║  ██║███████║   ██║   ███████║
   ██╔═══╝ ██║██╔══██╗██╔══██║   ██║   ██╔══╝      ██║  ██║██╔══██║   ██║   ██╔══██║
   ██║     ██║██║  ██║██║  ██║   ██║   ███████╗    ██████╔╝██║  ██║   ██║   ██║  ██║
   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
🏴‍☠️ ═══════════════════════════════════════════════════════════ 🏴‍☠️
EOF
    echo -e "${BRIGHT_CYAN}                           $title"
    echo "⚓ Ahoy! Time to hoard some digital treasure! ⚓"
    echo -e "${RESET}"
}

show_gaming_banner() {
    local title="$1"
    
    echo -e "${BRIGHT_MAGENTA}"
    cat << 'EOF'
🎮 ═══════════════════════════════════════════════════════════ 🎮
   ██████╗  █████╗ ███╗   ███╗██╗███╗   ██╗ ██████╗ 
   ██╔════╝ ██╔══██╗████╗ ████║██║████╗  ██║██╔════╝ 
   ██║  ███╗███████║██╔████╔██║██║██╔██╗ ██║██║  ███╗
   ██║   ██║██╔══██║██║╚██╔╝██║██║██║╚██╗██║██║   ██║
   ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝
    ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
🎮 ═══════════════════════════════════════════════════════════ 🎮
EOF
    echo -e "${BRIGHT_CYAN}                           $title"
    echo "🕹️ Level up your gaming experience! 🕹️"
    echo -e "${RESET}"
}

show_loading_bar() {
    local current="$1"
    local total="$2"
    local message="${3:-Processing}"
    
    local percent=$((current * 100 / total))
    local filled=$((percent / 2))
    local empty=$((50 - filled))
    
    printf "\r${BRIGHT_CYAN}$message [${BRIGHT_GREEN}"
    printf "${ASCII_BLOCK}%.0s" $(seq 1 $filled)
    printf "${RESET}${ASCII_SHADE}%.0s" $(seq 1 $empty)
    printf "${BRIGHT_CYAN}] ${percent}%%${RESET}"
    
    if [ $current -eq $total ]; then
        echo ""
    fi
}

show_success() {
    local message="$1"
    echo -e "${BRIGHT_GREEN}✅ $message${RESET}"
}

show_warning() {
    local message="$1"
    echo -e "${BRIGHT_YELLOW}⚠️  $message${RESET}"
}

show_error() {
    local message="$1"
    echo -e "${BRIGHT_RED}❌ $message${RESET}"
}

show_info() {
    local message="$1"
    echo -e "${BRIGHT_CYAN}ℹ️  $message${RESET}"
}

show_celebration() {
    echo -e "${BRIGHT_GREEN}"
    cat << 'EOF'
    🎉 ═══════════════════════════════════════════════════════════ 🎉
       ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗
       ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝
       ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗
       ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║
       ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║
       ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝
    🎉 ═══════════════════════════════════════════════════════════ 🎉
EOF
    echo -e "${RESET}"
    
    # Show the ASCII sloth for extra celebration
    show_ascii_sloth
    echo -e "${BRIGHT_CYAN}🦥 Bill Sloth celebrates your success! 🦥${RESET}"
}

show_thinking() {
    local message="${1:-Thinking}"
    echo -e "${BRIGHT_MAGENTA}🤖 $message...${RESET}"
}

pause_for_adhd() {
    local message="${1:-Press any key to continue}"
    echo -e "${BRIGHT_YELLOW}⏸️  $message${RESET}"
    read -n 1 -s
    echo ""
}

show_menu_option() {
    local number="$1"
    local emoji="$2"
    local title="$3"
    local description="$4"
    
    echo -e "${BRIGHT_CYAN}$number) $emoji ${BRIGHT_GREEN}$title${RESET}"
    if [ -n "$description" ]; then
        echo -e "   ${description}"
    fi
}

show_section_header() {
    local title="$1"
    local emoji="${2:-📋}"
    
    echo ""
    echo -e "${BRIGHT_CYAN}$emoji $(echo "$title" | tr '[:lower:]' '[:upper:]')${RESET}"
    printf "${BRIGHT_CYAN}${ASCII_BORDER_CHAR}%.0s${RESET}" $(seq 1 ${#title})
    echo "═══════════"
}

show_matrix_effect() {
    local lines="${1:-10}"
    local delay="${2:-0.1}"
    
    for i in $(seq 1 $lines); do
        echo -e "${MATRIX_GREEN}$(head /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*()' | head -c 80)${RESET}"
        sleep $delay
    done
}

show_typing_effect() {
    local text="$1"
    local delay="${2:-0.05}"
    local color="${3:-$BRIGHT_GREEN}"
    
    echo -n -e "$color"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo -e "${RESET}"
}

show_countdown() {
    local seconds="$1"
    local message="${2:-Starting in}"
    
    for (( i=seconds; i>0; i-- )); do
        printf "\r${BRIGHT_YELLOW}$message $i...${RESET}"
        sleep 1
    done
    printf "\r${BRIGHT_GREEN}$message NOW!${RESET}\n"
}

# Export all functions for use in other scripts
export -f show_bill_sloth_banner
export -f show_ascii_sloth
export -f show_module_banner
export -f show_pirate_banner
export -f show_gaming_banner
export -f show_loading_bar
export -f show_success
export -f show_warning
export -f show_error
export -f show_info
export -f show_celebration
export -f show_thinking
export -f pause_for_adhd
export -f show_menu_option
export -f show_section_header
export -f show_matrix_effect
export -f show_typing_effect
export -f show_countdown