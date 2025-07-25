#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=AI Pipeline, 2=Workflow Builder, 3=Tool Integration, 4=Automation Scripts, 5=Complete AI Workflow
# CLAUDE_PROMPTS: Workflow type selection, AI tool configuration, Integration setup
# CLAUDE_DEPENDENCIES: python3, docker, api-tools, workflow-engines
# AI WORKFLOW AUTOMATION - INTERACTIVE ASSISTANT PATTERN
# AI integration, workflow automation, and intelligent tool orchestration

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

# Source required libraries
source "$SOURCE_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SOURCE_DIR/../lib/interactive.sh" 2>/dev/null || true

ai_workflow_interactive() {
    echo "🤖 AI WORKFLOW AUTOMATION - YOUR INTELLIGENT DIGITAL ASSISTANT"
    echo "=============================================================="
    echo ""
    echo "🎯 Transform your workflows with AI-powered automation that learns"
    echo "from your patterns and handles complex tasks intelligently!"
    echo ""
    echo "🧠 Frylock: 'Using advanced AI algorithms to manipulate reality itself!'"
    echo ""
    
    # AI capability assessment
    echo "🔍 AI WORKFLOW ASSESSMENT"
    echo "========================"
    echo ""
    echo "Before we build your AI automation empire, let's understand your needs:"
    echo ""
    echo "🤖 What type of AI workflows do you want to automate?"
    echo "1) Content Creation & Writing - AI-powered content generation"
    echo "2) Data Analysis & Processing - AI-driven insights and automation"
    echo "3) Communication & Customer Service - AI chatbots and responses"
    echo "4) Creative Work - AI-assisted design, coding, and problem-solving"
    echo "5) All of the above - Complete AI workflow transformation"
    echo ""
    read -p "Your AI automation goals (1-5): " ai_goals
    
    echo ""
    echo "🧠 Current AI tool usage:"
    echo "• Do you use ChatGPT, Claude, or other AI assistants? (y/n): "
    read -p "> " uses_ai
    echo "• Are you interested in local/offline AI models? (y/n): "
    read -p "> " wants_local_ai
    echo "• Do you want AI to help with repetitive tasks? (y/n): "
    read -p "> " wants_automation
    echo "• Would you like AI-powered content generation? (y/n): "
    read -p "> " wants_content_ai
    
    # Generate personalized AI plan
    generate_ai_plan "$ai_goals" "$uses_ai" "$wants_local_ai" "$wants_automation" "$wants_content_ai"
    
    echo ""
    echo "🏆 CHOOSE YOUR AI AUTOMATION PATH:"
    echo "=================================="
    echo ""
    echo "1) 🧠 ChatGPT API Integration (Cloud AI Powerhouse)"
    echo "   💡 What it does: Integrate OpenAI's GPT models into your workflows"
    echo "   ✅ Features: Content generation, code assistance, data analysis"
    echo "   🧠 ADHD-Friendly: Reduces writing friction, provides instant help"
    echo "   📖 Learn: Professional AI API integration and automation"
    echo ""
    echo "2) 🏠 Local AI Models (Offline AI Independence)"
    echo "   💡 What it does: Run AI models locally with Ollama for privacy"
    echo "   ✅ Features: Offline AI, no data sharing, unlimited usage"
    echo "   🧠 ADHD-Friendly: Always available, no internet dependency"
    echo "   📖 Learn: Self-hosted AI and model management"
    echo ""
    echo "3) ✍️ AI Content Generation Workflows (Creative Automation)"
    echo "   💡 What it does: Automated content creation for blogs, social media"
    echo "   ✅ Features: Blog posts, emails, social content, documentation"
    echo "   🧠 ADHD-Friendly: Overcomes writer's block, maintains consistency"
    echo "   📖 Learn: Content strategy and AI-assisted creativity"
    echo ""
    echo "4) 📊 AI Data Analysis & Insights (Intelligent Analytics)"
    echo "   💡 What it does: AI-powered data processing and insight generation"
    echo "   ✅ Features: Automated reporting, trend analysis, data visualization"
    echo "   🧠 ADHD-Friendly: Turns complex data into simple insights"
    echo "   📖 Learn: Data science and AI-driven decision making"
    echo ""
    echo "5) 🔧 AI Task Automation (Intelligent Workflow Orchestration)"
    echo "   💡 What it does: AI that manages and optimizes your workflows"
    echo "   ✅ Features: Smart scheduling, adaptive automation, learning systems"
    echo "   🧠 ADHD-Friendly: AI handles complex decision-making"
    echo "   📖 Learn: Advanced automation and AI orchestration"
    echo ""
    echo "6) 🚀 Complete AI Automation Empire (Everything Above)"
    echo "   💡 What it does: Full AI-powered workflow transformation"
    echo "   ✅ Features: All AI tools integrated and working together"
    echo "   🧠 ADHD-Friendly: AI becomes your intelligent digital assistant"
    echo "   📖 Learn: Master-level AI workflow automation"
    echo ""
    echo "🧠 Shake: 'I am now one with the artificial intelligence!'"
    echo ""
    echo "Type the number of your choice, or 'models' for AI model recommendations:"
    read -p "Your choice: " ai_choice
    
    # Ensure log directory exists
    mkdir -p ~/ai_workflows
    
    case $ai_choice in
        1)
            echo "[LOG] Bill chose ChatGPT API Integration" >> ~/ai_workflows/assistant.log
            echo "🧠 DEPLOYING CHATGPT API INTEGRATION - CLOUD AI POWERHOUSE!"
            echo ""
            echo "🎓 WHAT IS CHATGPT API INTEGRATION?"
            echo "This connects OpenAI's powerful GPT models directly to your workflows."
            echo "You get professional-grade AI capabilities integrated into your tools:"
            echo "• Content generation with custom prompts and templates"
            echo "• Code assistance and debugging help"
            echo "• Data analysis and insight generation"
            echo "• Email and communication automation"
            echo "• Custom AI workflows for your specific needs"
            echo ""
            echo "🧠 WHY CHATGPT API IS POWERFUL FOR WORKFLOWS:"
            echo "• Latest GPT models with cutting-edge capabilities"
            echo "• Custom system prompts for specialized tasks"
            echo "• Batch processing for large-scale automation"
            echo "• Integration with existing tools and scripts"
            echo "• Professional-grade AI without web interface limitations"
            echo ""
            
            # Install ChatGPT API integration
            echo "🔧 INSTALLING CHATGPT API INTEGRATION..."
            
            # Create AI workflow directory structure
            mkdir -p ~/ai_workflows/{prompts,templates,scripts,outputs,logs}
            
            # Install Python dependencies for AI integration
            if command -v pip3 &> /dev/null; then
                pip3 install --user openai python-dotenv requests jinja2
                echo "✅ Python AI libraries installed!"
            else
                echo "⚠️ Please install Python and pip3 to use ChatGPT API"
            fi
            
            # Create API configuration
            cat > ~/ai_workflows/.env.template << 'EOF'
