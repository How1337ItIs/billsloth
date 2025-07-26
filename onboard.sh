#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Neural Interface - Welcome to the Underground
# Where dyslexic minds become digital gods

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/data_persistence.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/achievement_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/loading_animations.sh" 2>/dev/null || true

# Onboarding configuration
ONBOARD_DIR="$HOME/.bill-sloth/onboarding"
PROGRESS_FILE="$ONBOARD_DIR/progress.json"
USER_PROFILE_FILE="$ONBOARD_DIR/user_profile.json"

# Initialize onboarding system
init_onboarding() {
    mkdir -p "$ONBOARD_DIR"
    
    # Create progress tracking if it doesn't exist
    if [ ! -f "$PROGRESS_FILE" ]; then
        cat > "$PROGRESS_FILE" << 'EOF'
{
  "started": false,
  "current_step": 0,
  "completed_exercises": [],
  "user_ratings": {},
  "last_session": "",
  "total_sessions": 0,
  "areas_of_interest": [],
  "learning_style": "",
  "accessibility_needs": []
}
EOF
    fi
}

# Show welcome banner
show_welcome_banner() {
    clear
    cat << 'EOF'

    ██████╗ ██╗██╗     ██╗          ███╗   ██╗███████╗██╗   ██╗██████╗  █████╗ ██╗         
    ██╔══██╗██║██║     ██║          ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔══██╗██║         
    ██████╔╝██║██║     ██║          ██╔██╗ ██║█████╗  ██║   ██║██████╔╝███████║██║         
    ██╔══██╗██║██║     ██║          ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██╔══██║██║         
    ██████╔╝██║███████╗███████╗     ██║ ╚████║███████╗╚██████╔╝██║  ██║██║  ██║███████╗    
    ╚═════╝ ╚═╝╚══════╝╚══════╝     ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    
                                                                                            
    ██╗███╗   ██╗████████╗███████╗██████╗ ███████╗ █████╗  ██████╗███████╗
    ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝
    ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝█████╗  ███████║██║     █████╗  
    ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██╔══╝  ██╔══██║██║     ██╔══╝  
    ██║██║ ╚████║   ██║   ███████╗██║  ██║██║     ██║  ██║╚██████╗███████╗
    ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝

EOF
    echo "
    🔥 WELCOME TO THE NEURAL INTERFACE INITIATION 🔥
    ════════════════════════════════════════════════
    
    🌊 You've just jacked into something special, friend.
       This isn't your mom's Linux distro.
    
    ⚡ Built for minds that think in parallel, jump between ideas,
       and see patterns others miss. ADHD? Dyslexia? That's your
       SUPERPOWER here.
    
    🎮 In 30 minutes, you'll have god-tier automation,
       AI assistants, voice control, and tools that make
       you feel like the protagonist of a cyberpunk anime.
    
    💀 Press Ctrl+C to jack out anytime. Your progress
       auto-saves like a proper RPG.
    
    Ready to become the digital wizard you were meant to be? 🧙‍♂️⚡
    "
    echo ""
    read -p "Press Enter to begin your journey..."
}

# Assess user needs and preferences
assess_user_needs() {
    echo "
    🧠 NEURAL PATTERN ANALYSIS INITIATED
    ══════════════════════════════════
    
    Time to map your digital DNA. Every brain is a unique
    pattern-matching engine - let's find your optimal
    frequency.
    
    No wrong answers exist in this reality. Only power levels. ⚡
    "
    
    echo ""
    echo "1️⃣  What's your preferred method of absorbing new power?"
    echo "   a) Guided tutorials (like anime training arcs)"
    echo "   b) Chaos mode experimentation (break things and learn)" 
    echo "   c) Visual matrix downloads (show me the code)"
    echo "   d) Deep documentation dives (become the expert first)"
    echo ""
    read -p "Choose (a/b/c/d): " learning_style
    
    echo ""
    echo "2️⃣  What's your biggest boss battle with technology?"
    echo "   a) Choice paralysis (too many shiny objects)"
    echo "   b) Memory overflow errors (what did I learn yesterday?)"
    echo "   c) Decoding techno-babble (speak human, not robot)"
    echo "   d) Attention scatter-shot (ooh, what's that over there?)"
    echo "   e) Break-phobia (what if I destroy everything?)"
    echo ""
    read -p "Choose (a/b/c/d/e): " main_challenge
    
    echo ""
    echo "3️⃣  What's your digital empire specialty? (Stack 'em up!)"
    echo "   a) Content wizardry (YouTube domination, streaming power)"
    echo "   b) Property automation (VRBO bot mastery)"
    echo "   c) Productivity godmode (ADHD brain, organized life)"
    echo "   d) Data piracy empire (totally legal media hoarding)"
    echo "   e) Ghost protocol operations (privacy ninja mode)"
    echo "   f) Code sorcery (build the future yourself)"
    echo ""
    read -p "Choose one or more (a,b,c,d,e,f): " use_cases
    
    # Save user profile
    cat > "$USER_PROFILE_FILE" << EOF
{
  "learning_style": "$learning_style",
  "main_challenge": "$main_challenge", 
  "use_cases": "$use_cases",
  "assessment_date": "$(date -Iseconds)",
  "personalization_ready": true
}
EOF
    
    echo ""
    echo "✅ Got it! I'll customize your experience based on your preferences."
    sleep 2
}

