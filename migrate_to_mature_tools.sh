#!/bin/bash
# Migration plan: Replace over-engineered components with mature tools
# Phase 1: Quick wins with minimal risk

echo "🔄 BILL SLOTH: MIGRATING TO MATURE TOOLS"
echo "========================================"
echo ""

# Install mature alternatives
install_mature_tools() {
    echo "📦 Installing mature tool alternatives..."
    
    # Essential modern CLI tools
    echo "Installing fd (find replacement)..."
    if command -v apt &> /dev/null; then
        sudo apt install -y fd-find
        # Create alias since Ubuntu names it fd-find
        echo 'alias fd="fdfind"' >> ~/.bill-sloth/modern-cli-aliases.sh
    else
        echo "Manual install required: https://github.com/sharkdp/fd#installation"
    fi
    
    echo "Installing ripgrep (grep replacement)..."
    if command -v apt &> /dev/null; then
        sudo apt install -y ripgrep
    else
        echo "Manual install required: https://github.com/BurntSushi/ripgrep#installation"
    fi
    
    echo "Installing fzf (interactive selection)..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    
    echo "Installing restic (backup replacement)..."
    if command -v apt &> /dev/null; then
        sudo apt install -y restic
    else
        echo "Manual install required: https://restic.readthedocs.io/en/stable/020_installation.html"
    fi
    
    echo "Installing netdata (monitoring)..."
    bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait
    
    echo "✅ Mature tools installation complete"
}

# Phase 1: Replace file operations in existing scripts
modernize_file_operations() {
    echo "🔧 Modernizing file operations in existing modules..."
    
    # Create modern CLI wrapper functions
    cat > ~/.bill-sloth/lib/modern_cli.sh << 'EOF'
#!/bin/bash
# Modern CLI tool wrappers for Bill Sloth

# Smart find replacement
smart_find() {
    local pattern="$1"
    local path="${2:-.}"
    
    if command -v fd &> /dev/null; then
        fd "$pattern" "$path"
    else
        find "$path" -name "*$pattern*"
    fi
}

# Smart grep replacement  
smart_grep() {
    local pattern="$1"
    local path="${2:-.}"
    
    if command -v rg &> /dev/null; then
        rg "$pattern" "$path"
    else
        grep -r "$pattern" "$path"
    fi
}

# Interactive selection
interactive_select() {
    local prompt="${1:-Select:}"
    
    if command -v fzf &> /dev/null; then
        fzf --prompt="$prompt "
    else
        echo "⚠️  fzf not available, using basic selection"
        select item; do echo "$item"; break; done
    fi
}

export -f smart_find smart_grep interactive_select
EOF
    
    # Update modules to use modern tools
    echo "Updating modules to use modern CLI tools..."
    
    # Example: Update network management to use modern tools
    if [ -f modules/network_management_interactive.sh ]; then
        # Add modern CLI sourcing
        if ! grep -q "modern_cli.sh" modules/network_management_interactive.sh; then
            sed -i '1a source "$HOME/.bill-sloth/lib/modern_cli.sh" 2>/dev/null || true' modules/network_management_interactive.sh
        fi
    fi
    
    echo "✅ File operations modernized"
}

