#!/bin/bash
# AI PLAYGROUND - Ollama, Stable Diffusion, local AI
# Claude Code orchestrates based on system capabilities

echo "AI_PLAYGROUND_MODULE_LOADED"

ai_capabilities() {
    echo "AI Playground Module Capabilities:"
    echo "1. Ollama installation and model management"
    echo "2. Stable Diffusion setup (ComfyUI/Automatic1111)"
    echo "3. Local AI model recommendations based on VRAM"
    echo "4. AI development environment setup"
    echo "5. GPU acceleration configuration"
    echo "6. Voice AI setup (Whisper, TTS)"
}

install_ollama() {
    echo "[*] Installing Ollama..."
    curl -fsSL https://ollama.ai/install.sh | sh
    
    # Start Ollama service
    sudo systemctl enable ollama
    sudo systemctl start ollama
    
    echo "[✓] Ollama installed and running"
}

recommend_models() {
    echo "[*] Analyzing system for AI model recommendations..."
    
    # Check VRAM
    if command -v nvidia-smi &> /dev/null; then
        vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -1)
        echo "NVIDIA GPU detected with ${vram}MB VRAM"
        
        if [ "$vram" -gt 16000 ]; then
            echo "Recommended models: llama2:70b, codellama:34b, stable-diffusion-xl"
        elif [ "$vram" -gt 8000 ]; then
            echo "Recommended models: llama2:13b, codellama:13b, mistral:7b"
        elif [ "$vram" -gt 4000 ]; then
            echo "Recommended models: llama2:7b, codellama:7b, phi"
        else
            echo "Recommended models: tinyllama, phi (quantized versions)"
        fi
    else
        echo "No NVIDIA GPU detected. Recommended CPU models: tinyllama, phi"
    fi
}

setup_ollama_models() {
    echo "[*] Setting up recommended Ollama models..."
    
    # Pull essential models based on system
    ollama pull llama2:7b
    ollama pull codellama:7b
    ollama pull phi
    
    # Create AI chat alias
    echo 'alias ai="ollama run llama2:7b"' >> ~/.bashrc
    echo 'alias code-ai="ollama run codellama:7b"' >> ~/.bashrc
    
    echo "[✓] Ollama models installed"
}

install_stable_diffusion() {
    echo "[*] Installing Stable Diffusion (ComfyUI)..."
    
    # Install dependencies
    sudo apt update
    sudo apt install -y python3-pip python3-venv git
    
    # Clone ComfyUI
    cd ~/Downloads
    git clone https://github.com/comfyanonymous/ComfyUI.git
    cd ComfyUI
    
    # Create virtual environment
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    
    # Download basic model
    mkdir -p models/checkpoints
    echo "[*] Claude Code should help download appropriate models based on VRAM"
    
    echo "[✓] ComfyUI installed"
}

setup_ai_dev_environment() {
    echo "[*] Setting up AI development environment..."
    
    # Install Python AI libraries
    pip3 install --user \
        torch \
        transformers \
        diffusers \
        accelerate \
        datasets \
        gradio \
        streamlit \
        jupyter \
        notebook
    
    # Install CUDA support if NVIDIA GPU present
    if command -v nvidia-smi &> /dev/null; then
        pip3 install --user torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    fi
    
    echo "[✓] AI development environment ready"
}

install_whisper() {
    echo "[*] Installing OpenAI Whisper for voice AI..."
    
    pip3 install --user openai-whisper
    
    # Create voice transcription shortcut
    cat > ~/bin/transcribe << 'EOF'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: transcribe <audio_file>"
    exit 1
fi
whisper "$1" --model base --output_format txt
EOF
    chmod +x ~/bin/transcribe
    
    echo "[✓] Whisper installed with transcribe command"
}

create_ai_shortcuts() {
    echo "[*] Creating AI shortcuts..."
    
    # AI launcher script
    cat > ~/bin/ai-lab << 'EOF'
#!/bin/bash
echo "🤖 AI Playground"
echo "1) Chat with AI (Ollama)"
echo "2) Generate image (Stable Diffusion)"
echo "3) Transcribe audio (Whisper)"
echo "4) Open Jupyter notebook"
echo "5) Launch ComfyUI"
read -p "Choice: " choice

case $choice in
    1) ollama run llama2:7b ;;
    2) cd ~/Downloads/ComfyUI && python main.py ;;
    3) read -p "Audio file: "; whisper "$REPLY" ;;
    4) jupyter notebook ;;
    5) cd ~/Downloads/ComfyUI && python main.py --listen ;;
esac
EOF
    chmod +x ~/bin/ai-lab
    
    echo "[✓] AI shortcuts created - run 'ai-lab' to start"
}

check_ai_setup() {
    echo "[*] AI setup verification:"
    
    # Check Ollama
    if command -v ollama &> /dev/null; then
        echo "✓ Ollama: $(ollama list | wc -l) models installed"
    else
        echo "✗ Ollama: Not installed"
    fi
    
    # Check Python AI libraries
    python3 -c "import torch; print(f'✓ PyTorch: {torch.__version__}')" 2>/dev/null || echo "✗ PyTorch: Not installed"
    python3 -c "import transformers; print(f'✓ Transformers: {transformers.__version__}')" 2>/dev/null || echo "✗ Transformers: Not installed"
    
    # Check GPU acceleration
    if command -v nvidia-smi &> /dev/null; then
        python3 -c "import torch; print(f'✓ CUDA available: {torch.cuda.is_available()}')" 2>/dev/null
    fi
    
    # Check Whisper
    if command -v whisper &> /dev/null; then
        echo "✓ Whisper: Installed"
    else
        echo "✗ Whisper: Not installed"
    fi
}

# Anime AI prompt suggestions for Bill
create_anime_prompts() {
    echo "[*] Creating anime prompt suggestions..."
    mkdir -p ~/AIAssets/prompts
    
    cat > ~/AIAssets/prompts/anime_prompts.txt << 'EOF'
# Anime Character Prompts for Stable Diffusion
anime girl, pink hair, blue eyes, school uniform, cherry blossoms, highly detailed
cyberpunk anime character, neon lights, futuristic city, detailed face
cute anime mascot, chibi style, colorful, kawaii, simple background
anime warrior, samurai armor, katana, dramatic lighting, action pose
magical girl, transformation sequence, sparkles, pastel colors
EOF

    echo "[✓] Anime prompts saved to ~/AIAssets/prompts/"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This AI module should be executed by Claude Code"
    echo "Available functions: install_ollama, recommend_models, setup_ollama_models, install_stable_diffusion, setup_ai_dev_environment"
fi