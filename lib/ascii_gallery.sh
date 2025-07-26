#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth ASCII Art Gallery
# Display collection of legitimate ASCII art for maximum terminal coolness

# Load cyberpunk enhancements
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/cyberpunk_enhancements.sh" 2>/dev/null || true

# ASCII art collection paths
ASCII_DIR="$SCRIPT_DIR/../assets/ascii_art"
SLOTH_COLLECTION="$ASCII_DIR/sloth_collection.txt"
HARDCORE_COLLECTION="$ASCII_DIR/hardcore_collection.txt"
RANSOMWARE_COLLECTION="$ASCII_DIR/ransomware_collection.txt"
CYBERPUNK_SKULLS="$ASCII_DIR/cyberpunk_skulls.txt"

# Display sloth hanging from banner
show_sloth_banner() {
    local message="${1:-BILL SLOTH COMMAND CENTER}"
    
    echo -e "${CYBER_GREEN}"
    cat << EOF
 ┌─────────────────────────────────────────────────────────┐
 │                                                         │
 │    (\\_/)      $message
 │   ( ^.^ )     Where slow and steady wins the race      │
 │  o_(\"|(\")                                             │
 │     | |       "Maximum efficiency through minimal      │
 │     | |        effort" - The Sloth Way                 │
 │                                                         │
 └─────────────────────────────────────────────────────────┘
EOF
    echo -e "${CYBER_RESET}"
}

# Random sloth display
random_sloth() {
    if [ ! -f "$SLOTH_COLLECTION" ]; then
        # Fallback if file doesn't exist
        echo -e "${CYBER_GREEN}"
        echo "    (\\_/)"
        echo "   ( ^.^ )"
        echo "  o_(\"|(\")  <-- Bill Sloth"
        echo -e "${CYBER_RESET}"
        return
    fi
    
    # Extract a random sloth from collection
    local sloth_count=$(grep -c "^# " "$SLOTH_COLLECTION")
    local random_num=$((RANDOM % sloth_count + 1))
    
    echo -e "${CYBER_GREEN}"
    # Get the nth sloth section
    awk -v n="$random_num" '
        /^# / { count++ }
        count == n && !/^#/ && !/^$/ { print }
        count > n { exit }
    ' "$SLOTH_COLLECTION"
    echo -e "${CYBER_RESET}"
}

# Cyberpunk skull display
show_cyber_skull() {
    local skull_type="${1:-random}"
    
    if [ ! -f "$CYBERPUNK_SKULLS" ]; then
        echo -e "${CYBER_RED}[ASCII] Skull collection not found${CYBER_RESET}"
        return
    fi
    
    echo -e "${CYBER_RED}"
    
    case "$skull_type" in
        "petya")
            # Show Petya skull specifically
            awk '/^# SKULL_LARGE/,/^$/' "$CYBERPUNK_SKULLS" | grep -v "^#" | head -25
            ;;
        "compact")
            # Show compact skull
            awk '/^# SKULL_COMPACT/,/^$/' "$CYBERPUNK_SKULLS" | grep -v "^#"
            ;;
        "random"|*)
            # Show random skull
            local skull_sections=($(grep "^# SKULL" "$CYBERPUNK_SKULLS" | wc -l))
            local random_skull=$((RANDOM % 2 + 1))
            if [ "$random_skull" -eq 1 ]; then
                awk '/^# SKULL_LARGE/,/^$/' "$CYBERPUNK_SKULLS" | grep -v "^#" | head -25
            else
                awk '/^# SKULL_COMPACT/,/^$/' "$CYBERPUNK_SKULLS" | grep -v "^#"
            fi
            ;;
    esac
    
    echo -e "${CYBER_RESET}"
}

