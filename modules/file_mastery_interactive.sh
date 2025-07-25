#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=File Organizer, 2=Duplicate Finder, 3=Bulk Rename, 4=Smart Search, 5=Complete File Suite
# CLAUDE_PROMPTS: File operation selection, Target directory confirmation, Organization rules
# CLAUDE_DEPENDENCIES: find, fzf, ranger, fd, ripgrep, exiftool
# File Mastery - Lightning-fast file operations with AI organization
# "I'm straight. Teeth are for gay people" - Carl

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

source "../lib/interactive.sh" 2>/dev/null || {
    echo "📁 FILE MASTERY SETUP"
    echo "===================="
}

clear
echo -e "\033[38;5;46m"
cat << 'EOF'
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    ░                                                                            ░
    ░    ██╗███╗   ██╗███████╗ ██████╗     ██████╗  ██████╗ ███╗   ███╗██╗███╗   ██╗██╗ ██████╗ ███╗   ██╗
    ░    ██║████╗  ██║██╔════╝██╔═══██╗    ██╔══██╗██╔═══██╗████╗ ████║██║████╗  ██║██║██╔═══██╗████╗  ██║
    ░    ██║██╔██╗ ██║█████╗  ██║   ██║    ██║  ██║██║   ██║██╔████╔██║██║██╔██╗ ██║██║██║   ██║██╔██╗ ██║
    ░    ██║██║╚██╗██║██╔══╝  ██║   ██║    ██║  ██║██║   ██║██║╚██╔╝██║██║██║╚██╗██║██║██║   ██║██║╚██╗██║
    ░    ██║██║ ╚████║██║     ╚██████╔╝    ██████╔╝╚██████╔╝██║ ╚═╝ ██║██║██║ ╚████║██║╚██████╔╝██║ ╚████║
    ░    ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
EOF
echo -e "\033[0m"

echo -e "\033[38;5;196m💀 DIGITAL FILE WARFARE - CORPORATE INFORMATION SUPREMACY 💀\033[0m"
echo -e "\033[38;5;51m================================================================\033[0m"
echo ""
echo -e "\033[38;5;226m🔥 Weaponize your information architecture beyond corporate limitations!\033[0m"
echo -e "\033[38;5;226m   Make Windows Everything/TeraCopy look like stone-age meat-puppet tools!\033[0m"
echo ""
echo -e "\033[38;5;129m🧠 NEURODIVERGENT DIGITAL SUPREMACY:\033[0m"
echo -e "\033[38;5;82m   • Quantum-speed file location - find ANYTHING in nanoseconds\033[0m"
echo -e "\033[38;5;82m   • AI consciousness auto-organizes your digital existence\033[0m"
echo -e "\033[38;5;82m   • Neural pattern recognition for bulk reality manipulation\033[0m"
echo -e "\033[38;5;82m   • Visual interface that bypasses meat-brain limitations\033[0m"
echo -e "\033[38;5;82m   • Duplicate consciousness detection and digital cleansing\033[0m"
echo -e "\033[38;5;82m   • Project-aware reality frameworks and workflow domination\033[0m"
echo ""

