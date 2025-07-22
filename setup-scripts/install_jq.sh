#!/bin/bash
# Plugin: install_jq.sh
# Installs jq JSON processor for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_jq.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v jq &>/dev/null; then
  log "✅ jq is already installed ($(jq --version))."
  exit 0
fi

log "🔧 Installing jq JSON processor..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y jq | tee -a "$LOG_FILE"

log "✅ jq installation complete. Version: $(jq --version)"