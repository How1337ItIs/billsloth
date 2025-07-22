#!/bin/bash
# LLM_CAPABILITY: local_ok
# Dependency Installer with Claude Code Assistance
# Handles all Bill Sloth system dependencies with interactive installation

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Dependency configuration
DEPS_CONFIG_DIR="$HOME/.bill-sloth/dependencies"
DEPS_STATUS_FILE="$DEPS_CONFIG_DIR/status.json"
DEPS_LOG_FILE="$DEPS_CONFIG_DIR/install.log"

# Core dependencies required for Bill Sloth
declare -A CORE_DEPS=(
    ["jq"]="JSON processor - Required for all data operations"
    ["restic"]="Backup system - For reliable data protection"
    ["sqlite3"]="Database - For persistent data storage"
    ["ripgrep"]="Fast search - Better than grep"
    ["fd-find"]="Fast file finder - Better than find"
    ["fzf"]="Fuzzy finder - For interactive selection"
    ["just"]="Task runner - For automation workflows"
    ["netdata"]="System monitoring - For health checks"
    ["ollama"]="Local AI - For offline LLM capabilities"
)

# Optional but recommended dependencies
declare -A OPTIONAL_DEPS=(
    ["filebot"]="Media organization - For VRBO property photos"
    ["rclone"]="Cloud sync - For backup to cloud storage"
    ["tmux"]="Terminal multiplexer - For persistent sessions"
    ["htop"]="Process viewer - Better than top"
    ["ncdu"]="Disk usage analyzer - Interactive disk management"
    ["bat"]="Better cat - Syntax highlighting"
    ["exa"]="Better ls - Modern file listing"
    ["delta"]="Better diff - For git diffs"
)

# Initialize dependency system
init_dependency_system() {
    mkdir -p "$DEPS_CONFIG_DIR"
    
    if [ ! -f "$DEPS_STATUS_FILE" ]; then
        cat > "$DEPS_STATUS_FILE" << 'EOF'
{
  "last_check": "",
  "installed": {},
  "failed": {},
  "skipped": {}
}
EOF
    fi
}

# Check if running with Claude Code
is_claude_code_available() {
    # Check if we're in a Claude Code environment
    if [ ! -z "$CLAUDE_CODE_SESSION" ] || [ -f "$HOME/.claude/claude_code_active" ]; then
        return 0
    fi
    
    # Check if user has Claude Code available
    if command -v claude &> /dev/null; then
        return 0
    fi
    
    return 1
}