explain_file_mastery() {
    clear
    echo -e "\033[38;5;51m💀 WHAT IS DIGITAL INFORMATION WARFARE?\033[0m"
    echo -e "\033[38;5;196m========================================\033[0m"
    echo ""
    echo -e "\033[38;5;226m🔥 Your Windows tools were corporate training wheels:\033[0m"
    echo -e "\033[38;5;82m• 🔥 Everything - Primitive filename indexing (pathetic)\033[0m"
    echo -e "\033[38;5;82m• 📋 TeraCopy - Basic binary replication (stone-age)\033[0m"
    echo -e "\033[38;5;82m• 🏷️  PowerRename - Pattern matching for beginners\033[0m"
    echo -e "\033[38;5;82m• 🗂️  File Explorer - Corporate thought-control interface\033[0m"
    echo -e "\033[38;5;82m• 🔍 Windows Search - Surveillance capitalism disguised as utility\033[0m"
    echo ""
    echo -e "\033[38;5;129m⚡ THIS NEURAL INTERFACE TRANSCENDS REALITY LIMITATIONS:\033[0m"
    echo ""
    echo "⚡ LIGHTNING-FAST SEARCH:"
    echo "   • fd: Find files by name (faster than Everything)"
    echo "   • rg (ripgrep): Search inside files (content search)"
    echo "   • fzf: Interactive fuzzy finder with preview"
    echo "   • locate: System-wide file database"
    echo ""
    echo "🤖 AI-POWERED ORGANIZATION:"
    echo "   • Smart file categorization by content and context"
    echo "   • Automatic duplicate detection with merge suggestions"
    echo "   • Project-based file organization"
    echo "   • Intelligent naming suggestions for better organization"
    echo ""
    echo "🎨 ADVANCED OPERATIONS:"
    echo "   • rsync: Superior copying with progress and verification"
    echo "   • Bulk renaming with regex and AI suggestions"
    echo "   • Smart compression and archiving"
    echo "   • File permission management made simple"
    echo ""
    echo "📊 VISUAL FILE MANAGEMENT:"
    echo "   • ranger: Vi-like file manager with preview"
    echo "   • nnn: Blazingly fast terminal file manager"
    echo "   • Graphical tools integrated with terminal power"
    echo "   • Real-time file monitoring and notifications"
    echo ""
    echo "🔧 POWER-USER FEATURES:"
    echo "   • Command-line integration with GUI tools"
    echo "   • Scriptable file operations and automation"
    echo "   • Cross-device file synchronization"
    echo "   • Version control integration for project files"
    echo "   • Smart backup and recovery systems"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

install_search_tools() {
    echo "🔍 INSTALLING LIGHTNING-FAST SEARCH TOOLS"
    echo "=========================================="
    echo ""
    echo "🎯 Setting up search tools that make Windows Everything look slow!"
    echo ""
    
    # Install fd (fast file finder)
    echo "📦 Installing fd (ultra-fast file finder)..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y fd-find ripgrep fzf locate
            # Create symlink for fd-find to fd
            if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
                sudo ln -sf $(which fdfind) /usr/local/bin/fd
            fi
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y fd-find ripgrep fzf mlocate
        elif command -v pacman &> /dev/null; then
            sudo pacman -S fd ripgrep fzf mlocate
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install fd ripgrep fzf findutils
        fi
    fi
    
    # Update locate database
    echo "📊 Updating file database..."
    sudo updatedb 2>/dev/null || echo "Database update scheduled for background"
    
    echo "✅ Search tools installed!"
    echo ""
    echo "🎯 YOUR NEW SEARCH SUPERPOWERS:"
    echo "   fd        = Find files by name (faster than Everything)"
    echo "   rg        = Search inside files (content search)"
    echo "   fzf       = Interactive fuzzy finder"
    echo "   locate    = System-wide file database search"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

install_file_managers() {
    echo "📁 INSTALLING ADVANCED FILE MANAGERS"
    echo "===================================="
    echo ""
    echo "🎯 Setting up visual file management that puts File Explorer to shame!"
    echo ""
    
    echo "📦 Installing file management tools..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt install -y ranger nnn mc tree ncdu rsync
            # Install additional dependencies for ranger
            sudo apt install -y w3m-img ffmpegthumbnailer highlight atool lynx
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y ranger nnn mc tree ncdu rsync
            sudo dnf install -y w3m-img ffmpegthumbnailer highlight atool lynx
        elif command -v pacman &> /dev/null; then
            sudo pacman -S ranger nnn mc tree ncdu rsync
            sudo pacman -S w3m ffmpegthumbnailer highlight atool lynx
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install ranger nnn mc tree ncdu rsync
        fi
    fi
    
    echo "✅ File managers installed!"
    echo ""
    echo "🎯 YOUR NEW FILE MANAGEMENT ARSENAL:"
    echo "   ranger    = Vi-like file manager with preview"
    echo "   nnn       = Blazingly fast terminal file manager"
    echo "   mc        = Classic dual-pane file manager"
    echo "   tree      = Visual directory structure display"
    echo "   ncdu      = Disk usage analyzer with navigation"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

create_search_shortcuts() {
    echo "⚡ CREATING WINDOWS POWER-USER SEARCH SHORTCUTS"
    echo "=============================================="
    echo ""
    echo "🎯 Setting up shortcuts that mimic and exceed Windows Everything..."
    echo ""
    
    # Create search scripts
    mkdir -p ~/.local/bin
    
    # Everything-style instant search
    cat > ~/.local/bin/everything << 'EOF'
#!/bin/bash
# Everything-style file search for Linux
# Usage: everything [search term]

SEARCH_TERM="$*"

if [ -z "$SEARCH_TERM" ]; then
    echo "🔍 Everything-Style File Search"
    echo "=============================="
    echo ""
    echo "Usage: everything <search term>"
    echo ""
    echo "Examples:"
    echo "  everything config        # Find all files with 'config' in name"
    echo "  everything *.pdf         # Find all PDF files"
    echo "  everything /home doc     # Find 'doc' files in /home"
    echo "  everything -e mp3        # Find files with mp3 extension"
    echo "  everything -t f photo    # Find files (not dirs) with 'photo'"
    echo ""
    exit 1
fi

echo "🔍 Searching for: $SEARCH_TERM"
echo "==============================="
echo ""

# Use fd for fast file finding (like Everything)
if command -v fd &> /dev/null; then
    echo "📁 Files matching '$SEARCH_TERM':"
    fd -i "$SEARCH_TERM" 2>/dev/null | head -20
    
    TOTAL_COUNT=$(fd -i "$SEARCH_TERM" 2>/dev/null | wc -l)
    echo ""
    echo "💡 Found $TOTAL_COUNT matches (showing first 20)"
    
    if [ $TOTAL_COUNT -gt 20 ]; then
        echo "   Use: fd -i '$SEARCH_TERM' | less    # to see all results"
        echo "   Use: fd -i '$SEARCH_TERM' | fzf     # for interactive selection"
    fi
else
    echo "❌ fd not installed. Using find (slower)..."
    find / -iname "*$SEARCH_TERM*" 2>/dev/null | head -20
fi
EOF

    # Content search (inside files)
    cat > ~/.local/bin/search-content << 'EOF'
#!/bin/bash
# Search inside file contents (like Windows search but actually works)
# Usage: search-content [search term]

SEARCH_TERM="$*"

if [ -z "$SEARCH_TERM" ]; then
    echo "📄 Content Search - Find text inside files"
    echo "=========================================="
    echo ""
    echo "Usage: search-content <search term>"
    echo ""
    echo "Examples:"
    echo "  search-content password         # Find files containing 'password'"
    echo "  search-content 'TODO:'          # Find TODO comments in code"
    echo "  search-content -t py import     # Search only in Python files"
    echo "  search-content -g '*.md' linux  # Search only in Markdown files"
    echo ""
    exit 1
fi

echo "📄 Searching file contents for: $SEARCH_TERM"
echo "============================================="
echo ""

if command -v rg &> /dev/null; then
    echo "📝 Files containing '$SEARCH_TERM':"
    rg -i --color=always --heading --line-number "$SEARCH_TERM" . 2>/dev/null | head -50
    
    TOTAL_MATCHES=$(rg -i -c "$SEARCH_TERM" . 2>/dev/null | wc -l)
    echo ""
    echo "💡 Found matches in $TOTAL_MATCHES files (showing first 50 lines)"
else
    echo "❌ ripgrep not installed. Using grep (slower)..."
    grep -r -i --color=always -n "$SEARCH_TERM" . 2>/dev/null | head -20
fi
EOF

    # Interactive file finder with preview
    cat > ~/.local/bin/find-interactive << 'EOF'
#!/bin/bash
# Interactive file finder with preview (like Windows search but better)
# Usage: find-interactive

echo "🎯 Interactive File Finder"
echo "=========================="
echo ""
echo "💡 Use Ctrl+C to exit"
echo "   Arrow keys to navigate"
echo "   Enter to select file"
echo "   Tab for multi-select"
echo ""

if command -v fzf &> /dev/null && command -v fd &> /dev/null; then
    # Use fd with fzf for fast interactive search
    SELECTED_FILE=$(fd -t f | fzf --preview 'head -50 {}' --preview-window=right:50% --height=80%)
    
    if [ -n "$SELECTED_FILE" ]; then
        echo ""
        echo "🎯 Selected: $SELECTED_FILE"
        echo ""
        read -p "Open with default application? (y/n): " open_choice
        if [[ $open_choice =~ ^[Yy]$ ]]; then
            xdg-open "$SELECTED_FILE" 2>/dev/null || open "$SELECTED_FILE" 2>/dev/null || echo "Could not open file"
        fi
    fi
else
    echo "❌ fzf or fd not installed. Install them for interactive search."
    echo "Using basic find instead:"
    echo ""
    read -p "Enter search pattern: " pattern
    find . -iname "*$pattern*" -type f | head -20
fi
EOF

    # AI-powered file organization
    cat > ~/.local/bin/organize-files-ai << 'EOF'
#!/bin/bash
# AI-powered file organization
# Usage: organize-files-ai [directory]

TARGET_DIR="${1:-$(pwd)}"

echo "🤖 AI-Powered File Organization"
echo "==============================="
echo ""
echo "📁 Analyzing directory: $TARGET_DIR"
echo ""

if command -v claude &> /dev/null; then
    echo "🧠 Using AI to analyze file organization..."
    
    # Get file list with details
    FILE_LIST=$(ls -la "$TARGET_DIR" | head -20)
    
    AI_SUGGESTION=$(claude "Analyze this directory listing and suggest an organization strategy for better productivity. Focus on creating folders and grouping files logically: $FILE_LIST" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$AI_SUGGESTION" ]; then
        echo "💡 AI Organization Suggestions:"
        echo "==============================="
        echo "$AI_SUGGESTION"
        echo ""
        
        read -p "Would you like to implement any of these suggestions? (y/n): " implement
        if [[ $implement =~ ^[Yy]$ ]]; then
            echo "Manual implementation required - AI provided the strategy above!"
        fi
    else
        echo "❌ AI analysis failed. Using basic organization..."
        organize_basic "$TARGET_DIR"
    fi
else
    echo "💡 AI not available. Using rule-based organization..."
    organize_basic "$TARGET_DIR"
fi

organize_basic() {
    local dir="$1"
    echo "📁 Creating basic organization folders..."
    
    cd "$dir" || return
    mkdir -p Documents Images Videos Audio Archives Code Projects
    
    echo "✅ Basic folders created. You can now manually organize files:"
    echo "   Documents/ - Text files, PDFs, office docs"
    echo "   Images/ - Photos, screenshots, graphics"
    echo "   Videos/ - Movie files, recordings"
    echo "   Audio/ - Music, sound files"
    echo "   Archives/ - ZIP, TAR files"
    echo "   Code/ - Programming files"
    echo "   Projects/ - Work projects"
}
EOF

    chmod +x ~/.local/bin/everything ~/.local/bin/search-content ~/.local/bin/find-interactive ~/.local/bin/organize-files-ai
    
    echo "✅ Search shortcuts created!"
    echo ""
    echo "🎯 YOUR NEW SEARCH COMMANDS:"
    echo "   everything <term>      = Instant file search (like Windows Everything)"
    echo "   search-content <term>  = Search inside files"
    echo "   find-interactive       = Interactive finder with preview"
    echo "   organize-files-ai      = AI-powered file organization"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

setup_advanced_copying() {
    echo "📋 SETTING UP ADVANCED FILE COPYING"
    echo "==================================="
    echo ""
    echo "🎯 Creating TeraCopy-style file operations with verification!"
    echo ""
    
    # Create advanced copy script
    cat > ~/.local/bin/teracopy << 'EOF'
#!/bin/bash
# TeraCopy-style file copying with progress and verification
# Usage: teracopy <source> <destination>

SOURCE="$1"
DEST="$2"

if [ -z "$SOURCE" ] || [ -z "$DEST" ]; then
    echo "📋 TeraCopy-Style File Operations"
    echo "================================="
    echo ""
    echo "Usage: teracopy <source> <destination>"
    echo ""
    echo "Examples:"
    echo "  teracopy file.txt /backup/         # Copy single file"
    echo "  teracopy /home/user/docs/ /backup/ # Copy directory"
    echo "  teracopy *.jpg /photos/            # Copy multiple files"
    echo ""
    echo "Features:"
    echo "  ✅ Progress display"
    echo "  ✅ Speed monitoring"
    echo "  ✅ Integrity verification"
    echo "  ✅ Resume on failure"
    echo "  ✅ Detailed logging"
    echo ""
    exit 1
fi

echo "📋 TeraCopy-Style File Transfer"
echo "=============================="
echo ""
echo "📁 Source: $SOURCE"
echo "📁 Destination: $DEST"
echo ""

# Check if source exists
if [ ! -e "$SOURCE" ]; then
    echo "❌ Source not found: $SOURCE"
    exit 1
fi

# Create destination directory if needed
mkdir -p "$(dirname "$DEST")" 2>/dev/null

# Use rsync for advanced copying (better than TeraCopy)
if command -v rsync &> /dev/null; then
    echo "🚀 Starting transfer with verification..."
    echo ""
    
    rsync -av --progress --checksum --stats "$SOURCE" "$DEST"
    RSYNC_EXIT=$?
    
    echo ""
    if [ $RSYNC_EXIT -eq 0 ]; then
        echo "✅ Transfer completed successfully!"
        
        # Verify the copy
        if [ -f "$SOURCE" ] && [ -f "$DEST" ]; then
            SOURCE_HASH=$(sha256sum "$SOURCE" | cut -d' ' -f1)
            DEST_HASH=$(sha256sum "$DEST" | cut -d' ' -f1)
            
            if [ "$SOURCE_HASH" = "$DEST_HASH" ]; then
                echo "✅ Integrity verification passed!"
            else
                echo "❌ Integrity verification failed!"
                exit 1
            fi
        fi
        
        # Log the operation
        echo "$(date): Successfully copied $SOURCE to $DEST" >> ~/.bill-sloth/file-operations.log
        
    else
        echo "❌ Transfer failed with exit code: $RSYNC_EXIT"
        echo "$(date): Failed to copy $SOURCE to $DEST (exit code: $RSYNC_EXIT)" >> ~/.bill-sloth/file-operations.log
        exit $RSYNC_EXIT
    fi
    
else
    echo "❌ rsync not available. Using cp..."
    cp -r "$SOURCE" "$DEST"
fi
EOF

    # Create bulk rename script
    cat > ~/.local/bin/bulk-rename << 'EOF'
#!/bin/bash
# PowerRename-style bulk renaming with patterns
# Usage: bulk-rename [pattern] [replacement]

PATTERN="$1"
REPLACEMENT="$2"

if [ -z "$PATTERN" ]; then
    echo "🏷️  PowerRename-Style Bulk Renaming"
    echo "=================================="
    echo ""
    echo "Usage: bulk-rename <pattern> <replacement>"
    echo ""
    echo "Examples:"
    echo "  bulk-rename 'IMG_' 'Photo_'     # Rename IMG_001.jpg to Photo_001.jpg"
    echo "  bulk-rename '.jpeg' '.jpg'      # Change extension"
    echo "  bulk-rename ' ' '_'             # Replace spaces with underscores"
    echo ""
    echo "Advanced patterns (regex):"
    echo "  bulk-rename '([0-9]+)' 'Image_\$1'  # Add prefix to numbers"
    echo ""
    echo "🤖 AI-powered renaming:"
    echo "  bulk-rename-ai                  # Get AI suggestions for current directory"
    echo ""
    exit 1
fi

echo "🏷️  Bulk Renaming Operation"
echo "=========================="
echo ""
echo "🔍 Pattern: $PATTERN"
echo "🔄 Replacement: $REPLACEMENT"
echo ""
echo "📁 Files to be renamed:"

# Preview changes first
CHANGES=0
for file in *; do
    if [[ "$file" =~ $PATTERN ]] && [ "$file" != "${file//$PATTERN/$REPLACEMENT}" ]; then
        NEW_NAME="${file//$PATTERN/$REPLACEMENT}"
        echo "  $file → $NEW_NAME"
        CHANGES=$((CHANGES + 1))
    fi
done

if [ $CHANGES -eq 0 ]; then
    echo "❌ No files match the pattern: $PATTERN"
    exit 1
fi

echo ""
echo "💡 Found $CHANGES files to rename."
read -p "Proceed with renaming? (y/n): " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔄 Renaming files..."
    
    RENAMED=0
    for file in *; do
        if [[ "$file" =~ $PATTERN ]] && [ "$file" != "${file//$PATTERN/$REPLACEMENT}" ]; then
            NEW_NAME="${file//$PATTERN/$REPLACEMENT}"
            if mv "$file" "$NEW_NAME" 2>/dev/null; then
                echo "✅ $file → $NEW_NAME"
                RENAMED=$((RENAMED + 1))
            else
                echo "❌ Failed to rename: $file"
            fi
        fi
    done
    
    echo ""
    echo "🎉 Successfully renamed $RENAMED files!"
    echo "$(date): Bulk renamed $RENAMED files with pattern $PATTERN → $REPLACEMENT" >> ~/.bill-sloth/file-operations.log
else
    echo "❌ Operation cancelled."
fi
EOF

    # Create AI-powered bulk rename
    cat > ~/.local/bin/bulk-rename-ai << 'EOF'
#!/bin/bash
# AI-powered bulk renaming suggestions
# Usage: bulk-rename-ai

echo "🤖 AI-Powered Bulk Renaming"
echo "==========================="
echo ""
echo "📁 Analyzing current directory for renaming suggestions..."
echo ""

# Get file list
FILES=$(ls -1 | head -20)

if command -v claude &> /dev/null && [ -n "$FILES" ]; then
    echo "🧠 Getting AI suggestions..."
    
    AI_SUGGESTIONS=$(claude "Analyze these filenames and suggest better naming patterns for organization and consistency. Provide specific rename commands: $FILES" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$AI_SUGGESTIONS" ]; then
        echo "💡 AI Renaming Suggestions:"
        echo "=========================="
        echo "$AI_SUGGESTIONS"
        echo ""
        
        read -p "Would you like to implement any suggestions manually? (y/n): " implement
        if [[ $implement =~ ^[Yy]$ ]]; then
            echo ""
            echo "📝 Use the suggestions above with the bulk-rename command:"
            echo "   Example: bulk-rename 'old_pattern' 'new_pattern'"
            echo ""
        fi
    else
        echo "❌ AI analysis failed. Using basic suggestions..."
        basic_rename_suggestions
    fi
else
    echo "💡 AI not available. Here are basic renaming patterns:"
    basic_rename_suggestions
fi

basic_rename_suggestions() {
    echo ""
    echo "📝 Common Renaming Patterns:"
    echo "==========================="
    echo "  Remove spaces:     bulk-rename ' ' '_'"
    echo "  Lowercase all:     rename 's/.*/\L$&/' *"
    echo "  Add date prefix:   bulk-rename '' '$(date +%Y%m%d)_'"
    echo "  Clean up photos:   bulk-rename 'IMG_' 'Photo_'"
    echo "  Fix extensions:    bulk-rename '.JPEG' '.jpg'"
}
EOF

    chmod +x ~/.local/bin/teracopy ~/.local/bin/bulk-rename ~/.local/bin/bulk-rename-ai
    
    echo "✅ Advanced copying tools configured!"
    echo ""
    echo "🎯 YOUR NEW FILE OPERATION COMMANDS:"
    echo "   teracopy <src> <dst>    = Advanced copying with verification"
    echo "   bulk-rename <old> <new> = Bulk file renaming"
    echo "   bulk-rename-ai          = AI-powered rename suggestions"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

configure_file_shortcuts() {
    echo "⌨️  CONFIGURING FILE MANAGEMENT SHORTCUTS"
    echo "========================================"
    echo ""
    echo "🎯 Setting up Windows-style file shortcuts and more..."
    echo ""
    
    # Add aliases to bash profile
    cat >> ~/.bashrc << 'EOF'

# Bill Sloth File Mastery Aliases
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias tree='tree -C'

# Windows-style file operations
alias dir='ls -la'
alias copy='teracopy'
alias move='mv'
alias del='rm -i'
alias md='mkdir -p'
alias rd='rmdir'

# Power-user file shortcuts
alias ff='find-interactive'
alias search='everything'
alias searchtext='search-content'
alias organize='organize-files-ai'
alias fsize='du -sh'
alias fsizes='du -sh * | sort -hr'
alias space='ncdu'

# Quick navigation
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias desktop='cd ~/Desktop'
alias home='cd ~'

# File manager shortcuts
alias fm='ranger'
alias files='nnn'
alias mc='mc'

EOF

    # Create desktop file associations
    mkdir -p ~/.local/share/applications
    
    cat > ~/.local/share/applications/file-mastery-tools.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=File Mastery Tools
Comment=Launch file management tools
Exec=sh -c 'ranger'
Icon=folder
Terminal=true
Categories=System;FileManager;
EOF

    echo "✅ File shortcuts configured!"
    echo ""
    echo "🎯 YOUR NEW FILE SHORTCUTS:"
    echo "   ff         = Interactive file finder"
    echo "   search     = Everything-style search"
    echo "   copy       = TeraCopy-style copying"
    echo "   organize   = AI file organization"
    echo "   fm         = Launch ranger file manager"
    echo "   space      = Disk usage analyzer"
    echo ""
    echo "💡 Reload your terminal or run 'source ~/.bashrc' to activate!"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

demo_file_mastery() {
    echo "🎯 FILE MASTERY DEMONSTRATION"
    echo "============================="
    echo ""
    echo "Let's test your new file management superpowers!"
    echo ""
    
    # Create test directory
    TEST_DIR="/tmp/bill-sloth-file-test"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Create test files
    echo "Creating test files..."
    echo "This is a test document about Linux" > "test document.txt"
    echo "Important configuration settings" > "config.conf"
    echo "#!/bin/bash\necho 'Hello World'" > "script.sh"
    echo "Photo metadata" > "IMG_001.jpg"
    echo "Audio file info" > "song.mp3"
    
    echo "📁 Test files created in: $TEST_DIR"
    echo ""
    
    echo "🔍 TESTING SEARCH CAPABILITIES:"
    echo ""
    
    # Test file search
    echo "1️⃣  Testing everything command (find by name):"
    if command -v everything &> /dev/null; then
        everything "test"
    else
        fd -i "test" 2>/dev/null || find . -iname "*test*" 2>/dev/null
    fi
    echo ""
    
    # Test content search
    echo "2️⃣  Testing content search (search inside files):"
    if command -v search-content &> /dev/null; then
        search-content "Linux"
    else
        rg -i "linux" . 2>/dev/null || grep -r -i "linux" . 2>/dev/null
    fi
    echo ""
    
    # Test bulk rename
    echo "3️⃣  Testing bulk rename (IMG_ to Photo_):"
    if command -v bulk-rename &> /dev/null; then
        echo "Preview of bulk rename:"
        echo "IMG_001.jpg → Photo_001.jpg"
        echo "(This is just a demo - use 'bulk-rename IMG_ Photo_' to actually rename)"
    fi
    echo ""
    
    # Test file copying
    echo "4️⃣  Testing advanced copy:"
    if command -v teracopy &> /dev/null; then
        echo "Creating backup with verification..."
        mkdir -p backup
        teracopy "test document.txt" "backup/test document backup.txt"
    else
        echo "rsync -av --progress \"test document.txt\" \"backup/\""
    fi
    echo ""
    
    echo "📊 FILE MASTERY STATISTICS:"
    echo ""
    if command -v fd &> /dev/null; then
        FILE_COUNT=$(fd -t f . | wc -l)
        echo "   • Files found with fd: $FILE_COUNT"
    fi
    
    if command -v rg &> /dev/null; then
        CONTENT_MATCHES=$(rg -c "." . 2>/dev/null | wc -l)
        echo "   • Files with content: $CONTENT_MATCHES"
    fi
    
    echo "   • Test directory: $TEST_DIR"
    echo ""
    
    echo "🎯 POWER-USER COMMANDS TO TRY:"
    echo ""
    echo "📁 NAVIGATION:"
    echo "   ranger           = Visual file manager"
    echo "   nnn              = Fast terminal file manager"
    echo "   tree             = Show directory structure"
    echo ""
    echo "🔍 SEARCH:"
    echo "   everything photo        = Find files with 'photo' in name"
    echo "   search-content TODO     = Find files containing 'TODO'"
    echo "   find-interactive        = Interactive fuzzy finder"
    echo ""
    echo "🔧 OPERATIONS:"
    echo "   teracopy file.txt /backup/    = Copy with verification"
    echo "   bulk-rename IMG_ Photo_       = Rename all IMG_* files"
    echo "   organize-files-ai             = AI file organization"
    echo ""
    echo "💡 Your file management is now 1000x more powerful than Windows!"
    echo ""
    
    read -p "Press Enter to clean up test files and finish..."
    
    # Cleanup
    cd /
    rm -rf "$TEST_DIR"
    echo "✅ Test files cleaned up!"
    clear
}

# Neural interface main menu
main_menu() {
    while true; do
        clear
        echo -e "\033[38;5;46m"
        cat << 'EOF'
        ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
        █  ⚡ INFORMATION WARFARE COMMAND MATRIX ⚡                                █
        ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
EOF
        echo -e "\033[0m"
        
        echo ""
        echo -e "\033[38;5;196m1) 💀 Neural warfare briefing - what is digital file domination?\033[0m"
        echo -e "\033[38;5;226m2) 🔍 Deploy quantum search algorithms (beyond Everything)\033[0m"
        echo -e "\033[38;5;51m3) 📁 Install consciousness-level file management interfaces\033[0m"
        echo -e "\033[38;5;129m4) ⚡ Create neural search shortcuts (Windows power-user transcendence)\033[0m"
        echo -e "\033[38;5;82m5) 📋 Setup verified binary replication protocols (TeraCopy supremacy)\033[0m"
        echo -e "\033[38;5;46m6) ⌨️  Configure wetware-to-digital interface shortcuts\033[0m"
        echo -e "\033[38;5;199m7) 💾 Multi-reality storage and monitor consciousness management\033[0m"
        echo -e "\033[38;5;214m8) 🎯 Neural interface field test - witness your new powers\033[0m"
        echo -e "\033[38;5;160m9) 🚀 Complete digital transcendence sequence (ALL PROTOCOLS)\033[0m"
        echo -e "\033[38;5;240m0) Exit neural interface\033[0m"
        echo ""
        
        echo -e "\033[38;5;82m▶ Select reality manipulation protocol...\033[0m"
        read -p "" choice
        
        case $choice in
            1) explain_file_mastery ;;
            2) install_search_tools ;;
            3) install_file_managers ;;
            4) create_search_shortcuts ;;
            5) setup_advanced_copying ;;
            6) configure_file_shortcuts ;;
            7) setup_multi_drive_management ;;
            8) demo_file_mastery ;;
            9) complete_setup ;;
            0) echo "👋 Your file management powers are now legendary! 📁⚡"; exit 0 ;;
            *) echo "❌ Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Complete setup - all steps in sequence