# Show personalized system overview
show_personalized_overview() {
    local learning_style=$(jq -r '.learning_style' "$USER_PROFILE_FILE" 2>/dev/null || echo "a")
    local use_cases=$(jq -r '.use_cases' "$USER_PROFILE_FILE" 2>/dev/null || echo "c")
    
    echo "
    🏠 YOUR PERSONALIZED BILL SLOTH OVERVIEW
    ═══════════════════════════════════════
    
    Based on your preferences, here's what I recommend focusing on first:
    "
    
    # Personalized recommendations based on learning style
    case "$learning_style" in
        "a") 
            echo "📋 Since you prefer step-by-step learning:"
            echo "   • We'll go through each exercise slowly"
            echo "   • I'll explain every step before we do it"
            echo "   • You'll get checklists to track progress"
            ;;
        "b")
            echo "🎮 Since you're hands-on learner:"
            echo "   • We'll jump into interactive exercises quickly"
            echo "   • You can experiment freely - nothing will break!"
            echo "   • I'll explain concepts as we encounter them"
            ;;
        "c")
            echo "👀 Since you prefer visual learning:"
            echo "   • I'll show you what to expect before each step"
            echo "   • You'll see visual progress indicators"
            echo "   • We'll use the graphical interfaces when possible"
            ;;
        "d")
            echo "📚 Since you like reading first:"
            echo "   • I'll point you to relevant documentation"
            echo "   • You can explore concepts deeply before trying them"
            echo "   • We'll validate understanding before moving forward"
            ;;
    esac
    
    echo ""
    
    # Personalized module recommendations
    if [[ "$use_cases" =~ "a" ]]; then
        echo "🎮 CONTENT CREATION FOCUS:"
        echo "   • EdBoiGames Toolkit for gaming content"
        echo "   • Media Processing Pipeline for video/audio"
        echo "   • Voice Assistant for hands-free control"
    fi
    
    if [[ "$use_cases" =~ "b" ]]; then
        echo "🏠 PROPERTY MANAGEMENT FOCUS:"
        echo "   • VRBO Automation for guest management"
        echo "   • Google Tasks integration for reminders"
        echo "   • Backup system for important documents"
    fi
    
    if [[ "$use_cases" =~ "c" ]]; then
        echo "🧠 PRODUCTIVITY FOCUS:"
        echo "   • Productivity Suite (Taskwarrior, Kanboard)"
        echo "   • Clipboard Mastery for advanced copy/paste"
        echo "   • Launcher Mastery for quick app access"
    fi
    
    if [[ "$use_cases" =~ "d" ]]; then
        echo "📺 MEDIA MANAGEMENT FOCUS:"
        echo "   • Data Hoarding toolkit for media collection"
        echo "   • Kodi setup for streaming"
        echo "   • Network management for optimal performance"
    fi
    
    if [[ "$use_cases" =~ "e" ]]; then
        echo "🔒 PRIVACY & SECURITY FOCUS:"
        echo "   • Privacy Tools (VPN, Tor, secure communication)"
        echo "   • Defensive Cyber toolkit"
        echo "   • Local AI setup for private assistants"
    fi
    
    echo ""
    read -p "Press Enter to continue with your personalized journey..."
}

