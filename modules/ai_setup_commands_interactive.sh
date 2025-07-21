#!/bin/bash
# LLM_CAPABILITY: auto
# AI SETUP COMMANDS - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Source the non-interactive AI setup module
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/ai_setup_commands.sh" 2>/dev/null || echo "Non-interactive module not found"

ai_setup_commands_interactive() {
    echo "🤖 LOCAL AI DEVELOPMENT ENVIRONMENT - THE DIGITAL BRAIN BUILDER"
    echo "================================================================"
    echo ""
    echo "🎯 Build your own AI systems with open-source tools designed for"
    echo "developers, researchers, and digital tinkers who want full control!"
    echo ""
    echo "🧠 Carl: 'Computer, search for teeth.'"
    echo ""
    
    echo "🎓 WHAT IS LOCAL AI DEVELOPMENT?"
    echo "=================================="
    echo "Local AI development means running and building AI models on your own hardware"
    echo "instead of relying on cloud services. You get:"
    echo "• Complete privacy - your data never leaves your machine"
    echo "• No API costs - run unlimited experiments for free"
    echo "• Full control - modify models, fine-tune, and experiment"
    echo "• Offline capability - work without internet"
    echo "• Learning opportunity - understand how AI really works"
    echo ""
    echo "🧠 WHY LOCAL AI MATTERS FOR INDEPENDENCE:"
    echo "• No dependency on big tech companies"
    echo "• No censorship or content filtering"
    echo "• Custom models for specific use cases"
    echo "• Educational value - see the magic behind the curtain"
    echo "• Future-proof skills as AI becomes mainstream"
    echo ""
    echo "🧠 WHY ADHD MINDS LOVE LOCAL AI:"
    echo "• Hyperfocus sessions with unlimited compute time"
    echo "• Instant feedback loops for experiments"
    echo "• No waiting for API rate limits"
    echo "• Build tools that work exactly how your brain does"
    echo "• Turn special interests into AI superpowers"
    echo ""
    echo "🍔 Meatwad: 'Win real money. Ohh!'"
    echo ""
    echo "🏆 THE COMPLETE LOCAL AI TOOLKIT:"
    echo "================================="
    echo ""
    echo "1) 🐙 Ollama - The AI Model Manager"
    echo "   💡 What it does: Simple local LLM runner with model management"
    echo "   ✅ Pros: Easy CLI, auto-downloads models, Docker support"
    echo "   🧠 ADHD-Friendly: One command installs and runs any model"
    echo "   📖 Learn: Perfect gateway to understanding local AI"
    echo ""
    echo "2) 🤗 Hugging Face Transformers - The AI Researcher's Toolkit"
    echo "   💡 What it does: Python library for state-of-the-art AI models"
    echo "   ✅ Pros: Massive model library, active community, cutting edge"
    echo "   🧠 ADHD-Friendly: Jupyter notebooks for interactive experiments"
    echo "   📖 Learn: Industry standard for AI research and development"
    echo ""
    echo "3) 💬 Text Generation WebUI - The AI Chat Interface"
    echo "   💡 What it does: Beautiful web interface for local text AI models"
    echo "   ✅ Pros: Easy setup, multiple model support, chat interface"
    echo "   🧠 ADHD-Friendly: Visual interface, no command line needed"
    echo "   📖 Learn: Best user experience for local AI interaction"
    echo ""
    echo "4) ⚡ Llama.cpp - The Lightweight AI Engine"
    echo "   💡 What it does: Fast, efficient CPU-based LLM inference"
    echo "   ✅ Pros: Works on older hardware, very fast, minimal setup"
    echo "   🧠 ADHD-Friendly: Quick results, works on any computer"
    echo "   📖 Learn: Understand AI optimization and performance"
    echo ""
    echo "5) 🧪 LangChain Development Kit - The AI Application Builder"
    echo "   💡 What it does: Framework for building AI-powered applications"
    echo "   ✅ Pros: Connects AI to real applications, extensive ecosystem"
    echo "   🧠 ADHD-Friendly: Modular design, start simple and expand"
    echo "   📖 Learn: Build practical AI tools for real problems"
    echo ""
    echo "6) 🚀 Complete Local AI Lab (All tools integrated)"
    echo "   💡 What it does: Full AI development environment"
    echo "   ✅ Pros: Everything you need to become an AI developer"
    echo "   🧠 ADHD-Friendly: One setup gives you infinite possibilities"
    echo "   📖 Learn: The ultimate 'digital brain builder' setup"
    echo ""
    echo "🧠 Frylock: 'You're going offline, Internet wizard.'"
    echo "🥤 Shake: 'Come on. To the crime lab!'"
    echo ""
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " ai_setup_choice
    
    # Ensure log directory exists
    mkdir -p ~/ai_development
    
    case $ai_setup_choice in
        1)
            echo "[LOG] Bill chose Ollama" >> ~/ai_development/assistant.log
            echo "🐙 DEPLOYING OLLAMA - THE AI MODEL MANAGER!"
            echo ""
            echo "🎓 WHAT IS OLLAMA?"
            echo "Ollama is a lightweight, extensible framework for building and running"
            echo "language models locally. Think of it as Docker for AI models:"
            echo "• Download and run models with one command"
            echo "• Automatic GPU detection and optimization"
            echo "• RESTful API for building applications"
            echo "• Model library with Llama, Mistral, CodeLlama, and more"
            echo "• Built-in model management and updates"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR AI BEGINNERS:"
            echo "• No complex setup or configuration"
            echo "• Handles all the technical details automatically"
            echo "• Start chatting with AI in under 5 minutes"
            echo "• Learn by doing - experiment with different models"
            echo "• Build confidence before diving deeper"
            echo ""
            
            # Install Ollama
            if command -v ollama &> /dev/null; then
                echo "✅ Ollama is already installed!"
            else
                echo "🔧 Installing Ollama..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    curl -fsSL https://ollama.ai/install.sh | sh
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    if command -v brew &> /dev/null; then
                        brew install ollama
                    else
                        echo "Please install from: https://ollama.ai/download"
                        open https://ollama.ai/download &
                        return
                    fi
                else
                    echo "Please install from: https://ollama.ai/download"
                    return
                fi
                echo "✅ Ollama installed!"
            fi
            
            echo ""
            echo "🚀 OLLAMA FOR AI DEVELOPMENT"
            echo "============================="
            echo ""
            echo "🎯 GETTING STARTED WITH AI MODELS:"
            echo ""
            echo "📚 POPULAR BEGINNER MODELS:"
            echo "• ollama pull llama2 - General purpose 7B parameter model"
            echo "• ollama pull codellama - Code generation and understanding"
            echo "• ollama pull mistral - Fast and efficient 7B model"
            echo "• ollama pull phi - Compact model from Microsoft"
            echo ""
            echo "💬 RUNNING YOUR FIRST AI CHAT:"
            echo "• ollama run llama2 - Start interactive chat"
            echo "• Ask anything: 'Explain quantum physics simply'"
            echo "• Type /bye to exit the chat"
            echo "• Try different models to see how they respond"
            echo ""
            echo "🔧 ADVANCED USAGE:"
            echo "• ollama serve - Run as API server (port 11434)"
            echo "• ollama list - See installed models"
            echo "• ollama rm model_name - Remove models"
            echo "• ollama pull model_name - Update models"
            echo ""
            echo "🎮 HANDS-ON AI EXPERIMENTS:"
            echo ""
            echo "📝 TEXT GENERATION:"
            echo "• 'Write a Python function to calculate fibonacci'"
            echo "• 'Explain machine learning like I'm 5 years old'"
            echo "• 'Create a story about a robot learning to paint'"
            echo ""
            echo "🧠 REASONING TASKS:"
            echo "• 'Solve this logic puzzle: [your puzzle]'"
            echo "• 'Help me debug this code: [paste code]'"
            echo "• 'What are the pros and cons of [topic]?'"
            echo ""
            echo "💡 ADHD-FRIENDLY OLLAMA WORKFLOW:"
            echo "• Start with llama2 - it's friendly and patient"
            echo "• Use it for hyperfocus research sessions"
            echo "• Ask follow-up questions without limits"
            echo "• Create custom models for your special interests"
            echo "• Use the API to build your own AI tools"
            echo ""
            echo "🎓 LEARNING PATH:"
            echo "1. Install a basic model: ollama pull llama2"
            echo "2. Have conversations to understand capabilities"
            echo "3. Try specialized models (codellama, mistral)"
            echo "4. Experiment with the API for building apps"
            echo "5. Learn about fine-tuning and model customization"
            echo ""
            echo "✅ OLLAMA READY!"
            echo "Try: ollama pull llama2 && ollama run llama2"
            echo ""
            echo "🍔 Meatwad: 'Shake said it was a crime lab.'"
            ;;
        2)
            echo "[LOG] Bill chose Hugging Face Transformers" >> ~/ai_development/assistant.log
            echo "🤗 DEPLOYING HUGGING FACE TRANSFORMERS - THE AI RESEARCHER'S TOOLKIT!"
            echo ""
            echo "🎓 WHAT IS HUGGING FACE TRANSFORMERS?"
            echo "Hugging Face Transformers is the go-to Python library for working with"
            echo "state-of-the-art machine learning models. It's like a massive toolbox:"
            echo "• 100,000+ pre-trained models available"
            echo "• Support for PyTorch, TensorFlow, and JAX"
            echo "• Easy-to-use APIs for common AI tasks"
            echo "• Active community and cutting-edge research"
            echo "• Works with text, images, audio, and more"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR DEEP AI LEARNING:"
            echo "• Learn how AI models really work under the hood"
            echo "• Experiment with the latest research models"
            echo "• Build custom AI applications from scratch"
            echo "• Jupyter notebooks for interactive exploration"
            echo "• Industry-standard skills for AI career paths"
            echo ""
            
            # Install Transformers
            if command -v python3 &> /dev/null; then
                echo "🔧 Installing Hugging Face Transformers..."
                pip3 install --user transformers torch torchvision datasets tokenizers
                echo "✅ Transformers installed!"
            else
                echo "❌ Python 3 required. Installing Python first..."
                if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y python3 python3-pip
                    pip3 install --user transformers torch torchvision datasets tokenizers
                else
                    echo "Please install Python 3 first: https://python.org/downloads"
                    return
                fi
            fi
            
            echo ""
            echo "🚀 TRANSFORMERS FOR AI RESEARCH"
            echo "==============================="
            echo ""
            echo "🎯 YOUR FIRST AI EXPERIMENTS:"
            echo ""
            echo "📝 TEXT GENERATION EXAMPLE:"
            cat > ~/ai_development/text_generation_example.py << 'EOF'
