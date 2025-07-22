#!/bin/bash
# Plugin: install_docker.sh
# Installs Docker Engine and Docker Compose for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_docker.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v docker &>/dev/null; then
  log "✅ Docker is already installed."
  exit 0
fi

log "🔧 Installing Docker Engine..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release | tee -a "$LOG_FILE"

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | tee -a "$LOG_FILE"

log "✅ Docker installation complete." 