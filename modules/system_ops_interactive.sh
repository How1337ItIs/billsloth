#!/bin/bash
# LLM_CAPABILITY: auto
# SYSTEM OPS - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Source the non-interactive system ops module
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/system_ops.sh"
source "$SOURCE_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SOURCE_DIR/../lib/interactive.sh" 2>/dev/null || true

# GitHub Authentication Setup Function (extracted from automation_mastery_interactive.sh)
setup_github_authentication() {
    echo "🔗 GITHUB AUTHENTICATION SETUP"
    echo "==============================="
    echo ""
    echo "🐙 GitHub Integration for Bill Sloth System"
    echo "• Secure authentication for repository access"
    echo "• Personal Access Token (PAT) configuration"
    echo "• SSH key setup for seamless git operations"
    echo "• Integration with Claude Code workflows"
    echo ""
    
    echo "📋 GitHub Authentication Options:"
    echo "1) Setup Personal Access Token (recommended for HTTPS)"
    echo "2) Setup SSH Key Authentication"
    echo "3) Configure Git credentials"
    echo "4) Test GitHub connectivity"
    echo "5) Complete GitHub setup for Bill Sloth"
    echo ""
    
    local auth_choice
    read -p "Select authentication method (1-5): " auth_choice
    
    case "$auth_choice" in
        1)
            echo "🔐 Personal Access Token Setup"
            echo "============================="
            echo ""
            echo "📝 Step-by-step PAT configuration:"
            echo "1. Go to GitHub.com → Settings → Developer settings → Personal access tokens"
            echo "2. Click 'Generate new token (classic)'"
            echo "3. Set expiration to 'No expiration' (for convenience)"
            echo "4. Select these scopes:"
            echo "   ✅ repo (Full control of private repositories)"
            echo "   ✅ workflow (Update GitHub Action workflows)"
            echo "   ✅ write:packages (Upload packages to GitHub Package Registry)"
            echo "   ✅ delete:packages (Delete packages from GitHub Package Registry)"
            echo "   ✅ user:email (Access user email addresses)"
            echo ""
            
            echo "⚠️  IMPORTANT SECURITY NOTES:"
            echo "• Never share your PAT with anyone"
            echo "• Store it securely in the system credential manager"
            echo "• Use environment variables, not hard-coded in scripts"
            echo ""
            
            read -p "📋 Have you created your PAT? (y/n): " pat_created
            
            if [[ $pat_created == "y" ]]; then
                echo ""
                echo "🔐 PAT Configuration:"
                read -p "GitHub username: " github_username
                read -s -p "Personal Access Token: " github_token
                echo ""
                
                # Store credentials securely
                mkdir -p ~/.bill-sloth/github
                chmod 700 ~/.bill-sloth/github
                
                # Create secure credential file
                cat > ~/.bill-sloth/github/credentials << EOF