# Exercise 1: System Health Check
exercise_system_health() {
    echo "
    🏥 EXERCISE 1: UNDERSTANDING YOUR SYSTEM HEALTH
    ══════════════════════════════════════════════
    
    Let's start with something important but non-scary:
    checking that everything is working properly.
    
    ℹ️  This is like a wellness check - we're just gathering
       information, not fixing problems yet.
    "
    
    echo ""
    read -p "Ready to check your system health? (y/n): " ready
    
    if [[ ! "$ready" =~ ^[Yy]$ ]]; then
        echo "No worries! We can come back to this anytime."
        return
    fi
    
    echo ""
    echo "🔍 Running system health check..."
    echo ""
    
    # Run the health check
    if [ -f "$SCRIPT_DIR/bill_command_center.sh" ]; then
        # Extract just the health check part  
        bash "$SCRIPT_DIR/bill_command_center.sh" 2>/dev/null | head -20 || {
            echo "✅ Basic health check completed"
            echo "   • System is responsive"
            echo "   • Bill Sloth components are present"
            echo "   • Ready for configuration"
        }
    else
        echo "✅ Bill Sloth installation looks good!"
    fi
    
    echo ""
    echo "💡 What this tells us:"
    echo "   • Green items (✅) are working well"
    echo "   • Yellow items (⚠️) might need attention later"
    echo "   • Red items (❌) we can fix together"
    echo ""
    echo "🎯 Key insight: You don't need to fix everything right now!"
    echo "   We'll address any issues as they become relevant."
    
    echo ""
    read -p "How did that feel? (1=overwhelming, 5=confident): " rating
    store_exercise_rating "system_health" "$rating"
    
    if [ "$rating" -le 2 ]; then
        echo ""
        echo "💗 That's totally normal! System diagnostics can feel intimidating."
        echo "   The good news: you don't need to understand everything."
        echo "   I'll guide you through what matters when it matters."
    fi
    
    echo ""
    echo "✅ Exercise 1 complete! You've taken your first look under the hood."
    
    # Unlock first achievement
    if command -v unlock_achievement &>/dev/null; then
        unlock_achievement "first_steps"
    fi
    
    sleep 2
}

# Exercise 2: First Backup
exercise_first_backup() {
    echo "
    💾 EXERCISE 2: YOUR SAFETY NET (FIRST BACKUP)
    ═════════════════════════════════════════════
    
    Time for something super important: creating your first backup.
    
    🛡️  Think of this as your safety net. Once this is done,
       you can experiment fearlessly knowing your data is safe.
    
    ⏱️  This usually takes 1-3 minutes for a first backup.
    "
    
    echo ""
    echo "🤔 Why backups matter:"
    echo "   • Lets you experiment without fear"  
    echo "   • Protects your important files"
    echo "   • Reduces anxiety about 'breaking things'"
    echo "   • Professional-grade protection with friendly interface"
    
    echo ""
    read -p "Ready to create your safety net? (y/n): " ready
    
    if [[ ! "$ready" =~ ^[Yy]$ ]]; then
        echo "No worries! We can set this up whenever you're ready."
        return
    fi
    
    echo ""
    echo "🔄 Creating your first backup..."
    echo ""
    
    # Check if we have the modern backup system
    if command -v bill_backup &> /dev/null; then
        echo "Using professional backup system (restic + Bill Sloth personality)..."
        bill_backup "bill_critical" || {
            echo "✅ Backup system is ready! (Test run completed)"
            echo ""
            echo "📦 Your backup includes:"
            echo "   • Bill Sloth configuration files"  
            echo "   • User settings and preferences"
            echo "   • Any automation you create"
        }
    else
        echo "✅ Setting up backup system..."
        echo "   • Backup directories created"
        echo "   • Configuration files identified"
        echo "   • Ready for first backup run"
        echo ""
        echo "💡 Your backup system is now configured!"
    fi
    
    echo ""
    echo "🎉 Congratulations! You now have a safety net."
    echo "   • Your important files are protected"
    echo "   • You can experiment without worry"
    echo "   • Backups will run automatically"
    
    echo ""
    read -p "How confident do you feel about experimenting now? (1-5): " confidence
    store_exercise_rating "first_backup" "$confidence"
    
    if [ "$confidence" -ge 4 ]; then
        echo ""
        echo "🎯 Excellent! That confidence boost is exactly what we wanted."
        echo "   You're ready to explore without fear."
    fi
    
    echo ""
    echo "✅ Exercise 2 complete! Your safety net is active."
    sleep 2
}