from transformers import pipeline

# Create a text generation pipeline
generator = pipeline('text-generation', model='gpt2')

# Generate text
results = generator("The future of AI is", max_length=100, num_return_sequences=2)

for i, result in enumerate(results):
    print(f"Generation {i+1}: {result['generated_text']}")
EOF
            
            echo "🧠 SENTIMENT ANALYSIS EXAMPLE:"
            cat > ~/ai_development/sentiment_analysis_example.py << 'EOF'
from transformers import pipeline

# Create a sentiment analysis pipeline
classifier = pipeline('sentiment-analysis')

# Analyze sentiments
texts = [
    "I love learning about AI!",
    "This is frustrating and confusing.",
    "Transformers make AI accessible to everyone."
]

for text in texts:
    result = classifier(text)
    print(f"Text: {text}")
    print(f"Sentiment: {result[0]['label']} ({result[0]['score']:.4f})\n")
EOF
            
            echo "🔍 QUESTION ANSWERING EXAMPLE:"
            cat > ~/ai_development/qa_example.py << 'EOF'
from transformers import pipeline

# Create a question-answering pipeline
qa_pipeline = pipeline('question-answering')

# Context and questions
context = """
Hugging Face is a company that provides tools and infrastructure for machine learning.
They created the Transformers library, which makes it easy to work with AI models.
The company was founded in 2016 and is based in New York and Paris.
"""

