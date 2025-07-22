#!/bin/bash
# Plugin: install_ollama.sh
# Installs Ollama local AI runner for Bill Sloth
set -e

LOG_FILE="$HOME/.bill-sloth/plugin_logs/install_ollama.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

if command -v ollama &>/dev/null; then
  log "✅ Ollama is already installed."
  ollama version | tee -a "$LOG_FILE"
  exit 0
fi

log "🤖 Installing Ollama local AI..."
curl -fsSL https://ollama.ai/install.sh | sh 2>&1 | tee -a "$LOG_FILE"

# Start Ollama service
log "🚀 Starting Ollama service..."
sudo systemctl enable ollama
sudo systemctl start ollama

# Wait for service to be ready
sleep 5

# Pull a small model for testing
log "📥 Pulling small test model (tinyllama)..."
ollama pull tinyllama 2>&1 | tee -a "$LOG_FILE" || {
  log "⚠️  Failed to pull test model - you can do this later"
}

log "✅ Ollama installation complete."
log "💡 Recommended models based on your hardware:"
log "   - Low VRAM (4GB): tinyllama, phi3"
log "   - Medium VRAM (8GB): llama3.2, mistral"
log "   - High VRAM (16GB+): llama3.1:70b, mixtral"