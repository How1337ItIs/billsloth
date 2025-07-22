#!/bin/bash
# Plugin: install_nodejs.sh
# Installs Node.js 18+ and npm for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_nodejs.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v node &>/dev/null && [ "$(node --version | cut -d. -f1 | tr -d 'v')" -ge 18 ]; then
  log "✅ Node.js $(node --version) is already installed."
  exit 0
fi

log "🔧 Installing Node.js 18.x and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - | tee -a "$LOG_FILE"
sudo apt-get install -y nodejs | tee -a "$LOG_FILE"

log "✅ Node.js installation complete. Version: $(node --version)" 