# OpenAI API Configuration
OPENAI_API_KEY=your_api_key_here
OPENAI_MODEL=gpt-4o
OPENAI_MAX_TOKENS=4000
OPENAI_TEMPERATURE=0.7

# AI Workflow Settings
AI_WORKFLOWS_DIR=$HOME/ai_workflows
DEFAULT_PROMPT_STYLE=professional
ENABLE_LOGGING=true
EOF
            
            # Create ChatGPT integration script
            cat > ~/ai_workflows/scripts/chatgpt_integration.py << 'EOF'
#!/usr/bin/env python3
"""
ChatGPT API Integration for Bill Sloth AI Workflows
Provides command-line interface for ChatGPT API interactions
"""

import os
import openai
import json
import sys
from datetime import datetime
from pathlib import Path

# Load environment variables
from dotenv import load_dotenv
load_dotenv(Path.home() / "ai_workflows" / ".env")

# Configure OpenAI
openai.api_key = os.getenv('OPENAI_API_KEY')

def chat_completion(prompt, system_prompt=None, model=None, temperature=None):
    """Send a prompt to ChatGPT and return the response"""
    
    model = model or os.getenv('OPENAI_MODEL', 'gpt-4o')
    temperature = temperature or float(os.getenv('OPENAI_TEMPERATURE', 0.7))
    
    messages = []
    if system_prompt:
        messages.append({"role": "system", "content": system_prompt})
    messages.append({"role": "user", "content": prompt})
    
    try:
        response = openai.ChatCompletion.create(
            model=model,
            messages=messages,
            temperature=temperature,
            max_tokens=int(os.getenv('OPENAI_MAX_TOKENS', 4000))
        )
        
        return response.choices[0].message.content
        
    except Exception as e:
        return f"Error: {str(e)}"

