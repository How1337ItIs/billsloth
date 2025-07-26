#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=Ollama Local LLM, 2=Stable Diffusion, 3=Voice AI, 4=AI Development, 5=Complete AI Suite
# CLAUDE_PROMPTS: AI tool selection, Model configuration, Integration setup
# CLAUDE_DEPENDENCIES: python3, docker, cuda (optional), nodejs, git
# AI MASTERY - INTERACTIVE ASSISTANT PATTERN
# Complete AI toolkit: local models, development, workflow automation, and integration

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/enhanced_aesthetic_bridge.sh" 2>/dev/null || true

# Source required libraries
source "$SOURCE_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SOURCE_DIR/../lib/interactive.sh" 2>/dev/null || true

ai_mastery_interactive() {
    echo "🤖 AI MASTERY - YOUR COMPLETE ARTIFICIAL INTELLIGENCE EMPIRE"
    echo "=========================================================="
    echo ""
    echo "🎯 Master the power of AI on YOUR terms - locally, privately, and with"
    echo "professional automation that rivals tech giants, designed for ADHD minds!"
    echo ""
    echo "[ATHF] Carl: 'Yeah, I got it. It's called technology.'"
    echo "🧙 wwwyzzerdd: 'You have entered the cyberland portal of AI mastery, broadbrain.'"
    echo "🧙 wwwyzzerdd: 'This is live streaming artificial intelligence.'"
    echo ""
    
    # AI mastery assessment
    echo "🔍 AI MASTERY ASSESSMENT"
    echo "======================="
    echo ""
    echo "Before we build your AI empire, let's understand your goals and experience:"
    echo ""
    echo "🤖 What's your AI experience level?"
    echo "1) Complete Beginner - Never used AI tools"
    echo "2) Basic User - Used ChatGPT or similar web tools"
    echo "3) Intermediate - Some API or local AI experience"
    echo "4) Advanced - Ready for AI development and automation"
    echo ""
    read -p "Your AI experience (1-4): " ai_experience
    
    echo ""
    echo "🎯 What do you want to achieve with AI?"
    echo "1) Personal AI Assistant - Chat, writing, brainstorming"
    echo "2) Creative Work - Content generation, coding assistance"
    echo "3) Business Automation - Workflows, analysis, productivity"
    echo "4) AI Development - Build AI tools and applications"
    echo "5) Complete AI Independence - Everything above, locally"
    echo ""
    read -p "Your AI goals (1-5): " ai_goals
    
    echo ""
    echo "🔒 AI privacy preferences:"
    echo "• Do you prefer local/offline AI for privacy? (y/n): "
    read -p "> " wants_local
    echo "• Are you interested in cloud AI APIs for power? (y/n): "
    read -p "> " wants_cloud
    echo "• Do you want AI workflow automation? (y/n): "
    read -p "> " wants_automation
    echo "• Would you like AI development capabilities? (y/n): "
    read -p "> " wants_development
    
    # Safety checks for unbound variables
    ai_experience="${ai_experience:-3}"
    ai_goals="${ai_goals:-3}"
    wants_local="${wants_local:-y}"
    wants_cloud="${wants_cloud:-y}"
    wants_automation="${wants_automation:-y}"
    wants_development="${wants_development:-y}"
    
    # Generate personalized AI plan
    generate_ai_mastery_plan "$ai_experience" "$ai_goals" "$wants_local" "$wants_cloud" "$wants_automation" "$wants_development"
    
    echo ""
    echo "🏆 CHOOSE YOUR AI MASTERY PATH:"
    echo "==============================="
    echo ""
    echo "1) 🎯 Local AI Playground (Privacy-First AI Independence)"
    echo "   💡 What it does: Complete local AI setup with multiple tools"
    echo "   ✅ Features: GPT4All, Ollama, offline models, private AI chat"
    echo "   🧠 ADHD-Friendly: No distractions, always available, customizable"
    echo "   📖 Learn: AI independence without cloud dependency"
    echo ""
    echo "2) 🛠️ AI Development Environment (Build Your Own AI Tools)"
    echo "   💡 What it does: Professional AI development and experimentation"
    echo "   ✅ Features: Jupyter, Transformers, LangChain, model training"
    echo "   🧠 ADHD-Friendly: Interactive experiments, immediate feedback"
    echo "   📖 Learn: Understand and build AI from the ground up"
    echo ""
    echo "3) 🧠 AI Workflow Automation (Professional AI Integration)"
    echo "   💡 What it does: AI-powered automation for productivity workflows"
    echo "   ✅ Features: ChatGPT API, automated content, AI-driven analysis"
    echo "   🧠 ADHD-Friendly: Reduces repetitive work, intelligent assistance"
    echo "   📖 Learn: Professional AI workflow automation"
    echo ""
    echo "4) 🎨 Creative AI Powerhouse (AI-Assisted Content Creation)"
    echo "   💡 What it does: AI tools for writing, coding, design, and creativity"
    echo "   ✅ Features: Image generation, code assistance, creative writing"
    echo "   🧠 ADHD-Friendly: Overcomes creative blocks, visual inspiration"
    echo "   📖 Learn: AI as creative partner and inspiration"
    echo ""
    echo "5) 🚀 Complete AI Empire (Everything Above Integrated)"
    echo "   💡 What it does: Full AI mastery with local and cloud capabilities"
    echo "   ✅ Features: All AI tools working together seamlessly"
    echo "   🧠 ADHD-Friendly: Ultimate AI toolkit for every mood and need"
    echo "   📖 Learn: Master-level AI capabilities and understanding"
    echo ""
    echo "6) ⚡ Quick AI Setup (Essential AI tools for immediate productivity)"
    echo "   💡 What it does: Fastest path to useful AI capabilities"
    echo "   ✅ Features: Basic local AI + API setup, ready in minutes"
    echo "   🧠 ADHD-Friendly: Immediate results, minimal complexity"
    echo "   📖 Learn: Quick wins to build AI confidence"
    echo ""
    echo "🧠 Frylock: 'Local AI is the democratization of artificial intelligence.'"
    echo "🥤 Shake: 'I will master all the artificial intelligences!'"
    echo ""
    echo "Type the number of your choice, or 'models' for AI model recommendations:"
    read -p "Your choice: " ai_choice
    
    # Safety check for unbound variable
    ai_choice="${ai_choice:-3}"
    
    # Ensure log directory exists
    mkdir -p ~/ai_mastery
    
    case $ai_choice in
        1)
            echo "[LOG] Bill chose Local AI Playground" >> ~/ai_mastery/assistant.log
            echo "🎯 DEPLOYING LOCAL AI PLAYGROUND - PRIVACY-FIRST AI INDEPENDENCE!"
            echo ""
            echo "🎓 WHAT IS THE LOCAL AI PLAYGROUND?"
            echo "This gives you complete AI independence with powerful models running"
            echo "entirely on your machine. No cloud, no data sharing, no limits:"
            echo "• GPT4All - Beautiful desktop AI chat interface"
            echo "• Ollama - Professional command-line AI model management"  
            echo "• Multiple AI models for different tasks and performance levels"
            echo "• Complete privacy - your conversations stay on your machine"
            echo "• Works offline and has no usage restrictions or costs"
            echo ""
            echo "🧠 WHY LOCAL AI IS PERFECT FOR ADHD/NEURODIVERGENT MINDS:"
            echo "• No distractions from web interfaces and ads"
            echo "• Consistent performance without network variability"
            echo "• Private brainstorming without judgment or data collection"
            echo "• Always available when hyperfocus strikes"
            echo "• Customizable to your specific communication style"
            echo ""
            
            # Install local AI stack
            echo "🔧 INSTALLING LOCAL AI PLAYGROUND..."
            
            # Install Ollama
            if ! command -v ollama &> /dev/null; then
                echo "Installing Ollama (AI model manager)..."
                curl -fsSL https://ollama.ai/install.sh | sh
                echo "✅ Ollama installed!"
            else
                echo "✅ Ollama is already installed!"
            fi
            
            # Install GPT4All
            echo "Installing GPT4All (desktop AI chat)..."
            if command -v apt &> /dev/null; then
                # Download and install GPT4All AppImage
                mkdir -p ~/ai_mastery/apps
                if [ ! -f ~/ai_mastery/apps/gpt4all.AppImage ]; then
                    echo "Downloading GPT4All desktop app..."
                    wget -O ~/ai_mastery/apps/gpt4all.AppImage https://gpt4all.io/installers/gpt4all-installer-linux.AppImage
                    chmod +x ~/ai_mastery/apps/gpt4all.AppImage
                    echo "✅ GPT4All downloaded!"
                fi
            fi
            
            # Create AI management scripts
            mkdir -p ~/ai_mastery/scripts
            
            cat > ~/ai_mastery/scripts/ai-chat << 'EOF'