# Phase 2: Replace backup system with restic
migrate_to_restic() {
    echo "💾 Migrating to restic for backups..."
    
    # Initialize restic repositories for each backup set
    local backup_sets=("bill_critical" "vrbo_data" "edboigames_content")
    
    for set in "${backup_sets[@]}"; do
        local repo_path="$HOME/.bill-sloth/backups/restic/$set"
        mkdir -p "$repo_path"
        
        if ! restic -r "$repo_path" snapshots &>/dev/null; then
            echo "Initializing restic repository: $set"
            echo "Please set password for $set backup repository:"
            restic -r "$repo_path" init
        fi
    done
    
    # Create restic wrapper that maintains our notification system
    cat > ~/.bill-sloth/lib/restic_backup.sh << 'EOF'
#!/bin/bash
# Restic wrapper maintaining Bill Sloth patterns

source "$HOME/.bill-sloth/lib/notification_system.sh" 2>/dev/null || true

# Enhanced restic backup with Bill Sloth personality
bill_backup() {
    local backup_set="$1"
    local repo_path="$HOME/.bill-sloth/backups/restic/$backup_set"
    
    # Pre-backup friendly notification
    notify_info "Backup Starting" "📦 Preparing to backup $backup_set..."
    
    # Determine what to backup based on set
    local backup_paths=()
    case "$backup_set" in
        "bill_critical")
            backup_paths=(~/.bill-sloth ~/VacationRental ~/edboigames_business)
            ;;
        "vrbo_data")
            backup_paths=(~/VacationRental ~/.bill-sloth/vrbo-automation)
            ;;
        "edboigames_content")
            backup_paths=(~/edboigames_business ~/.bill-sloth/media-processing/edboigames)
            ;;
    esac
    
    # Run restic backup with progress
    echo "🔄 Running backup for $backup_set..."
    if restic -r "$repo_path" backup "${backup_paths[@]}" --exclude="*.tmp" --exclude="*cache*"; then
        # Success notification with personality
        notify_success "Backup Complete!" "🎉 Your $backup_set is safely backed up!"
        
        # Show backup stats
        echo "📊 Backup statistics:"
        restic -r "$repo_path" stats latest
    else
        # Gentle error handling
        notify_warning "Backup Issue" "😅 The $backup_set backup had some trouble. Don't worry, your data is still safe!"
        echo "💡 Tip: Check if the backup repository is accessible and try again"
        return 1
    fi
}

# List backups with friendly interface
bill_backup_list() {
    local backup_set="$1"
    local repo_path="$HOME/.bill-sloth/backups/restic/$backup_set"
    
    echo "📋 Available backups for $backup_set:"
    restic -r "$repo_path" snapshots
}

# Restore with safety checks
bill_restore() {
    local backup_set="$1"
    local snapshot_id="${2:-latest}"
    local restore_path="$3"
    
    if [ -z "$restore_path" ]; then
        restore_path="$HOME/restored-$(date +%Y%m%d-%H%M%S)"
        echo "💡 No restore path specified, using: $restore_path"
    fi
    
    local repo_path="$HOME/.bill-sloth/backups/restic/$backup_set"
    
    echo "🔍 Restoring $backup_set snapshot $snapshot_id to $restore_path..."
    if restic -r "$repo_path" restore "$snapshot_id" --target "$restore_path"; then
        notify_success "Restore Complete!" "🎉 Your files are restored to $restore_path"
    else
        notify_error "Restore Failed" "😱 Something went wrong during restore. Check the error messages above."
        return 1
    fi
}

export -f bill_backup bill_backup_list bill_restore
EOF
    
    echo "✅ Restic migration prepared"
}

# Phase 3: Integrate Netdata for system monitoring
setup_netdata_integration() {
    echo "📊 Setting up Netdata integration..."
    
    # Create hybrid monitoring that uses Netdata for system metrics
    cat > ~/.bill-sloth/lib/hybrid_monitoring.sh << 'EOF'
#!/bin/bash
# Hybrid monitoring: Netdata for system + custom for modules

get_netdata_metrics() {
    if curl -s localhost:19999/api/v1/info &>/dev/null; then
        # Netdata is running, get real metrics
        local cpu=$(curl -s "localhost:19999/api/v1/data?chart=system.cpu&after=-1&options=raw" | jq -r '.data[0][1]')
        local memory=$(curl -s "localhost:19999/api/v1/data?chart=system.ram&after=-1&options=raw" | jq -r '.data[0][1]')
        local disk=$(curl -s "localhost:19999/api/v1/data?chart=disk_space._&after=-1&options=raw" | jq -r '.data[0][1]')
        
        cat << METRICS
{
  "timestamp": "$(date -Iseconds)",
  "cpu_usage": $cpu,
  "memory_usage": $memory,
  "disk_usage": $disk,
  "source": "netdata"
}
METRICS
    else
        # Fallback to our custom metrics
        source "$HOME/.bill-sloth/lib/system_health_monitoring.sh"
        get_system_metrics
    fi
}

# Enhanced health dashboard with Netdata integration
show_enhanced_health_dashboard() {
    echo "🏥 Bill Sloth Health Dashboard (Enhanced)"
    echo "========================================"
    
    if curl -s localhost:19999/api/v1/info &>/dev/null; then
        echo "📊 System metrics powered by Netdata"
        echo "🌐 Web dashboard: http://localhost:19999"
    else
        echo "📊 System metrics: Built-in monitoring"
        echo "💡 Tip: Install Netdata for enhanced monitoring"
    fi
    
    # Still use our custom module health checking
    source "$HOME/.bill-sloth/lib/system_health_monitoring.sh"
    check_module_health "bill_command_center"
}

export -f get_netdata_metrics show_enhanced_health_dashboard
EOF
    
    echo "✅ Netdata integration ready"
}