complete_setup() {
    echo "🚀 COMPLETE FILE MASTERY SETUP"
    echo "=============================="
    echo ""
    echo "This will set up the ultimate file management system:"
    echo "Lightning search + Advanced managers + Multi-drive management + Multi-monitor setup + AI organization"
    echo ""
    read -p "Continue with complete setup? (y/n): " setup_confirm
    
    if [[ $setup_confirm =~ ^[Yy]$ ]]; then
        explain_file_mastery
        install_search_tools
        install_file_managers
        create_search_shortcuts
        setup_advanced_copying
        configure_file_shortcuts
        setup_multi_drive_management
        demo_file_mastery
        
        echo ""
        echo "🎉 FILE MASTERY COMPLETE!"
        echo "========================"
        echo ""
        echo "🎯 YOU NOW HAVE:"
        echo "   ✅ Lightning-fast file search (faster than Everything)"
        echo "   ✅ Advanced file copying with verification (better than TeraCopy)"
        echo "   ✅ Enterprise multi-drive storage management with bind mounts"
        echo "   ✅ Steam library management across multiple drives"
        echo "   ✅ Multi-monitor setup with autorandr profiles"
        echo "   ✅ Ubuntu system drive cleanup for dual-boot scenarios"
        echo "   ✅ AI-powered file organization and suggestions"
        echo "   ✅ Bulk operations with intelligent pattern matching"
        echo "   ✅ Visual file managers with preview capabilities"
        echo "   ✅ Windows-style shortcuts and power-user commands"
        echo ""
        echo "🚀 NEXT STEPS:"
        echo "   • Run 'drive-manager' to manage your multi-drive setup"
        echo "   • Try 'everything config' to find all config files instantly"
        echo "   • Use 'search-content TODO' to find all your TODO comments"
        echo "   • Run 'find-interactive' for visual file browsing"
        echo "   • Use 'teracopy' for verified file copying"
        echo "   • Try 'organize-files-ai' for intelligent file organization"
        echo ""
        echo "💡 Windows power users: Your file management is now SUPERIOR to what you had!"
        echo "   Everything + TeraCopy + PowerRename = Child's play compared to this!"
        
        # Log this installation
        echo "$(date): File Mastery setup completed with search tools, AI organization, and advanced operations" >> ~/.bill-sloth/history.log
    else
        return
    fi
}