#!/bin/bash
# Quick AI chat with Ollama
MODEL=${1:-llama2}
shift
PROMPT="$*"

if [ -z "$PROMPT" ]; then
    echo "🤖 Starting interactive AI chat with $MODEL"
    echo "Type 'exit' or Ctrl+C to quit"
    ollama run "$MODEL"
else
    ollama run "$MODEL" "$PROMPT"
fi
EOF
            
            cat > ~/ai_mastery/scripts/ai-models << 'EOF'
#!/bin/bash
# AI model management tool

case "$1" in
    "list"|"")
        echo "📦 Installed AI Models:"
        ollama list
        ;;
    "install")
        if [ -z "$2" ]; then
            echo "Usage: ai-models install <model_name>"
            echo "Popular models: llama2, codellama, mistral, phi"
            exit 1
        fi
        echo "Installing model: $2"
        ollama pull "$2"
        ;;
    "remove")
        if [ -z "$2" ]; then
            echo "Usage: ai-models remove <model_name>"
            exit 1
        fi
        ollama rm "$2"
        ;;
    "recommended")
        echo "🎯 RECOMMENDED AI MODELS FOR LOCAL USE:"
        echo ""
        echo "📱 LIGHTWEIGHT MODELS (4GB+ RAM):"
        echo "• phi - Microsoft's small but capable model"
        echo "• Install: ai-models install phi"
        echo ""
        echo "🧠 GENERAL PURPOSE (8GB+ RAM):"
        echo "• llama2 - Meta's well-rounded model"
        echo "• mistral - Fast and efficient model"
        echo "• Install: ai-models install llama2"
        echo ""
        echo "💻 CODING MODELS (8GB+ RAM):"
        echo "• codellama - Specialized for programming"
        echo "• Install: ai-models install codellama"
        echo ""
        ;;
    *)
        echo "Usage: ai-models [list|install|remove|recommended] [model_name]"
        ;;