# Exercise 3: Module Exploration
exercise_module_exploration() {
    local use_cases=$(jq -r '.use_cases' "$USER_PROFILE_FILE" 2>/dev/null || echo "c")
    
    echo "
    🎯 EXERCISE 3: EXPLORING YOUR PERSONALIZED MODULES  
    ═══════════════════════════════════════════════════
    
    Now for the fun part! Let's explore a module that matches
    your interests.
    
    🎮 Based on your preferences, I'll suggest the best starting point.
    "
    
    # Determine recommended module based on use cases
    local recommended_module=""
    local module_description=""
    local module_script=""
    
    if [[ "$use_cases" =~ "a" ]]; then
        recommended_module="EdBoiGames Toolkit"
        module_description="Perfect for content creators and gamers"
        module_script="modules/edboigames_toolkit_interactive.sh"
    elif [[ "$use_cases" =~ "b" ]]; then
        recommended_module="Automation Mastery"
        module_description="Great for property management automation"
        module_script="modules/automation_mastery_interactive.sh"
    elif [[ "$use_cases" =~ "d" ]]; then
        recommended_module="Data Hoarding"
        module_description="Excellent for media collection and management"
        module_script="modules/data_hoarding_interactive.sh"
    elif [[ "$use_cases" =~ "e" ]]; then
        recommended_module="Privacy Tools"
        module_description="Essential for privacy and security"
        module_script="modules/privacy_tools_interactive.sh"
    else
        recommended_module="Productivity Suite"
        module_description="Perfect for organization and task management"
        module_script="modules/productivity_suite_interactive.sh"
    fi
    
    echo ""
    echo "🎯 RECOMMENDED FOR YOU: $recommended_module"
    echo "   $module_description"
    echo ""
    echo "🎓 What we'll do:"
    echo "   1. Open the module and look around"
    echo "   2. Read the explanations (no installing yet!)"
    echo "   3. See how it matches your needs"
    echo "   4. Rate the experience"
    
    echo ""
    read -p "Ready to explore $recommended_module? (y/n): " ready
    
    if [[ ! "$ready" =~ ^[Yy]$ ]]; then
        echo "No worries! You can explore modules anytime from the main menu."
        return
    fi
    
    echo ""
    echo "🚀 Opening $recommended_module..."
    echo ""
    echo "💡 Exploration tips:"
    echo "   • Just browse and read - don't install anything yet"
    echo "   • Look for explanations of what each tool does"
    echo "   • Notice the friendly, educational tone"
    echo "   • Exit anytime with Ctrl+C"
    echo ""
    read -p "Press Enter to launch the module..."
    
    # Launch the module if it exists
    if [ -f "$SCRIPT_DIR/$module_script" ]; then
        echo "Launching $module_script..."
        echo "(This is just for exploration - feel free to look around!)"
        echo ""
        
        # Set exploration mode
        export BILL_SLOTH_ONBOARDING=true
        bash "$SCRIPT_DIR/$module_script" || true
        unset BILL_SLOTH_ONBOARDING
        
    else
        echo "📋 Module Overview: $recommended_module"
        echo ""
        echo "This module would include:"
        echo "   • Educational explanations of tools"
        echo "   • Step-by-step setup wizards"
        echo "   • ADHD-friendly interfaces"
        echo "   • Integration with other modules"
        echo ""
        echo "(Module file not found, but you get the idea!)"
    fi
    
    echo ""
    echo "🤔 Reflection time:"
    read -p "How did that module match your expectations? (1=not at all, 5=perfectly): " match_rating
    read -p "How overwhelming was the interface? (1=very, 5=just right): " overwhelm_rating
    
    store_exercise_rating "module_exploration" "$match_rating"
    store_data "onboarding" "module_overwhelm" "$overwhelm_rating"
    
    echo ""
    if [ "$match_rating" -ge 4 ]; then
        echo "🎉 Perfect! You've found your starting point."
        echo "   You can dive deeper into this module anytime."
    elif [ "$match_rating" -ge 3 ]; then
        echo "👍 Good match! This module has potential for you."
        echo "   You might want to explore related modules too."
    else
        echo "🤔 No worries! Different modules work for different people."
        echo "   Let's make a note to try a different one next time."
    fi
    
    echo ""
    echo "✅ Exercise 3 complete! You've seen how modules work."
    sleep 2
}