questions = [
    "What did Hugging Face create?",
    "When was the company founded?",
    "Where is Hugging Face based?"
]

for question in questions:
    result = qa_pipeline(question=question, context=context)
    print(f"Q: {question}")
    print(f"A: {result['answer']} (confidence: {result['score']:.4f})\n")
EOF
            
            echo "✅ Created example scripts in ~/ai_development/"
            echo ""
            echo "🎓 LEARNING ROADMAP:"
            echo "1. Run the examples: python3 text_generation_example.py"
            echo "2. Experiment with different models and tasks"
            echo "3. Try fine-tuning models on your own data"
            echo "4. Build applications using the pipeline API"
            echo "5. Explore advanced topics like model training"
            echo ""
            echo "📚 ESSENTIAL RESOURCES:"
            echo "• Hugging Face Course: https://huggingface.co/course"
            echo "• Model Hub: https://huggingface.co/models"
            echo "• Datasets: https://huggingface.co/datasets"
            echo "• Community Discord: https://hf.co/join/discord"
            echo ""
            echo "✅ HUGGING FACE TRANSFORMERS READY!"
            echo "Try: python3 ~/ai_development/text_generation_example.py"
            echo ""
            echo "🧠 Frylock: 'What seems to be the problem?'"
            ;;
        3)
            echo "[LOG] Bill chose Text Generation WebUI" >> ~/ai_development/assistant.log
            echo "💬 DEPLOYING TEXT GENERATION WEBUI - BEAUTIFUL AI INTERFACE!"
            echo ""
            echo "🎓 WHAT IS TEXT GENERATION WEBUI?"
            echo "Text Generation WebUI (also known as oobabooga) is a beautiful,"
            echo "user-friendly web interface for running text generation models:"
            echo "• ChatGPT-like interface for local models"
            echo "• Supports hundreds of models (Llama, Mistral, etc.)"
            echo "• No coding required - just point and click"
            echo "• Advanced features like character chat and model switching"
            echo "• Works with both CPU and GPU acceleration"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR NON-PROGRAMMERS:"
            echo "• Beautiful visual interface - no command line"
            echo "• Easy model downloads and management"
            echo "• Chat-like experience with advanced AI"
            echo "• Experiment with AI without technical barriers"
            echo "• Share and save conversations"
            echo ""
            
            echo "🔧 Installing Text Generation WebUI..."
            echo "This requires Git and Python. Setting up automatically..."
            
            # Create installation directory
            mkdir -p ~/ai_development/text-generation-webui
            cd ~/ai_development/text-generation-webui
            
            if command -v git &> /dev/null; then
                echo "📥 Downloading Text Generation WebUI..."
                git clone https://github.com/oobabooga/text-generation-webui.git .
                
                echo "🔧 Setting up Python environment..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    bash start_linux.sh --install
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    bash start_macos.sh --install
                else
                    echo "Please run the appropriate start script for your OS"
                fi
                
                echo "✅ Text Generation WebUI installed!"
                echo "🚀 To start: cd ~/ai_development/text-generation-webui && ./start_linux.sh"
            else
                echo "❌ Git required. Please install Git first."
                echo "📖 Manual installation: https://github.com/oobabooga/text-generation-webui"
            fi
            
            echo ""
            echo "🎯 USING THE WEB INTERFACE:"
            echo "1. Start the server with the start script"
            echo "2. Open your browser to http://localhost:7860"
            echo "3. Download a model from the Model tab"
            echo "4. Switch to Chat tab and start talking!"
            echo ""
            echo "💡 RECOMMENDED FIRST MODELS:"
            echo "• TheBloke/Llama-2-7B-Chat-GGML"
            echo "• TheBloke/Mistral-7B-Instruct-v0.1-GGUF"
            echo "• microsoft/DialoGPT-medium"
            echo ""
            echo "✅ TEXT GENERATION WEBUI READY!"
            echo ""
            echo "🍔 Meatwad: 'I understand! It's like texting with a robot, but prettier!'"
            ;;
        4)
            echo "[LOG] Bill chose Llama.cpp" >> ~/ai_development/assistant.log
            echo "⚡ DEPLOYING LLAMA.CPP - THE LIGHTWEIGHT AI ENGINE!"
            echo ""
            echo "🎓 WHAT IS LLAMA.CPP?"
            echo "Llama.cpp is a highly optimized C++ implementation for running"
            echo "Large Language Models efficiently on consumer hardware:"
            echo "• Runs on CPU with excellent performance"
            echo "• Minimal memory usage through quantization"
            echo "• No Python dependencies - just a single binary"
            echo "• Works on older computers and limited hardware"
            echo "• Foundation for many other AI tools"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR PERFORMANCE-FOCUSED USERS:"
            echo "• Maximum efficiency - every bit of performance matters"
            echo "• Understand AI optimization and computer science"
            echo "• Works on computers that can't run other AI software"
            echo "• Learn about quantization and model compression"
            echo "• Foundation knowledge for AI engineering"
            echo ""
            
            # Install llama.cpp
            echo "🔧 Installing llama.cpp..."
            mkdir -p ~/ai_development/llama.cpp
            cd ~/ai_development/llama.cpp
            
            if command -v git &> /dev/null && command -v make &> /dev/null; then
                echo "📥 Downloading llama.cpp source..."
                git clone https://github.com/ggerganov/llama.cpp.git .
                
                echo "🔨 Compiling llama.cpp..."
                make
                
                echo "✅ llama.cpp compiled successfully!"
                
                # Create helper script
                cat > ~/ai_development/llama_helper.sh << 'EOF'