esac
EOF
            
            cat > ~/ai_mastery/scripts/gpt4all-desktop << 'EOF'
#!/bin/bash
# Launch GPT4All desktop app
if [ -f ~/ai_mastery/apps/gpt4all.AppImage ]; then
    ~/ai_mastery/apps/gpt4all.AppImage
else
    echo "GPT4All not found. Download from https://gpt4all.io"
fi
EOF
            
            chmod +x ~/ai_mastery/scripts/{ai-chat,ai-models,gpt4all-desktop}
            
            # Add to PATH
            echo 'export PATH="$HOME/ai_mastery/scripts:$PATH"' >> ~/.bashrc
            
            echo ""
            echo "🚀 LOCAL AI PLAYGROUND SETUP GUIDE"
            echo "=================================="
            echo ""
            echo "🎯 GETTING STARTED:"
            echo "1. Install your first AI model: ai-models install llama2"
            echo "2. Start chatting: ai-chat llama2"
            echo "3. Launch desktop app: gpt4all-desktop"
            echo ""
            echo "💬 BASIC USAGE EXAMPLES:"
            echo ""
            echo "🤖 COMMAND-LINE AI CHAT:"
            echo "• ai-chat - Interactive chat with default model"
            echo "• ai-chat llama2 'Explain quantum computing simply'"
            echo "• ai-chat codellama 'Write a Python function to sort a list'"
            echo ""
            echo "📦 MODEL MANAGEMENT:"
            echo "• ai-models list - See installed models"
            echo "• ai-models install mistral - Install new model"
            echo "• ai-models recommended - See recommended models"
            echo ""
            echo "🖥️ DESKTOP AI CHAT:"
            echo "• gpt4all-desktop - Beautiful chat interface"
            echo "• No internet required once models are downloaded"
            echo "• Multiple models available in the app"
            echo ""
            echo "💡 LOCAL AI BEST PRACTICES:"
            echo "• Start with llama2 or mistral for general use"
            echo "• Use codellama for programming questions"
            echo "• Try phi for faster responses on older hardware"
            echo "• Each model has different strengths and personality"
            echo ""
            echo "✅ LOCAL AI PLAYGROUND READY!"
            echo "You now have complete AI independence!"
            echo "Reload your shell (source ~/.bashrc) to use new commands!"
            echo ""
            echo "[ATHF] Carl: 'Finally!'"
            ;;
        2)
            echo "[LOG] Bill chose AI Development Environment" >> ~/ai_mastery/assistant.log
            echo "🛠️ DEPLOYING AI DEVELOPMENT ENVIRONMENT - BUILD YOUR OWN AI TOOLS!"
            echo ""
            echo "🎓 WHAT IS AI DEVELOPMENT?"
            echo "AI development means building, training, and customizing AI models and"
            echo "applications. You get the power to create AI tools tailored to your needs:"
            echo "• Build custom AI applications with LangChain and Python"
            echo "• Train and fine-tune models on your own data"
            echo "• Experiment with cutting-edge AI research"
            echo "• Create AI-powered tools for specific problems"
            echo "• Understand how AI really works under the hood"
            echo ""
            echo "🧠 WHY AI DEVELOPMENT IS PERFECT FOR ADHD MINDS:"
            echo "• Hyperfocus sessions with unlimited compute time"
            echo "• Instant feedback loops for experiments"
            echo "• Build tools that work exactly how your brain does"
            echo "• Turn special interests into AI superpowers"
            echo "• Visual learning through Jupyter notebooks"
            echo ""
            
            # Install AI development stack
            echo "🔧 INSTALLING AI DEVELOPMENT ENVIRONMENT..."
            
            # Install Python AI libraries
            if command -v pip3 &> /dev/null; then
                echo "Installing AI development libraries..."
                pip3 install --user torch transformers datasets
                pip3 install --user langchain openai
                pip3 install --user jupyter notebook jupyterlab
                pip3 install --user huggingface-hub accelerate
                echo "✅ AI development libraries installed!"
            else
                echo "⚠️ Python and pip3 are required for AI development"
                return 1
            fi
            
            # Create AI development workspace
            mkdir -p ~/ai_mastery/development/{notebooks,projects,models,datasets}
            
            # Create Jupyter startup script
            cat > ~/ai_mastery/scripts/ai-lab << 'EOF'