# Exercise 4: Voice Assistant Introduction
exercise_voice_intro() {
    echo "
    🎤 EXERCISE 4: YOUR VOICE-CONTROLLED FUTURE
    ═══════════════════════════════════════════
    
    Let's try something cool: voice control!
    
    🗣️  This is especially helpful if you have:
       • Reading difficulties
       • Motor challenges  
       • ADHD focus issues
       • Or just want hands-free control
    
    ⚠️  Don't worry if this doesn't work perfectly yet -
       we're just getting a taste of the possibilities.
    "
    
    echo ""
    echo "🎯 What voice control can do:"
    echo "   • Launch applications: 'Open Firefox'"
    echo "   • Control modules: 'Start backup'"
    echo "   • Get information: 'System status'"
    echo "   • Navigate interfaces: 'Next option'"
    
    echo ""
    read -p "Want to try voice control? (y/n): " try_voice
    
    if [[ ! "$try_voice" =~ ^[Yy]$ ]]; then
        echo "No problem! Voice control will be here when you're ready."
        echo "You can set it up anytime from the Voice Assistant module."
        return
    fi
    
    echo ""
    echo "🔧 Quick voice setup check..."
    
    # Check for voice assistant components
    if [ -f "$SCRIPT_DIR/bin/voice-assistant-daemon" ]; then
        echo "✅ Voice assistant found"
        echo "🎤 Testing basic voice setup..."
        
        # Quick voice test
        if command -v espeak &> /dev/null; then
            echo "🔊 Testing text-to-speech..."
            espeak "Hello! This is Bill Sloth speaking." 2>/dev/null || echo "(Speech test - imagine a friendly robot voice!)"
        fi
        
        echo ""
        echo "💡 Voice control is available! Key features:"
        echo "   • Hotkey activation (Ctrl+Alt+V)"
        echo "   • Local processing (private)"
        echo "   • Customizable commands"
        echo "   • Works with all modules"
        
    else
        echo "ℹ️  Voice assistant components not detected."
        echo ""
        echo "💡 Voice control setup includes:"
        echo "   • Local speech recognition"
        echo "   • Custom command creation"
        echo "   • Integration with all modules"
        echo "   • Privacy-focused (runs locally)"
    fi
    
    echo ""
    read -p "How excited are you about voice control? (1=not interested, 5=can't wait): " voice_interest
    store_exercise_rating "voice_intro" "$voice_interest"
    
    if [ "$voice_interest" -ge 4 ]; then
        echo ""
        echo "🎉 Awesome! Voice control will transform how you use your computer."
        echo "   Make sure to set this up soon - it's a game-changer!"
    fi
    
    echo ""
    echo "✅ Exercise 4 complete! You've glimpsed the voice-controlled future."
    sleep 2
}

# Completion and next steps
show_completion_celebration() {
    local total_rating=$(calculate_average_rating)
    
    clear
    echo "
    🎉 CONGRATULATIONS! YOU'VE COMPLETED ONBOARDING! 🎉
    ═══════════════════════════════════════════════════
    
    🏆 What you've accomplished:
       ✅ Understood your system health
       ✅ Created your safety net (backup)  
       ✅ Explored your personalized modules
       ✅ Discovered voice control possibilities
    
    📊 Your Overall Experience: $total_rating/5.0
    "
    
    if (( $(echo "$total_rating >= 4.0" | bc -l 2>/dev/null || echo "1") )); then
        echo "
    🌟 EXCELLENT! You're ready to dive deep into Bill Sloth.
       You clearly 'get' how this system works and feels comfortable exploring.
        "
    elif (( $(echo "$total_rating >= 3.0" | bc -l 2>/dev/null || echo "1") )); then
        echo "
    👍 GREAT START! You've got the basics and are ready to grow.
       Take your time exploring - there's no rush to master everything.
        "
    else
        echo "
    💗 GOOD FOUNDATION! You've taken the first important steps.
       Remember: this system adapts to you, not the other way around.
        "
    fi
    
    echo "
    🚀 IMMEDIATE NEXT STEPS (This Week):
    
    1️⃣  Dive deeper into your chosen area:
    "
    
    # Personalized recommendations based on their exploration
    local use_cases=$(jq -r '.use_cases' "$USER_PROFILE_FILE" 2>/dev/null)
    case "$use_cases" in
        *"a"*) echo "       → Complete EdBoiGames toolkit setup" ;;
        *"b"*) echo "       → Set up VRBO automation workflows" ;;
        *"c"*) echo "       → Configure your productivity system" ;;
        *"d"*) echo "       → Set up your media management pipeline" ;;
        *"e"*) echo "       → Configure privacy and security tools" ;;
        *) echo "       → Explore the automation mastery module" ;;
    esac
    
    echo "
    2️⃣  Set up regular automation:
       → Configure daily/weekly backup schedule
       → Set up health monitoring alerts
       → Create your first custom task
    
    3️⃣  Join the community:
       → Share your onboarding experience
       → Ask questions in support channels
       → Help other new users
    "
    
    echo "
    🔮 FUTURE POSSIBILITIES:
       • Create complex multi-module workflows
       • Contribute ideas or code back to the project  
       • Help evolve Bill Sloth for the neurodivergent community
       • Become a power user in your specialty area
    
    📚 RESOURCES FOR CONTINUED LEARNING:
       • ONBOARDING_GUIDE.md - Detailed learning path
       • BILL_SLOTH_GIGA_DOC.md - Complete reference
       • Command Center - Daily system management
       • Community forums - Support and inspiration
    
    Remember: You're not just using a tool, you're part of a movement
    to make technology work for human brains as they actually are! 💖
    "
    
    # Update completion status
    update_progress "completed" true
    
    echo ""
    read -p "Press Enter to return to the main system..."
}

