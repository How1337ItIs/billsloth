#!/bin/bash
# Plugin: install_voice2json.sh
# Installs voice2json for offline voice/intent recognition
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_voice2json.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v voice2json &>/dev/null; then
  log "✅ voice2json is already installed."
  exit 0
fi

log "🔧 Installing voice2json..."
wget -O /tmp/voice2json.deb "https://github.com/synesthesiam/voice2json/releases/latest/download/voice2json_2.2.3_amd64.deb" | tee -a "$LOG_FILE"
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y sox libsox-fmt-all jq | tee -a "$LOG_FILE"
sudo dpkg -i /tmp/voice2json.deb | tee -a "$LOG_FILE" || sudo apt-get install -f -y | tee -a "$LOG_FILE"
rm -f /tmp/voice2json.deb

log "✅ voice2json installation complete." 