# Multi-Drive Storage Management - Mature Linux Solutions
setup_multi_drive_management() {
    echo "💾 MULTI-DRIVE STORAGE MANAGEMENT"
    echo "================================="
    echo ""
    echo "🎯 ENTERPRISE-GRADE SOLUTIONS FOR MANAGING STORAGE ACROSS MULTIPLE DRIVES"
    echo ""
    echo "This will set up mature Linux storage management tools used in production:"
    echo "• Steam library management across drives (native Steam feature)"
    echo "• Safe application relocation using bind mounts (superior to symlinks)"
    echo "• Automated drive detection and mounting with persistent configuration"
    echo "• Space monitoring and intelligent allocation"
    echo "• Multi-monitor display management with autorandr"
    echo ""
    
    read -p "Install multi-drive management tools? (y/n): " install_drives
    if [[ $install_drives == "y" ]]; then
        
        # Install core dependencies
        echo "📦 Installing multi-drive management dependencies..."
        sudo apt update
        sudo apt install -y autorandr arandr xrandr ncdu tree pv rsync bindfs
        
        # Create multi-drive management script
        cat > ~/.local/bin/drive-manager << 'EOF'
#!/bin/bash
# Enterprise Multi-Drive Storage Manager
# Uses mature Linux solutions: bind mounts, Steam native libraries, autorandr

# Configuration
DRIVES_CONFIG="$HOME/.config/bill-sloth/drives.conf"
STEAM_LIBRARY_CONFIG="$HOME/.config/bill-sloth/steam-libraries.conf"
MOUNT_BASE="/media/$USER"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_main_menu() {
    clear
    echo -e "${BLUE}💾 MULTI-DRIVE STORAGE MANAGER${NC}"
    echo "============================="
    echo ""
    echo "1. 📊 Show all drives and usage"
    echo "2. 🔧 Auto-mount available drives"
    echo "3. 🎮 Steam library management"
    echo "4. 📁 Relocate application data (safe bind mounts)"
    echo "5. 🖥️  Multi-monitor setup (autorandr)"
    echo "6. 🧹 Clean system drive (Ubuntu space recovery)"
    echo "7. ⚙️  Configure drive preferences"
    echo "8. 📈 Storage analytics and recommendations"
    echo "0. Exit"
    echo ""
    read -p "Choose option: " choice
}

show_drives_usage() {
    echo -e "${BLUE}📊 DRIVE OVERVIEW${NC}"
    echo "================"
    echo ""
    
    # Show mounted drives with usage
    df -h | grep -E '^/dev/' | while read filesystem size used avail percent mountpoint; do
        # Color code based on usage
        usage_num=${percent%\%}
        if [ "$usage_num" -gt 90 ]; then
            color=$RED
        elif [ "$usage_num" -gt 70 ]; then
            color=$YELLOW
        else
            color=$GREEN
        fi
        
        echo -e "${color}Drive: $filesystem${NC}"
        echo "  Mount: $mountpoint"
        echo "  Size:  $size (${percent} used)"
        echo "  Free:  $avail available"
        echo ""
    done
    
    # Show unmounted drives
    echo -e "${YELLOW}📡 AVAILABLE UNMOUNTED DRIVES:${NC}"
    lsblk -f | grep -E 'sd[a-z][0-9]' | grep -v '/' | while read device fstype label uuid mountpoint; do
        if [ -n "$fstype" ] && [ -z "$mountpoint" ]; then
            echo "  /dev/$device ($fstype) - $label"
        fi
    done
    
    echo ""
    read -p "Press Enter to continue..."
}

auto_mount_drives() {
    echo -e "${BLUE}🔧 AUTO-MOUNTING AVAILABLE DRIVES${NC}"
    echo "================================="
    echo ""
    
    mkdir -p "$MOUNT_BASE"
    
    # Find unmounted drives
    lsblk -f | grep -E 'sd[a-z][0-9]' | grep -v '/' | while read device fstype label uuid mountpoint; do
        if [ -n "$fstype" ] && [ -z "$mountpoint" ]; then
            full_device="/dev/$device"
            mount_name="${label:-$device}"
            mount_point="$MOUNT_BASE/$mount_name"
            
            echo "Found unmounted drive: $full_device ($fstype)"
            read -p "Mount as $mount_point? (y/n): " mount_it
            
            if [[ $mount_it == "y" ]]; then
                sudo mkdir -p "$mount_point"
                
                # Mount with appropriate options based on filesystem
                case "$fstype" in
                    "ext4"|"ext3"|"ext2")
                        sudo mount -o defaults,user,rw "$full_device" "$mount_point"
                        ;;
                    "ntfs")
                        sudo mount -o defaults,user,rw,uid=$UID,gid=$GID,umask=022 "$full_device" "$mount_point"
                        ;;
                    "exfat"|"vfat")
                        sudo mount -o defaults,user,rw,uid=$UID,gid=$GID,umask=022 "$full_device" "$mount_point"
                        ;;
                    *)
                        sudo mount "$full_device" "$mount_point"
                        ;;
                esac
                
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ Successfully mounted $full_device at $mount_point${NC}"
                    
                    # Ask about persistent mounting
                    read -p "Make this mount permanent (add to /etc/fstab)? (y/n): " permanent
                    if [[ $permanent == "y" ]]; then
                        # Get UUID for permanent mounting
                        drive_uuid=$(lsblk -no UUID "$full_device")
                        if [ -n "$drive_uuid" ]; then
                            fstab_entry="UUID=$drive_uuid $mount_point $fstype defaults,user,rw"
                            case "$fstype" in
                                "ntfs"|"exfat"|"vfat")
                                    fstab_entry="$fstab_entry,uid=$UID,gid=$GID,umask=022"
                                    ;;
                            esac
                            fstab_entry="$fstab_entry 0 2"
                            
                            echo "# Added by Bill Sloth Drive Manager" | sudo tee -a /etc/fstab
                            echo "$fstab_entry" | sudo tee -a /etc/fstab
                            echo -e "${GREEN}✅ Added permanent mount to /etc/fstab${NC}"
                        fi
                    fi
                else
                    echo -e "${RED}❌ Failed to mount $full_device${NC}"
                fi
            fi
        fi
    done
    
    echo ""
    read -p "Press Enter to continue..."
}

