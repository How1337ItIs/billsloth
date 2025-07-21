#!/bin/bash
# PRODUCTIVITY SUITE - ADHD & Memory Management Tools
# Designed specifically for Bill's needs: ADHD, dyslexia, memory issues

echo "PRODUCTIVITY_SUITE_MODULE_LOADED"

productivity_capabilities() {
    echo "Productivity Suite for ADHD & Memory Management:"
    echo "1. Visual task management (Kanban boards)"
    echo "2. Pomodoro timer with ADHD-friendly breaks"
    echo "3. Memory aids and note-taking systems"
    echo "4. Automated reminders and notifications"
    echo "5. Distraction blockers and focus tools"
    echo "6. Voice-to-text note capture"
    echo "7. Visual calendar and scheduling"
    echo "8. Brain dump and thought organization"
}

install_adhd_productivity_tools() {
    echo "[*] Installing ADHD-friendly productivity tools..."
    
    # Core productivity apps
    sudo apt install -y \
        freeplane \
        xmind \
        obsidian \
        notion-app \
        todoist \
        typora \
        flameshot \
        redshift \
        cold-turkey-blocker
    
    # Voice tools for note capture
    sudo apt install -y \
        gnome-sound-recorder \
        espeak \
        festival \
        vokoscreen-ng
    
    # Focus and time management
    sudo apt install -y \
        tomboy \
        gnome-pomodoro \
        workrave \
        stretchly
    
    echo "[✓] ADHD productivity tools installed"
}

setup_visual_task_management() {
    echo "[*] Setting up visual task management..."
    
    # Create Kanban board structure
    mkdir -p ~/Productivity/{ToDo,Doing,Done,Ideas,Backlog}
    
    # Install and configure Kanboard (web-based Kanban)
    cd ~/Downloads
    wget https://github.com/kanboard/kanboard/archive/refs/heads/master.zip
    unzip master.zip
    mv kanboard-master ~/Productivity/Kanboard
    
    # Create simple file-based Kanban
    cat > ~/bin/kanban << 'EOF'
#!/bin/bash
# Simple file-based Kanban for ADHD brain
clear
echo "🎯 BILL'S TASK BOARD"
echo "===================="
echo ""
echo "📋 TO DO:"
ls ~/Productivity/ToDo/ 2>/dev/null || echo "  (empty - good job!)"
echo ""
echo "⚡ DOING:"
ls ~/Productivity/Doing/ 2>/dev/null || echo "  (focus on one thing!)"
echo ""
echo "✅ DONE TODAY:"
find ~/Productivity/Done/ -mtime -1 2>/dev/null || echo "  (start small!)"
echo ""
echo "Commands: todo 'task', doing 'task', done 'task'"
EOF
    chmod +x ~/bin/kanban
    
    echo "[✓] Visual task management ready"
}

create_adhd_timer_system() {
    echo "[*] Creating ADHD-friendly timer system..."
    
    # Pomodoro with ADHD modifications (shorter focus, longer breaks)
    cat > ~/bin/focus-timer << 'EOF'
#!/bin/bash
echo "🧠 ADHD Focus Timer"
echo "1) Quick burst (15 min focus, 5 min break)"
echo "2) Standard (25 min focus, 5 min break)" 
echo "3) Deep work (45 min focus, 15 min break)"
echo "4) Hyperfocus mode (until you decide to stop)"
read -p "Choose: " choice

case $choice in
    1) focus_time=900; break_time=300 ;;
    2) focus_time=1500; break_time=300 ;;
    3) focus_time=2700; break_time=900 ;;
    4) echo "Hyperfocus activated! Press Ctrl+C when done"; sleep infinity ;;
esac

echo "Focus time starting! 🎯"
sleep $focus_time && notify-send "Break Time!" "Take a break, you earned it!" && 
echo "Break time! 😌" && sleep $break_time && 
notify-send "Back to Work!" "Ready for another round?"
EOF
    chmod +x ~/bin/focus-timer
    
    echo "[✓] ADHD timer system created"
}

