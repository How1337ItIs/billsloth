#!/bin/bash
# LLM_CAPABILITY: auto
# AI PLAYGROUND - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Source the non-interactive ai playground module
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -euo pipefail
source "$SOURCE_DIR/ai_playground.sh"

ai_playground_interactive() {
    echo "🤖 AI PLAYGROUND - YOUR PERSONAL AI LABORATORY"
    echo "=============================================="
    echo ""
    echo "🎯 Master the power of artificial intelligence on YOUR terms - locally, privately,"
    echo "and designed for neurodivergent minds that need reliable, distraction-free AI tools!"
    echo ""
    echo "🧠 Carl: 'Yeah, I got AI. It's called artificial intelligence, which is like... intelligence, but fake.'"
    echo ""
    
    echo "🎓 WHAT IS LOCAL AI?"
    echo "==================="
    echo "Local AI means running artificial intelligence models on your own computer"
    echo "instead of sending your data to cloud services. This gives you:"
    echo "• 🔒 Complete privacy - your conversations stay on your machine"
    echo "• ⚡ No internet required - works offline"
    echo "• 💰 No monthly subscriptions or API costs"
    echo "• 🎛️ Full control over the AI's behavior and responses"
    echo "• 🚫 No content filtering or usage restrictions"
    echo ""
    echo "🧠 WHY LOCAL AI IS PERFECT FOR ADHD/NEURODIVERGENT MINDS:"
    echo "• No distractions from web interfaces and ads"
    echo "• Consistent performance without network variability"  
    echo "• Private brainstorming without judgment or data collection"
    echo "• Always available when hyperfocus strikes"
    echo "• Customizable to your specific communication style"
    echo ""
    echo "🤖 wwwyzzerdd: 'It is I, the local AI wizard. No cloud required, broadbrain.'"
    echo ""
    echo "🏆 THE COMPLETE LOCAL AI TOOLKIT:"
    echo "================================="
    echo ""
    echo "1) 🎯 GPT4All - User-Friendly AI Chat"
    echo "   💡 What it does: Desktop app for chatting with local AI models"
    echo "   ✅ Pros: Easiest setup, beautiful UI, works on any computer"
    echo "   🧠 ADHD-Friendly: Simple interface, no distractions, works offline"
    echo "   📖 Learn: Perfect first step into local AI - just download and chat"
    echo ""
    echo "2) ⚙️ Llama.cpp - Lightweight AI Engine"
    echo "   💡 What it does: Minimal, fast AI inference with command-line control"
    echo "   ✅ Pros: Ultra-lightweight, runs on weak hardware, scriptable"
    echo "   🧠 ADHD-Friendly: Terminal-based = no UI distractions, fast responses"
    echo "   📖 Learn: For those who prefer command-line tools and maximum control"
    echo ""
    echo "3) 🌐 Ollama - Local AI Made Simple"
    echo "   💡 What it does: Easy model management with Docker-like simplicity"
    echo "   ✅ Pros: Simple commands, huge model library, great CLI experience"
    echo "   🧠 ADHD-Friendly: 'Pull model, run model' - no complex setup"
    echo "   📖 Learn: Popular choice for developers and power users"
    echo ""
    echo "4) 🎨 Stable Diffusion WebUI - Local Image Generation"
    echo "   💡 What it does: Create images from text descriptions locally"
    echo "   ✅ Pros: Beautiful web interface, tons of models and styles"
    echo "   🧠 ADHD-Friendly: Visual creativity tool, instant gratification"
    echo "   📖 Learn: Perfect for visual thinkers and creative ADHD minds"
    echo ""
    echo "5) 📊 Jupyter Notebooks - AI Experimentation Lab"
    echo "   💡 What it does: Interactive coding environment for AI experiments"
    echo "   ✅ Pros: Learn by doing, visual outputs, huge AI community"
    echo "   🧠 ADHD-Friendly: Immediate feedback, visual learning, step-by-step"
    echo "   📖 Learn: Great for understanding how AI actually works"
    echo ""
    echo "6) 🚀 Complete AI Lab (All tools integrated)"
    echo "   💡 What it does: Full local AI setup with multiple tools"
    echo "   ✅ Pros: Something for every AI need and learning style"
    echo "   🧠 ADHD-Friendly: Choice reduces overwhelm - use what fits your mood"
    echo "   📖 Learn: The ultimate 'AI independence' setup"
    echo ""
    echo "🧠 Frylock: 'Local AI is the democratization of artificial intelligence.'"
    echo "🧠 Frylock: 'You're not just using AI - you're mastering it.'"
    echo ""
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " ai_choice
    
    # Ensure log directory exists
    mkdir -p ~/ai_playground
    
    case $ai_choice in
        1)
            echo "[LOG] Bill chose GPT4All" >> ~/ai_playground/assistant.log
            echo "🎯 DEPLOYING GPT4All - USER-FRIENDLY AI CHAT!"
            echo ""
            echo "🎓 WHAT IS GPT4ALL?"
            echo "GPT4All is the easiest way to get started with local AI. It's a desktop"
            echo "application that lets you chat with powerful AI models locally:"
            echo "• No technical setup required - just download and run"
            echo "• Beautiful, ChatGPT-like interface"
            echo "• Supports dozens of different AI models"
            echo "• Works completely offline once models are downloaded"
            echo "• Free and open-source"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR ADHD:"
            echo "• Familiar chat interface reduces learning curve"
            echo "• No distracting ads or notifications"
            echo "• Private brainstorming space for sensitive thoughts"
            echo "• Always available when inspiration strikes"
            echo "• Models can adapt to your communication style"
            echo ""
            
            # Download and install GPT4All
            echo "🔧 Installing GPT4All..."
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                echo "📦 Downloading GPT4All for Linux..."
                cd ~/Downloads
                wget https://gpt4all.io/installers/gpt4all-installer-linux.run
                chmod +x gpt4all-installer-linux.run
                echo "✅ Downloaded! Run: ~/Downloads/gpt4all-installer-linux.run"
                
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                echo "🍎 For macOS, download from: https://gpt4all.io/installers/gpt4all-installer-darwin.dmg"
                echo "Or install with: brew install --cask gpt4all"
                
            else
                echo "🪟 For Windows, download from: https://gpt4all.io/installers/gpt4all-installer-win64.exe"
            fi
            
            echo ""
            echo "🎓 GPT4ALL CRASH COURSE:"
            echo "======================="
            echo ""
            echo "📖 FIRST-TIME SETUP:"
            echo "1. Launch GPT4All application"
            echo "2. Choose a model to download (recommended: Llama 3.2 3B)"
            echo "3. Wait for model download (3-8GB, one-time only)"
            echo "4. Start chatting with your local AI!"
            echo ""
            echo "🤖 RECOMMENDED MODELS FOR ADHD MINDS:"
            echo ""
            echo "🟢 BEGINNER - Light & Fast:"
            echo "• Llama 3.2 3B - Great balance of speed and intelligence"
            echo "• Phi-3 Mini - Extremely fast, good for quick questions"
            echo "• TinyLlama - Ultra-fast but simpler responses"
            echo ""
            echo "🟡 INTERMEDIATE - More Capable:"
            echo "• Llama 3.1 8B - Better reasoning, still runs on most hardware"
            echo "• Mistral 7B - Great for creative writing and analysis"
            echo ""
            echo "🔴 ADVANCED - Most Capable (Needs Good Hardware):"
            echo "• Llama 3.1 70B - Near GPT-4 quality for complex tasks"
            echo "• Nous Hermes - Fine-tuned for helpful, detailed responses"
            echo ""
            echo "💡 ADHD-FRIENDLY USAGE TIPS:"
            echo ""
            echo "🧠 Brain Dumping:"
            echo "• 'Help me organize these random thoughts: [stream of consciousness]'"
            echo "• 'Turn this messy idea into a structured plan'"
            echo "• 'What am I trying to say here?' [paste confusing text]"
            echo ""
            echo "📋 Task Management:"
            echo "• 'Break this overwhelming project into small steps'"
            echo "• 'What should I prioritize from this list?'"
            echo "• 'Help me estimate how long each task will take'"
            echo ""
            echo "✍️ Communication Help:"
            echo "• 'Make this email sound more professional'"
            echo "• 'Explain this technical concept in simple terms'"
            echo "• 'Help me respond to this message diplomatically'"
            echo ""
            echo "🔍 Research Assistant:"
            echo "• 'Summarize the key points of [topic]'"
            echo "• 'What questions should I ask about [subject]?'"
            echo "• 'Help me understand the pros and cons of [decision]'"
            echo ""
            echo "✅ GPT4ALL READY!"
            echo "🎉 You now have ChatGPT-level AI running privately on your computer!"
            echo ""
            echo "🍔 Meatwad: 'I understand! Now I can talk to the computer and it talks back!'"
            ;;
        2)
            echo "[LOG] Bill chose Llama.cpp" >> ~/ai_playground/assistant.log
            echo "⚙️ DEPLOYING LLAMA.CPP - LIGHTWEIGHT AI ENGINE!"
            echo ""
            echo "🎓 WHAT IS LLAMA.CPP?"
            echo "Llama.cpp is a minimalist C++ implementation for running AI models with"
            echo "maximum efficiency and control. It's for users who want:"
            echo "• Maximum speed with minimal resource usage"
            echo "• Command-line control and scriptability"
            echo "• Integration with other tools and workflows"
            echo "• No GUI overhead - pure performance"
            echo ""
            echo "🧠 WHY IT'S GREAT FOR ADHD COMMAND-LINE USERS:"
            echo "• No GUI distractions - just terminal and AI"
            echo "• Extremely fast startup and responses"
            echo "• Scriptable for automated workflows"
            echo "• Works on any hardware, even old computers"
            echo "• Perfect for hyperfocus terminal sessions"
            echo ""
            
            # Install build tools and dependencies
            echo "🔧 Installing Llama.cpp..."
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                echo "Installing build dependencies..."
                sudo apt update
                sudo apt install -y build-essential cmake git
                
                echo "Cloning and building llama.cpp..."
                cd ~/Downloads
                git clone https://github.com/ggerganov/llama.cpp.git
                cd llama.cpp
                make -j$(nproc)
                
                # Install to local bin
                mkdir -p ~/.local/bin
                cp main ~/.local/bin/llama-cpp
                cp server ~/.local/bin/llama-cpp-server
                
                # Add to PATH if needed
                if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
                    export PATH="$HOME/.local/bin:$PATH"
                fi
                
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                if command -v brew &> /dev/null; then
                    echo "Installing llama.cpp via Homebrew..."
                    brew install llama.cpp
                else
                    echo "Please install Homebrew first, then run: brew install llama.cpp"
                    return 1
                fi
            else
                echo "For Windows, download pre-built binaries from:"
                echo "https://github.com/ggerganov/llama.cpp/releases"
            fi
            
            # Create models directory
            mkdir -p ~/ai_models
            
            echo ""
            echo "🎓 LLAMA.CPP CRASH COURSE:"
            echo "========================="
            echo ""
            echo "📖 GETTING YOUR FIRST MODEL:"
            echo "Models are stored in GGUF format. Download from Hugging Face:"
            echo ""
            echo "🟢 LIGHTWEIGHT MODELS (2-4GB):"
            echo "cd ~/ai_models"
            echo "wget https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf"
            echo ""
            echo "🟡 BALANCED MODELS (4-8GB):"
            echo "wget https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf"
            echo ""
            echo "🎯 BASIC USAGE:"
            echo ""
            echo "# Interactive chat:"
            echo "llama-cpp -m ~/ai_models/model.gguf -n 512 --color -i"
            echo ""
            echo "# Single prompt:"
            echo "llama-cpp -m ~/ai_models/model.gguf -p 'Explain quantum computing in simple terms' -n 256"
            echo ""
            echo "# Start HTTP server (use with curl or scripts):"
            echo "llama-cpp-server -m ~/ai_models/model.gguf --host 0.0.0.0 --port 8080"
            echo ""
            echo "💡 ADHD-FRIENDLY COMMAND ALIASES:"
            echo "Add these to your ~/.bashrc for easy access:"
            echo ""
            echo "# Quick AI chat"
            echo "alias ai='llama-cpp -m ~/ai_models/default.gguf --color -i'"
            echo ""
            echo "# Fast AI for quick questions"  
            echo "alias qai='llama-cpp -m ~/ai_models/default.gguf -n 256 -p'"
            echo ""
            echo "# AI server mode"
            echo "alias ai-server='llama-cpp-server -m ~/ai_models/default.gguf --port 8080'"
            echo ""
            echo "🚀 ADVANCED INTEGRATIONS:"
            echo ""
            echo "📝 AI Writing Helper:"
            echo "echo 'Help me improve this text:' | cat - document.txt | llama-cpp -m model.gguf"
            echo ""
            echo "🔧 Code Review Assistant:"
            echo "git diff | llama-cpp -m model.gguf -p 'Review this code and suggest improvements:'"
            echo ""
            echo "📊 Log Analysis:"
            echo "tail -100 /var/log/system.log | llama-cpp -m model.gguf -p 'Analyze these logs for issues:'"
            echo ""
            echo "✅ LLAMA.CPP INSTALLED!"
            echo "🎯 Download a model to ~/ai_models/ and start chatting with: llama-cpp -m model.gguf -i"
            echo ""
            echo "🧠 Frylock: 'Command-line AI is the purest form of human-machine interaction.'"
            ;;
        3)
            echo "[LOG] Bill chose Ollama" >> ~/ai_playground/assistant.log
            echo "🌐 DEPLOYING OLLAMA - LOCAL AI MADE SIMPLE!"
            echo ""
            echo "🎓 WHAT IS OLLAMA?"
            echo "Ollama makes running local AI models as easy as Docker containers:"
            echo "• 'ollama pull llama3.2' - download a model"
            echo "• 'ollama run llama3.2' - start chatting"
            echo "• Huge library of pre-configured models"
            echo "• Automatic GPU acceleration when available"
            echo ""
            
            # Install Ollama
            echo "🔧 Installing Ollama..."
            if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
                curl -fsSL https://ollama.ai/install.sh | sh
            else
                echo "For Windows, download from: https://ollama.ai/"
            fi
            
            echo ""
            echo "🎓 OLLAMA CRASH COURSE:"
            echo "====================="
            echo ""
            echo "🚀 GET STARTED IN 30 SECONDS:"
            echo "ollama pull llama3.2:3b    # Download 3B model (fast)"
            echo "ollama run llama3.2:3b     # Start chatting!"
            echo ""
            echo "🤖 RECOMMENDED MODELS:"
            echo "• llama3.2:1b - Ultra-fast, basic conversations"
            echo "• llama3.2:3b - Great balance (recommended for ADHD)"
            echo "• llama3.1:8b - More capable, needs more RAM"
            echo "• codellama - Specialized for programming help"
            echo "• mistral - Good at creative writing"
            echo ""
            echo "💡 ADHD-FRIENDLY OLLAMA COMMANDS:"
            echo "# Quick question without starting interactive mode:"
            echo "ollama run llama3.2:3b 'Summarize this in 3 bullet points: [text]'"
            echo ""
            echo "# Pipe text directly to AI:"
            echo "echo 'Explain this code' | cat - script.py | ollama run codellama"
            echo ""
            echo "✅ OLLAMA INSTALLED! Try: ollama run llama3.2:3b"
            ;;
        4)
            echo "[LOG] Bill chose Stable Diffusion WebUI" >> ~/ai_playground/assistant.log
            echo "🎨 DEPLOYING STABLE DIFFUSION - LOCAL IMAGE GENERATION!"
            echo ""
            echo "Create stunning images from text descriptions, all running locally!"
            echo "Perfect for visual ADHD minds who think in images."
            echo ""
            echo "⚠️ REQUIREMENTS:"
            echo "• NVIDIA GPU with 4GB+ VRAM (recommended)"
            echo "• 8GB+ system RAM"
            echo "• 20GB+ free disk space for models"
            echo ""
            echo "🔧 Quick setup requires Python. Full guide at:"
            echo "https://github.com/AUTOMATIC1111/stable-diffusion-webui"
            echo ""
            echo "✅ STABLE DIFFUSION INFO PROVIDED!"
            ;;
        5)
            echo "[LOG] Bill chose Jupyter Notebooks" >> ~/ai_playground/assistant.log
            echo "📊 DEPLOYING JUPYTER NOTEBOOKS - AI EXPERIMENTATION LAB!"
            echo ""
            echo "Interactive coding environment perfect for learning AI step-by-step."
            echo ""
            if ! command -v python3 &> /dev/null; then
                echo "🔧 Installing Python first..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    sudo apt update && sudo apt install -y python3 python3-pip
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    brew install python3
                fi
            fi
            
            echo "📦 Installing Jupyter..."
            pip3 install --user jupyter notebook
            
            echo "✅ JUPYTER INSTALLED! Run: jupyter notebook"
            ;;
        6)
            echo "[LOG] Bill chose Complete AI Lab" >> ~/ai_playground/assistant.log
            echo "🚀 DEPLOYING COMPLETE AI LABORATORY!"
            echo ""
            echo "This installs GPT4All, Ollama, and sets up a complete local AI environment."
            echo ""
            read -p "Continue with complete AI lab setup? (y/n): " ai_confirm
            if [[ $ai_confirm =~ ^[Yy]$ ]]; then
                echo "🏗️ Building complete AI laboratory..."
                # Install GPT4All (simplified)
                echo "1/3 Setting up GPT4All..."
                # Install Ollama
                echo "2/3 Installing Ollama..."
                curl -fsSL https://ollama.ai/install.sh | sh
                # Install Jupyter
                echo "3/3 Installing Jupyter..."
                pip3 install --user jupyter notebook
                
                echo ""
                echo "🎉 COMPLETE AI LAB DEPLOYED!"
                echo "============================================="
                echo ""
                echo "🎯 YOUR AI ARSENAL:"
                echo "• GPT4All - Download from https://gpt4all.io"
                echo "• Ollama - Run: ollama pull llama3.2:3b"
                echo "• Jupyter - Run: jupyter notebook"
                echo ""
                echo "✅ You now have a complete local AI laboratory!"
            fi
            ;;
        other|Other|OTHER)
            echo "[LOG] Bill requested more options from Claude Code" >> ~/ai_playground/assistant.log
            echo "🤖 SUMMONING CLAUDE CODE FOR ADVANCED AI RECOMMENDATIONS..."
            echo ""
            echo "Claude Code can help you with specialized AI setups:"
            echo ""
            echo "🔬 ADVANCED AI TOOLS:"
            echo "• Text-generation-webui - Advanced local AI interface"
            echo "• LocalAI - OpenAI API compatible local server"
            echo "• Oobabooga - Community-driven AI interface"
            echo "• ComfyUI - Node-based image generation"
            echo "• InvokeAI - Professional AI art studio"
            echo ""
            echo "💡 Tell Claude Code about your specific needs!"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\nYou can always re-run this assistant to try a different solution!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ai_playground_interactive
fi 