#!/bin/bash
# Start AI development environment
echo "🧪 Starting AI Development Lab"
echo "============================"
echo ""
echo "📂 Workspace: ~/ai_mastery/development"
echo "🌐 Opening Jupyter Lab..."
echo ""
cd ~/ai_mastery/development/notebooks
jupyter lab --browser=firefox 2>/dev/null || jupyter lab
EOF
            
            chmod +x ~/ai_mastery/scripts/ai-lab
            
            # Create AI development starter notebook
            cat > ~/ai_mastery/development/notebooks/AI_Development_Starter.ipynb << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# 🤖 AI Development Starter Lab\n",
    "## Your gateway to building AI applications\n",
    "\n",
    "This notebook demonstrates how to build AI applications using modern tools.\n",
    "Way more powerful than using web interfaces!"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Import the AI development power tools\n",
    "import torch\n",
    "from transformers import pipeline, AutoTokenizer, AutoModel\n",
    "from langchain.llms import OpenAI\n",
    "from langchain.chains import LLMChain\n",
    "from langchain.prompts import PromptTemplate\n",
    "\n",
    "print(\"🚀 AI development tools loaded!\")\n",
    "print(f\"PyTorch version: {torch.__version__}\")\n",
    "print(f\"CUDA available: {torch.cuda.is_available()}\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Example 1: Use a pre-trained AI model\n",
    "# This runs entirely locally!\n",
    "\n",
    "print(\"🧠 Loading sentiment analysis model...\")\n",
    "classifier = pipeline(\"sentiment-analysis\")\n",
    "\n",
    "# Test the model\n",
    "texts = [\n",
    "    \"I love building AI applications!\",\n",
    "    \"This is frustrating and not working.\",\n",
    "    \"AI development is fascinating and empowering.\"\n",
    "]\n",
    "\n",
    "for text in texts:\n",
    "    result = classifier(text)\n",
    "    print(f\"Text: {text}\")\n",
    "    print(f\"Sentiment: {result[0]['label']} ({result[0]['score']:.2f})\")\n",
    "    print()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Example 2: Build a custom AI application with LangChain\n",
    "# This shows how to create AI-powered workflows\n",
    "\n",
    "# Create a creative writing assistant\n",
    "template = \"\"\"\n",
    "You are a creative writing assistant specialized in {genre} stories.\n",
    "Write a compelling {story_length} story about: {topic}\n",
    "\n",
    "Story:\n",
    "\"\"\"\n",
    "\n",
    "prompt = PromptTemplate(\n",
    "    input_variables=[\"genre\", \"story_length\", \"topic\"],\n",
    "    template=template\n",
    ")\n",
    "\n",
    "print(\"✍️ Creative Writing AI Assistant Created!\")\n",
    "print(\"This template can be used with any AI model.\")\n",
    "print(\"\")\n",
    "print(\"Example usage:\")\n",
    "example_prompt = prompt.format(\n",
    "    genre=\"science fiction\",\n",
    "    story_length=\"short\",\n",
    "    topic=\"an AI that becomes self-aware\"\n",
    ")\n",
    "print(example_prompt)"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "name": "python",
   "version": "3.8.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF
            
            # Create AI project templates
            cat > ~/ai_mastery/development/projects/custom_ai_assistant.py << 'EOF'
#!/usr/bin/env python3
"""
Custom AI Assistant Template
Build your own AI-powered command-line assistant
"""

from langchain.llms import Ollama
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
import sys