def log_interaction(prompt, response):
    """Log AI interactions for reference"""
    if os.getenv('ENABLE_LOGGING', 'true').lower() == 'true':
        log_dir = Path.home() / "ai_workflows" / "logs"
        log_dir.mkdir(exist_ok=True)
        
        log_file = log_dir / f"ai_log_{datetime.now().strftime('%Y%m%d')}.json"
        
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "prompt": prompt,
            "response": response
        }
        
        # Append to daily log file
        logs = []
        if log_file.exists():
            with open(log_file, 'r') as f:
                try:
                    logs = json.load(f)
                except:
                    logs = []
        
        logs.append(log_entry)
        
        with open(log_file, 'w') as f:
            json.dump(logs, f, indent=2)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 chatgpt_integration.py 'Your prompt here'")
        print("       python3 chatgpt_integration.py --system 'System prompt' 'User prompt'")
        sys.exit(1)
    
    system_prompt = None
    user_prompt = sys.argv[1]
    
    if sys.argv[1] == "--system" and len(sys.argv) >= 4:
        system_prompt = sys.argv[2]
        user_prompt = sys.argv[3]
    
    response = chat_completion(user_prompt, system_prompt)
    log_interaction(user_prompt, response)
    print(response)
EOF
            
            chmod +x ~/ai_workflows/scripts/chatgpt_integration.py
            
            # Create prompt templates
            mkdir -p ~/ai_workflows/prompts
            
            cat > ~/ai_workflows/prompts/content_writer.txt << 'EOF'
You are a professional content writer specializing in clear, engaging content.
Write content that is:
- Easy to read and understand
- Engaging and interesting
- Well-structured with clear sections
- Optimized for the target audience
- Free of grammatical errors
EOF

            cat > ~/ai_workflows/prompts/code_assistant.txt << 'EOF'
You are an expert software developer and code reviewer.
Provide code solutions that are:
- Clean and well-documented
- Following best practices
- Secure and efficient
- Easy to understand and maintain
- Include explanations of complex parts
EOF

            cat > ~/ai_workflows/prompts/data_analyst.txt << 'EOF'
You are a data analyst expert at extracting insights from data.
Provide analysis that is:
- Clear and actionable insights
- Supported by evidence from the data
- Includes visualizations when helpful
- Explains methodology and limitations
- Focuses on business impact
EOF
            
            # Create convenience scripts
            cat > ~/ai_workflows/scripts/ask-ai << 'EOF'
#!/bin/bash
# Quick AI assistant for command line
python3 ~/ai_workflows/scripts/chatgpt_integration.py "$@"
EOF
            
            cat > ~/ai_workflows/scripts/ai-writer << 'EOF'
#!/bin/bash
# AI content writer with specialized prompt
SYSTEM_PROMPT=$(cat ~/ai_workflows/prompts/content_writer.txt)
python3 ~/ai_workflows/scripts/chatgpt_integration.py --system "$SYSTEM_PROMPT" "$@"
EOF
            
            cat > ~/ai_workflows/scripts/ai-coder << 'EOF'
