#!/bin/bash
# LLM_CAPABILITY: local_ok
# ATHF Easter Eggs Library - ASCII VERSION
# Source this file and call random_athf_easter_egg to occasionally display a random ATHF character and quote
# Now with enhanced randomness and authentic quotes only

# Authentic ATHF quotes
random_athf_easter_egg() {
    set -euo pipefail
    # 15% chance
    if (( RANDOM % 7 == 0 )); then
        case $((RANDOM % 4)) in
            0)
                # Master Shake
                cat <<'EOF'
     ___
    |   |
    | O |  <- Shake
    |___|
     | |
     |_|
EOF
                local quotes=(
                    "Number one in the hood, G!"
                    "I hope you can see this, because I'm doing it as hard as I can."
                    "Dancing is forbidden!"
                    "Don't question the plan!"
                    "I am the leader!"
                )
                local rand=$((RANDOM % ${#quotes[@]}))
                echo "Master Shake: \"${quotes[$rand]}\""
                ;;
            1)
                # Frylock
                cat <<'EOF'
    /^^^^\
   ( o  o )  <- Frylock
    \  ^  /
     |||||
     |||||
EOF
                local quotes=(
                    "Shake, that doesn't make any sense."
                    "Computers do not work that way!"
                    "Let me break this down for you..."
                    "You can't just make stuff up."
                    "That's not how technology works, Shake."
                )
                local rand=$((RANDOM % ${#quotes[@]}))
                echo "Frylock: \"${quotes[$rand]}\""
                ;;
            2)
                # Meatwad
                cat <<'EOF'
     ____
    /    \
   (  ..  )  <- Meatwad
    \____/
EOF
                local quotes=(
                    "I get it! I get it!"
                    "Do what now?"
                    "I am a dog."
                    "That's awesome!"
                    "Can I be a computer?"
                )
                local rand=$((RANDOM % ${#quotes[@]}))
                echo "Meatwad: \"${quotes[$rand]}\""
                ;;
            3)
                # Carl
                cat <<'EOF'
     ####
    #    #
   #  __  #  <- Carl
   # |  | #
    #____#
     ||||
EOF
                local quotes=(
                    "Tonight! You!"
                    "I don't need no instructions to know how to rock!"
                    "Yeah, I got it. It's called technology."
                    "Hey, you're breaking my stuff!"
                    "What the hell is going on over there?"
                )
                local rand=$((RANDOM % ${#quotes[@]}))
                echo "Carl: \"${quotes[$rand]}\""
                ;;
        esac
        echo ""
    fi
}

# Context-specific easter eggs for automation themes
automation_athf() {
    local quotes=(
        "Frylock: 'Computers do not work that way!'"
        "Shake: 'Don't question the plan!'"
        "Carl: 'Yeah, I got it. It's called technology.'"
        "Meatwad: 'Can I be a computer?'"
    )
    local rand_quote=${quotes[$((RANDOM % ${#quotes[@]}))]}
    echo "[ATHF] $rand_quote"
}

# Export the function
export -f random_athf_easter_egg
export -f automation_athf