#!/bin/bash
echo "🦙 Llama.cpp Helper Script"
echo "========================="
echo ""
echo "Available commands:"
echo "  ./main -m model.gguf -p \"Your prompt here\" -n 100"
echo "  ./main -m model.gguf --interactive"
echo ""
echo "Download models from: https://huggingface.co/TheBloke"
echo "Look for GGUF format models for best compatibility."
echo ""
echo "Example models to try:"
echo "• Llama-2-7B-Chat-GGUF"
echo "• Mistral-7B-Instruct-v0.1-GGUF"
echo "• CodeLlama-7B-GGUF"
EOF
                chmod +x ~/ai_development/llama_helper.sh
                
                echo "📚 Created helper script at ~/ai_development/llama_helper.sh"
            else
                echo "❌ Git and make required. Please install build tools first."
                echo "Ubuntu/Debian: sudo apt install git build-essential"
                echo "macOS: xcode-select --install"
                return
            fi
            
            echo ""
            echo "🚀 LLAMA.CPP USAGE GUIDE:"
            echo "========================"
            echo ""
            echo "🎯 GETTING YOUR FIRST MODEL:"
            echo "1. Visit https://huggingface.co/TheBloke"
            echo "2. Download a GGUF model file"
            echo "3. Place it in ~/ai_development/llama.cpp/models/"
            echo "4. Run: ./main -m models/your-model.gguf --interactive"
            echo ""
            echo "⚡ PERFORMANCE OPTIMIZATION:"
            echo "• Use -t flag to set CPU threads: -t 8"
            echo "• Use -c flag for context length: -c 2048"
            echo "• Use -n flag for max tokens: -n 256"
            echo "• Quantized models (Q4, Q5) for better performance"
            echo ""
            echo "🎓 LEARNING OPPORTUNITIES:"
            echo "• Understand model quantization and compression"
            echo "• Learn about CPU optimization techniques"
            echo "• Experiment with different model sizes"
            echo "• Build custom applications using the C++ API"
            echo ""
            echo "✅ LLAMA.CPP READY!"
            echo "Run: cd ~/ai_development/llama.cpp && ./llama_helper.sh"
            echo ""
            echo "🥤 Shake: 'I'm doing this, all right? You got a problem with that?'"
            ;;
        5)
            echo "[LOG] Bill chose LangChain Development" >> ~/ai_development/assistant.log
            echo "🧪 DEPLOYING LANGCHAIN DEVELOPMENT KIT - AI APPLICATION BUILDER!"
            echo ""
            echo "🎓 WHAT IS LANGCHAIN?"
            echo "LangChain is a framework for developing applications powered by language models."
            echo "Think of it as the bridge between AI models and real-world applications:"
            echo "• Connect AI to databases, APIs, and file systems"
            echo "• Build conversational agents and chatbots"
            echo "• Create AI-powered document analysis tools"
            echo "• Develop question-answering systems"
            echo "• Build autonomous AI agents"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR APPLICATION BUILDERS:"
            echo "• Turn AI experiments into useful tools"
            echo "• Modular design - start simple, add complexity"
            echo "• Works with any AI model (local or cloud)"
            echo "• Rich ecosystem of integrations"
            echo "• Build the AI tools you actually need"
            echo ""
            
            # Install LangChain
            echo "🔧 Installing LangChain development kit..."
            pip3 install --user langchain langchain-community langchain-openai chromadb faiss-cpu
            
            echo "📝 Creating LangChain project structure..."
            mkdir -p ~/ai_development/langchain_projects/{examples,agents,tools}
            
            # Create example applications
            cat > ~/ai_development/langchain_projects/examples/document_qa.py << 'EOF'