#!/bin/bash
# AI coding assistant with specialized prompt
SYSTEM_PROMPT=$(cat ~/ai_workflows/prompts/code_assistant.txt)
python3 ~/ai_workflows/scripts/chatgpt_integration.py --system "$SYSTEM_PROMPT" "$@"
EOF
            
            chmod +x ~/ai_workflows/scripts/{ask-ai,ai-writer,ai-coder}
            
            # Add to PATH
            echo "" >> ~/.bashrc
            echo "# Bill Sloth AI Workflows" >> ~/.bashrc
            echo 'export PATH="$HOME/ai_workflows/scripts:$PATH"' >> ~/.bashrc
            
            echo ""
            echo "🚀 CHATGPT API INTEGRATION SETUP GUIDE"
            echo "======================================"
            echo ""
            echo "🔑 STEP 1: GET YOUR OPENAI API KEY"
            echo "• Go to https://platform.openai.com/api-keys"
            echo "• Create a new API key"
            echo "• Copy the key (starts with sk-...)"
            echo ""
            echo "⚙️ STEP 2: CONFIGURE YOUR API KEY"
            echo "• Copy ~/ai_workflows/.env.template to ~/ai_workflows/.env"
            echo "• Replace 'your_api_key_here' with your actual API key"
            echo "• Customize model and settings as needed"
            echo ""
            echo "🎯 STEP 3: START USING AI AUTOMATION"
            echo "After reloading your shell (source ~/.bashrc), use these commands:"
            echo "• ask-ai 'Your question here' - General AI assistant"
            echo "• ai-writer 'Write a blog post about...' - Content creation"
            echo "• ai-coder 'Write a Python function to...' - Code assistance"
            echo ""
            echo "💡 ADVANCED USAGE EXAMPLES:"
            echo ""
            echo "📝 CONTENT CREATION:"
            echo "• ai-writer 'Write a professional email about project delays'"
            echo "• ai-writer 'Create a blog post outline about Linux automation'"
            echo "• ai-writer 'Write social media posts for a tech product launch'"
            echo ""
            echo "💻 CODE ASSISTANCE:"
            echo "• ai-coder 'Create a Python script to process CSV files'"
            echo "• ai-coder 'Review this code for security issues: [paste code]'"
            echo "• ai-coder 'Write bash script to backup important directories'"
            echo ""
            echo "📊 DATA ANALYSIS:"
            echo "• ask-ai 'Analyze this data and provide insights: [data]'"
            echo "• ask-ai 'What trends do you see in this sales data?'"
            echo "• ask-ai 'Create a summary report from these metrics'"
            echo ""
            echo "🔄 WORKFLOW AUTOMATION:"
            echo "• Create scripts that use AI for automated content generation"
            echo "• Set up scheduled AI reports and summaries"
            echo "• Build AI-powered data processing pipelines"
            echo ""
            echo "✅ CHATGPT API INTEGRATION READY!"
            echo "Configure your API key and start automating with AI!"
            echo "You now have professional-grade AI integrated into your workflows!"
            echo ""
            echo "🤖 Shake: 'I am now the master of artificial intelligence!'"
            ;;
        2)
            echo "[LOG] Bill chose Local AI Models" >> ~/ai_workflows/assistant.log
            echo "🏠 DEPLOYING LOCAL AI MODELS - OFFLINE AI INDEPENDENCE!"
            echo ""
            echo "🎓 WHAT ARE LOCAL AI MODELS?"
            echo "Local AI models run entirely on your machine, providing AI capabilities"
            echo "without internet dependency or data sharing concerns:"
            echo "• Complete privacy - your data never leaves your machine"
            echo "• No usage limits or API costs"
            echo "• Works offline and is always available"
            echo "• Customizable models for specific tasks"
            echo "• Full control over AI behavior and responses"
            echo ""
            echo "🧠 WHY LOCAL AI IS POWERFUL FOR WORKFLOWS:"
            echo "• Privacy-first AI for sensitive work"
            echo "• Unlimited usage without cost concerns"
            echo "• Customizable for your specific needs"
            echo "• Always available regardless of internet"
            echo "• Perfect for ADHD minds that need instant AI help"
            echo ""
            
            # Install Ollama for local AI
            echo "🔧 INSTALLING LOCAL AI INFRASTRUCTURE..."
            
            # Download and install Ollama
            if ! command -v ollama &> /dev/null; then
                echo "Installing Ollama (local AI runtime)..."
                curl -fsSL https://ollama.ai/install.sh | sh
                echo "✅ Ollama installed!"
            else
                echo "✅ Ollama is already installed!"
            fi
            
            # Create local AI workflow directory
            mkdir -p ~/ai_workflows/local/{models,scripts,prompts,outputs}
            
            # Create Ollama management script
            cat > ~/ai_workflows/local/scripts/ollama_manager.sh << 'EOF'
