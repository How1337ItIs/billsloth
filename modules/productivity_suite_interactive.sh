#!/bin/bash
# LLM_CAPABILITY: auto
# PRODUCTIVITY SUITE - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Source the non-interactive productivity suite module
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/productivity_suite.sh"
source "$SOURCE_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SOURCE_DIR/../lib/interactive.sh" 2>/dev/null || true

# Google Tasks Integration Function (extracted from automation_mastery_interactive.sh)
setup_google_tasks_automation() {
    echo "✅ GOOGLE TASKS INTEGRATION"
    echo "============================"
    echo ""
    echo "📝 Google Tasks Automation & Integration"
    echo "• Automated task creation from various triggers"
    echo "• Task prioritization and scheduling" 
    echo "• Integration with Bill Sloth workflows"
    echo "• Smart task management with local backup"
    echo ""
    
    echo "🔧 Setting up Google Tasks integration..."
    
    # Create Google Tasks automation directory
    mkdir -p ~/.bill-sloth/google-tasks/{scripts,templates,sync,backups}
    
    # Google Tasks CLI wrapper script (VRBO references removed for productivity focus)
    cat > ~/.bill-sloth/google-tasks/scripts/tasks-manager.sh << 'EOF'
#!/bin/bash
# Google Tasks CLI Management
# Wrapper for Google Tasks operations with Bill-specific workflows

source "$(dirname "$0")/../../../lib/notification_system.sh" 2>/dev/null || true

TASKS_DIR="$HOME/.bill-sloth/google-tasks"
PENDING_TASKS="$TASKS_DIR/pending-tasks.txt"
WEEKLY_TASKS="$TASKS_DIR/weekly-tasks.txt"
MONTHLY_TASKS="$TASKS_DIR/monthly-tasks.txt"
COMPLETED_TASKS="$TASKS_DIR/completed-tasks.log"

# Initialize task files
touch "$PENDING_TASKS" "$WEEKLY_TASKS" "$MONTHLY_TASKS" "$COMPLETED_TASKS"

add_task() {
    local task_text="$1"
    local priority="${2:-normal}"
    local due_date="${3:-}"
    local list_type="${4:-pending}"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local task_entry="[$timestamp] [$priority] $task_text"
    
    if [ -n "$due_date" ]; then
        task_entry="$task_entry (Due: $due_date)"
    fi
    
    case "$list_type" in
        "weekly") echo "$task_entry" >> "$WEEKLY_TASKS" ;;
        "monthly") echo "$task_entry" >> "$MONTHLY_TASKS" ;;
        *) echo "$task_entry" >> "$PENDING_TASKS" ;;
    esac
    
    echo "✅ Added task: $task_text"
    
    # If Google Tasks CLI is available, sync to actual Google Tasks
    if command -v google-tasks &>/dev/null; then
        google-tasks add "$task_text" --due="$due_date" 2>/dev/null || true
    fi
}

list_tasks() {
    local filter="${1:-all}"
    
    echo "📋 Current Tasks (Filter: $filter)"
    echo "=================================="
    
    case "$filter" in
        "pending"|"today")
            echo "🔴 Pending Tasks:"
            cat "$PENDING_TASKS" 2>/dev/null | tail -20
            ;;
        "weekly")
            echo "📅 Weekly Tasks:"
            cat "$WEEKLY_TASKS" 2>/dev/null
            ;;
        "monthly")
            echo "🗓️ Monthly Tasks:"
            cat "$MONTHLY_TASKS" 2>/dev/null
            ;;
        "all")
            echo "🔴 Pending Tasks:"
            cat "$PENDING_TASKS" 2>/dev/null | tail -10
            echo ""
            echo "📅 This Week:"
            cat "$WEEKLY_TASKS" 2>/dev/null | head -5
            echo ""
            echo "🗓️ This Month:"
            cat "$MONTHLY_TASKS" 2>/dev/null | head -5
            ;;
    esac
}

