#!/bin/bash
# ATHF Easter Eggs Library
# Source this file and call random_athf_easter_egg to occasionally display a random ATHF character and quote

random_athf_easter_egg() {
  # 20% chance
  if (( RANDOM % 5 == 0 )); then
    case $((RANDOM % 3)) in
      0)
        # Master Shake
        cat <<'EOF'
⬜⬜⬜⬜⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜⬜
⬜⬜⬜⬜⬛🏻🏻🏻🏻🏻🏻🏻🏻🏻🏻🏻🏻⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬛🏻🏻🏻🏻🏻🏻🏻🏻🏻🏻🏻⬛⬛🏻⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬛🏻🏻🏻🏻🏻🏻⬛⬛⬛⬛⬛⬛🏻🏻⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜⬜⬛🏻🏻🏻⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬛🏻🏻🏻⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬛🏻🏻🏻⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬛⬛⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜
EOF
        echo 'Master Shake: "I’m on the internet. I’m downloading the internet as we speak."'
        ;;
      1)
        # Ignignokt
        cat <<'EOF'
⬜⬜⬜⬜🟩🟩🟩⬜⬜⬜⬜🟩🟩🟩🟩⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜🟩🟩🟩⬜⬜⬜⬜🟩🟩🟩🟩⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜🟩🟩🟩⬜⬜⬜⬜🟩🟩🟩🟩⬜⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜🟩🟩🟩🟩🟩🟩⬜🟩🟩🟩🟩🟩🟩🟩⬜⬜⬜⬜
⬜⬜⬜⬜🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜⬜⬜⬜
⬜⬜⬜⬜🟩🟩🟩🟦🟩🟩🟩🟩🟩🟦🟩🟩🟩🟩⬜⬜🟦⬜
⬜⬜⬜⬜🟩🟩🟦🟩🟩🟩🟩🟩🟩🟩🟦🟩🟩🟩⬜⬜🟦⬜
⬜⬜⬜⬜🟩🟦🟩🟦🟦🟦🟩🟦🟦🟦🟩🟦🟩⬜⬜🟦🟦🟦
EOF
        echo 'Ignignokt: "Some would say that the Earth is our moon. But that would belittle the name of our moon, which is: The Moon."'
        ;;
      2)
        # Err
        cat <<'EOF'
⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜🟪🟪🟪🟪🟪⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜🟪🟪🟪🟪🟪⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜🟪🟪🟪🟪🟪⬜⬜⬜⬜⬜⬜
⬜⬜⬜⬜🟪🟪🟪🟪🟪🟪🟪🟪🟪🟪🟪🟪🟪⬜⬜⬜⬜⬜⬜
⬜🟦⬜⬜🟪🟪🟪🟪🟪🟪🟪🟪🟪🟪🟪🟪🟪⬜⬜⬜⬜🟦⬜
⬜🟦⬜⬜🟪🟦🟪🟪🟪🟪🟪🟪🟪🟪🟪🟦🟪⬜⬜⬜⬜🟦⬜
EOF
        echo 'Err: "Don'[0;39m't question it!"'
        ;;
    esac
    echo ""
  fi
} 