# GitHub Credentials for Bill Sloth System
# Created: $(date)
GITHUB_USERNAME="$github_username"
GITHUB_TOKEN="$github_token"
GITHUB_CONFIGURED=true
EOF
                chmod 600 ~/.bill-sloth/github/credentials
                
                # Configure git to use the token
                git config --global user.name "$github_username"
                read -p "GitHub email address: " github_email
                git config --global user.email "$github_email"
                
                # Set up credential helper
                git config --global credential.helper store
                
                echo "https://$github_username:$github_token@github.com" > ~/.git-credentials
                chmod 600 ~/.git-credentials
                
                echo ""
                echo "✅ GitHub PAT configured successfully!"
                echo "🔧 Testing authentication..."
                
                # Test the authentication
                if curl -s -H "Authorization: token $github_token" https://api.github.com/user >/dev/null; then
                    echo "✅ GitHub authentication test successful!"
                    echo "✅ Authentication configured for $github_username"
                else
                    echo "❌ Authentication test failed - please check your token"
                fi
            else
                echo "📝 Please create your PAT first, then run this setup again"
            fi
            ;;
        2)
            echo "🔑 SSH Key Authentication Setup"
            echo "==============================="
            echo ""
            
            # Check if SSH key exists
            if [ -f ~/.ssh/id_rsa.pub ] || [ -f ~/.ssh/id_ed25519.pub ]; then
                echo "✅ Existing SSH key found"
                echo ""
                echo "📋 Your public SSH key:"
                [ -f ~/.ssh/id_ed25519.pub ] && cat ~/.ssh/id_ed25519.pub || cat ~/.ssh/id_rsa.pub
                echo ""
                echo "📝 Add this key to your GitHub account:"
                echo "1. Go to GitHub.com → Settings → SSH and GPG keys"
                echo "2. Click 'New SSH key'"
                echo "3. Paste the key above"
                echo "4. Give it a title like 'Bill Sloth System'"
            else
                echo "🔧 Generating new SSH key..."
                read -p "📧 Enter your GitHub email: " github_email
                
                # Generate Ed25519 key (more secure)
                ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519 -N ""
                
                echo ""
                echo "✅ SSH key generated!"
                echo ""
                echo "📋 Your new public SSH key:"
                cat ~/.ssh/id_ed25519.pub
                echo ""
                echo "📝 Add this key to GitHub (instructions above)"
            fi
            
            # Start SSH agent and add key
            eval "$(ssh-agent -s)"
            [ -f ~/.ssh/id_ed25519 ] && ssh-add ~/.ssh/id_ed25519 || ssh-add ~/.ssh/id_rsa
            
            echo ""
            echo "🔧 Testing SSH connection to GitHub..."
            ssh -T git@github.com -o StrictHostKeyChecking=no || true
            echo ""
            echo "📝 If you see 'successfully authenticated', SSH is working!"
            ;;
        3)
            echo "⚙️ Git Global Configuration"
            echo "=========================="
            echo ""
            
            read -p "📛 Your name (for git commits): " git_name
            read -p "📧 Your email (GitHub email): " git_email
            
            git config --global user.name "$git_name"
            git config --global user.email "$git_email"
            git config --global init.defaultBranch main
            git config --global pull.rebase false
            
            echo ""
            echo "✅ Git configuration complete!"
            echo "📋 Current settings:"
            echo "• Name: $(git config --global user.name)"
            echo "• Email: $(git config --global user.email)"
            echo "• Default branch: $(git config --global init.defaultBranch)"
            ;;
        4)
            echo "🔍 Testing GitHub Connectivity"
            echo "=============================="
            echo ""
            
            echo "🔧 Running GitHub connectivity tests..."
            
            # Test 1: Basic GitHub API access
            echo "1. Testing GitHub API access..."
            if curl -s https://api.github.com/zen >/dev/null; then
                echo "   ✅ GitHub API accessible"
            else
                echo "   ❌ GitHub API not accessible"
            fi
            
            # Test 2: Authentication test
            echo "2. Testing authentication..."
            if [ -f ~/.bill-sloth/github/credentials ]; then
                source ~/.bill-sloth/github/credentials
                if curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user >/dev/null; then
                    echo "   ✅ Token authentication working"
                else
                    echo "   ❌ Token authentication failed"
                fi
            else
                echo "   ⚠️  No stored credentials found"
            fi
            
            # Test 3: SSH test
            echo "3. Testing SSH connection..."
            if ssh -T git@github.com -o ConnectTimeout=5 -o StrictHostKeyChecking=no 2>&1 | grep -q "successfully authenticated"; then
                echo "   ✅ SSH authentication working"
            else
                echo "   ❌ SSH authentication not configured"
            fi
            
            # Test 4: Git configuration
            echo "4. Checking git configuration..."
            if git config --global user.name >/dev/null && git config --global user.email >/dev/null; then
                echo "   ✅ Git configured with user details"
            else
                echo "   ⚠️  Git user details not configured"
            fi
            ;;
        5)
            echo "🚀 Complete GitHub Setup for Bill Sloth"
            echo "====================================="
            echo ""
            echo "🔧 Running comprehensive GitHub setup..."
            
            # Check if already configured
            if [ -f ~/.bill-sloth/github/credentials ] && git config --global user.name >/dev/null; then
                echo "✅ GitHub already configured!"
                source ~/.bill-sloth/github/credentials
                echo "• Username: $GITHUB_USERNAME"
                echo "• Git name: $(git config --global user.name)"
                echo "• Git email: $(git config --global user.email)"
            else
                echo "🔧 Setting up GitHub integration..."
                
                # Get user details
                read -p "📛 GitHub username: " github_username
                read -p "📧 GitHub email: " github_email
                read -p "📛 Your full name (for commits): " full_name
                
                # Configure git
                git config --global user.name "$full_name"
                git config --global user.email "$github_email"
                git config --global init.defaultBranch main
                git config --global pull.rebase false
                
                echo ""
                echo "✅ Git configuration complete!"
                
                # Prompt for authentication method
                echo ""
                echo "🔐 Authentication Setup:"
                echo "1) Personal Access Token (recommended)"
                echo "2) SSH Key"
                echo ""
                read -p "Select method (1-2): " auth_method
                
                if [ "$auth_method" = "1" ]; then
                    echo ""
                    echo "📝 Please create a Personal Access Token:"
                    echo "1. Visit: https://github.com/settings/tokens"
                    echo "2. Generate new token with 'repo' and 'workflow' scopes"
                    echo "3. Copy the token"
                    echo ""
                    read -s -p "🔐 Paste your PAT here: " github_token
                    echo ""
                    
                    # Store credentials
                    mkdir -p ~/.bill-sloth/github
                    chmod 700 ~/.bill-sloth/github
                    
                    cat > ~/.bill-sloth/github/credentials << EOF