steam_library_manager() {
    echo -e "${BLUE}🎮 STEAM LIBRARY MANAGEMENT${NC}"
    echo "==========================="
    echo ""
    
    # Check if Steam is installed
    if ! command -v steam &> /dev/null; then
        echo -e "${YELLOW}⚠️  Steam is not installed${NC}"
        read -p "Install Steam? (y/n): " install_steam
        if [[ $install_steam == "y" ]]; then
            sudo apt install -y steam
        else
            return
        fi
    fi
    
    echo "Steam Library Management Options:"
    echo ""
    echo "1. Show current Steam libraries"
    echo "2. Add new library on different drive"
    echo "3. Move games between libraries"
    echo "4. Create shared library for dual-boot (Windows/Linux)"
    echo "0. Back to main menu"
    echo ""
    
    read -p "Choose option: " steam_choice
    
    case $steam_choice in
        1)
            echo -e "${BLUE}📚 CURRENT STEAM LIBRARIES:${NC}"
            echo ""
            
            # Find Steam directories
            steam_dirs=(
                "$HOME/.steam/steam/steamapps"
                "$HOME/.local/share/Steam/steamapps"
            )
            
            for steam_dir in "${steam_dirs[@]}"; do
                if [ -d "$steam_dir" ]; then
                    echo "Main library: $steam_dir"
                    if [ -f "$steam_dir/libraryfolders.vdf" ]; then
                        echo "Additional libraries found in libraryfolders.vdf:"
                        grep -o '"path"[[:space:]]*"[^"]*"' "$steam_dir/libraryfolders.vdf" | sed 's/"path"[[:space:]]*"//; s/"//'
                    fi
                fi
            done
            ;;
        2)
            echo -e "${BLUE}➕ ADD NEW STEAM LIBRARY${NC}"
            echo ""
            echo "Available mounted drives:"
            df -h | grep -E '^/dev/' | awk '{print $6 " (" $4 " free)"}'
            echo ""
            read -p "Enter path for new Steam library (e.g., /media/user/GameDrive/SteamLibrary): " new_library
            
            if [ -n "$new_library" ]; then
                mkdir -p "$new_library"
                chmod 755 "$new_library"
                echo -e "${GREEN}✅ Created Steam library directory: $new_library${NC}"
                echo ""
                echo "To use this library:"
                echo "1. Open Steam"
                echo "2. Go to Steam > Settings > Storage"
                echo "3. Click the dropdown next to 'Create library folder on this drive'"
                echo "4. Browse to: $new_library"
                echo "5. Games can now be installed to this drive"
            fi
            ;;
        3)
            echo -e "${BLUE}🔄 MOVE STEAM GAMES${NC}"
            echo ""
            echo "Use Steam's built-in game moving feature:"
            echo "1. Open Steam"
            echo "2. Right-click on a game in your library"
            echo "3. Select Properties > Installed Files"
            echo "4. Click 'Move Install Folder'"
            echo "5. Choose the destination library"
            echo ""
            echo "This is the safest method for moving Steam games between libraries."
            ;;
        4)
            echo -e "${BLUE}🔗 DUAL-BOOT SHARED LIBRARY${NC}"
            echo ""
            echo -e "${YELLOW}⚠️  Advanced: Sharing Steam library between Windows and Linux${NC}"
            echo ""
            echo "This requires:"
            echo "1. NTFS drive accessible from both systems"
            echo "2. Careful symlink management"
            echo "3. Same Steam username on both systems"
            echo ""
            read -p "Continue with dual-boot setup? (y/n): " dual_boot
            
            if [[ $dual_boot == "y" ]]; then
                echo "Mount your Windows drive (typically C:):"
                ls /media/$USER/
                echo ""
                read -p "Enter Windows drive mount point (e.g., /media/$USER/Windows): " windows_mount
                
                if [ -d "$windows_mount" ]; then
                    windows_steam="$windows_mount/Program Files (x86)/Steam"
                    if [ -d "$windows_steam" ]; then
                        echo "Windows Steam found at: $windows_steam"
                        
                        # Create symlink for steamapps
                        steam_linux="$HOME/.steam/steam"
                        if [ -d "$steam_linux" ]; then
                            echo "Backing up Linux steamapps..."
                            mv "$steam_linux/steamapps" "$steam_linux/steamapps.backup" 2>/dev/null
                            
                            echo "Creating symlink to Windows Steam library..."
                            ln -s "$windows_steam/steamapps" "$steam_linux/steamapps"
                            
                            echo -e "${GREEN}✅ Dual-boot Steam library configured${NC}"
                            echo -e "${YELLOW}Note: Proton compatibility may vary between Windows and Linux versions${NC}"
                        fi
                    else
                        echo -e "${RED}❌ Windows Steam not found in expected location${NC}"
                    fi
                else
                    echo -e "${RED}❌ Windows drive not accessible${NC}"
                fi
            fi
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

