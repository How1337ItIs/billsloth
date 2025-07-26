#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Cyberpunk Enhancements
# Legitimate h4xx0r aesthetics without fake content

# Cyberpunk color schemes using standard ANSI
export CYBER_GREEN='\033[38;5;46m'      # Matrix green
export CYBER_PURPLE='\033[38;5;201m'    # Cyberpunk purple  
export CYBER_CYAN='\033[38;5;51m'       # Neon cyan
export CYBER_RED='\033[38;5;196m'       # Danger red
export CYBER_YELLOW='\033[38;5;226m'    # Warning yellow
export CYBER_ORANGE='\033[38;5;208m'    # Status orange
export CYBER_RESET='\033[0m'            # Reset

# Terminal effects using existing standards
glitch_text() {
    local text="$1"
    local glitch_chance="${2:-10}"
    
    # Add occasional ANSI escape "glitches" for cyberpunk effect
    echo -n "$text" | while IFS= read -r -n1 char; do
        if [ $((RANDOM % 100)) -lt "$glitch_chance" ]; then
            echo -ne "\033[5m$char\033[0m"  # Blink effect
        else
            echo -n "$char"
        fi
    done
    echo
}

# Matrix-style character sets (legitimate Unicode)
matrix_chars() {
    # Real Japanese Katakana used in Matrix (not fake)
    echo "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ"
}

# Cyberpunk status indicators
cyber_status() {
    local status="$1"
    case "$status" in
        "online")
            echo -e "${CYBER_GREEN}[ONLINE]${CYBER_RESET}"
            ;;
        "loading")
            echo -e "${CYBER_YELLOW}[PROC]${CYBER_RESET}"
            ;;
        "error")
            echo -e "${CYBER_RED}[ERR]${CYBER_RESET}"
            ;;
        "success")
            echo -e "${CYBER_GREEN}[OK]${CYBER_RESET}"
            ;;
        "warning")
            echo -e "${CYBER_ORANGE}[WARN]${CYBER_RESET}"
            ;;
        *)
            echo -e "${CYBER_CYAN}[SYS]${CYBER_RESET}"
            ;;
    esac
}

# H4xx0r-style text processing
l33t_filter() {
    local text="$1"
    local intensity="${2:-light}"
    
    case "$intensity" in
        "light")
            # Minimal l33t speak
            echo "$text" | sed 's/e/3/g; s/a/4/g; s/o/0/g'
            ;;
        "medium")
            # More l33t speak
            echo "$text" | sed 's/e/3/g; s/a/4/g; s/o/0/g; s/i/1/g; s/s/5/g'
            ;;
        "heavy")
            # Full l33t speak
            echo "$text" | sed 's/e/3/g; s/a/4/g; s/o/0/g; s/i/1/g; s/s/5/g; s/t/7/g; s/l/1/g'
            ;;
    esac
}

# Cyberpunk border generators
cyber_border() {
    local width="${1:-60}"
    local style="${2:-solid}"
    
    case "$style" in
        "solid")
            printf '%*s\n' "$width" '' | tr ' ' '='
            ;;
        "dashed")
            printf '%*s\n' "$width" '' | tr ' ' '-'
            ;;
        "double")
            printf '%*s\n' "$width" '' | tr ' ' '━'
            ;;
        "cyber")
            # Mix of characters for cyberpunk aesthetic
            local chars="=━─-"
            for ((i=0; i<width; i++)); do
                echo -n "${chars:$((RANDOM % ${#chars})):1}"
            done
            echo
            ;;
    esac
}

# Terminal-safe progress indicators
cyber_progress() {
    local current="$1"
    local total="$2"
    local width="${3:-40}"
    
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    echo -ne "${CYBER_CYAN}["
    printf '%*s' "$filled" '' | tr ' ' '█'
    printf '%*s' "$empty" '' | tr ' ' '░'
    local percent=$((current * 100 / total))
    echo -e "] ${percent}%${CYBER_RESET}"
}

# Legitimate hacker-style timestamp
hack_timestamp() {
    echo -n "$(date '+[%Y.%m.%d_%H:%M:%S]')"
}

# System info in cyberpunk style
cyber_sysinfo() {
    echo -e "${CYBER_PURPLE}╔════════════════════════════════════════╗${CYBER_RESET}"
    echo -e "${CYBER_PURPLE}║           SYSTEM INTERFACE             ║${CYBER_RESET}"
    echo -e "${CYBER_PURPLE}╠════════════════════════════════════════╣${CYBER_RESET}"
    echo -e "${CYBER_PURPLE}║${CYBER_RESET} USER: ${CYBER_GREEN}$(whoami)${CYBER_RESET}$(printf "%*s" $((31 - ${#USER})) '')${CYBER_PURPLE}║${CYBER_RESET}"
    echo -e "${CYBER_PURPLE}║${CYBER_RESET} HOST: ${CYBER_CYAN}$(hostname)${CYBER_RESET}$(printf "%*s" $((31 - $(hostname | wc -c) + 1)) '')${CYBER_PURPLE}║${CYBER_RESET}"
    echo -e "${CYBER_PURPLE}║${CYBER_RESET} TIME: ${CYBER_YELLOW}$(date '+%H:%M:%S')${CYBER_RESET}$(printf "%*s" 23 '')${CYBER_PURPLE}║${CYBER_RESET}"
    echo -e "${CYBER_PURPLE}╚════════════════════════════════════════╝${CYBER_RESET}"
}

# Enhanced prompt styling
cyber_prompt() {
    local user_color="${CYBER_GREEN}"
    local host_color="${CYBER_CYAN}"
    local path_color="${CYBER_YELLOW}"
    
    echo -e "${user_color}$(whoami)${CYBER_RESET}@${host_color}$(hostname)${CYBER_RESET}:${path_color}$(pwd)${CYBER_RESET}$ "
}

# Export functions
export -f glitch_text
export -f matrix_chars
export -f cyber_status
export -f l33t_filter
export -f cyber_border
export -f cyber_progress
export -f hack_timestamp
export -f cyber_sysinfo
export -f cyber_prompt