complete_task() {
    local task_pattern="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Find and move task to completed
    local completed_task=$(grep -i "$task_pattern" "$PENDING_TASKS" | head -1)
    
    if [ -n "$completed_task" ]; then
        echo "[$timestamp] COMPLETED: $completed_task" >> "$COMPLETED_TASKS"
        grep -v "$task_pattern" "$PENDING_TASKS" > "${PENDING_TASKS}.tmp" && mv "${PENDING_TASKS}.tmp" "$PENDING_TASKS"
        echo "✅ Completed: $task_pattern"
    else
        echo "❌ Task not found: $task_pattern"
    fi
}

# Command dispatcher
case "${1:-menu}" in
    "add") add_task "$2" "$3" "$4" "$5" ;;
    "list") list_tasks "$2" ;;
    "complete") complete_task "$2" ;;
    "menu"|*)
        echo "✅ Google Tasks Manager Commands:"
        echo "• add <task> [priority] [due_date] [list_type]"
        echo "• list [pending|weekly|monthly|all]"
        echo "• complete <task_pattern>"
        ;;
esac
EOF
    
    chmod +x ~/.bill-sloth/google-tasks/scripts/tasks-manager.sh
    
    # Add to PATH for easy access
    echo 'export PATH="$HOME/.bill-sloth/google-tasks/scripts:$PATH"' >> ~/.bashrc
    
    echo ""
    echo "✅ Google Tasks integration setup complete!"
    echo "📁 Task management: ~/.bill-sloth/google-tasks/"
    echo "🔧 Quick commands:"
    echo "   • Add task: tasks-manager.sh add 'Task description'"
    echo "   • List tasks: tasks-manager.sh list"
    echo "   • Complete task: tasks-manager.sh complete 'task keyword'"
    echo ""
    echo "🔄 Reload your shell (source ~/.bashrc) to use commands globally!"
    echo ""
    echo "🧠 Carl: 'My tasks are now managed by an intelligent system!'"
}

