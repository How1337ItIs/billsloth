#!/bin/bash
# Plugin: install_ripgrep.sh
# Installs ripgrep (rg) fast search tool for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_ripgrep.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v rg &>/dev/null; then
  log "✅ ripgrep is already installed ($(rg --version | head -1))."
  exit 0
fi

log "🔍 Installing ripgrep fast search tool..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y ripgrep | tee -a "$LOG_FILE"

log "✅ ripgrep installation complete. Version: $(rg --version | head -1)"
log "💡 Use 'rg' instead of grep for faster searches!"