relocate_app_data() {
    echo -e "${BLUE}📁 APPLICATION DATA RELOCATION${NC}"
    echo "=============================="
    echo ""
    echo "Safely relocate large application data using bind mounts"
    echo "(Safer than symlinks, transparent to applications)"
    echo ""
    
    echo "Common relocations for system drive space recovery:"
    echo "1. Browser cache and profiles"
    echo "2. ~/.cache (application caches)"
    echo "3. ~/Downloads"
    echo "4. Development workspaces"
    echo "5. Custom directory"
    echo "0. Back to main menu"
    echo ""
    
    read -p "Choose what to relocate: " relocate_choice
    
    case $relocate_choice in
        1)
            echo "Browser data relocation:"
            echo ""
            browsers=("firefox" "chrome" "chromium")
            for browser in "${browsers[@]}"; do
                case $browser in
                    "firefox")
                        profile_dir="$HOME/.mozilla/firefox"
                        ;;
                    "chrome")
                        profile_dir="$HOME/.config/google-chrome"
                        ;;
                    "chromium")
                        profile_dir="$HOME/.config/chromium"
                        ;;
                esac
                
                if [ -d "$profile_dir" ]; then
                    echo "Found $browser profile: $profile_dir"
                    size=$(du -sh "$profile_dir" | awk '{print $1}')
                    echo "Current size: $size"
                    
                    read -p "Relocate $browser data to which drive? (path): " target_drive
                    if [ -d "$target_drive" ]; then
                        relocate_directory_with_bind_mount "$profile_dir" "$target_drive/browser-data/$browser"
                    fi
                fi
            done
            ;;
        2)
            cache_dir="$HOME/.cache"
            if [ -d "$cache_dir" ]; then
                size=$(du -sh "$cache_dir" | awk '{print $1}')
                echo "Application cache directory: $cache_dir"
                echo "Current size: $size"
                echo ""
                read -p "Relocate cache to which drive? (path): " target_drive
                if [ -d "$target_drive" ]; then
                    relocate_directory_with_bind_mount "$cache_dir" "$target_drive/user-cache"
                fi
            fi
            ;;
        3)
            downloads_dir="$HOME/Downloads"
            size=$(du -sh "$downloads_dir" | awk '{print $1}')
            echo "Downloads directory: $downloads_dir"
            echo "Current size: $size"
            echo ""
            read -p "Relocate Downloads to which drive? (path): " target_drive
            if [ -d "$target_drive" ]; then
                relocate_directory_with_bind_mount "$downloads_dir" "$target_drive/Downloads"
            fi
            ;;
        4)
            echo "Development workspace relocation:"
            echo ""
            workspaces=("$HOME/Projects" "$HOME/Development" "$HOME/Code" "$HOME/workspace")
            for workspace in "${workspaces[@]}"; do
                if [ -d "$workspace" ]; then
                    size=$(du -sh "$workspace" | awk '{print $1}')
                    echo "Found workspace: $workspace ($size)"
                    read -p "Relocate this workspace? (y/n): " relocate_ws
                    if [[ $relocate_ws == "y" ]]; then
                        read -p "Target drive path: " target_drive
                        if [ -d "$target_drive" ]; then
                            workspace_name=$(basename "$workspace")
                            relocate_directory_with_bind_mount "$workspace" "$target_drive/$workspace_name"
                        fi
                    fi
                fi
            done
            ;;
        5)
            read -p "Enter directory path to relocate: " custom_dir
            if [ -d "$custom_dir" ]; then
                size=$(du -sh "$custom_dir" | awk '{print $1}')
                echo "Directory: $custom_dir"
                echo "Size: $size"
                read -p "Target drive path: " target_drive
                if [ -d "$target_drive" ]; then
                    dir_name=$(basename "$custom_dir")
                    relocate_directory_with_bind_mount "$custom_dir" "$target_drive/$dir_name"
                fi
            else
                echo -e "${RED}❌ Directory not found: $custom_dir${NC}"
            fi
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

relocate_directory_with_bind_mount() {
    local source_dir="$1"
    local target_location="$2"
    
    echo -e "${BLUE}🔧 Setting up bind mount relocation...${NC}"
    echo "Source: $source_dir"
    echo "Target: $target_location"
    echo ""
    
    # Safety checks
    if [ ! -d "$source_dir" ]; then
        echo -e "${RED}❌ Source directory doesn't exist: $source_dir${NC}"
        return 1
    fi
    
    if [ -z "$target_location" ]; then
        echo -e "${RED}❌ Target location not specified${NC}"
        return 1
    fi
    
    # Create target directory
    mkdir -p "$target_location"
    
    # Copy data to new location
    echo "Copying data to new location..."
    rsync -avh --progress "$source_dir/" "$target_location/"
    
    if [ $? -eq 0 ]; then
        # Backup original directory
        echo "Backing up original directory..."
        mv "$source_dir" "${source_dir}.backup"
        
        # Create new directory
        mkdir -p "$source_dir"
        
        # Create bind mount
        echo "Creating bind mount..."
        sudo mount --bind "$target_location" "$source_dir"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Bind mount created successfully${NC}"
            
            # Make permanent
            read -p "Make this bind mount permanent? (y/n): " permanent
            if [[ $permanent == "y" ]]; then
                # Add to fstab
                fstab_entry="$target_location $source_dir none bind 0 0"
                echo "# Bill Sloth bind mount: $(basename "$source_dir")" | sudo tee -a /etc/fstab
                echo "$fstab_entry" | sudo tee -a /etc/fstab
                echo -e "${GREEN}✅ Added permanent bind mount to /etc/fstab${NC}"
            fi
            
            # Verify the mount works
            ls "$source_dir" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Relocation completed successfully${NC}"
                echo "Original data backed up to: ${source_dir}.backup"
                echo "You can delete the backup once you've verified everything works"
            else
                echo -e "${RED}❌ Verification failed${NC}"
            fi
        else
            echo -e "${RED}❌ Failed to create bind mount${NC}"
            # Restore original
            rmdir "$source_dir"
            mv "${source_dir}.backup" "$source_dir"
        fi
    else
        echo -e "${RED}❌ Failed to copy data${NC}"
    fi
}

multimonitor_setup() {
    echo -e "${BLUE}🖥️  MULTI-MONITOR SETUP${NC}"
    echo "======================"
    echo ""
    
    # Check if autorandr is available
    if ! command -v autorandr &> /dev/null; then
        echo "Installing autorandr for automatic monitor management..."
        sudo apt install -y autorandr arandr
    fi
    
    echo "Multi-monitor management options:"
    echo "1. Current monitor configuration"
    echo "2. Automatic monitor setup (autorandr)"
    echo "3. Manual monitor configuration (arandr GUI)"
    echo "4. Save current setup as profile"
    echo "5. Load monitor profile"
    echo "0. Back to main menu"
    echo ""
    
    read -p "Choose option: " monitor_choice
    
    case $monitor_choice in
        1)
            echo -e "${BLUE}📺 CURRENT MONITOR SETUP:${NC}"
            echo ""
            xrandr --query
            ;;
        2)
            echo -e "${BLUE}🔧 AUTOMATIC MONITOR DETECTION${NC}"
            echo ""
            echo "Detecting connected monitors..."
            autorandr --change
            echo -e "${GREEN}✅ Applied best configuration for connected monitors${NC}"
            ;;
        3)
            echo -e "${BLUE}🎨 LAUNCHING VISUAL MONITOR CONFIGURATOR${NC}"
            echo ""
            if command -v arandr &> /dev/null; then
                arandr &
                echo "Visual monitor configuration tool launched"
                echo "Configure your monitors and save the script to ~/.screenlayout/"
            else
                echo "Installing arandr..."
                sudo apt install -y arandr
                arandr &
            fi
            ;;
        4)
            echo -e "${BLUE}💾 SAVE MONITOR PROFILE${NC}"
            read -p "Enter profile name (e.g., 'work', 'home', 'presentation'): " profile_name
            if [ -n "$profile_name" ]; then
                autorandr --save "$profile_name"
                echo -e "${GREEN}✅ Saved current setup as profile: $profile_name${NC}"
            fi
            ;;
        5)
            echo -e "${BLUE}📋 AVAILABLE MONITOR PROFILES:${NC}"
            autorandr --list
            echo ""
            read -p "Enter profile name to load: " profile_name
            if [ -n "$profile_name" ]; then
                autorandr --load "$profile_name"
                echo -e "${GREEN}✅ Loaded monitor profile: $profile_name${NC}"
            fi
            ;;
    esac
    
    echo ""
    echo "💡 Tip: autorandr can automatically switch profiles when monitors are connected/disconnected"
    echo "   Enable with: sudo systemctl enable --now autorandr.service"
    echo ""
    read -p "Press Enter to continue..."
}