GITHUB_USERNAME="$github_username"
GITHUB_TOKEN="$github_token"
GITHUB_CONFIGURED=true
EOF
                    chmod 600 ~/.bill-sloth/github/credentials
                    
                    # Set up credential helper
                    git config --global credential.helper store
                    echo "https://$github_username:$github_token@github.com" > ~/.git-credentials
                    chmod 600 ~/.git-credentials
                    
                    echo "✅ PAT authentication configured!"
                elif [ "$auth_method" = "2" ]; then
                    # SSH setup (simplified)
                    if [ ! -f ~/.ssh/id_ed25519 ]; then
                        ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519 -N ""
                        eval "$(ssh-agent -s)"
                        ssh-add ~/.ssh/id_ed25519
                    fi
                    
                    echo "✅ SSH key generated!"
                    echo "📋 Add this key to GitHub:"
                    cat ~/.ssh/id_ed25519.pub
                fi
            fi
            
            echo ""
            echo "🎯 GitHub Setup Complete for Bill Sloth System!"
            echo "📋 Next steps:"
            echo "• Your GitHub authentication is configured"
            echo "• Git is set up with your details"
            echo "• You can now clone, push, and pull repositories"
            echo "• Claude Code can access your GitHub repositories"
            echo ""
            echo "🔧 Test with: git clone https://github.com/[username]/[repo-name]"
            ;;
        *)
            echo "Invalid choice - running complete setup"
            setup_github_authentication
            ;;
    esac
    
    echo ""
    echo "📚 GitHub Authentication Documentation:"
    echo "• Credentials stored in: ~/.bill-sloth/github/"
    echo "• Git config: git config --global --list"
    echo "• Test connection: ssh -T git@github.com"
    echo "• API test: curl -H 'Authorization: token <PAT>' https://api.github.com/user"
}

