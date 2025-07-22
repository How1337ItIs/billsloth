#!/bin/bash
# Plugin: install_filebot.sh
# Installs FileBot for media management in Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_filebot.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v filebot &>/dev/null; then
  log "✅ FileBot is already installed."
  exit 0
fi

log "🔧 Installing FileBot..."
wget -O /tmp/filebot.deb "https://get.filebot.net/filebot/FileBot_5.2.4/FileBot_5.2.4_amd64.deb" | tee -a "$LOG_FILE"
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y openjdk-17-jre | tee -a "$LOG_FILE"
sudo dpkg -i /tmp/filebot.deb | tee -a "$LOG_FILE" || sudo apt-get install -f -y | tee -a "$LOG_FILE"
rm -f /tmp/filebot.deb

log "✅ FileBot installation complete." 