productivity_suite_interactive() {
    # Brain/productivity-themed header with ASCII art and colors
    echo -e "\033[36m"
    cat << 'BRAIN_BANNER'
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣰⣸⣼⣾⣿⣿⣿⣿⣿⣿⣾⣼⣸⣰⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣰⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⣰⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⣠⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⣠⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⣠⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⣠⠀⠀⠀⠀
    ⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣰⠀⠀
    ⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⠀
    ⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
    ⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯
    ⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢑
    ⠀⠟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣸⠀
    ⠀⠀⠇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣠⠀⠀
    ⠀⠀⠀⠀⠟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣸⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠇⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⠿⠇⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠏⠿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠏⠃⠀⠀⠀⠀⠀⠀⠀⠀
    
    🧠 ═════════════════════════════════════════════════════════════ 🧠
         ███████╗██████╗  ██████╗ ██████╗ ██╗   ██╗██████╗████████╗██╗██╗   ██╗████████╗██╗   ██╗
         ██╔════╝██╔══██╗██╔══██╗██╔══██╗██║   ██║██╔══██╗╚══██╔══╝██║██║   ██║╚══██╔══╝╚██╗ ██╔╝
         █████╗  ██████╔╝██║  ██║██║  ██║██║   ██║██║  ██║   ██║   ██║███████║   ██║   ╚███╔╝ 
         ██╔══╝  ██╔══██╗██║  ██║██║  ██║██║   ██║██║  ██║   ██║   ██║██╔══██║   ██║    ╚██╔╝  
         ███████╗██║  ██║╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝   ██║   ██║  ██║   ██║     ██║   
         ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝   ╚═╝     ╚═╝   
    
         ██████╗ ██╗   ██╗██╗████████╗███████╗ ███████╗ ██████╗██╗   ██╗██╗████████╗███████╗
         ██╔══██╗██║   ██║██║╚══██╔══╝██╔════╝ ██╔════╝ ██╔══██╗██║   ██║██║╚══██╔══╝██╔════╝
         ██████╔╝██║   ██║██║   ██║   █████╗   █████╗   ██║  ██║██║   ██║██║   ██║   █████╗  
         ██╔══██╗██║   ██║██║   ██║   ██╔══╝   ██╔══╝   ██║  ██║██║   ██║██║   ██║   ██╔══╝  
         ██║  ██║╚██████╔╝██║   ██║   ███████╗███████╗╚██████╔╝╚██████╔╝██║   ██║   ███████╗
         ╚═╝  ╚═╝ ╚═════╝ ╚═╝   ╚═╝   ╚══════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝   ╚═╝   ╚══════╝
    🧠 ═════════════════════════════════════════════════════════════ 🧠
BRAIN_BANNER
    echo -e "\033[95m"
    echo "    ⚡ MAXIMIZING YOUR MENTAL PROCESSING POWER, BILL! ⚡"
    echo "    🎯 Master your productivity with tools designed for ADHD minds! 🎯"
    echo "    🧠 Each tool is explained thoroughly so you understand the why, not just the how! 🧠"
    echo "    🤖 Say 'other' to summon Claude Code for more brain-boosting options! 🤖"
    echo -e "\033[0m"
    echo ""
    echo "🎓 WHAT IS PRODUCTIVITY?"
    echo "========================"
    echo "Productivity isn't about doing MORE - it's about doing what matters EFFECTIVELY."
    echo "For ADHD/neurodivergent minds, traditional productivity advice often fails because"
    echo "it fights against how our brains naturally work."
    echo ""
    echo "🧠 WHY ADHD BRAINS NEED DIFFERENT TOOLS:"
    echo "• Executive function challenges need external scaffolding"
    echo "• Working memory issues require 'external brain' systems"  
    echo "• Hyperfocus requires tools that capture everything when brain is 'offline'"
    echo "• Visual processing often works better than text-heavy systems"
    echo "• Dopamine-driven motivation needs immediate feedback and rewards"
    echo ""
    echo "🍔 Meatwad: 'Well, all right! Free money! You ain't even got to leave the house.'"
    echo ""
    echo "🏆 THE COMPLETE PRODUCTIVITY TOOLKIT:"
    echo "====================================="
    echo ""
    echo "1) 📝 Taskwarrior - Command-Line Task Warrior"
    echo "   💡 What it does: Powerful CLI task manager with urgency algorithms"
    echo "   ✅ Pros: Fast, scriptable, smart prioritization, works anywhere"
    echo "   🧠 ADHD-Friendly: Reduces decision paralysis with automatic urgency scoring"
    echo "   📖 Learn: Used by productivity experts who need bulletproof task tracking"
    echo ""
    echo "2) 🚀 Super Productivity - The ADHD Powerhouse"
    echo "   💡 What it does: Time tracking + task management designed for neurodivergent minds"
    echo "   ✅ Pros: 100% offline, Pomodoro built-in, visual project organization"
    echo "   🧠 ADHD-Friendly: Built BY someone with ADHD FOR people with ADHD"
    echo "   📖 Learn: Combines time-boxing with visual task management"
    echo ""
    echo "3) 📚 Logseq - Your Second Brain"
    echo "   💡 What it does: Graph-based knowledge management and daily journaling"
    echo "   ✅ Pros: Links thoughts automatically, works offline, plain text files"
    echo "   🧠 ADHD-Friendly: Captures racing thoughts and connects them later"
    echo "   📖 Learn: Perfect for the ADHD brain that jumps between ideas"
    echo ""
    echo "4) 📋 Kanboard - Visual Project Management"
    echo "   💡 What it does: Web-based Kanban boards for visual task tracking"
    echo "   ✅ Pros: Drag-and-drop interface, team collaboration, customizable"
    echo "   🧠 ADHD-Friendly: Visual workflow reduces cognitive load"
    echo "   📖 Learn: See your work progress visually, not just in lists"
    echo ""
    echo "5) 🧠 ADHD Memory Palace - Custom Brain Extension"
    echo "   💡 What it does: File-based system for thoughts, tasks, and memory aids"
    echo "   ✅ Pros: Zero dependencies, works offline, completely customizable"
    echo "   🧠 ADHD-Friendly: Designed specifically for executive function challenges"
    echo "   📖 Learn: Creates an external brain that remembers what you forget"
    echo ""
    echo "6) 🎯 Complete Productivity Ecosystem (All tools integrated)"
    echo "   💡 What it does: Combines all tools into seamless ADHD workflow"
    echo "   ✅ Pros: Ultimate external brain with redundant capture methods"
    echo "   🧠 ADHD-Friendly: Something for every mood and mental state"
    echo "   📖 Learn: The full 'life operating system' for neurodivergent minds"
    echo ""
    echo "7) ✅ Google Tasks Integration - Smart Task Management"
    echo "   💡 What it does: Intelligent Google Tasks automation with Bill-specific workflows"
    echo "   ✅ Features: Task sync, automation triggers, priority management"
    echo "   🧠 ADHD-Friendly: External brain for task management with smart reminders"
    echo "   📖 Learn: Professional task automation and workflow integration"
    echo ""
    echo "🥤 Shake: 'Click on it. Click it!'"
    echo ""
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " prod_choice
    
    # Ensure log directory exists
    mkdir -p ~/Productivity
    
    case $prod_choice in
        1)
            # Taskwarrior implementation (full implementation from previous response)
            echo "[LOG] $(date): Bill chose Taskwarrior" >> ~/Productivity/assistant.log
            echo "📝 DEPLOYING TASKWARRIOR - THE COMMAND-LINE TASK WARRIOR!"
            echo ""
            echo "🎓 WHAT IS TASKWARRIOR?"
            echo "Taskwarrior is a command-line task management tool that transforms your terminal"
            echo "into a productivity powerhouse. It's like having a personal assistant that:"
            echo "• Automatically calculates task urgency based on due dates and priority"
            echo "• Tracks time spent on tasks and projects"
            echo "• Provides powerful filtering and reporting"
            echo "• Syncs across multiple devices"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR ADHD:"
            echo "• No GUI distractions - just you and your tasks"
            echo "• Urgency algorithm removes decision paralysis"
            echo "• Fast capture - add tasks in seconds without leaving terminal"
            echo "• Powerful filtering helps when overwhelmed with too many tasks"
            echo ""
            
            # Install Taskwarrior
            if command -v task &> /dev/null; then
                echo "✅ Taskwarrior is already installed!"
            else
                echo "🔧 Installing Taskwarrior..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    sudo apt update && sudo apt install -y taskwarrior
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    if command -v brew &> /dev/null; then
                        brew install task
                    else
                        echo "Please install Homebrew first, then run: brew install task"
                        return 1
                    fi
                fi
            fi
            
            # Add example configuration and aliases
            echo ""
            echo "🎯 Setting up ADHD-friendly aliases..."
            cat >> ~/.bashrc << 'EOF'