#!/bin/bash
# Ollama Local AI Model Manager for Bill Sloth

MODELS_DIR="$HOME/ai_workflows/local/models"
mkdir -p "$MODELS_DIR"

show_help() {
    echo "🤖 LOCAL AI MODEL MANAGER"
    echo "======================="
    echo ""
    echo "Commands:"
    echo "  install <model>     Install a local AI model"
    echo "  list               List installed models"
    echo "  chat <model>       Start interactive chat with model"
    echo "  generate <model> <prompt>  Generate text with model"
    echo "  remove <model>     Remove a model"
    echo "  update             Update Ollama and models"
    echo ""
    echo "Recommended Models:"
    echo "  llama2             General purpose, good for most tasks"
    echo "  codellama          Specialized for coding tasks"
    echo "  mistral            Fast and efficient general model"
    echo "  phi                Lightweight model for basic tasks"
    echo ""
}

install_model() {
    local model="$1"
    if [ -z "$model" ]; then
        echo "Usage: ollama_manager.sh install <model_name>"
        return 1
    fi
    
    echo "Installing model: $model"
    ollama pull "$model"
    
    if [ $? -eq 0 ]; then
        echo "✅ Model $model installed successfully!"
        echo "Usage: ollama_manager.sh chat $model"
    else
        echo "❌ Failed to install model $model"
    fi
}

case "$1" in
    install)
        install_model "$2"
        ;;
    list)
        echo "📦 Installed AI Models:"
        ollama list
        ;;
    chat)
        if [ -z "$2" ]; then
            echo "Usage: ollama_manager.sh chat <model_name>"
            exit 1
        fi
        echo "Starting chat with $2 (type /bye to exit)"
        ollama run "$2"
        ;;
    generate)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: ollama_manager.sh generate <model> <prompt>"
            exit 1
        fi
        ollama generate "$2" "$3"
        ;;
    remove)
        if [ -z "$2" ]; then
            echo "Usage: ollama_manager.sh remove <model_name>"
            exit 1
        fi
        ollama rm "$2"
        ;;
    update)
        echo "Updating Ollama and models..."
        curl -fsSL https://ollama.ai/install.sh | sh
        ollama list | tail -n +2 | awk '{print $1}' | xargs -I {} ollama pull {}
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
EOF
            
            chmod +x ~/ai_workflows/local/scripts/ollama_manager.sh
            
            # Create local AI convenience scripts
            cat > ~/ai_workflows/local/scripts/local-ai << 'EOF'
#!/bin/bash
# Quick local AI assistant
MODEL=${1:-llama2}
shift
PROMPT="$*"

if [ -z "$PROMPT" ]; then
    echo "Usage: local-ai [model] 'Your prompt here'"
    echo "Example: local-ai llama2 'Explain quantum computing'"
    exit 1
fi

ollama generate "$MODEL" "$PROMPT"
EOF
            
            cat > ~/ai_workflows/local/scripts/code-ai << 'EOF'
#!/bin/bash
# Local AI coding assistant
MODEL=${1:-codellama}
if [ "$1" = "codellama" ] || [ "$1" = "llama2" ] || [ "$1" = "mistral" ]; then
    shift
fi
PROMPT="$*"

if [ -z "$PROMPT" ]; then
    echo "Usage: code-ai 'Your coding question here'"
    echo "Example: code-ai 'Write a Python function to sort a list'"
    exit 1
fi

