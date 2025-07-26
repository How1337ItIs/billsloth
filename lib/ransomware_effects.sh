#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Ransomware-Inspired Terminal Effects
# Based on documented malware research (educational/aesthetic purposes only)

# Load cyberpunk enhancements
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/cyberpunk_enhancements.sh" 2>/dev/null || true

# Encryption simulation effect (aesthetic only)
simulate_encryption() {
    local file_count="${1:-20}"
    local speed="${2:-0.1}"
    
    echo -e "${CYBER_RED}[SIMULATION] File encryption demo${CYBER_RESET}"
    echo ""
    
    # Fake file paths for demo
    local files=(
        "/home/user/documents"
        "/home/user/photos" 
        "/home/user/videos"
        "/var/log/system.log"
        "/etc/passwd"
        "/home/user/projects"
        "/home/user/downloads"
        "/opt/applications"
        "/usr/share/data"
        "/home/user/.ssh"
        "/home/user/backups"
        "/home/user/music"
        "/tmp/cache"
        "/home/user/desktop"
        "/var/cache/system"
        "/home/user/.config"
        "/usr/local/bin"
        "/home/user/scripts"
        "/var/lib/data"
        "/home/user/.bashrc"
    )
    
    for ((i=0; i<file_count && i<${#files[@]}; i++)); do
        echo -ne "${CYBER_YELLOW}[PROC]${CYBER_RESET} encrypting: ${files[$i]}"
        sleep "$speed"
        echo -e " ${CYBER_GREEN}[DONE]${CYBER_RESET}"
    done
    
    echo ""
    echo -e "${CYBER_RED}[SIMULATION COMPLETE]${CYBER_RESET}"
}

# Progress bar that looks menacing
menacing_progress() {
    local message="$1"
    local duration="${2:-5}"
    local width=50
    
    echo -e "${CYBER_RED}$message${CYBER_RESET}"
    echo ""
    
    for ((i=0; i<=width; i++)); do
        local percent=$((i * 100 / width))
        
        echo -ne "\r${CYBER_RED}["
        printf '%*s' "$i" '' | tr ' ' '█'
        printf '%*s' "$((width - i))" '' | tr ' ' '░'
        echo -ne "] $percent%${CYBER_RESET}"
        
        sleep $(echo "scale=3; $duration / $width" | bc 2>/dev/null || echo "0.1")
    done
    
    echo ""
    echo ""
}

# Skull display function
show_ransomware_skull() {
    local skull_type="${1:-petya}"
    
    case "$skull_type" in
        "petya")
            echo -e "${CYBER_RED}"
            cat << 'EOF'
uu$$$$$$$$$$$uu
uu$$$$$$$$$$$$$$$$$uu
u$$$$$$$$$$$$$$$$$$$$$u
u$$$$$$$$$$$$$$$$$$$$$$$u
u$$$$$$$$$$$$$$$$$$$$$$$$$u
u$$$$$$* *$$$* *$$$$$$u
*$$$$* u$u $$$$*
$$$u u$u u$$$
$$$u u$$$u u$$$
*$$$$uu$$$ $$$uu$$$$*
*$$$$$$$* *$$$$$$$*
u$$$$$$$u$$$$$$$u
u$*$*$*$*$*$*$u
uuu $$u$ $ $ $ $u$$ uuu
u$$$$ $$$$$u$u$u$$$ u$$$$
$$$$$uu *$$$$$$$$$* uu$$$$$$
u$$$$$$$$$$$uu **** uuuu$$$$$$$$$
$$$$***$$$$$$$$$$uuu uu$$$$$$$$$***$$$*
*** **$$$$$$$$$$$uu **$***
uuuu **$$$$$$$$$$uuu
u$$$uuu$$$$$$$$$uu **$$$$$$$$$$$uuu$$$
$$$$$$$$$$*** **$$$$$$$$$$$*
*$$$$$* **$$$$**
$$$* $$$$*
EOF
            echo -e "${CYBER_RESET}"
            ;;
        "compact")
            echo -e "${CYBER_RED}"
            cat << 'EOF'
    ___
   /   \
  | X X |
   \ _ /
    ---
EOF
            echo -e "${CYBER_RESET}"
            ;;
        "terminal")
            echo -e "${CYBER_RED}"
            cat << 'EOF'
  ╔══════════════════════════════════════╗
  ║  SYSTEM COMPROMISED - ACCESS DENIED  ║
  ║                                      ║
  ║              ███████                 ║
  ║            ███     ███               ║
  ║           ███  ███  ███              ║
  ║            ███     ███               ║
  ║              ███████                 ║
  ║                                      ║
  ║        NEURAL LINK TERMINATED        ║
  ╚══════════════════════════════════════╝
EOF
            echo -e "${CYBER_RESET}"
            ;;
    esac
}

# Typewriter effect like ransomware messages
typewriter_effect() {
    local message="$1"
    local speed="${2:-0.05}"
    local color="${3:-$CYBER_GREEN}"
    
    echo -ne "$color"
    for ((i=0; i<${#message}; i++)); do
        echo -n "${message:$i:1}"
        sleep "$speed"
    done
    echo -e "${CYBER_RESET}"
}

# System compromise simulation (purely aesthetic)
system_compromise_demo() {
    clear
    
    # Show skull
    show_ransomware_skull "petya"
    echo ""
    
    # Typewriter messages
    typewriter_effect "SYSTEM NEURAL LINK COMPROMISED" 0.03 "$CYBER_RED"
    echo ""
    typewriter_effect "Sloth protocols have been encrypted..." 0.02 "$CYBER_YELLOW"
    echo ""
    
    # Progress bar
    menacing_progress "Analyzing system vulnerabilities..." 3
    
    # File simulation
    simulate_encryption 10 0.05
    
    echo ""
    typewriter_effect "Just kidding! This is Bill Sloth security training." 0.02 "$CYBER_GREEN"
    echo ""
    echo -e "${CYBER_CYAN}Press Enter to return to safety...${CYBER_RESET}"
    read -r
}

# Glitch text effect for error messages
glitch_error() {
    local message="$1"
    local intensity="${2:-3}"
    
    for ((i=0; i<intensity; i++)); do
        # Random corruption
        local corrupted=$(echo "$message" | sed 's/./&\x1b[5m/g; s/$/\x1b[0m/')
        echo -e "${CYBER_RED}$corrupted${CYBER_RESET}"
        sleep 0.1
        echo -e "\033[2K\r"  # Clear line
    done
    
    # Final clean message
    echo -e "${CYBER_RED}$message${CYBER_RESET}"
}

# Warning banner
show_warning_banner() {
    local title="$1"
    local subtitle="$2"
    
    echo -e "${CYBER_RED}"
    cyber_border 60 "cyber"
    echo ""
    echo -e "    ⚠️  WARNING: $title  ⚠️"
    echo ""
    if [ -n "$subtitle" ]; then
        echo -e "    $subtitle"
        echo ""
    fi
    cyber_border 60 "cyber"
    echo -e "${CYBER_RESET}"
}

# Export functions
export -f simulate_encryption
export -f menacing_progress
export -f show_ransomware_skull
export -f typewriter_effect
export -f system_compromise_demo
export -f glitch_error
export -f show_warning_banner