system_ops_interactive() {
    echo "🔧 SYSTEM OPERATIONS - YOUR DIGITAL MECHANIC"
    echo "============================================="
    echo ""
    echo "🎯 Master your system like a pro with tools designed for efficiency,"
    echo "troubleshooting, and keeping your Linux machine running perfectly!"
    echo ""
    echo "🧠 Carl: 'Well, let's compute it, and I will solve the answer... to your face!'"
    echo ""
    
    echo "🎓 WHAT ARE SYSTEM OPERATIONS?"
    echo "=============================="
    echo "System operations (SysOps) is the art of keeping computers running smoothly."
    echo "It's like being a digital mechanic - you monitor, maintain, troubleshoot,"
    echo "and optimize your system for peak performance."
    echo ""
    echo "🧠 WHY SYSTEM OPS MATTERS:"
    echo "• Prevents problems before they occur"
    echo "• Saves time by automating repetitive tasks"
    echo "• Helps troubleshoot when things go wrong"
    echo "• Keeps your system secure and updated"
    echo "• Makes you more productive and less frustrated"
    echo ""
    echo "🧠 WHY ADHD BRAINS NEED GOOD SYSTEM TOOLS:"
    echo "• Executive function challenges need external systems"
    echo "• Hyperfocus sessions require stable, fast systems"
    echo "• Visual tools help process information quickly"
    echo "• Automated maintenance reduces cognitive load"
    echo "• Quick reference tools support working memory"
    echo ""
    echo "🍔 Meatwad: 'I understand! Sometimes computers get sad and need help!'"
    echo ""
    echo "🏆 THE COMPLETE SYSTEM OPS TOOLKIT:"
    echo "=================================="
    echo ""
    echo "1) 📊 VisiData - Data Exploration Powerhouse"
    echo "   💡 What it does: Explore CSV, JSON, databases in terminal"
    echo "   ✅ Pros: Lightning fast, handles huge datasets, intuitive"
    echo "   🧠 ADHD-Friendly: Visual data navigation, no GUI distractions"
    echo "   📖 Learn: Essential for system logs, monitoring data, analysis"
    echo ""
    echo "2) 📚 TLDR Pages - Command Cheat Sheets"
    echo "   💡 What it does: Concise examples for command-line tools"
    echo "   ✅ Pros: Quick reference, practical examples, community-driven"
    echo "   🧠 ADHD-Friendly: No overwhelming man pages, just what you need"
    echo "   📖 Learn: Perfect for when you know what you want but not how"
    echo ""
    echo "3) 📖 Zeal - Offline Documentation Browser"
    echo "   💡 What it does: Browse documentation without internet"
    echo "   ✅ Pros: Fast search, 200+ docsets, distraction-free"
    echo "   🧠 ADHD-Friendly: Offline = no web distractions, instant search"
    echo "   📖 Learn: Always have answers, even without internet"
    echo ""
    echo "4) 📊 Glances - Real-time System Monitor"
    echo "   💡 What it does: Beautiful system monitoring in terminal"
    echo "   ✅ Pros: Real-time stats, web interface, highly customizable"
    echo "   🧠 ADHD-Friendly: Visual dashboard, color-coded alerts"
    echo "   📖 Learn: Keep tabs on system health at a glance"
    echo ""
    echo "5) 🧹 Stacer - System Cleaner & Optimizer"
    echo "   💡 What it does: GUI system cleaner and performance monitor"
    echo "   ✅ Pros: Easy cleanup, startup manager, visual feedback"
    echo "   🧠 ADHD-Friendly: Point-and-click interface, immediate results"
    echo "   📖 Learn: Keep system clean without command-line complexity"
    echo ""
    echo "6) 🌐 Cockpit - Web-based System Management"
    echo "   💡 What it does: Manage system through web browser"
    echo "   ✅ Pros: Remote access, visual interface, multi-server support"
    echo "   🧠 ADHD-Friendly: Familiar web interface, visual system state"
    echo "   📖 Learn: Professional system management made simple"
    echo ""
    echo "7) 🚀 Complete SysOps Suite (All tools integrated)"
    echo "   💡 What it does: Full system operations toolkit"
    echo "   ✅ Pros: Tool for every situation, comprehensive coverage"
    echo "   🧠 ADHD-Friendly: Options for every mood and need"
    echo "   📖 Learn: The ultimate 'digital mechanic' setup"
    echo ""
    echo "8) 🔗 GitHub Authentication Setup - Secure Git Integration"
    echo "   💡 What it does: Configure GitHub authentication for seamless git operations"
    echo "   ✅ Features: PAT setup, SSH keys, credential management"
    echo "   🧠 ADHD-Friendly: Step-by-step authentication with automated testing"
    echo "   📖 Learn: Professional git workflow configuration"
    echo ""
    echo "🧠 Frylock: 'What part of no did you not understand?'"
    echo "🥤 Shake: 'Click yes for yes!'"
    echo ""
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " sys_choice
    
    # Ensure log directory exists
    mkdir -p ~/system_ops
    
    case $sys_choice in
        1)
            echo "[LOG] Bill chose VisiData" >> ~/system_ops/assistant.log
            echo "📊 DEPLOYING VISIDATA - DATA EXPLORATION POWERHOUSE!"
            echo ""
            echo "🎓 WHAT IS VISIDATA?"
            echo "VisiData is a terminal-based interactive multitool for tabular data."
            echo "Think of it as Excel for the command line, but way more powerful:"
            echo "• Open CSV, JSON, TSV, Excel, SQLite, and 30+ formats"
            echo "• Navigate huge datasets instantly"
            echo "• Filter, sort, aggregate data with keystrokes"
            echo "• Export results to any format"
            echo "• Works entirely in terminal - no GUI needed"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR ADHD SYSTEM ADMINS:"
            echo "• Visual data exploration reduces cognitive load"
            echo "• Keyboard shortcuts for instant navigation"
            echo "• No mouse required - perfect for hyperfocus"
            echo "• Handles system logs, monitoring data, config files"
            echo "• Quick data analysis without context switching"
            echo ""
            
            # Install VisiData
            if command -v vd &> /dev/null; then
                echo "✅ VisiData is already installed!"
            else
                echo "🔧 Installing VisiData..."
                if command -v pip3 &> /dev/null; then
                    pip3 install --user visidata
                elif command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y python3-pip
                    pip3 install --user visidata
                elif command -v dnf &> /dev/null; then
                    sudo dnf install -y python3-pip
                    pip3 install --user visidata
                else
                    echo "Please install Python3 and pip, then run: pip3 install visidata"
                    return
                fi
                echo "✅ VisiData installed!"
            fi
            
            echo ""
            echo "🚀 VISIDATA FOR SYSTEM OPERATIONS"
            echo "================================="
            echo ""
            echo "🎯 SYSTEM ADMIN USE CASES:"
            echo ""
            echo "📊 ANALYZING LOG FILES:"
            echo "• vd /var/log/syslog - Explore system logs visually"
            echo "• Filter by timestamp, severity, process"
            echo "• Sort by columns to find patterns"
            echo "• Export filtered results for reports"
            echo ""
            echo "📈 MONITORING DATA:"
            echo "• vd monitoring_data.csv - Analyze system metrics"
            echo "• Create pivot tables of CPU/memory usage"
            echo "• Generate histograms of response times"
            echo "• Identify performance bottlenecks"
            echo ""
            echo "⚙️ CONFIGURATION MANAGEMENT:"
            echo "• vd users.csv - Manage user accounts"
            echo "• vd installed_packages.tsv - Review software inventory"
            echo "• Compare configurations across systems"
            echo ""
            echo "🎮 ESSENTIAL VISIDATA KEYBINDINGS:"
            echo ""
            echo "NAVIGATION:"
            echo "• h/j/k/l - Move left/down/up/right (like vim)"
            echo "• g + arrow - Go to edges of data"
            echo "• Ctrl+F/B - Page forward/backward"
            echo "• / - Search for text"
            echo ""
            echo "DATA MANIPULATION:"
            echo "• [ or ] - Sort by current column (asc/desc)"
            echo "• | - Select rows matching pattern"
            echo "• \\ - Unselect rows matching pattern"
            echo "• F - Add frequency table for current column"
            echo ""
            echo "EXPORT & SAVE:"
            echo "• Ctrl+S - Save current sheet"
            echo "• Ctrl+O - Open new file"
            echo "• q - Quit current sheet"
            echo "• Q - Quit VisiData"
            echo ""
            echo "💡 ADHD-FRIENDLY VISIDATA TIPS:"
            echo "• Start with 'vd --tutorial' to learn interactively"
            echo "• Use F1 for help without leaving VisiData"
            echo "• Create aliases for common data files:"
            echo "  alias logs='vd /var/log/syslog'"
            echo "  alias processes='vd <(ps aux)'"
            echo "• Use themes: vd --theme dark (easier on eyes)"
            echo ""
            echo "🎓 LEARNING RESOURCES:"
            echo "• Built-in tutorial: vd --tutorial"
            echo "• Official docs: visidata.org/docs"
            echo "• Video tutorials: Search 'VisiData tutorial' on YouTube"
            echo ""
            echo "✅ VISIDATA READY!"
            echo "Try: vd /var/log/syslog (if it exists) or vd --tutorial"
            echo ""
            echo "🍔 Meatwad: 'I understand! Now I can see data like it's pictures!'"
            ;;
        2)
            echo "[LOG] Bill chose TLDR Pages" >> ~/system_ops/assistant.log
            echo "📚 DEPLOYING TLDR PAGES - COMMAND CHEAT SHEETS!"
            echo ""
            echo "🎓 WHAT ARE TLDR PAGES?"
            echo "TLDR (Too Long; Didn't Read) pages provide concise, practical"
            echo "examples for command-line tools. Instead of overwhelming man pages,"
            echo "you get exactly what you need:"
            echo "• Simple, practical examples"
            echo "• Common use cases covered"
            echo "• Community-maintained and updated"
            echo "• Available for 1000+ commands"
            echo "• Works offline once cached"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR ADHD:"
            echo "• No overwhelming technical documentation"
            echo "• Quick examples you can copy-paste"
            echo "• Reduces cognitive load when learning commands"
            echo "• Perfect for 'I know what I want to do but not how'"
            echo "• Supports working memory with clear examples"
            echo ""
            
            # Install TLDR
            if command -v tldr &> /dev/null; then
                echo "✅ TLDR is already installed!"
            else
                echo "🔧 Installing TLDR..."
                if command -v npm &> /dev/null; then
                    sudo npm install -g tldr
                elif command -v pip3 &> /dev/null; then
                    pip3 install --user tldr
                elif command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y npm
                    sudo npm install -g tldr
                else
                    echo "Please install Node.js/npm or Python3/pip first"
                    return
                fi
                echo "✅ TLDR installed!"
                
                # Update cache
                echo "📦 Updating TLDR database..."
                tldr --update
            fi
            
            echo ""
            echo "🚀 TLDR FOR SYSTEM OPERATIONS"
            echo "============================="
            echo ""
            echo "🎯 SYSTEM ADMIN EXAMPLES:"
            echo ""
            echo "📊 SYSTEM MONITORING:"
            echo "• tldr top - Process monitoring examples"
            echo "• tldr htop - Enhanced process viewer"
            echo "• tldr iotop - Disk I/O monitoring"
            echo "• tldr netstat - Network connection info"
            echo ""
            echo "🧹 SYSTEM MAINTENANCE:"
            echo "• tldr apt - Package management examples"
            echo "• tldr systemctl - Service management"
            echo "• tldr cron - Task scheduling"
            echo "• tldr rsync - File synchronization"
            echo ""
            echo "🔧 FILE OPERATIONS:"
            echo "• tldr find - File searching examples"
            echo "• tldr grep - Text searching in files"
            echo "• tldr sed - Stream editing"
            echo "• tldr awk - Text processing"
            echo ""
            echo "🌐 NETWORK TOOLS:"
            echo "• tldr curl - HTTP requests"
            echo "• tldr wget - File downloads"
            echo "• tldr ssh - Secure shell examples"
            echo "• tldr scp - Secure file copy"
            echo ""
            echo "💡 ADHD-FRIENDLY TLDR WORKFLOW:"
            echo ""
            echo "🔍 QUICK REFERENCE PATTERN:"
            echo "1. Need to do something with a command? → tldr command"
            echo "2. Copy the example that matches your need"
            echo "3. Modify parameters as needed"
            echo "4. Execute with confidence"
            echo ""
            echo "🎯 COMMON SYSTEM TASKS:"
            echo "• 'How do I find large files?' → tldr find"
            echo "• 'How do I check disk usage?' → tldr du"
            echo "• 'How do I monitor processes?' → tldr ps"
            echo "• 'How do I compress files?' → tldr tar"
            echo ""
            echo "⚡ TLDR PRODUCTIVITY TIPS:"
            echo "• Create aliases for common lookups:"
            echo "  alias howto='tldr'"
            echo "  alias examples='tldr'"
            echo "• Use with other tools: tldr grep | grep 'recursive'"
            echo "• Update regularly: tldr --update"
            echo "• Use --list to see all available commands"
            echo ""
            echo "🎓 LEARNING STRATEGY:"
            echo "• When learning a new tool: tldr toolname first"
            echo "• Before reading man pages: check tldr for quick examples"
            echo "• Keep a cheat sheet of your most-used tldr commands"
            echo "• Practice examples in a test directory"
            echo ""
            echo "✅ TLDR PAGES READY!"
            echo "Try: tldr ls  or  tldr --list  or  tldr --random"
            echo ""
            echo "🥤 Shake: 'You need to watch what you agree to,'"
            echo "🥤 Shake: 'cause that one almost took my head off.'"
            ;;
        3)
            echo "[LOG] Bill chose Zeal" >> ~/system_ops/assistant.log
            echo "📖 DEPLOYING ZEAL - OFFLINE DOCUMENTATION BROWSER!"
            echo ""
            echo "🎓 WHAT IS ZEAL?"
            echo "Zeal is an offline documentation browser that gives you instant access"
            echo "to API docs, references, and guides for 200+ programming languages,"
            echo "frameworks, and tools:"
            echo "• Works completely offline"
            echo "• Lightning-fast search across all documentation"
            echo "• 200+ available docsets (Python, JavaScript, Linux, etc.)"
            echo "• Inspired by macOS Dash"
            echo "• No distractions, just documentation"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR ADHD SYSTEM ADMINS:"
            echo "• Offline = no web distractions or rabbit holes"
            echo "• Instant search supports working memory"
            echo "• Clean interface reduces visual overwhelm"
            echo "• Always available during hyperfocus sessions"
            echo "• Reduces context switching between browser tabs"
            echo ""
            
            # Install Zeal
            if command -v zeal &> /dev/null; then
                echo "✅ Zeal is already installed!"
            else
                echo "🔧 Installing Zeal..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    if command -v flatpak &> /dev/null; then
                        flatpak install -y flathub org.zealdocs.Zeal
                    elif command -v snap &> /dev/null; then
                        sudo snap install zeal
                    elif command -v apt &> /dev/null; then
                        sudo apt update && sudo apt install -y zeal
                    elif command -v dnf &> /dev/null; then
                        sudo dnf install -y zeal
                    elif command -v pacman &> /dev/null; then
                        sudo pacman -S zeal
                    else
                        echo "Download from: https://zealdocs.org/download.html"
                        xdg-open https://zealdocs.org/download.html &
                        return
                    fi
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    if command -v brew &> /dev/null; then
                        brew install --cask zeal
                    else
                        echo "Download from: https://zealdocs.org/download.html"
                        open https://zealdocs.org/download.html
                        return
                    fi
                else
                    echo "Download from: https://zealdocs.org/download.html"
                    return
                fi
                echo "✅ Zeal installed!"
            fi
            
            echo ""
            echo "🚀 ZEAL FOR SYSTEM OPERATIONS"
            echo "============================="
            echo ""
            echo "🎯 ESSENTIAL DOCSETS FOR SYSTEM ADMINS:"
            echo ""
            echo "🐧 LINUX & SYSTEM ADMINISTRATION:"
            echo "• Linux - Commands, system calls, configuration"
            echo "• Bash - Shell scripting reference"
            echo "• systemd - Service management"
            echo "• Docker - Container management"
            echo "• Kubernetes - Container orchestration"
            echo ""
            echo "⚙️ CONFIGURATION & AUTOMATION:"
            echo "• Ansible - Configuration management"
            echo "• Terraform - Infrastructure as code"
            echo "• YAML - Configuration file format"
            echo "• JSON - Data interchange format"
            echo "• Regular Expressions - Pattern matching"
            echo ""
            echo "📊 MONITORING & DATABASES:"
            echo "• Prometheus - Metrics and monitoring"
            echo "• Grafana - Data visualization"
            echo "• InfluxDB - Time series database"
            echo "• PostgreSQL - Advanced database"
            echo "• Redis - In-memory data store"
            echo ""
            echo "🌐 NETWORKING & WEB:"
            echo "• HTTP - Protocol reference"
            echo "• nginx - Web server configuration"
            echo "• Apache HTTP Server - Web server docs"
            echo "• OpenSSL - Cryptography and SSL/TLS"
            echo ""
            echo "🛠️ PROGRAMMING FOR SYSADMIN:"
            echo "• Python - Automation and scripting"
            echo "• Go - Systems programming"
            echo "• JavaScript - Web interfaces and Node.js"
            echo "• C - System programming"
            echo ""
            echo "📱 ZEAL USAGE GUIDE:"
            echo ""
            echo "🔍 SEARCHING:"
            echo "• Global search: Just type to search across all docsets"
            echo "• Scoped search: 'python:list' searches only Python docs"
            echo "• Multiple scopes: 'linux,bash:process' searches both docsets"
            echo ""
            echo "⌨️ KEYBOARD SHORTCUTS:"
            echo "• Ctrl+K - Focus search bar"
            echo "• Ctrl+L - Focus docset list"
            echo "• F1 - Toggle sidebar"
            echo "• Ctrl+T - New tab"
            echo "• Ctrl+W - Close tab"
            echo ""
            echo "📋 ORGANIZATION TIPS:"
            echo "• Download docsets for your main tools"
            echo "• Use favorites (star icon) for frequent references"
            echo "• Create custom docsets for internal documentation"
            echo "• Use multiple tabs for cross-referencing"
            echo ""
            echo "💡 ADHD-FRIENDLY ZEAL WORKFLOW:"
            echo ""
            echo "🎯 QUICK REFERENCE PATTERN:"
            echo "1. Need to check syntax? → Open Zeal"
            echo "2. Type tool:keyword (e.g., 'bash:for loop')"
            echo "3. Get answer without web distractions"
            echo "4. Stay focused on your task"
            echo ""
            echo "⚡ PRODUCTIVITY SETUP:"
            echo "• Set global hotkey in settings (Alt+Space recommended)"
            echo "• Keep Zeal always running in background"
            echo "• Download core docsets you use daily"
            echo "• Use 'Recently viewed' for common references"
            echo ""
            echo "🎓 FIRST-TIME SETUP:"
            echo "1. Open Zeal"
            echo "2. Go to File > Preferences > Docsets"
            echo "3. Download: Linux, Bash, Python (essentials)"
            echo "4. Set global hotkey in General preferences"
            echo "5. Start using it whenever you need reference!"
            echo ""
            echo "✅ ZEAL READY!"
            echo "Launch Zeal and download your first docsets from File > Preferences > Docsets"
            echo ""
            echo "🍔 Meatwad: 'Well, all right! Free money!'"
            echo "🥤 Shake: 'You ain't even got to leave the house.'"
            
            read -p "Want to start Zeal now? (y/n): " start_zeal
            if [[ $start_zeal =~ ^[Yy]$ ]]; then
                echo "🚀 Starting Zeal..."
                nohup zeal > /dev/null 2>&1 &
                echo "Don't forget to download docsets: File > Preferences > Docsets"
            fi
            ;;
        4)
            echo "[LOG] Bill chose Glances" >> ~/system_ops/assistant.log
            echo "📊 DEPLOYING GLANCES - SYSTEM MONITOR!"
            echo ""
            echo "Installing Glances..."
            if command -v glances &> /dev/null; then
                echo "✅ Glances is already installed!"
            else
                if command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y glances
                elif command -v dnf &> /dev/null; then
                    sudo dnf install -y glances
                elif command -v pacman &> /dev/null; then
                    sudo pacman -S glances
                else
                    pip3 install --user glances
                fi
                echo "✅ Glances installed!"
            fi
            echo ""
            echo "🎯 GLANCES QUICK START:"
            echo "• glances - Start monitoring"
            echo "• glances -w - Web interface (http://localhost:61208)"
            echo "• Press 'h' in glances for help"
            echo ""
            echo "Starting Glances..."
            glances
            ;;
        5)
            echo "[LOG] Bill chose Stacer" >> ~/system_ops/assistant.log
            echo "🧹 DEPLOYING STACER - SYSTEM CLEANER!"
            echo ""
            if command -v stacer &> /dev/null; then
                echo "✅ Stacer is already installed!"
                stacer &
            else
                echo "📦 Installing Stacer..."
                echo "Visit: https://github.com/oguzhaninan/Stacer/releases"
                echo "Download the .deb file for your system"
                xdg-open https://github.com/oguzhaninan/Stacer/releases &
            fi
            ;;
        6)
            echo "[LOG] Bill chose Cockpit" >> ~/system_ops/assistant.log
            echo "🌐 DEPLOYING COCKPIT - WEB SYSTEM MANAGEMENT!"
            echo ""
            echo "Installing Cockpit..."
            if command -v systemctl &> /dev/null && systemctl is-active --quiet cockpit; then
                echo "✅ Cockpit is already running!"
                echo "Access at: http://localhost:9090"
                xdg-open http://localhost:9090 &
            else
                if command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y cockpit
                    sudo systemctl enable --now cockpit.socket
                elif command -v dnf &> /dev/null; then
                    sudo dnf install -y cockpit
                    sudo systemctl enable --now cockpit.socket
                else
                    echo "Visit: https://cockpit-project.org/ for installation instructions"
                    xdg-open https://cockpit-project.org/ &
                fi
                echo "✅ Cockpit installed! Access at: http://localhost:9090"
            fi
            ;;
        7)
            echo "[LOG] Bill chose Complete SysOps Suite" >> ~/system_ops/assistant.log
            echo "🚀 DEPLOYING COMPLETE SYSTEM OPERATIONS SUITE!"
            echo ""
            echo "This installs VisiData, TLDR, Zeal, Glances, and sets up a complete"
            echo "system operations environment for maximum productivity!"
            echo ""
            read -p "Continue with complete suite installation? (y/n): " suite_confirm
            if [[ $suite_confirm =~ ^[Yy]$ ]]; then
                echo "🏗️ Building complete system operations suite..."
                
                # Install all tools
                echo "1/4 Installing VisiData..."
                pip3 install --user visidata 2>/dev/null
                
                echo "2/4 Installing TLDR..."
                if command -v npm &> /dev/null; then
                    sudo npm install -g tldr 2>/dev/null
                    tldr --update 2>/dev/null
                fi
                
                echo "3/4 Installing Zeal..."
                if command -v apt &> /dev/null; then
                    sudo apt install -y zeal 2>/dev/null
                fi
                
                echo "4/4 Installing Glances..."
                if command -v apt &> /dev/null; then
                    sudo apt install -y glances 2>/dev/null
                fi
                
                # Create useful aliases
                cat >> ~/.bashrc << 'EOF'

