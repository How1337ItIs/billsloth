#!/bin/bash
# Plugin: install_glances.sh
# Installs Glances system health monitor for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_glances.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v glances &>/dev/null; then
  log "✅ Glances is already installed."
  exit 0
fi

log "🔧 Installing Glances..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y glances | tee -a "$LOG_FILE"

log "✅ Glances installation complete." 