class CustomAIAssistant:
    def __init__(self, model_name="llama2"):
        """Initialize the AI assistant with a local model"""
        self.llm = Ollama(model=model_name)
        
        # Create a specialized prompt template
        self.template = """
        You are a helpful AI assistant specialized in {specialty}.
        Please provide a {response_style} response to: {user_input}
        
        Response:
        """
        
        self.prompt = PromptTemplate(
            input_variables=["specialty", "response_style", "user_input"],
            template=self.template
        )
        
        self.chain = LLMChain(llm=self.llm, prompt=self.prompt)
    
    def ask(self, question, specialty="general help", style="helpful and concise"):
        """Ask the AI assistant a question"""
        response = self.chain.run({
            "specialty": specialty,
            "response_style": style,
            "user_input": question
        })
        return response

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 custom_ai_assistant.py 'Your question here'")
        print("Example: python3 custom_ai_assistant.py 'How do I optimize Python code?'")
        sys.exit(1)
    
    assistant = CustomAIAssistant()
    question = " ".join(sys.argv[1:])
    
    print("🤖 Custom AI Assistant")
    print("=" * 40)
    print(f"Question: {question}")
    print()
    print("Response:")
    print(assistant.ask(question))
EOF
            
            echo ""
            echo "🚀 AI DEVELOPMENT ENVIRONMENT SETUP GUIDE"
            echo "========================================="
            echo ""
            echo "🎯 GETTING STARTED:"
            echo "1. Launch AI Lab: ai-lab"
            echo "2. Open AI_Development_Starter.ipynb"
            echo "3. Start experimenting!"
            echo ""
            echo "🧪 WHAT YOU CAN BUILD:"
            echo ""
            echo "🤖 CUSTOM AI ASSISTANTS:"
            echo "• Specialized chatbots for specific domains"
            echo "• AI tools that understand your workflow"
            echo "• Personal AI tutors for learning topics"
            echo ""
            echo "📊 AI-POWERED ANALYSIS:"
            echo "• Sentiment analysis for social media"
            echo "• Document classification and summarization"
            echo "• Content generation and optimization"
            echo ""
            echo "🔗 AI WORKFLOW AUTOMATION:"
            echo "• AI-powered email responses"
            echo "• Automated content creation pipelines"
            echo "• Smart data processing workflows"
            echo ""
            echo "💡 DEVELOPMENT WORKFLOW:"
            echo "1. Experiment in Jupyter notebooks"
            echo "2. Build prototypes with LangChain"
            echo "3. Create custom applications"
            echo "4. Deploy locally or share with others"
            echo ""
            echo "📚 LEARNING RESOURCES:"
            echo "• Hugging Face Hub - Thousands of models"
            echo "• LangChain Documentation - AI app framework"
            echo "• PyTorch Tutorials - Deep learning fundamentals"
            echo ""
            echo "✅ AI DEVELOPMENT ENVIRONMENT READY!"
            echo "You can now build custom AI applications!"
            echo "Launch with: ai-lab"
            echo ""
            echo "🧠 Frylock: 'You're not just using AI - you're mastering it!'"
            ;;
        3)
            # This content comes from ai_workflow_interactive.sh
            echo "[LOG] Bill chose AI Workflow Automation" >> ~/ai_mastery/assistant.log
            echo "🧠 DEPLOYING AI WORKFLOW AUTOMATION - PROFESSIONAL AI INTEGRATION!"
            echo ""
            echo "🎓 WHAT IS AI WORKFLOW AUTOMATION?"
            echo "This integrates AI directly into your daily workflows and business processes."
            echo "Professional-grade AI automation that works behind the scenes:"
            echo "• ChatGPT API integration for unlimited AI power"
            echo "• Automated content generation and analysis"
            echo "• AI-powered email and communication workflows"
            echo "• Intelligent task automation and decision making"
            echo "• Custom AI workflows for your specific needs"
            echo ""
            echo "🧠 WHY AI AUTOMATION IS PERFECT FOR PRODUCTIVITY:"
            echo "• Eliminates repetitive writing and analysis tasks"
            echo "• Provides intelligent suggestions and insights"
            echo "• Scales your capabilities without hiring more people"
            echo "• Works 24/7 without breaks or sick days"
            echo "• Learns and adapts to your preferences over time"
            echo ""
            
            # Install AI workflow automation
            echo "🔧 INSTALLING AI WORKFLOW AUTOMATION..."
            
            # Create AI workflow directory structure
            mkdir -p ~/ai_mastery/workflows/{scripts,templates,outputs,logs}
            
            # Install Python dependencies for AI automation
            if command -v pip3 &> /dev/null; then
                pip3 install --user openai python-dotenv requests jinja2
                echo "✅ AI workflow libraries installed!"
            else
                echo "⚠️ Please install Python and pip3 for AI automation"
            fi
            
            # Create API configuration template
            cat > ~/ai_mastery/workflows/.env.template << 'EOF'
# OpenAI API Configuration
OPENAI_API_KEY=your_api_key_here
OPENAI_MODEL=gpt-4o
OPENAI_MAX_TOKENS=4000
OPENAI_TEMPERATURE=0.7

