#!/bin/bash
# Bill Sloth Systemd Services Setup Script
# Installs and configures all Bill Sloth systemd services

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
SERVICE_USER="${SUDO_USER:-$USER}"
SERVICE_GROUP="$SERVICE_USER"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Validate system requirements
validate_requirements() {
    log_info "Validating system requirements..."
    
    # Check if systemd is available
    if ! command -v systemctl &> /dev/null; then
        log_error "systemctl not found - systemd is required"
        exit 1
    fi
    
    # Check if target user exists
    if ! id "$SERVICE_USER" &>/dev/null; then
        log_error "User '$SERVICE_USER' does not exist"
        exit 1
    fi
    
    # Check if Bill Sloth directory exists
    local bill_sloth_home="/home/$SERVICE_USER/bill sloth"
    if [ ! -d "$bill_sloth_home" ]; then
        log_error "Bill Sloth directory not found: $bill_sloth_home"
        exit 1
    fi
    
    log_success "System requirements validated"
}

# Create system directories and files
setup_system_directories() {
    log_info "Creating system directories..."
    
    # Create log directory
    mkdir -p /var/log/bill-sloth
    chown "$SERVICE_USER:$SERVICE_GROUP" /var/log/bill-sloth
    chmod 755 /var/log/bill-sloth
    
    # Create runtime directory (systemd will create this, but we set permissions)
    mkdir -p /run/bill-sloth
    chown "$SERVICE_USER:$SERVICE_GROUP" /run/bill-sloth
    chmod 755 /run/bill-sloth
    
    # Create lock directory
    mkdir -p /var/lock/bill-sloth
    chown "$SERVICE_USER:$SERVICE_GROUP" /var/lock/bill-sloth
    chmod 755 /var/lock/bill-sloth
    
    # Create system configuration directory
    mkdir -p /etc/bill-sloth
    chown root:root /etc/bill-sloth
    chmod 755 /etc/bill-sloth
    
    log_success "System directories created"
}

# Install service files
install_service_files() {
    log_info "Installing systemd service files..."
    
    local services=(
        "bill-sloth-core.service"
        "bill-sloth-monitoring.service"
        "bill-sloth-backup.service"
        "bill-sloth-daily.service"
        "bill-sloth-daily.timer"
        "bill-sloth-backup.timer"
    )
    
    for service in "${services[@]}"; do
        if [ -f "$SCRIPT_DIR/$service" ]; then
            log_info "Installing $service..."
            
            # Replace placeholder paths with actual user paths
            sed "s|/home/bill/|/home/$SERVICE_USER/|g" "$SCRIPT_DIR/$service" > "/etc/systemd/system/$service"
            chmod 644 "/etc/systemd/system/$service"
            
            log_success "$service installed"
        else
            log_warning "Service file not found: $service"
        fi
    done
    
    # Install user service
    local user_service_dir="/home/$SERVICE_USER/.config/systemd/user"
    if [ -f "$SCRIPT_DIR/bill-sloth-user.service" ]; then
        log_info "Installing user service..."
        
        sudo -u "$SERVICE_USER" mkdir -p "$user_service_dir"
        sed "s|%h|/home/$SERVICE_USER|g" "$SCRIPT_DIR/bill-sloth-user.service" > "$user_service_dir/bill-sloth-user.service"
        chown "$SERVICE_USER:$SERVICE_GROUP" "$user_service_dir/bill-sloth-user.service"
        chmod 644 "$user_service_dir/bill-sloth-user.service"
        
        log_success "User service installed"
    fi
}

# Install daemon scripts
install_daemon_scripts() {
    log_info "Installing daemon scripts..."
    
    local scripts_dir="/home/$SERVICE_USER/bill sloth/systemd/scripts"
    local daemon_scripts=(
        "bill-sloth-core-daemon.sh"
        "bill-sloth-monitoring-daemon.sh"
        "bill-sloth-backup-runner.sh"
        "bill-sloth-daily-maintenance.sh"
        "bill-sloth-user-daemon.sh"
    )
    
    for script in "${daemon_scripts[@]}"; do
        if [ -f "$SCRIPT_DIR/scripts/$script" ]; then
            cp "$SCRIPT_DIR/scripts/$script" "$scripts_dir/"
            chown "$SERVICE_USER:$SERVICE_GROUP" "$scripts_dir/$script"
            chmod 755 "$scripts_dir/$script"
            log_success "$script installed"
        else
            log_warning "Daemon script not found: $script - creating placeholder"
            create_placeholder_script "$scripts_dir/$script"
        fi
    done
}