setup_memory_aids() {
    echo "[*] Setting up memory aids..."
    
    # Quick note capture for racing thoughts
    cat > ~/bin/brain-dump << 'EOF'
#!/bin/bash
echo "🧠 Brain Dump - Get it out of your head!"
echo "Type your thoughts (Ctrl+D when done):"
echo "$(date): " >> ~/Productivity/brain-dump-$(date +%Y%m%d).txt
cat >> ~/Productivity/brain-dump-$(date +%Y%m%d).txt
echo "Dumped to brain-dump-$(date +%Y%m%d).txt"
EOF
    chmod +x ~/bin/brain-dump
    
    # Voice note capture
    cat > ~/bin/voice-note << 'EOF'
#!/bin/bash
echo "🎤 Recording voice note... (Ctrl+C to stop)"
filename="voice-note-$(date +%Y%m%d-%H%M%S).wav"
arecord -f cd -t wav ~/Productivity/VoiceNotes/$filename
echo "Saved: $filename"
# Auto-transcribe if whisper is available
if command -v whisper &> /dev/null; then
    echo "Transcribing..."
    whisper ~/Productivity/VoiceNotes/$filename --output_dir ~/Productivity/VoiceNotes/
fi
EOF
    chmod +x ~/bin/voice-note
    
    # Daily routine checklist
    cat > ~/bin/daily-routine << 'EOF'
#!/bin/bash
echo "📅 Daily Routine Checklist"
echo "========================="
checklist=(
    "Check VRBO messages"
    "Review cleaning schedule"
    "Update EdBoiGames tasks"
    "Respond to urgent emails"
    "Plan tomorrow's priorities"
)

for item in "${checklist[@]}"; do
    echo -n "[ ] $item - Done? (y/n): "
    read -n 1 answer
    echo
    if [[ $answer == "y" ]]; then
        echo "✅ $item" >> ~/Productivity/daily-$(date +%Y%m%d).log
    fi
done
EOF
    chmod +x ~/bin/daily-routine
    
    mkdir -p ~/Productivity/VoiceNotes
    echo "[✓] Memory aids configured"
}

setup_distraction_management() {
    echo "[*] Setting up distraction management..."
    
    # Website blocker for focus sessions
    cat > ~/bin/focus-mode << 'EOF'
#!/bin/bash
echo "🔒 Entering Focus Mode"
echo "Blocking distracting websites..."

# Common distracting sites
sites=(
    "reddit.com"
    "youtube.com"
    "facebook.com"
    "twitter.com" 
    "instagram.com"
    "tiktok.com"
    "twitch.tv"
)

# Backup current hosts file
sudo cp /etc/hosts /etc/hosts.backup

# Add blocks
for site in "${sites[@]}"; do
    echo "127.0.0.1 $site" | sudo tee -a /etc/hosts
    echo "127.0.0.1 www.$site" | sudo tee -a /etc/hosts
done

echo "Focus mode activated! Use 'unfocus' to disable"
echo "alias unfocus='sudo mv /etc/hosts.backup /etc/hosts'" >> ~/.bashrc
EOF
    chmod +x ~/bin/focus-mode
    
    # Notification manager
    cat > ~/bin/quiet-time << 'EOF'
#!/bin/bash
echo "🔕 Quiet Time - Disabling notifications"
gsettings set org.gnome.desktop.notifications show-banners false
dunstctl set-paused true
echo "Notifications paused. Use 'notify-on' to re-enable"
echo "alias notify-on='gsettings set org.gnome.desktop.notifications show-banners true; dunstctl set-paused false'" >> ~/.bashrc
EOF
    chmod +x ~/bin/quiet-time
    
    echo "[✓] Distraction management tools ready"
}

create_visual_reminders() {
    echo "[*] Creating visual reminder system..."
    
    # Desktop widget for current tasks
    cat > ~/bin/task-widget << 'EOF'
#!/bin/bash
# Visual reminder widget
while true; do
    clear
    echo "════════════════════════════════════"
    echo "🎯 CURRENT FOCUS"
    echo "════════════════════════════════════"
    if [ -f ~/Productivity/.current-task ]; then
        cat ~/Productivity/.current-task
    else
        echo "No current task set"
        echo "Use: echo 'task name' > ~/Productivity/.current-task"
    fi
    echo "════════════════════════════════════"
    echo "⏰ $(date '+%H:%M')"
    echo "Press Ctrl+C to close"
    sleep 60
done
EOF
    chmod +x ~/bin/task-widget
    
    # Urgent reminder system
    cat > ~/bin/urgent-reminder << 'EOF'
#!/bin/bash
echo "⚠️ Setting urgent reminder..."
echo "What needs to be remembered?"
read reminder
echo "In how many minutes?"
read minutes
echo "Setting reminder for $minutes minutes: $reminder"
(sleep $((minutes * 60)) && notify-send "⚠️ URGENT REMINDER" "$reminder" && zenity --warning --text="$reminder") &
echo "Reminder set! Process ID: $!"
EOF
    chmod +x ~/bin/urgent-reminder
    
    echo "[✓] Visual reminder system created"
}