SYSTEM_PROMPT="You are an expert programmer. Provide clean, well-documented code with explanations."
ollama generate "$MODEL" "$SYSTEM_PROMPT\n\nUser request: $PROMPT"
EOF
            
            chmod +x ~/ai_workflows/local/scripts/{local-ai,code-ai}
            
            # Add to PATH
            echo 'export PATH="$HOME/ai_workflows/local/scripts:$PATH"' >> ~/.bashrc
            
            echo ""
            echo "🚀 LOCAL AI MODELS SETUP GUIDE"
            echo "=============================="
            echo ""
            echo "🎯 STEP 1: INSTALL YOUR FIRST AI MODEL"
            echo "Choose a model based on your needs and hardware:"
            echo ""
            echo "💾 LIGHTWEIGHT MODELS (4GB+ RAM):"
            echo "• ~/ai_workflows/local/scripts/ollama_manager.sh install phi"
            echo "• Good for: Basic tasks, fast responses"
            echo ""
            echo "🧠 GENERAL PURPOSE MODELS (8GB+ RAM):"
            echo "• ~/ai_workflows/local/scripts/ollama_manager.sh install llama2"
            echo "• Good for: Most tasks, balanced performance"
            echo ""
            echo "💻 CODING MODELS (8GB+ RAM):"
            echo "• ~/ai_workflows/local/scripts/ollama_manager.sh install codellama"
            echo "• Good for: Programming, code assistance"
            echo ""
            echo "⚡ FAST MODELS (8GB+ RAM):"
            echo "• ~/ai_workflows/local/scripts/ollama_manager.sh install mistral"
            echo "• Good for: Quick responses, efficient processing"
            echo ""
            echo "🎯 STEP 2: START USING LOCAL AI"
            echo "After reloading your shell (source ~/.bashrc):"
            echo "• local-ai 'Your question here' - General AI assistance"
            echo "• code-ai 'Write a script to...' - Coding help"
            echo "• ~/ai_workflows/local/scripts/ollama_manager.sh chat llama2 - Interactive chat"
            echo ""
            echo "💡 USAGE EXAMPLES:"
            echo ""
            echo "📝 CONTENT & WRITING:"
            echo "• local-ai 'Write a professional email about...' "
            echo "• local-ai 'Summarize this article: [text]'"
            echo "• local-ai 'Create bullet points for this topic'"
            echo ""
            echo "💻 CODING ASSISTANCE:"
            echo "• code-ai 'Create a bash script to backup files'"
            echo "• code-ai 'Explain this Python code: [code]'"
            echo "• code-ai 'Write a function to parse JSON'"
            echo ""
            echo "🔧 WORKFLOW AUTOMATION:"
            echo "• Create scripts that use local AI for automated analysis"
            echo "• Build offline AI-powered tools"
            echo "• Integrate local AI into existing workflows"
            echo ""
            echo "⚙️ MODEL MANAGEMENT:"
            echo "• ~/ai_workflows/local/scripts/ollama_manager.sh list - See installed models"
            echo "• ~/ai_workflows/local/scripts/ollama_manager.sh remove model - Remove unused models"
            echo "• ~/ai_workflows/local/scripts/ollama_manager.sh update - Update all models"
            echo ""
            echo "✅ LOCAL AI MODELS READY!"
            echo "Install your first model and start using offline AI!"
            echo "You now have privacy-first AI that works anywhere!"
            echo ""
            echo "🧠 Carl: 'Finally! AI that respects my privacy and doesn't spy on me!'"
            ;;
        models|Models|MODELS)
            echo "[LOG] Bill requested AI model recommendations" >> ~/ai_workflows/assistant.log
            echo "🤖 AI MODEL RECOMMENDATIONS GUIDE"
            echo "================================"
            echo ""
            echo "🎯 Choose the right AI model for your workflow needs!"
            echo ""
            echo "☁️ CLOUD AI MODELS (OpenAI API):"
            echo "=============================="
            echo "🚀 GPT-4o (Recommended)"
            echo "   • Best overall performance for complex tasks"
            echo "   • Excellent at coding, writing, analysis"
            echo "   • Higher cost but superior quality"
            echo "   • Perfect for professional workflows"
            echo ""
            echo "⚡ GPT-3.5-Turbo"
            echo "   • Fast and cost-effective"
            echo "   • Good for simple tasks and automation"
            echo "   • Lower cost, still very capable"
            echo "   • Great for high-volume workflows"
            echo ""
            echo "🏠 LOCAL AI MODELS (Ollama):"
            echo "========================="
            echo "🧠 Llama 2 (7B/13B/70B)"
            echo "   • General purpose, well-rounded"
            echo "   • Good balance of speed and quality"
            echo "   • 7B: 4GB RAM, 13B: 8GB RAM, 70B: 48GB RAM"
            echo "   • Perfect for most local AI needs"
            echo ""
            echo "💻 Code Llama (7B/13B/34B)"
            echo "   • Specialized for programming tasks"
            echo "   • Excellent code generation and debugging"
            echo "   • Understands multiple programming languages"
            echo "   • Essential for coding workflows"
            echo ""
            echo "⚡ Mistral (7B)"
            echo "   • Fast and efficient"
            echo "   • Good general performance"
            echo "   • Lower resource requirements"
            echo "   • Great for quick AI assistance"
            echo ""
            echo "🏃 Phi-2 (2.7B)"
            echo "   • Lightweight and fast"
            echo "   • Runs on modest hardware"
            echo "   • Good for basic tasks"
            echo "   • Perfect for older computers"
            echo ""
            echo "🎯 CHOOSING THE RIGHT MODEL:"
            echo "=========================="
            echo ""
            echo "💰 FOR BUDGET-CONSCIOUS USERS:"
            echo "• Start with local models (Llama 2 or Mistral)"
            echo "• Use GPT-3.5-Turbo for cloud tasks"
            echo "• Unlimited usage with local models"
            echo ""
            echo "🚀 FOR MAXIMUM PERFORMANCE:"
            echo "• Use GPT-4o for complex reasoning"
            echo "• Code Llama for programming tasks"
            echo "• Combine cloud and local for best of both"
            echo ""
            echo "🔒 FOR PRIVACY-FOCUSED WORKFLOWS:"
            echo "• Use only local models (Llama 2, Code Llama)"
            echo "• All processing happens on your machine"
            echo "• No data leaves your system"
            echo ""
            echo "⚡ FOR SPEED AND EFFICIENCY:"
            echo "• Mistral or Phi-2 for local processing"
            echo "• GPT-3.5-Turbo for cloud processing"
            echo "• Focus on faster, smaller models"
            echo ""
            echo "💡 PRO TIP: Start with one model and expand as needed!"
            echo "You can always install additional models later based on your usage patterns."
            echo ""
            echo "🧠 Frylock: 'The choice of model determines the quality of intelligence!'"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo ""
    echo "📝 All actions logged to ~/ai_workflows/assistant.log"
    echo "🔄 You can always re-run this assistant to try different AI workflows!"
}