# Create placeholder scripts for missing daemon scripts
create_placeholder_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    cat > "$script_path" << EOF
#!/bin/bash
# Placeholder script for $script_name
# This script needs to be implemented

echo "Placeholder script: $script_name"
echo "This script is not yet implemented"
exit 0
EOF
    
    chown "$SERVICE_USER:$SERVICE_GROUP" "$script_path"
    chmod 755 "$script_path"
}

# Configure system settings
configure_system_settings() {
    log_info "Configuring system settings..."
    
    # Create logrotate configuration
    cat > /etc/logrotate.d/bill-sloth << 'EOF'
/var/log/bill-sloth/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 SERVICE_USER SERVICE_GROUP
    postrotate
        systemctl reload bill-sloth-core 2>/dev/null || true
    endscript
}
EOF
    
    # Replace placeholders in logrotate config
    sed -i "s/SERVICE_USER/$SERVICE_USER/g" /etc/logrotate.d/bill-sloth
    sed -i "s/SERVICE_GROUP/$SERVICE_GROUP/g" /etc/logrotate.d/bill-sloth
    
    # Create tmpfiles configuration for runtime directory
    cat > /etc/tmpfiles.d/bill-sloth.conf << EOF
d /run/bill-sloth 0755 $SERVICE_USER $SERVICE_GROUP -
d /var/lock/bill-sloth 0755 $SERVICE_USER $SERVICE_GROUP -
EOF
    
    log_success "System settings configured"
}

# Enable and start services
enable_services() {
    log_info "Enabling and starting services..."
    
    # Reload systemd daemon
    systemctl daemon-reload
    
    # Enable and start core service
    systemctl enable bill-sloth-core.service
    log_success "bill-sloth-core.service enabled"
    
    # Enable monitoring service (it will start with core)
    systemctl enable bill-sloth-monitoring.service
    log_success "bill-sloth-monitoring.service enabled"
    
    # Enable timers
    systemctl enable bill-sloth-daily.timer
    systemctl start bill-sloth-daily.timer
    log_success "bill-sloth-daily.timer enabled and started"
    
    systemctl enable bill-sloth-backup.timer
    systemctl start bill-sloth-backup.timer
    log_success "bill-sloth-backup.timer enabled and started"
    
    # Enable user service for the target user
    sudo -u "$SERVICE_USER" systemctl --user enable bill-sloth-user.service
    log_success "bill-sloth-user.service enabled for user $SERVICE_USER"
    
    # Start core service
    log_info "Starting bill-sloth-core service..."
    if systemctl start bill-sloth-core.service; then
        log_success "bill-sloth-core.service started successfully"
    else
        log_error "Failed to start bill-sloth-core.service"
        systemctl status bill-sloth-core.service --no-pager
        return 1
    fi
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    # Check service status
    local services=("bill-sloth-core" "bill-sloth-monitoring")
    local failed_services=0
    
    for service in "${services[@]}"; do
        if systemctl is-active "$service" >/dev/null; then
            log_success "$service is running"
        else
            log_error "$service is not running"
            ((failed_services++))
        fi
    done
    
    # Check timers
    local timers=("bill-sloth-daily.timer" "bill-sloth-backup.timer")
    for timer in "${timers[@]}"; do
        if systemctl is-active "$timer" >/dev/null; then
            log_success "$timer is active"
        else
            log_error "$timer is not active"
            ((failed_services++))
        fi
    done
    
    # Check user service
    if sudo -u "$SERVICE_USER" systemctl --user is-enabled bill-sloth-user.service >/dev/null; then
        log_success "User service is enabled"
    else
        log_warning "User service is not enabled"
    fi
    
    if [ $failed_services -eq 0 ]; then
        log_success "All services are running correctly"
    else
        log_warning "$failed_services service(s) have issues"
    fi
    
    return $failed_services
}