# Display hardcore cyberpunk art
show_hardcore_art() {
    local art_type="${1:-random}"
    
    if [ ! -f "$HARDCORE_COLLECTION" ]; then
        echo -e "${CYBER_RED}[ASCII] Hardcore collection not found${CYBER_RESET}"
        return
    fi
    
    echo -e "${CYBER_PURPLE}"
    
    case "$art_type" in
        "cyberpunk")
            awk '/^# CYBERPUNK FIGURE/,/^# /' "$HARDCORE_COLLECTION" | grep -v "^#" | head -50
            ;;
        "demon")
            awk '/^# MENACING DEMON FACE/,/^$/' "$HARDCORE_COLLECTION" | grep -v "^#"
            ;;
        "terminal")
            awk '/^# HACKER TERMINAL DEATH/,/^# /' "$HARDCORE_COLLECTION" | grep -v "^#" | head -20
            ;;
        "warning")
            awk '/^# TERMINAL WARNING SKULL/,/^# /' "$HARDCORE_COLLECTION" | grep -v "^#" | head -20
            ;;
        "hacker")
            awk '/^# HACKER SIGNATURE/,/^$/' "$HARDCORE_COLLECTION" | grep -v "^#"
            ;;
        *)
            # Random hardcore art
            local art_types=("cyberpunk" "demon" "terminal" "warning" "hacker")
            local random_type=${art_types[$((RANDOM % ${#art_types[@]}))]}
            show_hardcore_art "$random_type"
            ;;
    esac
    
    echo -e "${CYBER_RESET}"
}

# Ransomware-style warning (aesthetic only)
show_ransomware_warning() {
    local title="${1:-NEURAL LINK COMPROMISED}"
    local subtitle="${2:-This is a simulation for educational purposes}"
    
    echo -e "${CYBER_RED}"
    if [ -f "$RANSOMWARE_COLLECTION" ]; then
        # Show Petya skull
        awk '/^# PETYA SKULL/,/^# /' "$RANSOMWARE_COLLECTION" | grep -v "^#" | head -25
    fi
    
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║  ⚠️  $title ⚠️  "
    echo "║                                                            ║"
    echo "║  $subtitle"
    echo "║                                                            ║"
    echo "║  Your files have been... just kidding! This is Bill Sloth ║"
    echo "║  security awareness training. Stay vigilant, broadbrain!   ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${CYBER_RESET}"
}

# ASCII art gallery browser
ascii_gallery() {
    while true; do
        clear
        echo -e "${CYBER_CYAN}"
        echo "╔══════════════════════════════════════════════════════════╗"
        echo "║                 BILL SLOTH ASCII GALLERY                 ║"
        echo "╠══════════════════════════════════════════════════════════╣"
        echo "║                                                          ║"
        echo "║  1) Random Sloth         2) Sloth Banner                ║"
        echo "║  3) Cyber Skull          4) Hardcore Cyberpunk          ║"
        echo "║  5) Ransomware Demo      6) Terminal Warning            ║"
        echo "║  7) Hacker Signature     8) Random Everything           ║"
        echo "║                                                          ║"
        echo "║  0) Exit Gallery                                         ║"
        echo "║                                                          ║"
        echo "╚══════════════════════════════════════════════════════════╝"
        echo -e "${CYBER_RESET}"
        echo ""
        
        read -p "$(echo -e "${CYBER_GREEN}Select ASCII art to display: ${CYBER_RESET}")" choice
        
        case "$choice" in
            1)
                echo -e "${CYBER_GREEN}=== RANDOM SLOTH ===${CYBER_RESET}"
                random_sloth
                ;;
            2)
                echo -e "${CYBER_GREEN}=== SLOTH BANNER ===${CYBER_RESET}"
                show_sloth_banner "NEURAL INTERFACE ACTIVATED"
                ;;
            3)
                echo -e "${CYBER_RED}=== CYBER SKULL ===${CYBER_RESET}"
                show_cyber_skull
                ;;
            4)
                echo -e "${CYBER_PURPLE}=== HARDCORE CYBERPUNK ===${CYBER_RESET}"
                show_hardcore_art
                ;;
            5)
                echo -e "${CYBER_RED}=== RANSOMWARE DEMO ===${CYBER_RESET}"
                show_ransomware_warning "SYSTEM HIJACKED" "Just kidding! Educational demo only"
                ;;
            6)
                echo -e "${CYBER_YELLOW}=== TERMINAL WARNING ===${CYBER_RESET}"
                show_hardcore_art "warning"
                ;;
            7)
                echo -e "${CYBER_GREEN}=== HACKER SIGNATURE ===${CYBER_RESET}"
                show_hardcore_art "hacker"
                ;;
            8)
                echo -e "${CYBER_CYAN}=== RANDOM EVERYTHING ===${CYBER_RESET}"
                local random_choice=$((RANDOM % 7 + 1))
                case "$random_choice" in
                    1) random_sloth ;;
                    2) show_sloth_banner "RANDOM MODE ACTIVATED" ;;
                    3) show_cyber_skull ;;
                    4) show_hardcore_art ;;
                    5) show_ransomware_warning ;;
                    6) show_hardcore_art "warning" ;;
                    7) show_hardcore_art "hacker" ;;
                esac
                ;;
            0)
                echo "Exiting ASCII Gallery..."
                break
                ;;
            *)
                echo -e "${CYBER_RED}Invalid selection${CYBER_RESET}"
                ;;
        esac
        
        echo ""
        echo -e "${CYBER_CYAN}Press Enter to continue...${CYBER_RESET}"
        read -r
    done
}

# Export functions
export -f show_sloth_banner
export -f random_sloth
export -f show_cyber_skull
export -f show_hardcore_art
export -f show_ransomware_warning
export -f ascii_gallery