# AI Workflow Settings
AI_WORKFLOWS_DIR=$HOME/ai_mastery/workflows
DEFAULT_PROMPT_STYLE=professional
ENABLE_LOGGING=true
EOF
            
            # Create ChatGPT workflow integration
            cat > ~/ai_mastery/workflows/scripts/ai_workflows.py << 'EOF'
#!/usr/bin/env python3
"""
AI Workflow Automation System
Professional AI integration for business workflows
"""

import os
import openai
import json
import sys
from datetime import datetime
from pathlib import Path

# Load environment variables
try:
    from dotenv import load_dotenv
    load_dotenv(Path.home() / "ai_mastery" / "workflows" / ".env")
except ImportError:
    print("Install python-dotenv: pip3 install --user python-dotenv")

# Configure OpenAI
openai.api_key = os.getenv('OPENAI_API_KEY')

def ai_generate(prompt, system_prompt=None, model=None, temperature=None):
    """Generate content using AI"""
    
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

def workflow_email_response(email_content, tone="professional"):
    """Generate AI-powered email response"""
    system_prompt = f"""You are a professional assistant writing email responses.
    Write responses that are {tone}, clear, and appropriate.
    Keep responses concise but complete."""
    
    prompt = f"Write a response to this email:\n\n{email_content}"
    return ai_generate(prompt, system_prompt)

def workflow_content_creation(topic, content_type="blog post", length="medium"):
    """Generate AI-powered content"""
    system_prompt = f"""You are a professional content creator.
    Create high-quality {content_type} content that is engaging and informative."""
    
    prompt = f"Create a {length} {content_type} about: {topic}"
    return ai_generate(prompt, system_prompt)

def workflow_data_analysis(data_description):
    """Generate AI-powered data insights"""
    system_prompt = """You are a data analyst providing clear, actionable insights.
    Focus on practical recommendations and key findings."""
    
    prompt = f"Analyze this data and provide insights: {data_description}"
    return ai_generate(prompt, system_prompt)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("AI Workflow Automation System")
        print("============================")
        print("Usage:")
        print("  python3 ai_workflows.py email 'email content here'")
        print("  python3 ai_workflows.py content 'topic' 'blog post'")
        print("  python3 ai_workflows.py analyze 'data description'")
        print("  python3 ai_workflows.py generate 'your prompt here'")
        return
    
    command = sys.argv[1]
    
    if command == 'email' and len(sys.argv) >= 3:
        result = workflow_email_response(sys.argv[2])
        print("📧 AI Email Response:")
        print("=" * 40)
        print(result)
        
    elif command == 'content' and len(sys.argv) >= 3:
        topic = sys.argv[2]
        content_type = sys.argv[3] if len(sys.argv) > 3 else "blog post"
        result = workflow_content_creation(topic, content_type)
        print(f"✍️ AI {content_type.title()}:")
        print("=" * 40)
        print(result)
        
    elif command == 'analyze' and len(sys.argv) >= 3:
        result = workflow_data_analysis(sys.argv[2])
        print("📊 AI Data Analysis:")
        print("=" * 40)
        print(result)
        
    elif command == 'generate' and len(sys.argv) >= 3:
        result = ai_generate(sys.argv[2])
        print("🤖 AI Response:")
        print("=" * 40)
        print(result)
    
    else:
        print("❌ Invalid command or missing arguments")
EOF
            
            chmod +x ~/ai_mastery/workflows/scripts/ai_workflows.py
            
            # Create workflow automation scripts
            cat > ~/ai_mastery/scripts/ai-email << 'EOF'
#!/bin/bash
# AI-powered email response generator
python3 ~/ai_mastery/workflows/scripts/ai_workflows.py email "$@"
EOF
            
            cat > ~/ai_mastery/scripts/ai-content << 'EOF'
#!/bin/bash
# AI-powered content creation
python3 ~/ai_mastery/workflows/scripts/ai_workflows.py content "$@"
EOF
            
            cat > ~/ai_mastery/scripts/ai-analyze << 'EOF'