# Display post-installation information
show_post_install_info() {
    cat << EOF

${GREEN}Bill Sloth Systemd Services Installation Complete!${NC}

${BLUE}Service Management Commands:${NC}
  Start all services:     sudo systemctl start bill-sloth-core
  Stop all services:      sudo systemctl stop bill-sloth-core
  Restart services:       sudo systemctl restart bill-sloth-core
  Check status:           sudo systemctl status bill-sloth-core
  View logs:              journalctl -u bill-sloth-core -f

${BLUE}Timer Management:${NC}
  List active timers:     systemctl list-timers bill-sloth-*
  Check timer status:     systemctl status bill-sloth-daily.timer

${BLUE}User Service:${NC}
  Start user service:     systemctl --user start bill-sloth-user
  Check user service:     systemctl --user status bill-sloth-user

${BLUE}Log Locations:${NC}
  System logs:            /var/log/bill-sloth/
  Journal logs:           journalctl -u bill-sloth-*

${BLUE}Configuration:${NC}
  System config:          /etc/bill-sloth/
  User config:            /home/$SERVICE_USER/.config/bill-sloth/

${YELLOW}Next Steps:${NC}
1. Verify services are running: sudo systemctl status bill-sloth-core
2. Check logs for any issues: journalctl -u bill-sloth-core
3. Configure any additional settings in /etc/bill-sloth/
4. Test backup functionality: sudo systemctl start bill-sloth-backup

EOF
}

# Uninstall services (for --uninstall flag)
uninstall_services() {
    log_info "Uninstalling Bill Sloth systemd services..."
    
    # Stop and disable services
    systemctl stop bill-sloth-core.service 2>/dev/null || true
    systemctl stop bill-sloth-monitoring.service 2>/dev/null || true
    systemctl stop bill-sloth-backup.timer 2>/dev/null || true
    systemctl stop bill-sloth-daily.timer 2>/dev/null || true
    
    systemctl disable bill-sloth-core.service 2>/dev/null || true
    systemctl disable bill-sloth-monitoring.service 2>/dev/null || true
    systemctl disable bill-sloth-backup.timer 2>/dev/null || true
    systemctl disable bill-sloth-daily.timer 2>/dev/null || true
    
    # Remove service files
    rm -f /etc/systemd/system/bill-sloth-*.service
    rm -f /etc/systemd/system/bill-sloth-*.timer
    
    # Remove user service
    sudo -u "$SERVICE_USER" systemctl --user stop bill-sloth-user.service 2>/dev/null || true
    sudo -u "$SERVICE_USER" systemctl --user disable bill-sloth-user.service 2>/dev/null || true
    rm -f "/home/$SERVICE_USER/.config/systemd/user/bill-sloth-user.service"
    
    # Remove configuration files
    rm -f /etc/logrotate.d/bill-sloth
    rm -f /etc/tmpfiles.d/bill-sloth.conf
    
    # Reload systemd
    systemctl daemon-reload
    sudo -u "$SERVICE_USER" systemctl --user daemon-reload
    
    log_success "Bill Sloth systemd services uninstalled"
}

# Main installation function
main() {
    local command="${1:-install}"
    
    case "$command" in
        install)
            check_root
            validate_requirements
            setup_system_directories
            install_service_files
            install_daemon_scripts
            configure_system_settings
            enable_services
            if verify_installation; then
                show_post_install_info
            else
                log_error "Installation completed with some issues - check service status"
                exit 1
            fi
            ;;
        uninstall)
            check_root
            uninstall_services
            ;;
        verify)
            check_root
            verify_installation
            ;;
        *)
            echo "Usage: $0 {install|uninstall|verify}"
            echo ""
            echo "Commands:"
            echo "  install   - Install Bill Sloth systemd services"
            echo "  uninstall - Remove Bill Sloth systemd services"  
            echo "  verify    - Verify installation status"
            exit 1
            ;;
    esac
}

# Execute main function
main "$@"