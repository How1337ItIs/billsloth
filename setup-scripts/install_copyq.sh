#!/bin/bash
# Plugin: install_copyq.sh
# Installs CopyQ clipboard manager for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_copyq.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v copyq &>/dev/null; then
  log "✅ CopyQ is already installed."
  exit 0
fi

log "🔧 Installing CopyQ clipboard manager..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y copyq | tee -a "$LOG_FILE"

log "✅ CopyQ installation complete." 