#!/bin/bash
# These provide structure for Claude Code to follow
# But Claude Code makes decisions and handles errors

ollama_setup_steps() {
    echo "Ollama Setup Steps:"
    echo "1. Install Ollama"
    echo "2. Pull models based on VRAM"
    echo "3. Create 'ai' shortcut"
    echo "4. Test installation"
}

stable_diffusion_steps() {
    echo "Stable Diffusion Setup Steps:"
    echo "1. Check GPU compatibility"
    echo "2. Install ComfyUI or Automatic1111"
    echo "3. Download starter models"
    echo "4. Configure for Bill's hardware"
}

install_ollama() {
    echo "Installing Ollama..."
    curl -fsSL https://ollama.ai/install.sh | sh
    echo "Ollama installed! Starting service..."
    systemctl start ollama
    systemctl enable ollama
}

recommend_ollama_models() {
    local vram=$1
    echo "Based on your VRAM ($vram), recommending:"
    
    if [[ $vram -ge 16 ]]; then
        echo "- llama3.1:70b (large model)"
        echo "- codellama:34b (coding)"
        echo "- mixtral:8x7b (fast)"
    elif [[ $vram -ge 8 ]]; then
        echo "- llama3.1:8b (good balance)"
        echo "- codellama:13b (coding)"
        echo "- mistral:7b (fast)"
    else
        echo "- llama3.1:3b (lightweight)"
        echo "- phi3:mini (very fast)"
        echo "- tinyllama:1.1b (ultrafast)"
    fi
}

setup_comfyui() {
    echo "ComfyUI Setup Steps:"
    echo "1. Clone ComfyUI repository"
    echo "2. Create Python virtual environment"
    echo "3. Install dependencies"
    echo "4. Download base models"
    echo "5. Create startup script"
}

setup_automatic1111() {
    echo "Automatic1111 Setup Steps:"
    echo "1. Clone stable-diffusion-webui"
    echo "2. Run webui.sh installer"
    echo "3. Download base models to models/Stable-diffusion/"
    echo "4. Configure for GPU acceleration"
    echo "5. Create desktop shortcut"
}

ai_model_recommendations() {
    echo "AI Model Recommendations for Bill:"
    echo ""
    echo "Text Generation:"
    echo "- llama3.1:8b (general purpose)"
    echo "- codellama:13b (coding assistance)"
    echo "- mistral:7b (fast responses)"
    echo ""
    echo "Image Generation:"
    echo "- SD 1.5 (stable, lots of models)"
    echo "- SDXL (higher quality)"
    echo "- SD Turbo (fast generation)"
    echo ""
    echo "Specialized:"
    echo "- whisper (speech to text)"
    echo "- llava (vision + language)"
}

create_ai_shortcuts() {
    echo "Creating AI shortcuts..."
    
    # Ollama chat shortcut
    echo '#!/bin/bash' > ~/ai
    echo 'ollama run llama3.1:8b' >> ~/ai
    chmod +x ~/ai
    
    # ComfyUI shortcut
    echo '#!/bin/bash' > ~/sd
    echo 'cd ~/ComfyUI && python main.py' >> ~/sd
    chmod +x ~/sd
    
    echo "Shortcuts created: ~/ai (text), ~/sd (images)"
}

check_ai_requirements() {
    echo "Checking AI setup requirements..."
    
    # Check GPU
    if nvidia-smi &>/dev/null; then
        echo "✓ NVIDIA GPU detected"
        vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -1)
        echo "✓ VRAM: ${vram}MB"
    else
        echo "⚠ No NVIDIA GPU detected - will use CPU"
    fi
    
    # Check Python
    if python3 --version &>/dev/null; then
        echo "✓ Python3 available"
    else
        echo "✗ Python3 needed"
    fi
    
    # Check disk space
    available=$(df -h ~ | awk 'NR==2{print $4}')
    echo "✓ Available space: $available"
}

setup_local_ai_environment() {
    echo "Setting up local AI environment for Bill..."
    echo "This will:"
    echo "1. Install Ollama for text generation"
    echo "2. Set up Stable Diffusion for images"
    echo "3. Create easy shortcuts"
    echo "4. Download starter models"
    echo "5. Configure for Bill's hardware"
}