#!/bin/bash
# Plugin: install_obs.sh
# Installs and configures OBS Studio for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_obs.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v obs &>/dev/null; then
  log "✅ OBS Studio is already installed."
  exit 0
fi

log "🔧 Installing OBS Studio..."
sudo add-apt-repository ppa:obsproject/obs-studio -y | tee -a "$LOG_FILE"
sudo apt update | tee -a "$LOG_FILE"
sudo apt install -y obs-studio v4l2loopback-dkms | tee -a "$LOG_FILE"

log "✅ OBS Studio installation complete." 