setup_work_context_switching() {
    echo "[*] Setting up work context switching..."
    
    # Quick context switcher for different work modes
    cat > ~/bin/work-mode << 'EOF'
#!/bin/bash
echo "🏠 Work Mode Selector"
echo "1) Vacation Rental Management"
echo "2) EdBoiGames Business Development"
echo "3) General Productivity"
echo "4) Break/Recharge Mode"
read -p "Select mode: " mode

case $mode in
    1)
        echo "🏖️ VACATION RENTAL MODE ACTIVATED"
        # Open relevant apps and files
        firefox guntersvillegetaway.com vrbo.com &
        code ~/VacationRental/ &
        notify-send "Vacation Rental Mode" "VRBO, calendar, and cleaning checklist ready"
        echo "vacation-rental" > ~/Productivity/.current-context
        ;;
    2)
        echo "🎮 EDBOIGAMES BD MODE ACTIVATED"
        firefox youtube.com/edboigames &
        code ~/EdBoiGames/ &
        discord &
        notify-send "EdBoiGames Mode" "YouTube, Discord, and BD tools ready"
        echo "edboigames-bd" > ~/Productivity/.current-context
        ;;
    3)
        echo "⚡ GENERAL PRODUCTIVITY MODE"
        ~/bin/kanban
        echo "general" > ~/Productivity/.current-context
        ;;
    4)
        echo "😌 BREAK MODE - Take care of yourself!"
        pkill firefox chrome discord
        echo "break" > ~/Productivity/.current-context
        ;;
esac
EOF
    chmod +x ~/bin/work-mode
    
    echo "[✓] Work context switching ready"
}

create_adhd_dashboard() {
    echo "[*] Creating ADHD-friendly dashboard..."
    
    cat > ~/bin/dashboard << 'EOF'
#!/bin/bash
clear
echo "🌟 BILL'S COMMAND CENTER"
echo "========================"
echo ""
echo "🎯 Current Focus: $(cat ~/Productivity/.current-task 2>/dev/null || echo 'Not set')"
echo "🏠 Work Context: $(cat ~/Productivity/.current-context 2>/dev/null || echo 'None')"
echo "⏰ Time: $(date '+%A, %B %d - %H:%M')"
echo ""
echo "📋 Quick Actions:"
echo "1) Start focus timer       6) Voice note"
echo "2) Check task board        7) Brain dump" 
echo "3) Switch work mode        8) Set reminder"
echo "4) Daily routine           9) Take break"
echo "5) Focus mode (block web)  0) Exit"
echo ""
read -p "Choose action: " action

case $action in
    1) ~/bin/focus-timer ;;
    2) ~/bin/kanban ;;
    3) ~/bin/work-mode ;;
    4) ~/bin/daily-routine ;;
    5) ~/bin/focus-mode ;;
    6) ~/bin/voice-note ;;
    7) ~/bin/brain-dump ;;
    8) ~/bin/urgent-reminder ;;
    9) echo "Take a break! You deserve it 😌"; sleep 3 ;;
    0) exit ;;
esac
EOF
    chmod +x ~/bin/dashboard
    
    echo "[✓] ADHD dashboard created - run 'dashboard' to start"
}

check_productivity_setup() {
    echo "[*] Productivity setup verification:"
    
    # Check installed tools
    tools=("freeplane" "obsidian" "gnome-pomodoro" "flameshot")
    for tool in "${tools[@]}"; do
        if command -v $tool &> /dev/null; then
            echo "✓ $tool: Installed"
        else
            echo "✗ $tool: Not installed"
        fi
    done
    
    # Check custom scripts
    scripts=("kanban" "focus-timer" "brain-dump" "dashboard")
    for script in "${scripts[@]}"; do
        if [ -f ~/bin/$script ]; then
            echo "✓ $script: Ready"
        else
            echo "✗ $script: Missing"
        fi
    done
    
    # Check directories
    if [ -d ~/Productivity ]; then
        echo "✓ Productivity workspace: $(ls ~/Productivity | wc -l) items"
    else
        echo "✗ Productivity workspace: Not created"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This productivity module should be executed by Claude Code"
    echo "Available functions: install_adhd_productivity_tools, setup_visual_task_management, create_adhd_timer_system, setup_memory_aids"
fi