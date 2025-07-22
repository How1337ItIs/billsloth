#!/bin/bash
# Plugin: install_bc.sh
# Installs bc calculator for Bill Sloth scripts
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_bc.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v bc &>/dev/null; then
  log "✅ bc is already installed."
  exit 0
fi

log "🧮 Installing bc calculator..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y bc | tee -a "$LOG_FILE"

log "✅ bc installation complete."