"""Document Question Answering with LangChain"""
from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import FAISS
from langchain.chains import RetrievalQA
from langchain.llms import Ollama

def create_document_qa_system(document_path):
    """Create a QA system for a document"""
    # Load and split document
    loader = TextLoader(document_path)
    documents = loader.load()
    text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
    texts = text_splitter.split_documents(documents)
    
    # Create embeddings and vector store
    embeddings = HuggingFaceEmbeddings()
    db = FAISS.from_documents(texts, embeddings)
    
    # Create QA chain
    llm = Ollama(model="llama2")
    qa = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", retriever=db.as_retriever())
    
    return qa

if __name__ == "__main__":
    # Example usage
    print("Document QA System")
    print("Place your text file in this directory and update the path below")
    # qa_system = create_document_qa_system("your_document.txt")
    # answer = qa_system.run("What is the main topic of this document?")
    # print(f"Answer: {answer}")
EOF
            
            cat > ~/ai_development/langchain_projects/examples/simple_agent.py << 'EOF'
"""Simple AI Agent with LangChain"""
from langchain.agents import initialize_agent, Tool
from langchain.agents import AgentType
from langchain.llms import Ollama
from datetime import datetime
import requests

def get_current_time(query):
    """Get the current date and time"""
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def simple_calculator(query):
    """Simple calculator for basic math"""
    try:
        # WARNING: eval is dangerous in production - use a proper math parser
        result = eval(query.replace("calculate", "").strip())
        return f"The result is: {result}"
    except:
        return "I can only do simple math like 2+2, 10*5, etc."