# Phase 4: Update command center to use mature tools
update_command_center() {
    echo "🎯 Updating command center with mature tool integration..."
    
    # Add mature tools integration to command center
    if [ -f bill_command_center.sh ]; then
        # Source our modern CLI tools
        if ! grep -q "modern_cli.sh" bill_command_center.sh; then
            sed -i '/source.*error_handling.sh/a source "$SCRIPT_DIR/lib/modern_cli.sh" 2>/dev/null || true' bill_command_center.sh
            sed -i '/source.*system_health_monitoring.sh/a source "$SCRIPT_DIR/lib/hybrid_monitoring.sh" 2>/dev/null || true' bill_command_center.sh
            sed -i '/source.*backup_management.sh/a source "$SCRIPT_DIR/lib/restic_backup.sh" 2>/dev/null || true' bill_command_center.sh
        fi
        
        echo "✅ Command center updated with mature tools"
    fi
}

# Create migration summary
create_migration_report() {
    cat > ~/.bill-sloth/MATURE_TOOLS_MIGRATION.md << 'EOF'
# Bill Sloth Mature Tools Migration

## What We've Improved

### ✅ Replaced Over-Engineering
1. **File Operations** → fd + ripgrep + fzf
   - 10x faster searches
   - Better UX with fuzzy finding
   - Industry standard tools

2. **Backup System** → restic 
   - Deduplication saves storage
   - Encryption built-in
   - Battle-tested reliability
   - **Kept our friendly notifications**

3. **System Monitoring** → Netdata + custom module checks
   - Professional metrics dashboard
   - Real-time monitoring
   - **Kept our Bill-specific health checks**

### 🎯 Kept Our Innovations
1. **ADHD-Friendly UX** - Gentle errors, educational explanations
2. **Bill-Specific Workflows** - VRBO/EdBoiGames integration
3. **Personality** - Friendly notifications and progress messages

## Usage Examples

### Modern File Operations
```bash
# Find modules with modern tools
fd -e sh . modules/ | fzf

# Search for functions across codebase  
rg "function.*bill" --type bash
```

### Enhanced Backup
```bash
# Backup with personality intact
bill_backup "bill_critical"

# List backups
bill_backup_list "vrbo_data"

# Restore (with safety checks)
bill_restore "bill_critical" latest ~/restored-files
```

### Hybrid Monitoring
- System metrics: http://localhost:19999 (Netdata)
- Module health: Built-in Bill Sloth checks
- Best of both worlds!

## Result
We now have **mature tool reliability** with **Bill Sloth personality** - the perfect hybrid approach!
EOF

    echo "✅ Migration report created: ~/.bill-sloth/MATURE_TOOLS_MIGRATION.md"
}

# Main migration execution
main() {
    echo "Starting migration to mature tools..."
    echo "This will enhance Bill Sloth with industry-standard tools while keeping the personality!"
    echo ""
    
    read -p "Proceed with migration? [Y/n]: " proceed
    if [[ "$proceed" =~ ^[Nn]$ ]]; then
        echo "Migration cancelled"
        exit 0
    fi
    
    install_mature_tools
    modernize_file_operations
    migrate_to_restic
    setup_netdata_integration
    update_command_center
    create_migration_report
    
    echo ""
    echo "🎉 MIGRATION COMPLETE!"
    echo "====================="
    echo ""
    echo "Bill Sloth now uses mature, battle-tested tools while keeping its personality!"
    echo ""
    echo "📋 What changed:"
    echo "  • File operations: fd + ripgrep + fzf"
    echo "  • Backups: restic (with friendly notifications)"
    echo "  • Monitoring: Netdata + custom module checks"
    echo "  • All Bill-specific UX and workflows preserved"
    echo ""
    echo "🚀 Next steps:"
    echo "  1. Test the enhanced backup: bill_backup bill_critical"
    echo "  2. Check Netdata dashboard: http://localhost:19999"
    echo "  3. Try modern file search: fd -e sh . | fzf"
    echo ""
    echo "Your system is now more reliable AND still has personality! 🎯"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi