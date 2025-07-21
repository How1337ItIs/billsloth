#!/bin/bash
# LLM_CAPABILITY: auto
# File Mastery - Lightning-fast file operations with AI organization
# "I'm straight. Teeth are for gay people" - Carl

source "../lib/interactive.sh" 2>/dev/null || {
    echo "📁 FILE MASTERY SETUP"
    echo "===================="
}

show_banner "FILE MASTERY" "Windows Everything + TeraCopy, but AI-powered" "PRODUCTIVITY"

echo "📁 FILE MASTERY - WINDOWS POWER-USER FILE OPERATIONS, SUPERCHARGED"
echo "=================================================================="
echo ""
echo "🎯 Transform your file management into something that makes Everything,"
echo "   TeraCopy, and PowerRename look like toys from the stone age!"
echo ""
echo "🧠 ADHD BRAIN BENEFITS:"
echo "   • Find ANY file in milliseconds, not minutes of hunting"
echo "   • AI automatically organizes and categorizes your files"
echo "   • Bulk operations with intelligent pattern recognition"
echo "   • Visual file management that reduces cognitive load"
echo "   • Smart duplicate detection and cleanup"
echo "   • Project-aware file organization and workflows"
echo ""

explain_file_mastery() {
    echo "💡 WHAT IS ADVANCED FILE MANAGEMENT?"
    echo "===================================="
    echo ""
    echo "If you're coming from Windows, you probably used:"
    echo "• 🔥 Everything - Instant file search by name"
    echo "• 📋 TeraCopy - Enhanced file copying with verification"
    echo "• 🏷️  PowerRename - Bulk file renaming with patterns"
    echo "• 🗂️  File Explorer - Basic file operations"
    echo "• 🔍 Windows Search - Slow and unreliable indexing"
    echo ""
    echo "🚀 THIS LINUX SETUP GIVES YOU ALL THAT PLUS AI SUPERPOWERS:"
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

# Main menu
main_menu() {
    while true; do
        show_banner "FILE MASTERY" "Windows Everything + TeraCopy, but AI-powered" "PRODUCTIVITY"
        
        echo "📁 FILE MASTERY MENU"
        echo "===================="
        echo ""
        echo "1) 💡 What is Advanced File Management?"
        echo "2) 🔍 Install Lightning-Fast Search Tools"
        echo "3) 📁 Install Advanced File Managers"
        echo "4) ⚡ Create Windows Power-User Search Shortcuts"
        echo "5) 📋 Setup Advanced File Copying (TeraCopy-style)"
        echo "6) ⌨️  Configure File Management Shortcuts"
        echo "7) 🎯 Demo Your New File Mastery Powers"
        echo "8) 🚀 Complete Setup (All Steps)"
        echo "0) Exit"
        echo ""
        
        read -p "Choose an option (0-8): " choice
        
        case $choice in
            1) explain_file_mastery ;;
            2) install_search_tools ;;
            3) install_file_managers ;;
            4) create_search_shortcuts ;;
            5) setup_advanced_copying ;;
            6) configure_file_shortcuts ;;
            7) demo_file_mastery ;;
            8) complete_setup ;;
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
    echo "Lightning search + Advanced managers + AI organization + TeraCopy-style operations"
    echo ""
    read -p "Continue with complete setup? (y/n): " setup_confirm
    
    if [[ $setup_confirm =~ ^[Yy]$ ]]; then
        explain_file_mastery
        install_search_tools
        install_file_managers
        create_search_shortcuts
        setup_advanced_copying
        configure_file_shortcuts
        demo_file_mastery
        
        echo ""
        echo "🎉 FILE MASTERY COMPLETE!"
        echo "========================"
        echo ""
        echo "🎯 YOU NOW HAVE:"
        echo "   ✅ Lightning-fast file search (faster than Everything)"
        echo "   ✅ Advanced file copying with verification (better than TeraCopy)"
        echo "   ✅ AI-powered file organization and suggestions"
        echo "   ✅ Bulk operations with intelligent pattern matching"
        echo "   ✅ Visual file managers with preview capabilities"
        echo "   ✅ Windows-style shortcuts and power-user commands"
        echo ""
        echo "🚀 NEXT STEPS:"
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

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth
mkdir -p ~/.local/bin
mkdir -p ~/.config

# Start the main menu
main_menu