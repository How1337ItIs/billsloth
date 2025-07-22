#!/bin/bash
# Plugin: configure_vpn.sh
# Installs and configures OpenVPN and WireGuard for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/configure_vpn.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "🔧 Installing VPN tools (OpenVPN, WireGuard)..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y openvpn wireguard network-manager-openvpn-gnome | tee -a "$LOG_FILE"

log "✅ VPN tools installed."

# Check for ProtonVPN CLI
if ! command -v protonvpn &>/dev/null; then
  log "🔧 Installing ProtonVPN CLI..."
  sudo apt-get install -y python3-pip | tee -a "$LOG_FILE"
  pip3 install --user protonvpn-cli || sudo pip3 install protonvpn-cli
  log "✅ ProtonVPN CLI installed."
else
  log "✅ ProtonVPN CLI is already installed."
fi

log "🔒 VPN configuration complete. Please use your provider's instructions to import configs." 