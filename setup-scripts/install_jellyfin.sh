#!/bin/bash
# Plugin: install_jellyfin.sh
# Installs Jellyfin media server using Docker
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_jellyfin.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if docker ps -a --format '{{.Names}}' | grep -q '^jellyfin$'; then
  log "✅ Jellyfin Docker container already exists."
  exit 0
fi

log "🔧 Pulling Jellyfin Docker image..."
docker pull jellyfin/jellyfin:latest | tee -a "$LOG_FILE"

JELLYFIN_CONFIG="$HOME/.bill-sloth/jellyfin_config"
JELLYFIN_CACHE="$HOME/.bill-sloth/jellyfin_cache"
JELLYFIN_MEDIA="$HOME/Media"
mkdir -p "$JELLYFIN_CONFIG" "$JELLYFIN_CACHE" "$JELLYFIN_MEDIA"

log "🔧 Starting Jellyfin Docker container..."
docker run -d --name jellyfin \
  -p 8096:8096 \
  -v "$JELLYFIN_CONFIG":/config \
  -v "$JELLYFIN_CACHE":/cache \
  -v "$JELLYFIN_MEDIA":/media \
  jellyfin/jellyfin:latest | tee -a "$LOG_FILE"

log "✅ Jellyfin is running at http://localhost:8096" 