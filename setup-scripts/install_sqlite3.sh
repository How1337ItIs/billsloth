#!/bin/bash
# Plugin: install_sqlite3.sh
# Installs SQLite3 database for Bill Sloth data persistence
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_sqlite3.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v sqlite3 &>/dev/null; then
  log "✅ SQLite3 is already installed ($(sqlite3 --version))."
  exit 0
fi

log "🔧 Installing SQLite3 database..."
sudo apt-get update | tee -a "$LOG_FILE"
sudo apt-get install -y sqlite3 | tee -a "$LOG_FILE"

# Create Bill Sloth database if it doesn't exist
DB_DIR="$HOME/.bill-sloth/data"
DB_FILE="$DB_DIR/bill_sloth.db"

if [ ! -f "$DB_FILE" ]; then
  log "🗄️ Initializing Bill Sloth database..."
  mkdir -p "$DB_DIR"
  sqlite3 "$DB_FILE" << 'EOF'
CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    module TEXT NOT NULL,
    task TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    status TEXT DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS learning_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    module TEXT NOT NULL,
    action TEXT NOT NULL,
    feedback TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vrbo_guests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT,
    property TEXT,
    checkin DATE,
    checkout DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF
  log "✅ Database initialized"
fi

log "✅ SQLite3 installation complete. Version: $(sqlite3 --version)"