#!/bin/bash
# AI-powered data analysis
python3 ~/ai_mastery/workflows/scripts/ai_workflows.py analyze "$@"
EOF
            
            chmod +x ~/ai_mastery/scripts/{ai-email,ai-content,ai-analyze}
            
            echo ""
            echo "🚀 AI WORKFLOW AUTOMATION SETUP GUIDE"
            echo "====================================="
            echo ""
            echo "🔑 STEP 1: GET YOUR OPENAI API KEY"
            echo "• Go to https://platform.openai.com/api-keys"
            echo "• Create a new API key"
            echo "• Copy ~/ai_mastery/workflows/.env.template to .env"
            echo "• Replace 'your_api_key_here' with your actual key"
            echo ""
            echo "🎯 STEP 2: START AUTOMATING WITH AI"
            echo "After configuring your API key and reloading shell:"
            echo ""
            echo "📧 EMAIL AUTOMATION:"
            echo "• ai-email 'Customer complaint about late delivery'"
            echo "• ai-email 'Meeting request for next Tuesday'"
            echo "• ai-email 'Follow up on project proposal'"
            echo ""
            echo "✍️ CONTENT AUTOMATION:"
            echo "• ai-content 'Linux automation benefits' 'blog post'"
            echo "• ai-content 'AI in business' 'social media post'"
            echo "• ai-content 'Product features' 'marketing copy'"
            echo ""
            echo "📊 DATA ANALYSIS AUTOMATION:"
            echo "• ai-analyze 'Sales dropped 15% last quarter, what factors to investigate?'"
            echo "• ai-analyze 'Website traffic increased but conversions down'"
            echo "• ai-analyze 'Customer satisfaction scores by product category'"
            echo ""
            echo "🔄 ADVANCED WORKFLOW AUTOMATION:"
            echo "• Build custom scripts that use AI for complex workflows"
            echo "• Automate report generation with AI insights"
            echo "• Create AI-powered chatbots for customer service"
            echo "• Integrate AI into existing business processes"
            echo ""
            echo "✅ AI WORKFLOW AUTOMATION READY!"
            echo "Configure your API key and start automating with professional AI!"
            echo ""
            echo "🤖 Shake: 'My workflows are now powered by artificial intelligence!'"
            ;;
        models|Models|MODELS)
            echo "[LOG] Bill requested AI model recommendations" >> ~/ai_mastery/assistant.log
            echo "🤖 AI MODEL RECOMMENDATIONS GUIDE"
            echo "================================"
            echo ""
            echo "🎯 Choose the right AI model for your specific needs!"
            echo ""
            echo "🏠 LOCAL AI MODELS (Privacy-First):"
            echo "================================="
            echo ""
            echo "📱 LIGHTWEIGHT MODELS (4-8GB RAM):"
            echo "🔸 Phi-2 (2.7B parameters)"
            echo "   • Microsoft's efficient small model"
            echo "   • Great for basic tasks and older hardware"
            echo "   • Fast responses, good for quick questions"
            echo "   • Install: ai-models install phi"
            echo ""
            echo "🔸 TinyLlama (1.1B parameters)"
            echo "   • Ultra-lightweight, runs on any machine"
            echo "   • Good for simple tasks and experimentation"
            echo "   • Very fast, minimal resource usage"
            echo ""
            echo "🧠 GENERAL PURPOSE MODELS (8-16GB RAM):"
            echo "🔸 Llama 2 7B"
            echo "   • Meta's well-balanced general model"
            echo "   • Excellent for most conversational AI tasks"
            echo "   • Good balance of quality and performance"
            echo "   • Install: ai-models install llama2"
            echo ""
            echo "🔸 Mistral 7B"
            echo "   • Fast and efficient European model"
            echo "   • Great for creative writing and analysis"
            echo "   • Good instruction following"
            echo "   • Install: ai-models install mistral"
            echo ""
            echo "💻 SPECIALIZED MODELS:"
            echo "🔸 Code Llama 7B/13B"
            echo "   • Meta's programming-specialized model"
            echo "   • Excellent for code generation and debugging"
            echo "   • Supports multiple programming languages"
            echo "   • Install: ai-models install codellama"
            echo ""
            echo "🔸 Llama 2 Uncensored"
            echo "   • Uncensored version of Llama 2"
            echo "   • Fewer content restrictions"
            echo "   • Good for creative and research tasks"
            echo ""
            echo "🚀 HIGH-PERFORMANCE MODELS (32GB+ RAM):"
            echo "🔸 Llama 2 70B"
            echo "   • Meta's largest open model"
            echo "   • Near GPT-4 quality for many tasks"
            echo "   • Requires powerful hardware"
            echo ""
            echo "🔸 Mixtral 8x7B"
            echo "   • Mixture of experts model"
            echo "   • Excellent performance-to-size ratio"
            echo "   • Good for complex reasoning tasks"
            echo ""
            echo "☁️ CLOUD AI MODELS (API-Based):"
            echo "============================="
            echo ""
            echo "🏆 OPENAI MODELS:"
            echo "🔸 GPT-4o (Recommended)"
            echo "   • Best overall performance"
            echo "   • Excellent reasoning and creativity"
            echo "   • Higher cost but superior quality"
            echo "   • Good for complex business tasks"
            echo ""
            echo "🔸 GPT-3.5-Turbo"
            echo "   • Fast and cost-effective"
            echo "   • Good for most automation tasks"
            echo "   • Great for high-volume workflows"
            echo ""
            echo "⚡ OTHER CLOUD OPTIONS:"
            echo "🔸 Claude (Anthropic)"
            echo "   • Strong at analysis and writing"
            echo "   • Good safety features"
            echo "   • Longer context windows"
            echo ""
            echo "🔸 Gemini (Google)"
            echo "   • Good multimodal capabilities"
            echo "   • Integrated with Google services"
            echo "   • Strong at reasoning tasks"
            echo ""
            echo "🎯 MODEL SELECTION GUIDE:"
            echo "======================="
            echo ""
            echo "💰 FOR BUDGET-CONSCIOUS USERS:"
            echo "• Start with local models (Phi, Llama 2 7B)"
            echo "• Use GPT-3.5-Turbo for cloud tasks when needed"
            echo "• No ongoing costs for local models"
            echo ""
            echo "🚀 FOR MAXIMUM PERFORMANCE:"
            echo "• Use GPT-4o for complex reasoning"
            echo "• Local Llama 2 70B if you have the hardware"
            echo "• Combine local and cloud for best of both"
            echo ""
            echo "🔒 FOR PRIVACY-FOCUSED WORKFLOWS:"
            echo "• Use only local models (Llama 2, Mistral)"
            echo "• All processing happens on your machine"
            echo "• No data leaves your system"
            echo ""
            echo "⚡ FOR DEVELOPMENT AND CODING:"
            echo "• Code Llama for programming tasks"
            echo "• GPT-4o for complex software architecture"
            echo "• Combination of both for comprehensive development"
            echo ""
            echo "🎨 FOR CREATIVE WORK:"
            echo "• Mistral for creative writing"
            echo "• GPT-4o for complex creative projects"
            echo "• Uncensored models for unrestricted creativity"
            echo ""
            echo "📊 HARDWARE REQUIREMENTS:"
            echo "• 4GB RAM: Phi, TinyLlama"
            echo "• 8GB RAM: Llama 2 7B, Mistral 7B, Code Llama 7B"
            echo "• 16GB RAM: Llama 2 13B, Code Llama 13B"
            echo "• 32GB+ RAM: Llama 2 70B, Mixtral 8x7B"
            echo ""
            echo "💡 PRO TIP: Start with one model and expand based on usage!"
            echo "You can always install additional models as you discover your preferences."
            echo ""
            echo "🧠 Frylock: 'The choice of model determines the quality of intelligence!'"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo ""
    echo "📝 All actions logged to ~/ai_mastery/assistant.log"
    echo "🔄 You can always re-run this assistant to explore different AI capabilities!"
}

