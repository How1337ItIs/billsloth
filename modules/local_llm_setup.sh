#!/bin/bash
# LLM_CAPABILITY: local_ok
# Local AI Stack Setup - Open Interpreter + Ollama for offline AI capabilities

echo "🤖 LOCAL AI STACK INSTALLER"
echo "============================"
echo "Installing Open Interpreter + Ollama for offline AI capabilities..."
echo ""

# Check if already installed
if command -v ollama &> /dev/null && python3 -c "import interpreter" &> /dev/null; then
    echo "✅ Local AI stack already installed!"
    echo "🧠 Current models:"
    ollama list 2>/dev/null || echo "No models installed"
    exit 0
fi

# Install Ollama
echo "📦 Installing Ollama..."
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.ai/install.sh | sh
    echo "✅ Ollama installed"
else
    echo "✅ Ollama already installed"
fi

# Start Ollama service
echo "🚀 Starting Ollama service..."
ollama serve &
sleep 5

# Install Open Interpreter
echo "📦 Installing Open Interpreter..."
pip3 install --user "open-interpreter[all]" || {
    echo "⚠️ Trying with sudo..."
    sudo pip3 install "open-interpreter[all]"
}

# Pull recommended model
echo "📥 Pulling CodeLlama 13B model (this may take a while - ~7GB download)..."
ollama pull codellama:13b-instruct

# Add PowerShell adapter
echo "⚡ Adding PowerShell adapter to Open Interpreter..."
cat > "$(python3 - <<'PY'
import site, pathlib
try:
    p = pathlib.Path(site.getsitepackages()[0]) / "interpreter" / "code_interpreters" / "powershell.py"
    print(p)
except:
    print("/tmp/powershell_adapter.py")
PY
)" <<'PY'
from interpreter.code_interpreters.base import CodeInterpreter
import subprocess, tempfile, textwrap, os

class PowerShell(CodeInterpreter):
    file_extension = "ps1"
    
    def __init__(self):
        super().__init__()
        self.language = "powershell"
        
    def run(self, code):
        with tempfile.NamedTemporaryFile(mode='w', suffix='.ps1', delete=False) as f:
            f.write(code)
            temp_file = f.name
            
        try:
            if os.name == 'nt':
                result = subprocess.run(['powershell', '-ExecutionPolicy', 'Bypass', '-File', temp_file], 
                                      capture_output=True, text=True, timeout=30)
            else:
                result = subprocess.run(['pwsh', '-File', temp_file], 
                                      capture_output=True, text=True, timeout=30)
            return result.stdout, result.stderr
        except subprocess.TimeoutExpired:
            return "", "PowerShell execution timed out"
        finally:
            os.unlink(temp_file)
PY

# Configure Open Interpreter for local use
echo "⚙️ Configuring Open Interpreter for local model..."
python3 -c "
import interpreter
interpreter.llm.model = 'ollama/codellama:13b-instruct'
interpreter.llm.api_base = 'http://localhost:11434'
interpreter.offline = True
interpreter.auto_run = False
print('✅ Open Interpreter configured for local model')
"

# Log successful installation
HISTORY_LOG="$HOME/.bill-sloth/history.log"
mkdir -p "$(dirname "$HISTORY_LOG")"
echo "$(date '+%Y-%m-%d %H:%M:%S'): Local AI stack installed successfully (Ollama + Open Interpreter + CodeLlama 13B)" >> "$HISTORY_LOG"

echo ""
echo "🎉 LOCAL AI STACK INSTALLATION COMPLETE!"
echo "========================================"
echo "✅ Ollama: $(ollama --version 2>/dev/null || echo 'installed')"
echo "✅ Open Interpreter: $(python3 -c 'import interpreter; print(interpreter.__version__)' 2>/dev/null || echo 'installed')"
echo "✅ CodeLlama 13B: $(ollama list | grep codellama || echo 'downloading...')"
echo ""
echo "🧠 You can now use local AI with:"
echo "   OFFLINE_MODE=1 ./lab.sh"
echo ""
echo "💡 Local model is good for:"
echo "   • Code execution and file operations"
echo "   • Log parsing and data processing" 
echo "   • Bulk media tasks"
echo "   • Offline development work"
echo ""
echo "⚠️  For bleeding-edge guidance or web research, use Claude Code (cloud)"