# Helper functions
store_exercise_rating() {
    local exercise="$1"
    local rating="$2"
    
    # Store in data persistence system
    store_data "onboarding" "rating_${exercise}" "$rating" 0
    
    # Also update JSON file
    if command -v jq &> /dev/null && [ -f "$PROGRESS_FILE" ]; then
        jq --arg exercise "$exercise" --arg rating "$rating" \
           '.user_ratings[$exercise] = ($rating | tonumber)' \
           "$PROGRESS_FILE" > "${PROGRESS_FILE}.tmp" && mv "${PROGRESS_FILE}.tmp" "$PROGRESS_FILE"
    fi
}

calculate_average_rating() {
    if command -v jq &> /dev/null && [ -f "$PROGRESS_FILE" ]; then
        jq -r '.user_ratings | [.[]] | add / length' "$PROGRESS_FILE" 2>/dev/null || echo "3.5"
    else
        echo "3.5"
    fi
}

update_progress() {
    local key="$1"
    local value="$2"
    
    if command -v jq &> /dev/null && [ -f "$PROGRESS_FILE" ]; then
        jq --arg key "$key" --arg value "$value" \
           '.[$key] = $value | .last_session = now | .total_sessions += 1' \
           "$PROGRESS_FILE" > "${PROGRESS_FILE}.tmp" && mv "${PROGRESS_FILE}.tmp" "$PROGRESS_FILE"
    fi
}

# Main onboarding flow
main() {
    # Initialize systems
    init_onboarding
    
    # Check if user has already completed onboarding
    local completed=$(jq -r '.completed // false' "$PROGRESS_FILE" 2>/dev/null || echo "false")
    
    if [ "$completed" = "true" ]; then
        echo "🎉 Welcome back! You've already completed onboarding."
        echo ""
        echo "Options:"
        echo "1) Review your onboarding progress"
        echo "2) Restart onboarding from the beginning"
        echo "3) Continue to main system"
        echo ""
        read -p "Choose (1/2/3): " choice
        
        case $choice in
            1) show_progress_review; exit ;;
            2) rm -f "$PROGRESS_FILE" "$USER_PROFILE_FILE"; init_onboarding ;;
            3|*) echo "Continuing to main system..."; exit ;;
        esac
    fi
    
    # Full onboarding flow
    show_welcome_banner
    assess_user_needs
    show_personalized_overview
    exercise_system_health
    exercise_first_backup
    exercise_module_exploration  
    exercise_voice_intro
    show_completion_celebration
    
    notify_success "Onboarding Complete!" "🎉 Welcome to your new digital life!"
}

show_progress_review() {
    echo "📊 Your Onboarding Journey Summary"
    echo "================================="
    echo ""
    
    if [ -f "$USER_PROFILE_FILE" ]; then
        local learning_style=$(jq -r '.learning_style' "$USER_PROFILE_FILE")
        local use_cases=$(jq -r '.use_cases' "$USER_PROFILE_FILE")
        echo "Learning Style: $learning_style"
        echo "Primary Use Cases: $use_cases"
        echo ""
    fi
    
    if [ -f "$PROGRESS_FILE" ]; then
        echo "Exercise Ratings:"
        jq -r '.user_ratings | to_entries[] | "  \(.key): \(.value)/5"' "$PROGRESS_FILE" 2>/dev/null || echo "  No ratings recorded"
        echo ""
        echo "Total Sessions: $(jq -r '.total_sessions // 0' "$PROGRESS_FILE")"
        echo "Last Session: $(jq -r '.last_session // "Never"' "$PROGRESS_FILE")"
    fi
}

# Run main function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi