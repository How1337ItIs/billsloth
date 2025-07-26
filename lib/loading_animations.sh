#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Loading Animations - Cyberpunk-style progress indicators
# Makes waiting feel like part of the experience

# Cyberpunk loading animation with glitch effects
cyberpunk_loader() {
    local message="${1:-Processing}"
    local duration="${2:-3}"
    local width=50
    
    echo -e "\033[38;5;46m"  # Matrix green
    echo ""
    echo "┌$(printf '─%.0s' $(seq 1 $width))┐"
    echo -n "│ $message"
    printf "%*s│\n" $((width - ${#message} - 1)) ""
    echo -n "│ "
    
    # Animated progress bar
    for ((i=0; i<=width-2; i++)); do
        sleep $(echo "scale=3; $duration / ($width - 2)" | bc 2>/dev/null || echo "0.1")
        
        # Random glitch effect
        if [ $((RANDOM % 10)) -eq 0 ]; then
            echo -ne "\033[38;5;196m█\033[38;5;46m"  # Red glitch
        else
            echo -n "█"
        fi
        
        # Random character corruption
        if [ $((RANDOM % 15)) -eq 0 ]; then
            echo -ne "\033[5m"  # Blink
        fi
    done
    
    echo -e " │\033[0m"
    echo -e "\033[38;5;46m└$(printf '─%.0s' $(seq 1 $width))┘\033[0m"
    echo ""
}

# Matrix-style digital rain effect
matrix_loader() {
    local message="${1:-Initializing neural pathways}"
    local duration="${2:-2}"
    
    echo -e "\033[38;5;46m"
    echo "$message..."
    echo ""
    
    # Matrix rain characters
    local chars="01ᾰᾱᾲᾳᾴᾶᾷ∅∀∂∆∈∉∋∌∍∎∏∐∑−∓∔∕∖∗∘∙√∝∞∟∠∡∢∣∤∥∦∧∨∩∪∫∬∭∮∯∰∱∲∳∴∵∶∷∸∹∺∻∼∽∾∿≀≁≂≃≄≅"
    
    for ((i=0; i<duration*10; i++)); do
        # Generate random matrix line
        line=""
        for ((j=0; j<60; j++)); do
            if [ $((RANDOM % 3)) -eq 0 ]; then
                char_index=$((RANDOM % ${#chars}))
                line+="${chars:$char_index:1}"
            else
                line+=" "
            fi
        done
        
        echo -e "\033[2K\r$line"  # Clear line and print
        sleep 0.1
    done
    
    echo -e "\033[0m"
    echo -e "\033[38;5;46m✓ Complete\033[0m"
    echo ""
}

# Sloth-themed loading with ASCII art
sloth_loader() {
    local message="${1:-Sloth systems loading}"
    local duration="${2:-4}"
    
    echo -e "\033[38;5;208m"  # Orange
    echo "$message..."
    echo ""
    
    # Sloth loading states
    local frames=(
        "     (\\_/)    "
        "    ( -.- )   "
        "   o_(\"|(\")   "
        "              "
        "     (\\_/)    "
        "    ( o.o )   "
        "   o_(\"|(\")   "
        "              "
        "     (\\_/)    "
        "    ( ^.^ )   "
        "   o_(\"|(\")   "
        "    READY!    "
    )
    
    local steps_per_frame=$(echo "scale=0; $duration * 10 / ${#frames[@]}" | bc 2>/dev/null || echo "3")
    
    for frame in "${frames[@]}"; do
        for ((i=0; i<steps_per_frame; i++)); do
            echo -e "\033[2K\r$frame"
            sleep 0.1
        done
    done
    
    echo -e "\033[0m"
    echo ""
}

# Wwwyzzerdd tech loading
wwwyzzerdd_loader() {
    local message="${1:-Entering cyberland portal}"
    local duration="${2:-3}"
    
    echo -e "\033[38;5;51m"  # Cyan
    echo "🧙 wwwyzzerdd: '$message, broadbrain...'"
    echo ""
    
    # Tech-style loading
    local stages=(
        "[ ] Initializing brainframe connection"
        "[.] Establishing broadbrain uplink"
        "[..] Loading cyberland protocols"
        "[...] Activating wireless transmission"
        "[✓] Live streaming operational"
    )
    
    local delay=$(echo "scale=2; $duration / ${#stages[@]}" | bc 2>/dev/null || echo "0.6")
    
    for stage in "${stages[@]}"; do
        echo -e "\033[2K\r$stage"
        sleep "$delay"
    done
    
    echo -e "\033[0m"
    echo ""
    echo "🧙 wwwyzzerdd: 'Welcome to Instant Pestering... I mean, success!'"
    echo ""
}

# Quick spinner for short operations
quick_spinner() {
    local pid=$1
    local message="${2:-Working}"
    
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    echo -n "$message "
    while kill -0 $pid 2>/dev/null; do
        printf "\b${spin:$i:1}"
        sleep 0.1
        i=$(( (i+1) % ${#spin} ))
    done
    
    printf "\b✓\n"
}

# Progress bar with percentage
progress_bar() {
    local current=$1
    local total=$2
    local message="${3:-Progress}"
    local width=40
    
    local percentage=$(echo "scale=0; $current * 100 / $total" | bc 2>/dev/null || echo "0")
    local filled=$(echo "scale=0; $current * $width / $total" | bc 2>/dev/null || echo "0")
    
    echo -ne "\r$message: ["
    
    # Filled portion
    echo -ne "\033[38;5;46m"
    for ((i=0; i<filled; i++)); do
        echo -n "█"
    done
    
    # Empty portion
    echo -ne "\033[38;5;238m"
    for ((i=filled; i<width; i++)); do
        echo -n "░"
    done
    
    echo -ne "\033[0m] $percentage%"
    
    if [ "$current" -eq "$total" ]; then
        echo ""
    fi
}

# Context-aware loader selection
smart_loader() {
    local operation="$1"
    local message="$2"
    local duration="${3:-3}"
    
    case "$operation" in
        "ai"|"neural"|"brain")
            matrix_loader "$message" "$duration"
            ;;
        "tech"|"cyber"|"network")
            wwwyzzerdd_loader "$message" "$duration"
            ;;
        "sloth"|"automation"|"workflow")
            sloth_loader "$message" "$duration"
            ;;
        "cyberpunk"|"hack"|"matrix")
            cyberpunk_loader "$message" "$duration"
            ;;
        *)
            cyberpunk_loader "$message" "$duration"
            ;;
    esac
}

# Loading with ATHF personality
athf_loading() {
    local message="$1"
    local duration="${2:-3}"
    
    # Random ATHF character provides loading commentary
    local characters=("meatwad" "frylock" "shake" "carl" "wwwyzzerdd")
    local selected_char=${characters[$((RANDOM % ${#characters[@]}))]}
    
    case "$selected_char" in
        "meatwad")
            echo "🍔 Meatwad: 'I get it! It ain't making me laugh, but I get it!'"
            sloth_loader "$message" "$duration"
            echo "🍔 Meatwad: 'I'm a wildman.'"
            ;;
        "frylock")
            echo "🧠 Frylock: 'Damn it, Shake!'"
            cyberpunk_loader "$message" "$duration"
            echo "🧠 Frylock: 'Grab my potatoes, Carl!'"
            ;;
        "shake")
            echo "🥤 Shake: 'Dancing is forbidden!'"
            matrix_loader "$message" "$duration"
            echo "🥤 Shake: 'Number one in the hood, G!'"
            ;;
        "carl")
            echo "👨 Carl: 'Yeah, I know all about computers.'"
            wwwyzzerdd_loader "$message" "$duration"
            echo "👨 Carl: 'Write yourself a prescription for shutting the f*** up.'"
            ;;
        "wwwyzzerdd")
            wwwyzzerdd_loader "$message" "$duration"
            ;;
    esac
}

# Export functions
export -f cyberpunk_loader
export -f matrix_loader
export -f sloth_loader
export -f wwwyzzerdd_loader
export -f quick_spinner
export -f progress_bar
export -f smart_loader
export -f athf_loading