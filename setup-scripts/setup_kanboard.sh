#!/bin/bash
# Plugin: setup_kanboard.sh
# Installs and configures Kanboard (Kanban project management) using Docker
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/setup_kanboard.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if docker ps -a --format '{{.Names}}' | grep -q '^kanboard$'; then
  log "✅ Kanboard Docker container already exists."
  exit 0
fi

log "🔧 Pulling Kanboard Docker image..."
docker pull kanboard/kanboard:latest | tee -a "$LOG_FILE"

KANBOARD_DATA="$HOME/.bill-sloth/kanboard_data"
mkdir -p "$KANBOARD_DATA"

log "🔧 Starting Kanboard Docker container..."
docker run -d --name kanboard \
  -p 8081:80 \
  -v "$KANBOARD_DATA":/var/www/app/data \
  kanboard/kanboard:latest | tee -a "$LOG_FILE"

log "✅ Kanboard is running at http://localhost:8081 (default login: admin/admin)" 