#!/bin/bash
# Plugin: install_restic.sh
# Installs restic backup tool for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_restic.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v restic &>/dev/null; then
  log "✅ restic is already installed ($(restic version))."
  exit 0
fi

log "🔧 Installing restic backup tool..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y restic | tee -a "$LOG_FILE"

# Initialize Bill's backup repos if they don't exist
BACKUP_DIR="$HOME/.bill-sloth/backups/restic"
if [ ! -d "$BACKUP_DIR" ]; then
  log "📁 Creating backup directory structure..."
  mkdir -p "$BACKUP_DIR"/{bill_critical,vrbo_data,edboigames_content}
fi

log "✅ restic installation complete. Version: $(restic version)"
log "💡 Run 'restic init' in each backup directory to initialize repositories"