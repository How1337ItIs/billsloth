#!/bin/bash
# Bill Sloth Centralized Kill-Switch Library
# Single implementation for VPN kill-switch functionality
# Replaces duplicate implementations across modules

# Source error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# Kill-switch state file
KILL_SWITCH_STATE="$HOME/.bill-sloth/security/kill_switch.state"
KILL_SWITCH_BACKUP="$HOME/.bill-sloth/security/iptables_backup.rules"

# Ensure security directory exists
create_directory "$(dirname "$KILL_SWITCH_STATE")" || exit 1

# Auto-detect VPN interface
detect_vpn_interface() {
    local interface=""
    
    # Check for common VPN interfaces in order of preference
    for iface in tun0 tun1 wg0 wg1 ppp0; do
        if ip link show "$iface" &>/dev/null; then
            interface="$iface"
            break
        fi
    done
    
    # If no standard interface found, look for any tun or wg interface
    if [ -z "$interface" ]; then
        interface=$(ip link show | grep -E '^[0-9]+: (tun|wg)' | head -1 | cut -d: -f2 | tr -d ' ')
    fi
    
    if [ -n "$interface" ]; then
        log_info "Detected VPN interface: $interface"
        echo "$interface"
        return 0
    else
        log_warning "No VPN interface detected"
        return 1
    fi
}

# Check if kill-switch is currently enabled
is_kill_switch_enabled() {
    if [ -f "$KILL_SWITCH_STATE" ]; then
        local state
        state=$(cat "$KILL_SWITCH_STATE" 2>/dev/null)
        [ "$state" = "enabled" ]
    else
        return 1
    fi
}

# Get kill-switch status with details
kill_switch_status() {
    print_header "VPN Kill-Switch Status"
    
    if is_kill_switch_enabled; then
        log_success "Kill-switch is ENABLED"
        
        # Show which interface is protected
        if [ -f "$KILL_SWITCH_STATE.interface" ]; then
            local interface
            interface=$(cat "$KILL_SWITCH_STATE.interface")
            log_info "Protected interface: $interface"
            
            # Check if interface still exists
            if ! ip link show "$interface" &>/dev/null; then
                log_warning "Protected interface $interface no longer exists!"
            fi
        fi
        
        # Show active rules
        echo ""
        log_info "Active firewall rules:"
        sudo iptables -L OUTPUT -n -v | grep -E "(DROP|ACCEPT)" | head -10
        
    else
        log_warning "Kill-switch is DISABLED"
        log_info "Run 'kill_switch_enable' to protect your connection"
    fi
    
    # Check for backup
    if [ -f "$KILL_SWITCH_BACKUP" ]; then
        log_info "Firewall backup exists (can be restored)"
    fi
    
    return 0
}

# Enable kill-switch
kill_switch_enable() {
    local interface="${1:-}"
    
    # Check if already enabled
    if is_kill_switch_enabled; then
        log_warning "Kill-switch is already enabled"
        kill_switch_status
        return 0
    fi
    
    # Auto-detect interface if not provided
    if [ -z "$interface" ]; then
        interface=$(detect_vpn_interface) || {
            log_error "No VPN interface detected. Please specify interface manually."
            log_info "Usage: kill_switch_enable <interface>"
            log_info "Example: kill_switch_enable tun0"
            return 1
        }
    fi
    
    # Verify interface exists
    if ! ip link show "$interface" &>/dev/null; then
        log_error "Interface $interface does not exist"
        return 1
    fi
    
    # Check for sudo/root
    if [ "$EUID" -ne 0 ] && ! sudo -n true 2>/dev/null; then
        log_error "Kill-switch requires sudo privileges"
        log_info "Please run with sudo or configure passwordless sudo for iptables"
        return 1
    fi
    
    log_info "Enabling kill-switch for interface: $interface"
    
    # Backup current iptables rules
    log_progress "Backing up current firewall rules..."
    if sudo iptables-save > "$KILL_SWITCH_BACKUP" 2>/dev/null; then
        log_success "Firewall rules backed up"
    else
        log_warning "Could not backup firewall rules"
        if ! confirm "Continue without backup?"; then
            return 1
        fi
    fi
    
    # Apply kill-switch rules
    log_progress "Applying kill-switch rules..."
    
    # Allow localhost
    sudo iptables -A OUTPUT -o lo -j ACCEPT || {
        log_error "Failed to add localhost rule"
        return 1
    }
    
    # Allow VPN interface
    sudo iptables -A OUTPUT -o "$interface" -j ACCEPT || {
        log_error "Failed to add VPN interface rule"
        sudo iptables -D OUTPUT -o lo -j ACCEPT 2>/dev/null
        return 1
    }
    
    # Allow established connections
    sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT || {
        log_error "Failed to add established connections rule"
        kill_switch_cleanup
        return 1
    }
    
    # Allow DHCP (needed for some networks)
    sudo iptables -A OUTPUT -p udp --dport 67:68 -j ACCEPT || {
        log_warning "Could not add DHCP rule (may not be needed)"
    }
    
    # Allow DNS to VPN
    sudo iptables -A OUTPUT -p udp --dport 53 -o "$interface" -j ACCEPT || {
        log_warning "Could not add DNS rule"
    }
    
    # DROP everything else
    sudo iptables -A OUTPUT -j DROP || {
        log_error "Failed to add DROP rule"
        kill_switch_cleanup
        return 1
    }
    
    # Save state
    echo "enabled" > "$KILL_SWITCH_STATE"
    echo "$interface" > "$KILL_SWITCH_STATE.interface"
    
    log_success "Kill-switch ENABLED for interface $interface"
    log_warning "All traffic except through $interface is now BLOCKED"
    log_info "To disable: run 'kill_switch_disable'"
    
    return 0
}