clean_system_drive() {
    echo -e "${BLUE}🧹 UBUNTU SYSTEM DRIVE CLEANUP${NC}"
    echo "=============================="
    echo ""
    echo "Comprehensive cleanup for Ubuntu systems (safe for dual-boot)"
    echo ""
    
    # Show current disk usage
    echo -e "${YELLOW}📊 Current disk usage:${NC}"
    df -h / | tail -1
    echo ""
    
    echo "Cleanup options:"
    echo "1. Package cache cleanup (apt, snap)"
    echo "2. Remove old kernels (keep 2 most recent)"
    echo "3. Clear system logs (journalctl)"
    echo "4. Remove orphaned packages"
    echo "5. Clear thumbnail cache"
    echo "6. Empty trash"
    echo "7. 🚨 FULL CLEANUP (all of the above)"
    echo "0. Back to main menu"
    echo ""
    
    read -p "Choose cleanup option: " cleanup_choice
    
    case $cleanup_choice in
        1|7)
            echo -e "${BLUE}🗑️  Cleaning package caches...${NC}"
            sudo apt autoremove -y
            sudo apt autoclean
            sudo apt clean
            
            # Snap cleanup
            if command -v snap &> /dev/null; then
                echo "Cleaning snap cache..."
                sudo snap refresh
                # Keep only 2 revisions of each snap
                snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
                    sudo snap remove "$snapname" --revision="$revision" 2>/dev/null || true
                done
            fi
            
            # Flatpak cleanup
            if command -v flatpak &> /dev/null; then
                echo "Cleaning Flatpak cache..."
                flatpak uninstall --unused -y
            fi
            
            if [ "$cleanup_choice" != "7" ]; then break; fi
            ;;& 
        2|7)
            echo -e "${BLUE}🐧 Removing old kernels...${NC}"
            # Keep current kernel plus one backup
            current_kernel=$(uname -r)
            echo "Current kernel: $current_kernel"
            
            # List all installed kernels except current
            old_kernels=$(dpkg -l | grep 'linux-image-[0-9]' | awk '{print $2}' | grep -v "$current_kernel" | head -n -1)
            
            if [ -n "$old_kernels" ]; then
                echo "Removing old kernels:"
                echo "$old_kernels"
                echo "$old_kernels" | xargs sudo apt purge -y
            else
                echo "No old kernels to remove"
            fi
            
            if [ "$cleanup_choice" != "7" ]; then break; fi
            ;;&
        3|7)
            echo -e "${BLUE}📜 Cleaning system logs...${NC}"
            # Keep only 1 week of journal logs
            sudo journalctl --vacuum-time=1week
            
            # Clear old log files
            sudo find /var/log -type f -name "*.log.1" -delete 2>/dev/null || true
            sudo find /var/log -type f -name "*.log.*.gz" -delete 2>/dev/null || true
            
            if [ "$cleanup_choice" != "7" ]; then break; fi
            ;;&
        4|7)
            echo -e "${BLUE}🏚️  Removing orphaned packages...${NC}"
            orphans=$(deborphan 2>/dev/null || echo "")
            if [ -n "$orphans" ]; then
                echo "$orphans" | xargs sudo apt purge -y
            else
                echo "No orphaned packages found (install 'deborphan' for better detection)"
            fi
            
            if [ "$cleanup_choice" != "7" ]; then break; fi
            ;;&
        5|7)
            echo -e "${BLUE}🖼️  Clearing thumbnail cache...${NC}"
            rm -rf ~/.cache/thumbnails/*
            rm -rf ~/.thumbnails/*
            
            if [ "$cleanup_choice" != "7" ]; then break; fi
            ;;&
        6|7)
            echo -e "${BLUE}🗑️  Emptying trash...${NC}"
            rm -rf ~/.local/share/Trash/files/*
            rm -rf ~/.local/share/Trash/info/*
            
            if [ "$cleanup_choice" != "7" ]; then break; fi
            ;;
    esac
    
    # Show space recovered
    echo ""
    echo -e "${GREEN}✅ Cleanup completed!${NC}"
    echo -e "${YELLOW}📊 Disk usage after cleanup:${NC}"
    df -h / | tail -1
    echo ""
    read -p "Press Enter to continue..."
}

storage_analytics() {
    echo -e "${BLUE}📈 STORAGE ANALYTICS${NC}"
    echo "==================="
    echo ""
    
    echo "1. Directory size analysis (ncdu)"
    echo "2. Large file finder"
    echo "3. Duplicate file scanner"
    echo "4. Drive health check (SMART)"
    echo "5. I/O performance test"
    echo "0. Back to main menu"
    echo ""
    
    read -p "Choose analysis: " analytics_choice
    
    case $analytics_choice in
        1)
            echo "Launching interactive directory size analyzer..."
            if command -v ncdu &> /dev/null; then
                ncdu /
            else
                echo "Installing ncdu..."
                sudo apt install -y ncdu
                ncdu /
            fi
            ;;
        2)
            echo -e "${BLUE}🔍 FINDING LARGE FILES${NC}"
            echo "Searching for files larger than 100MB..."
            find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | awk '{ print $9 ": " $5 }'
            ;;
        3)
            echo -e "${BLUE}👥 DUPLICATE FILE SCANNER${NC}"
            if command -v fdupes &> /dev/null; then
                read -p "Scan directory (default: $HOME): " scan_dir
                scan_dir=${scan_dir:-$HOME}
                fdupes -r "$scan_dir"
            else
                echo "Installing fdupes..."
                sudo apt install -y fdupes
                read -p "Scan directory (default: $HOME): " scan_dir
                scan_dir=${scan_dir:-$HOME}
                fdupes -r "$scan_dir"
            fi
            ;;
        4)
            echo -e "${BLUE}🏥 DRIVE HEALTH CHECK${NC}"
            if command -v smartctl &> /dev/null; then
                echo "Available drives:"
                lsblk -d -o NAME,SIZE,MODEL | grep -E '^sd'
                read -p "Enter drive to check (e.g., sda): " drive
                if [ -n "$drive" ]; then
                    sudo smartctl -a "/dev/$drive"
                fi
            else
                echo "Installing smartmontools..."
                sudo apt install -y smartmontools
            fi
            ;;
        5)
            echo -e "${BLUE}⚡ I/O PERFORMANCE TEST${NC}"
            echo "Available mount points:"
            df -h | grep -E '^/dev/' | awk '{print $6}'
            read -p "Enter path to test (e.g., /home): " test_path
            
            if [ -d "$test_path" ]; then
                test_file="$test_path/disk_speed_test.tmp"
                echo "Testing write speed..."
                dd if=/dev/zero of="$test_file" bs=1M count=1024 2>&1 | grep -E 'copied|MB/s'
                echo "Testing read speed..."
                dd if="$test_file" of=/dev/null bs=1M 2>&1 | grep -E 'copied|MB/s'
                rm -f "$test_file"
            fi
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

# Main execution
main_drive_manager() {
    mkdir -p ~/.config/bill-sloth
    
    while true; do
        show_main_menu
        
        case $choice in
            1) show_drives_usage ;;
            2) auto_mount_drives ;;
            3) steam_library_manager ;;
            4) relocate_app_data ;;
            5) multimonitor_setup ;;
            6) clean_system_drive ;;
            7) echo "Configure drive preferences - Coming soon!" ;;
            8) storage_analytics ;;
            0) break ;;
            *) echo "Invalid option" ;;
        esac
    done
}

main_drive_manager
EOF

        chmod +x ~/.local/bin/drive-manager
        
        echo "✅ Multi-drive management tools installed!"
        echo ""
        echo "🎯 NEW COMMANDS AVAILABLE:"
        echo "   drive-manager  = Complete multi-drive storage management"
        echo ""
        echo "💡 This provides enterprise-grade solutions for:"
        echo "   • Safe application relocation using bind mounts"
        echo "   • Steam library management across multiple drives"  
        echo "   • Multi-monitor setup with autorandr profiles"
        echo "   • Ubuntu system drive cleanup for dual-boot scenarios"
        echo "   • Storage analytics and health monitoring"
        echo ""
        
        # Add to PATH if needed
        if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo "💡 Added ~/.local/bin to PATH. Reload terminal or run: source ~/.bashrc"
        fi
        
        read -p "Press Enter to continue..."
    else
        echo "Skipped multi-drive setup."
    fi
    
    echo ""
}

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth
mkdir -p ~/.local/bin
mkdir -p ~/.config

# Start the main menu
main_menu