# Generate personalized AI mastery plan
generate_ai_mastery_plan() {
    local ai_experience="$1"
    local ai_goals="$2"
    local wants_local="$3"
    local wants_cloud="$4"
    local wants_automation="$5"
    local wants_development="$6"
    
    echo ""
    echo "🎯 PERSONALIZED AI MASTERY PLAN"
    echo "==============================="
    echo ""
    
    case $ai_experience in
        1) echo "📊 Experience Level: Complete Beginner - we'll start with fundamentals" ;;
        2) echo "📊 Experience Level: Basic User - we'll enhance your existing knowledge" ;;
        3) echo "📊 Experience Level: Intermediate - ready for advanced capabilities" ;;
        4) echo "📊 Experience Level: Advanced - ready for cutting-edge AI development" ;;
    esac
    
    case $ai_goals in
        1) echo "🎯 Primary Goal: Personal AI Assistant" ;;
        2) echo "🎯 Primary Goal: Creative Work Enhancement" ;;
        3) echo "🎯 Primary Goal: Business Automation" ;;
        4) echo "🎯 Primary Goal: AI Development" ;;
        5) echo "🎯 Primary Goal: Complete AI Independence" ;;
    esac
    
    echo "🔒 Privacy Preference: $([ "$wants_local" = "y" ] && echo "Local AI preferred" || echo "Cloud AI acceptable")"
    echo ""
    
    echo "🚀 RECOMMENDED AI MASTERY PATH:"
    if [ "$wants_local" = "y" ]; then
        echo "✅ Local AI setup - Privacy-first AI independence"
    fi
    if [ "$wants_cloud" = "y" ]; then
        echo "✅ Cloud AI integration - Maximum AI capabilities"
    fi
    if [ "$wants_automation" = "y" ]; then
        echo "✅ Workflow automation - AI-powered productivity"
    fi
    if [ "$wants_development" = "y" ]; then
        echo "✅ AI development - Build custom AI applications"
    fi
    
    echo ""
    echo "💡 Your personalized AI mastery plan is ready! Choose options below that match your goals."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ai_mastery_interactive
fi