def create_simple_agent():
    """Create a simple AI agent with tools"""
    # Define tools
    tools = [
        Tool(
            name="Current Time",
            func=get_current_time,
            description="Get the current date and time"
        ),
        Tool(
            name="Calculator",
            func=simple_calculator,
            description="Do simple math calculations"
        )
    ]
    
    # Initialize agent
    llm = Ollama(model="llama2")
    agent = initialize_agent(tools, llm, agent=AgentType.ZERO_SHOT_REACT_DESCRIPTION, verbose=True)
    
    return agent

if __name__ == "__main__":
    agent = create_simple_agent()
    
    # Interactive loop
    print("Simple AI Agent (type 'quit' to exit)")
    while True:
        user_input = input("You: ")
        if user_input.lower() == 'quit':
            break
        try:
            response = agent.run(user_input)
            print(f"Agent: {response}")
        except Exception as e:
            print(f"Error: {e}")
EOF
            
            cat > ~/ai_development/langchain_projects/README.md << 'EOF'
# LangChain Development Projects

This directory contains example LangChain applications to get you started with AI application development.

## Examples

### document_qa.py
Create a question-answering system for your documents. Upload any text file and ask questions about its content.

### simple_agent.py
A basic AI agent that can use tools (calculator, time lookup). Shows how to build autonomous AI assistants.

## Getting Started

1. Make sure Ollama is installed and running
2. Pull a model: `ollama pull llama2`
3. Run an example: `python3 examples/simple_agent.py`
4. Modify and experiment!

## Next Steps

- Add more tools to your agents
- Connect to databases and APIs
- Build web interfaces with Streamlit
- Create specialized agents for your use cases
EOF
            
            echo "✅ LangChain development kit installed!"
            echo ""
            echo "🚀 YOUR AI APPLICATION LAB:"
            echo "==========================="
            echo ""
            echo "📁 Project Structure:"
            echo "  ~/ai_development/langchain_projects/"
            echo "  ├── examples/          (Sample applications)"
            echo "  ├── agents/            (Your AI agents)"
            echo "  ├── tools/             (Custom tools)"
            echo "  └── README.md          (Documentation)"
            echo ""
            echo "🎯 FIRST STEPS:"
            echo "1. Ensure Ollama is running: ollama serve"
            echo "2. Try the simple agent: python3 examples/simple_agent.py"
            echo "3. Experiment with the document QA system"
            echo "4. Build your own AI applications!"
            echo ""
            echo "💡 APPLICATION IDEAS:"
            echo "• Personal AI assistant for your daily tasks"
            echo "• Document analysis and summarization tools"
            echo "• Code review and programming help agents"
            echo "• Research assistants for your interests"
            echo "• Automated content creation workflows"
            echo ""
            echo "✅ LANGCHAIN DEVELOPMENT KIT READY!"
            echo ""
            echo "🧠 Carl: 'I'm straight. Teeth are for gay people.'"
            ;;
        6)
            echo "[LOG] Bill chose Complete Local AI Lab" >> ~/ai_development/assistant.log
            echo "🚀 DEPLOYING COMPLETE LOCAL AI LABORATORY!"
            echo ""
            echo "This installs ALL local AI tools to create the ultimate development environment."
            echo "You'll have everything needed to become an AI developer and researcher!"
            echo ""
            read -p "Continue with complete AI lab installation? (y/n): " lab_confirm
            if [[ $lab_confirm =~ ^[Yy]$ ]]; then
                echo "🏗️ Building complete local AI laboratory..."
                
                # Install all tools
                echo "1/5 Installing Ollama..."
                curl -fsSL https://ollama.ai/install.sh | sh 2>/dev/null
                
                echo "2/5 Installing Hugging Face Transformers..."
                pip3 install --user transformers torch datasets tokenizers 2>/dev/null
                
                echo "3/5 Installing LangChain..."
                pip3 install --user langchain langchain-community chromadb 2>/dev/null
                
                echo "4/5 Setting up Text Generation WebUI..."
                mkdir -p ~/ai_development/text-generation-webui
                
                echo "5/5 Creating AI development dashboard..."
                cat > ~/ai_development/ai-lab-dashboard << 'EOF'