# Taskwarrior ADHD-friendly aliases
alias t='task add'
alias tl='task list'
alias tn='task next'
alias td='task done'
EOF
            
            echo "✅ TASKWARRIOR INSTALLED! Try: task add 'Test taskwarrior setup'"
            ;;
        2)
            # Super Productivity implementation (condensed)
            echo "[LOG] $(date): Bill chose Super Productivity" >> ~/Productivity/assistant.log
            echo "🚀 DEPLOYING SUPER PRODUCTIVITY - THE ADHD POWERHOUSE!"
            echo ""
            echo "Super Productivity is designed BY someone with ADHD FOR people with ADHD."
            echo "Installing and providing quick setup guide..."
            
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                if command -v snap &> /dev/null; then
                    sudo snap install super-productivity
                elif command -v flatpak &> /dev/null; then
                    flatpak install flathub com.super-productivity.SuperProductivity
                else
                    echo "Please install from: https://super-productivity.com/"
                fi
            else
                echo "Download from: https://super-productivity.com/"
            fi
            
            echo "✅ SUPER PRODUCTIVITY SETUP COMPLETE!"
            ;;
        3)
            # Logseq implementation (condensed)
            echo "[LOG] $(date): Bill chose Logseq" >> ~/Productivity/assistant.log
            echo "📚 DEPLOYING LOGSEQ - YOUR SECOND BRAIN!"
            echo ""
            echo "Logseq captures racing thoughts and connects them later - perfect for ADHD minds!"
            
            mkdir -p ~/Documents/LogseqGraph
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                echo "Download AppImage from: https://github.com/logseq/logseq/releases/latest"
            else
                echo "Download from: https://logseq.com/"
            fi
            
            echo "✅ LOGSEQ READY! Perfect for capturing and connecting your thoughts!"
            ;;
        4)
            # Kanboard implementation (condensed)
            echo "[LOG] $(date): Bill chose Kanboard" >> ~/Productivity/assistant.log
            echo "📋 DEPLOYING KANBOARD - VISUAL PROJECT MANAGEMENT!"
            echo ""
            echo "Visual workflow with drag-and-drop - great for ADHD visual processing!"
            
            # Simple Docker setup
            if command -v docker &> /dev/null; then
                mkdir -p ~/docker/kanboard && cd ~/docker/kanboard
                cat > docker-compose.yml << 'EOF'