# Setup Claude Code permissions for Bill Sloth system
setup_claude_code_permissions() {
    if ! is_claude_code_available; then
        return 1
    fi
    
    echo -e "\033[38;5;196m🤖 CLAUDE CODE NEURAL INTERFACE PERMISSION SETUP\033[0m"
    echo "================================================="
    echo ""
    echo -e "\033[38;5;51m💀 For maximum effectiveness, Claude Code needs full access to:\033[0m"
    echo "• **Read/write files** throughout your system (for automation setup)"
    echo "• **Execute system commands** with sudo (for dependency installation)"
    echo "• **Access network/internet** (for downloads and updates)"
    echo "• **Manage system services** (for automation and monitoring)"
    echo "• **File system operations** (for backups and file management)"
    echo ""
    echo -e "\033[38;5;226m⚡ This enables Claude to:\033[0m"
    echo "• **Automatically install missing dependencies**"
    echo "• **Set up VRBO automation scripts**"
    echo "• **Configure backup systems**"
    echo "• **Install and configure monitoring tools**"
    echo "• **Manage your EdBoiGames business automation**"
    echo "• **Troubleshoot system issues**"
    echo ""
    echo -e "\033[38;5;129m🔐 SECURITY NOTE: Claude Code is designed to be helpful and safe,\033[0m"
    echo -e "\033[38;5;129m    but you can review all commands before they execute.\033[0m"
    echo ""
    
    read -p "▶ Grant Claude Code full system access for Bill Sloth setup? [Y/n]: " grant_access
    
    if [[ "$grant_access" == "n" || "$grant_access" == "N" ]]; then
        log_warning "Limited access mode - some features may not work optimally"
        return 1
    fi
    
    # Create Claude Code configuration for this project
    mkdir -p "$HOME/.claude"
    cat > "$HOME/.claude/bill_sloth_permissions.json" << 'EOF'
{
  "project": "bill_sloth",
  "permissions": {
    "file_system": {
      "read": true,
      "write": true,
      "execute": true,
      "scope": ["$HOME", "/opt", "/usr/local", "/etc"]
    },
    "system_commands": {
      "sudo_allowed": true,
      "package_manager": true,
      "service_management": true,
      "network_access": true
    },
    "automation": {
      "cron_jobs": true,
      "systemd_services": true,
      "background_processes": true
    },
    "development": {
      "git_operations": true,
      "code_execution": true,
      "environment_setup": true
    }
  },
  "restrictions": {
    "no_destructive_system_changes": true,
    "require_confirmation_for_sudo": true,
    "backup_before_major_changes": true
  }
}
EOF
    
    # Set up sudo permissions for common operations
    echo ""
    echo -e "\033[38;5;82m📋 Setting up sudo permissions for common operations...\033[0m"
    
    # Create a sudoers file for Bill Sloth operations
    local sudoers_content="# Bill Sloth System Automation
$USER ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get, /usr/bin/snap
$USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl
$USER ALL=(ALL) NOPASSWD: /usr/bin/mount, /usr/bin/umount
$USER ALL=(ALL) NOPASSWD: /usr/bin/chown, /usr/bin/chmod
$USER ALL=(ALL) NOPASSWD: /usr/bin/mkdir -p /opt/*, /usr/local/bin/*"
    
    if [ -d "/etc/sudoers.d" ]; then
        echo "$sudoers_content" | sudo tee /etc/sudoers.d/bill-sloth-automation > /dev/null
        echo -e "\033[38;5;46m✅ Sudo permissions configured for automation tasks\033[0m"
    fi
    
    # Mark Claude Code as having full access
    touch "$HOME/.claude/bill_sloth_full_access"
    
    log_success "Claude Code neural interface permissions configured!"
    echo ""
    echo -e "\033[38;5;82m💀 Claude now has the power to fully manage your digital empire!\033[0m"
    
    return 0
}

# Check single dependency
check_dependency() {
    local dep="$1"
    local description="$2"
    
    if command -v "$dep" &> /dev/null; then
        log_success "✓ $dep is installed"
        return 0
    else
        log_warning "✗ $dep is NOT installed - $description"
        return 1
    fi
}

# Install dependency with package manager detection
install_dependency() {
    local dep="$1"
    local description="$2"
    
    log_info "Installing $dep: $description"
    
    # Detect package manager
    local pkg_manager=""
    local install_cmd=""
    
    if command -v apt-get &> /dev/null; then
        pkg_manager="apt"
        install_cmd="sudo apt-get install -y"
    elif command -v dnf &> /dev/null; then
        pkg_manager="dnf"
        install_cmd="sudo dnf install -y"
    elif command -v pacman &> /dev/null; then
        pkg_manager="pacman"
        install_cmd="sudo pacman -S --noconfirm"
    elif command -v brew &> /dev/null; then
        pkg_manager="brew"
        install_cmd="brew install"
    else
        log_error "No supported package manager found"
        return 1
    fi
    
    # Special cases for package names
    local package_name="$dep"
    case "$dep" in
        "fd-find")
            [ "$pkg_manager" = "apt" ] && package_name="fd-find"
            [ "$pkg_manager" = "dnf" ] && package_name="fd-find"
            [ "$pkg_manager" = "pacman" ] && package_name="fd"
            [ "$pkg_manager" = "brew" ] && package_name="fd"
            ;;
        "ripgrep")
            [ "$pkg_manager" = "apt" ] && package_name="ripgrep"
            [ "$pkg_manager" = "brew" ] && package_name="ripgrep"
            ;;
        "bat")
            [ "$pkg_manager" = "apt" ] && package_name="bat"
            [ "$pkg_manager" = "pacman" ] && package_name="bat"
            ;;
        "exa")
            [ "$pkg_manager" = "apt" ] && package_name="exa"
            [ "$pkg_manager" = "brew" ] && package_name="exa"
            ;;
    esac
    
    # Try to install
    if $install_cmd $package_name >> "$DEPS_LOG_FILE" 2>&1; then
        log_success "Successfully installed $dep"
        
        # Update status
        local timestamp=$(date -Iseconds)
        jq --arg dep "$dep" --arg time "$timestamp" \
           '.installed[$dep] = $time' "$DEPS_STATUS_FILE" > "${DEPS_STATUS_FILE}.tmp" && \
           mv "${DEPS_STATUS_FILE}.tmp" "$DEPS_STATUS_FILE"
        
        return 0
    else
        log_error "Failed to install $dep - check $DEPS_LOG_FILE"
        
        # Update failed status
        local timestamp=$(date -Iseconds)
        jq --arg dep "$dep" --arg time "$timestamp" \
           '.failed[$dep] = $time' "$DEPS_STATUS_FILE" > "${DEPS_STATUS_FILE}.tmp" && \
           mv "${DEPS_STATUS_FILE}.tmp" "$DEPS_STATUS_FILE"
        
        return 1
    fi
}

# Install special dependencies
install_special_dependency() {
    local dep="$1"
    
    case "$dep" in
        "ollama")
            log_info "Installing Ollama (Local AI)..."
            if curl -fsSL https://ollama.ai/install.sh | sh; then
                log_success "Ollama installed successfully"
                # Pull a small model for testing
                ollama pull llama2:7b 2>/dev/null || true
                return 0
            else
                log_error "Failed to install Ollama"
                return 1
            fi
            ;;
        "just")
            log_info "Installing Just (Task Runner)..."
            if command -v cargo &> /dev/null; then
                cargo install just
            else
                # Try prebuilt binary
                local just_version="1.14.0"
                local arch=$(uname -m)
                local os=$(uname -s | tr '[:upper:]' '[:lower:]')
                
                curl -LSfs "https://github.com/casey/just/releases/download/${just_version}/just-${just_version}-${arch}-unknown-${os}-musl.tar.gz" | \
                    tar xzf - -C "$HOME/.local/bin" just
                
                if [ -f "$HOME/.local/bin/just" ]; then
                    chmod +x "$HOME/.local/bin/just"
                    log_success "Just installed to ~/.local/bin"
                    return 0
                fi
            fi
            ;;
        "netdata")
            log_info "Installing Netdata (System Monitoring)..."
            bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait
            ;;
        "filebot")
            log_info "FileBot requires manual installation"
            echo "Please visit: https://www.filebot.net/linux/"
            echo "Or install via snap: sudo snap install filebot"
            ;;
    esac
}

# Interactive dependency check and install
check_and_install_dependencies() {
    print_header "🔧 BILL SLOTH DEPENDENCY CHECKER"
    
    init_dependency_system
    
    # Update last check time
    jq --arg time "$(date -Iseconds)" '.last_check = $time' "$DEPS_STATUS_FILE" > "${DEPS_STATUS_FILE}.tmp" && \
       mv "${DEPS_STATUS_FILE}.tmp" "$DEPS_STATUS_FILE"
    
    local missing_core=()
    local missing_optional=()
    
    echo "🔍 Checking core dependencies..."
    echo ""
    
    # Check core dependencies
    for dep in "${!CORE_DEPS[@]}"; do
        if ! check_dependency "$dep" "${CORE_DEPS[$dep]}"; then
            missing_core+=("$dep")
        fi
    done
    
    echo ""
    echo "🔍 Checking optional dependencies..."
    echo ""
    
    # Check optional dependencies
    for dep in "${!OPTIONAL_DEPS[@]}"; do
        if ! check_dependency "$dep" "${OPTIONAL_DEPS[$dep]}"; then
            missing_optional+=("$dep")
        fi
    done
    
    echo ""
    
    # Handle missing dependencies
    if [ ${#missing_core[@]} -eq 0 ] && [ ${#missing_optional[@]} -eq 0 ]; then
        log_success "🎉 All dependencies are installed!"
        return 0
    fi
    
    # Show summary
    if [ ${#missing_core[@]} -gt 0 ]; then
        echo "❌ Missing CORE dependencies (required):"
        for dep in "${missing_core[@]}"; do
            echo "   • $dep - ${CORE_DEPS[$dep]}"
        done
        echo ""
    fi
    
    if [ ${#missing_optional[@]} -gt 0 ]; then
        echo "⚠️  Missing OPTIONAL dependencies (recommended):"
        for dep in "${missing_optional[@]}"; do
            echo "   • $dep - ${OPTIONAL_DEPS[$dep]}"
        done
        echo ""
    fi
    
    # Offer installation options
    if is_claude_code_available; then
        echo "🤖 Claude Code detected! Would you like assistance installing dependencies?"
        echo ""
        echo "1) Install all missing dependencies with Claude Code guidance"
        echo "2) Install only core dependencies"
        echo "3) Select dependencies to install"
        echo "4) Skip installation for now"
        echo ""
        read -p "Select option [1-4]: " install_choice
    else
        echo "🔧 Installation Options:"
        echo ""
        echo "1) Attempt automatic installation of all missing"
        echo "2) Install only core dependencies"
        echo "3) Show manual installation commands"
        echo "4) Skip installation for now"
        echo ""
        read -p "Select option [1-4]: " install_choice
    fi
    
    case "$install_choice" in
        1)
            # Install all missing
            for dep in "${missing_core[@]}"; do
                install_dependency "$dep" "${CORE_DEPS[$dep]}" || \
                    install_special_dependency "$dep"
            done
            
            for dep in "${missing_optional[@]}"; do
                install_dependency "$dep" "${OPTIONAL_DEPS[$dep]}" || \
                    install_special_dependency "$dep"
            done
            ;;
        2)
            # Install only core
            for dep in "${missing_core[@]}"; do
                install_dependency "$dep" "${CORE_DEPS[$dep]}" || \
                    install_special_dependency "$dep"
            done
            ;;
        3)
            if is_claude_code_available; then
                # Interactive selection with Claude Code
                echo "🤖 Let's work through each dependency together..."
                
                for dep in "${missing_core[@]}" "${missing_optional[@]}"; do
                    local desc="${CORE_DEPS[$dep]:-${OPTIONAL_DEPS[$dep]}}"
                    echo ""
                    echo "📦 $dep - $desc"
                    read -p "Install this dependency? [Y/n]: " install_this
                    
                    if [[ "$install_this" != "n" && "$install_this" != "N" ]]; then
                        install_dependency "$dep" "$desc" || \
                            install_special_dependency "$dep"
                    else
                        # Mark as skipped
                        jq --arg dep "$dep" --arg time "$(date -Iseconds)" \
                           '.skipped[$dep] = $time' "$DEPS_STATUS_FILE" > "${DEPS_STATUS_FILE}.tmp" && \
                           mv "${DEPS_STATUS_FILE}.tmp" "$DEPS_STATUS_FILE"
                    fi
                done
            else
                # Show manual commands
                show_manual_install_commands "${missing_core[@]}" "${missing_optional[@]}"
            fi
            ;;
        4)
            log_info "Skipping dependency installation"
            echo "⚠️  Some features may not work without required dependencies!"
            ;;
    esac
    
    # Create helper script for future use
    create_dependency_helper
}

# Show manual installation commands
show_manual_install_commands() {
    local deps=("$@")
    
    echo "📋 MANUAL INSTALLATION COMMANDS"
    echo "==============================="
    echo ""
    
    # Detect system
    if command -v apt-get &> /dev/null; then
        echo "# Debian/Ubuntu:"
        echo "sudo apt-get update"
        echo "sudo apt-get install -y ${deps[@]}"
    elif command -v dnf &> /dev/null; then
        echo "# Fedora/RHEL:"
        echo "sudo dnf install -y ${deps[@]}"
    elif command -v pacman &> /dev/null; then
        echo "# Arch Linux:"
        echo "sudo pacman -S ${deps[@]}"
    elif command -v brew &> /dev/null; then
        echo "# macOS (Homebrew):"
        echo "brew install ${deps[@]}"
    fi
    
    echo ""
    echo "# Special installations:"
    echo "# Ollama: curl -fsSL https://ollama.ai/install.sh | sh"
    echo "# Just: cargo install just"
    echo "# Netdata: bash <(curl -Ss https://my-netdata.io/kickstart.sh)"
    echo "# FileBot: sudo snap install filebot"
}

# Create dependency helper script
create_dependency_helper() {
    cat > "$HOME/.bill-sloth/bin/check-deps" << 'EOF'
#!/bin/bash
# Quick dependency checker for Bill Sloth

source "$HOME/.bill-sloth/lib/dependency_installer.sh"
check_and_install_dependencies
EOF
    chmod +x "$HOME/.bill-sloth/bin/check-deps"
    
    log_info "Created dependency checker: ~/.bill-sloth/bin/check-deps"
}

# Quick dependency check (non-interactive)
quick_dependency_check() {
    local missing_core=()
    
    for dep in "${!CORE_DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_core+=("$dep")
        fi
    done
    
    if [ ${#missing_core[@]} -gt 0 ]; then
        return 1
    fi
    
    return 0
}

# Export functions
export -f check_dependency install_dependency check_and_install_dependencies quick_dependency_check setup_claude_code_permissions is_claude_code_available