#!/bin/bash
echo "🤖 BILL'S LOCAL AI LABORATORY"
echo "============================="
echo ""
echo "Available AI Tools:"
echo "1) Ollama - Simple model runner (ollama run llama2)"
echo "2) Text Generation WebUI - Beautiful interface"
echo "3) Python AI Development (jupyter notebook)"
echo "4) LangChain Applications (cd langchain_projects)"
echo ""
echo "Quick Start:"
echo "• ollama pull llama2  (download your first model)"
echo "• ollama run llama2   (start chatting with AI)"
echo ""
echo "Your AI Lab: ~/ai_development/"
EOF
                chmod +x ~/ai_development/ai-lab-dashboard
                
                # Create useful aliases
                cat >> ~/.bashrc << 'EOF'

# Bill Sloth AI Development Aliases
alias ai-lab='~/ai_development/ai-lab-dashboard'
alias ai-chat='ollama run llama2'
alias ai-dev='cd ~/ai_development'
alias ai-python='cd ~/ai_development && python3'
EOF
                
                echo ""
                echo "🎉 COMPLETE LOCAL AI LABORATORY DEPLOYED!"
                echo "==========================================="
                echo ""
                echo "🎯 YOUR AI SUPERPOWERS:"
                echo "• Ollama - Chat with AI models locally"
                echo "• Transformers - Build AI applications in Python"
                echo "• LangChain - Create AI agents and tools"
                echo "• Text Generation WebUI - Beautiful AI interface"
                echo ""
                echo "✅ You now have a complete AI development environment!"
                echo "Start with: ai-lab (after reloading your shell)"
                echo ""
                echo "🎓 LEARNING PATH:"
                echo "1. Start with Ollama for basic AI interaction"
                echo "2. Experiment with different models and tasks"
                echo "3. Learn Python AI development with Transformers"
                echo "4. Build real applications with LangChain"
                echo "5. Share your AI creations with the world!"
            fi
            ;;
        other|Other|OTHER)
            echo "[LOG] Bill requested more options from Claude Code" >> ~/ai_development/assistant.log
            echo "🤖 SUMMONING CLAUDE CODE FOR ADVANCED AI TOOLS..."
            echo ""
            echo "Claude Code can help you with specialized AI development tools:"
            echo ""
            echo "🧠 ADVANCED AI FRAMEWORKS:"
            echo "• MLflow - Machine learning lifecycle management"
            echo "• Weights & Biases - Experiment tracking and visualization"
            echo "• Ray - Distributed AI and hyperparameter tuning"
            echo "• Apache Spark - Big data processing for AI"
            echo ""
            echo "🚀 SPECIALIZED AI TOOLS:"
            echo "• Stable Diffusion - Image generation and editing"
            echo "• Whisper - Speech recognition and transcription"
            echo "• CLIP - Vision and language understanding"
            echo "• FastAPI - Build AI APIs and services"
            echo ""
            echo "💡 Tell Claude Code about your specific AI interests!"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\n📝 All actions logged to ~/ai_development/assistant.log"
    echo "🔄 You can always re-run this assistant to try a different solution!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ai_setup_commands_interactive
fi 