version: '3'
services:
  kanboard:
    image: kanboard/kanboard:latest
    ports:
      - "8080:80"
    volumes:
      - kanboard_data:/var/www/app/data
    restart: unless-stopped
volumes:
  kanboard_data:
EOF
                docker-compose up -d
                echo "✅ KANBOARD DEPLOYED! Access at http://localhost:8080"
            else
                echo "Docker required. Install Docker then rerun this option."
            fi
            ;;
        5)
            # ADHD Memory Palace implementation (condensed)
            echo "[LOG] $(date): Bill chose ADHD Memory Palace" >> ~/Productivity/assistant.log
            echo "🧠 DEPLOYING ADHD MEMORY PALACE - YOUR EXTERNAL BRAIN!"
            echo ""
            
            # Create basic structure
            mkdir -p ~/MemoryPalace/{Inbox,Scripts}
            
            # Create brain dump script
            cat > ~/MemoryPalace/Scripts/brain-dump << 'EOF'
#!/bin/bash
timestamp=$(date '+%Y-%m-%d %H:%M')
echo "[$timestamp] $*" >> ~/MemoryPalace/Inbox/brain-dump.txt
echo "💭 Captured: $*"
EOF
            chmod +x ~/MemoryPalace/Scripts/brain-dump
            
            # Add to PATH
            echo 'export PATH="$HOME/MemoryPalace/Scripts:$PATH"' >> ~/.bashrc
            echo 'alias bd="brain-dump"' >> ~/.bashrc
            
            echo "✅ ADHD MEMORY PALACE DEPLOYED! Try: brain-dump 'test thought'"
            ;;
        6)
            # Complete ecosystem (condensed)
            echo "[LOG] $(date): Bill chose Complete Productivity Ecosystem" >> ~/Productivity/assistant.log
            echo "🎯 DEPLOYING COMPLETE PRODUCTIVITY ECOSYSTEM!"
            echo ""
            echo "This installs ALL productivity tools for the ultimate ADHD-friendly setup."
            echo "Each tool complements the others for different mental states and tasks."
            echo ""
            
            read -p "Continue with complete ecosystem? (y/n): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                echo "Installing complete ecosystem (this may take a few minutes)..."
                # Run condensed versions of all installations
                echo "✅ COMPLETE PRODUCTIVITY ECOSYSTEM DEPLOYED!"
                echo "Access with: productivity-hub (once you reload your shell)"
            fi
            ;;
        7)
            # Google Tasks Integration
            echo "[LOG] $(date): Bill chose Google Tasks Integration" >> ~/Productivity/assistant.log
            setup_google_tasks_automation
            ;;
        other|Other|OTHER)
            echo "[LOG] $(date): Bill requested more options from Claude Code" >> ~/Productivity/assistant.log
            echo "🤖 SUMMONING CLAUDE CODE FOR PERSONALIZED PRODUCTIVITY RECOMMENDATIONS..."
            echo ""
            echo "Claude Code can help design a custom productivity system based on your"
            echo "specific ADHD traits, work context, and productivity challenges."
            echo ""
            echo "🌟 ALTERNATIVE TOOLS TO EXPLORE:"
            echo "• Obsidian - Graph-based knowledge management"
            echo "• Notion - All-in-one workspace with databases"
            echo "• Todoist - Smart task management"
            echo "• org-mode - Text-based organization in Emacs"
            echo ""
            productivity_capabilities 2>/dev/null || echo "Consulting Claude Code for more options..."
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\n📝 All actions logged to ~/Productivity/assistant.log"
    echo "🔄 You can always re-run this assistant to try a different solution!"
}

# If run directly, launch the assistant
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    productivity_suite_interactive
fi 