# Disable kill-switch
kill_switch_disable() {
    if ! is_kill_switch_enabled; then
        log_warning "Kill-switch is already disabled"
        return 0
    fi
    
    # Check for sudo/root
    if [ "$EUID" -ne 0 ] && ! sudo -n true 2>/dev/null; then
        log_error "Kill-switch requires sudo privileges"
        return 1
    fi
    
    log_info "Disabling kill-switch..."
    
    # Try to restore from backup first
    if [ -f "$KILL_SWITCH_BACKUP" ]; then
        log_progress "Restoring firewall rules from backup..."
        if sudo iptables-restore < "$KILL_SWITCH_BACKUP" 2>/dev/null; then
            log_success "Firewall rules restored from backup"
        else
            log_warning "Could not restore from backup, flushing rules instead"
            kill_switch_cleanup
        fi
    else
        log_warning "No backup found, flushing OUTPUT chain"
        kill_switch_cleanup
    fi
    
    # Update state
    echo "disabled" > "$KILL_SWITCH_STATE"
    rm -f "$KILL_SWITCH_STATE.interface"
    
    log_success "Kill-switch DISABLED"
    log_info "Normal network connectivity restored"
    
    return 0
}

# Clean up kill-switch rules (internal function)
kill_switch_cleanup() {
    # Flush OUTPUT chain
    sudo iptables -F OUTPUT 2>/dev/null || true
    
    # Reset OUTPUT policy to ACCEPT
    sudo iptables -P OUTPUT ACCEPT 2>/dev/null || true
}

# Test kill-switch connectivity
kill_switch_test() {
    print_header "Testing Kill-Switch"
    
    if ! is_kill_switch_enabled; then
        log_warning "Kill-switch is not enabled"
        return 1
    fi
    
    # Get protected interface
    local interface=""
    if [ -f "$KILL_SWITCH_STATE.interface" ]; then
        interface=$(cat "$KILL_SWITCH_STATE.interface")
    fi
    
    log_info "Testing connectivity..."
    
    # Test localhost (should work)
    log_progress "Testing localhost..."
    if ping -c 1 -W 2 127.0.0.1 &>/dev/null; then
        log_success "Localhost connectivity OK"
    else
        log_error "Localhost connectivity FAILED (this should not happen)"
    fi
    
    # Test VPN connectivity (should work if VPN is up)
    if [ -n "$interface" ]; then
        log_progress "Testing VPN connectivity on $interface..."
        if ping -c 1 -W 2 -I "$interface" 1.1.1.1 &>/dev/null; then
            log_success "VPN connectivity OK"
        else
            log_warning "VPN connectivity FAILED (is VPN connected?)"
        fi
    fi
    
    # Test direct internet (should fail)
    log_progress "Testing kill-switch blocking..."
    local main_interface
    main_interface=$(ip route | grep default | head -1 | awk '{print $5}')
    
    if [ -n "$main_interface" ] && [ "$main_interface" != "$interface" ]; then
        if ! ping -c 1 -W 2 -I "$main_interface" 8.8.8.8 &>/dev/null; then
            log_success "Kill-switch is BLOCKING direct internet (working correctly)"
        else
            log_error "Kill-switch FAILED - direct internet is accessible!"
            log_warning "Your kill-switch may not be working properly"
        fi
    fi
    
    return 0
}

# Toggle kill-switch
kill_switch_toggle() {
    if is_kill_switch_enabled; then
        kill_switch_disable
    else
        kill_switch_enable "$@"
    fi
}

# Main function for standalone execution
kill_switch_main() {
    local command="${1:-status}"
    shift || true
    
    case "$command" in
        enable|on)
            kill_switch_enable "$@"
            ;;
        disable|off)
            kill_switch_disable
            ;;
        status)
            kill_switch_status
            ;;
        test)
            kill_switch_test
            ;;
        toggle)
            kill_switch_toggle "$@"
            ;;
        *)
            echo "Usage: $0 {enable|disable|status|test|toggle} [interface]"
            echo ""
            echo "Commands:"
            echo "  enable [interface]  - Enable kill-switch (auto-detects interface)"
            echo "  disable            - Disable kill-switch"
            echo "  status             - Show current kill-switch status"
            echo "  test               - Test kill-switch functionality"
            echo "  toggle [interface] - Toggle kill-switch on/off"
            echo ""
            echo "Examples:"
            echo "  $0 enable          # Auto-detect VPN interface"
            echo "  $0 enable tun0     # Use specific interface"
            echo "  $0 disable         # Disable kill-switch"
            echo "  $0 status          # Check current status"
            return 1
            ;;
    esac
}

# Export functions for use in other scripts
export -f detect_vpn_interface is_kill_switch_enabled
export -f kill_switch_enable kill_switch_disable kill_switch_status
export -f kill_switch_test kill_switch_toggle

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    kill_switch_main "$@"
fi