#!/bin/bash
# LLM_CAPABILITY: auto
# AI Playground setup

install_ollama() {
    echo "🦙 Installing Ollama..."
    curl -fsSL https://ollama.ai/install.sh | sh
    sudo systemctl enable ollama
    sudo systemctl start ollama
}

ollama_model_recommendations() {
    # Check VRAM
    if command -v nvidia-smi &>/dev/null; then
        vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -1)
        echo "💾 Detected VRAM: ${vram}MB"
        
        if [ $vram -lt 4000 ]; then
            echo "📦 Recommended models: phi3, gemma:2b, tinyllama"
        elif [ $vram -lt 8000 ]; then
            echo "📦 Recommended models: llama3.2, mistral, codellama:7b"
        else
            echo "📦 Recommended models: llama3.1:70b, mixtral, deepseek-coder:33b"
        fi
    else
        echo "💻 No NVIDIA GPU detected. Stick to smaller models."
    fi
}

setup_stable_diffusion() {
    echo "🎨 Setting up Stable Diffusion..."
    echo "Options:"
    echo "1) ComfyUI (node-based, flexible)"
    echo "2) Automatic1111 (traditional UI)"
    echo "3) Stable Diffusion WebUI Forge (optimized)"
}

create_ai_shortcuts() {
    # Create simple 'ai' command
    cat > ~/bin/ai << 'EOF'
#!/bin/bash
echo "🤖 AI Assistant Ready!"
model=$(ollama list | grep -v NAME | head -1 | awk '{print $1}')
if [ -z "$model" ]; then
    echo "No models found. Pull one with: ollama pull llama3.2"
else
    ollama run $model
fi
EOF
    chmod +x ~/bin/ai
}