# Generate personalized AI automation plan
generate_ai_plan() {
    local ai_goals="$1"
    local uses_ai="$2" 
    local wants_local_ai="$3"
    local wants_automation="$4"
    local wants_content_ai="$5"
    
    echo ""
    echo "🎯 PERSONALIZED AI AUTOMATION PLAN"
    echo "=================================="
    echo ""
    
    case $ai_goals in
        1) echo "📊 Focus: Content Creation & Writing Automation" ;;
        2) echo "📊 Focus: Data Analysis & Processing Automation" ;;
        3) echo "📊 Focus: Communication & Customer Service Automation" ;;
        4) echo "📊 Focus: Creative Work & Problem-Solving Automation" ;;
        5) echo "📊 Focus: Complete AI Workflow Transformation" ;;
    esac
    
    echo "🤖 Current AI Usage: $([ "$uses_ai" = "y" ] && echo "Yes - we can enhance your existing workflows" || echo "New to AI - we'll start with the basics")"
    echo "🏠 Privacy Preference: $([ "$wants_local_ai" = "y" ] && echo "Local AI preferred - privacy-first approach" || echo "Cloud AI acceptable - maximum performance focus")"
    echo ""
    
    echo "🚀 RECOMMENDED AI WORKFLOW PRIORITY:"
    if [ "$wants_content_ai" = "y" ]; then
        echo "✅ Content automation - Perfect for creative workflows"
    fi
    if [ "$wants_automation" = "y" ]; then
        echo "✅ Task automation - Reduce repetitive work with AI"
    fi
    if [ "$wants_local_ai" = "y" ]; then
        echo "✅ Local AI models - Privacy-focused AI independence"
    else
        echo "✅ Cloud AI integration - Maximum AI capabilities"
    fi
    
    echo ""
    echo "💡 Your customized AI plan is ready! Choose options below that match your goals."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ai_workflow_interactive
fi