# Bill Sloth System Operations Aliases
alias data='vd'
alias docs='zeal'
alias monitor='glances'
alias howto='tldr'
alias examples='tldr'
alias logs='vd /var/log/syslog'
alias processes='vd <(ps aux)'
EOF
                
                echo ""
                echo "🎉 COMPLETE SYSTEM OPERATIONS SUITE DEPLOYED!"
                echo "=========================================="
                echo ""
                echo "🎯 YOUR SYSTEM TOOLKIT:"
                echo "• VisiData - data exploration (alias: data)"
                echo "• TLDR - command examples (alias: howto)"
                echo "• Zeal - offline docs (alias: docs)"
                echo "• Glances - system monitor (alias: monitor)"
                echo ""
                echo "✅ You now have a complete system operations toolkit!"
                echo "Reload your shell with: source ~/.bashrc"
            fi
            ;;
        8)
            # GitHub Authentication Setup
            echo "[LOG] Bill chose GitHub Authentication Setup" >> ~/system_ops/assistant.log
            setup_github_authentication
            ;;
        other|Other|OTHER)
            echo "[LOG] Bill requested more options from Claude Code" >> ~/system_ops/assistant.log
            echo "🤖 SUMMONING CLAUDE CODE FOR ADVANCED SYSTEM TOOLS..."
            echo ""
            echo "Claude Code can help you with specialized system operation tools:"
            echo ""
            echo "🔬 ADVANCED MONITORING:"
            echo "• Netdata - Real-time performance monitoring"
            echo "• Prometheus + Grafana - Professional metrics stack"
            echo "• Nagios - Enterprise monitoring solution"
            echo "• Zabbix - Network and application monitoring"
            echo ""
            echo "⚡ PERFORMANCE TOOLS:"
            echo "• htop/btop - Enhanced process viewers"
            echo "• iotop - I/O monitoring"
            echo "• nethogs - Network usage per process"
            echo "• powertop - Power consumption analysis"
            echo ""
            echo "💡 Tell Claude Code about your specific system needs!"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\n📝 All actions logged to ~/system_ops/assistant.log"
    echo "🔄 You can always re-run this assistant to try a different solution!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    system_ops_interactive
fi 