#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Claude Launcher - Phase 1 Working Implementation
# Creates tmux split-pane session: module on left, Claude CLI on right

set -euo pipefail

# Parse arguments
MODULE="${1:-}"
if [[ -z "$MODULE" ]]; then
    echo "Usage: $0 <module_name> [args...]"
    echo "Example: $0 data_hoarding_interactive"
    exit 1
fi

# Validate module exists
MODULE_PATH="modules/${MODULE}.sh"
if [[ ! -f "$MODULE_PATH" ]]; then
    echo "Error: Module not found: $MODULE_PATH"
    echo "Available modules:"
    ls modules/*.sh 2>/dev/null | sed 's/modules\//  /' | sed 's/\.sh$//' || echo "  (no modules found)"
    exit 1
fi

# Check prerequisites
if ! command -v tmux &>/dev/null; then
    echo "Error: tmux not installed. Install with:"
    echo "  Ubuntu/Debian: sudo apt install tmux"
    echo "  RedHat/CentOS: sudo yum install tmux"
    exit 1
fi

if ! command -v claude &>/dev/null; then
    echo "Error: Claude CLI not found. Install from: https://claude.ai/code"
    exit 1
fi

# Session management
SESSION_NAME="bill-sloth-${MODULE}"
shift # Remove module name from args

# Kill existing session if it exists
tmux has-session -t "$SESSION_NAME" 2>/dev/null && tmux kill-session -t "$SESSION_NAME"

# Create new session with module in left pane
echo "Starting Bill Sloth module: $MODULE"
tmux new-session -d -s "$SESSION_NAME" -c "$(pwd)" bash "$MODULE_PATH" "$@"

# Split window vertically (left: module, right: Claude CLI)
tmux split-window -h -t "$SESSION_NAME" -c "$(pwd)"

# Start Claude CLI in right pane with context
CLAUDE_PROMPT="You are assisting inside Bill Sloth module $MODULE. Monitor left pane and help when requested. Type 'help' for available commands."
tmux send-keys -t "$SESSION_NAME:0.1" "claude --dangerously-skip-permissions -p \"$CLAUDE_PROMPT\"" Enter

# Configure key bindings for this session
tmux bind-key -T prefix a run-shell "tmux capture-pane -t 0 -p -S -100 | tmux load-buffer - && tmux paste-buffer -t 1"
tmux bind-key -T prefix q kill-session

# Adjust pane sizes (70% left, 30% right)
tmux resize-pane -t "$SESSION_NAME:0.0" -x 70%

# Attach to session
echo "Launching tmux session: $SESSION_NAME"
echo "Key bindings:"
echo "  Ctrl-b a : Capture left pane (last 100 lines) and send to Claude"
echo "  Ctrl-b q : Quit session"
echo "  Ctrl-b [ : Enter copy mode (navigate with arrow keys, q to exit)"
echo ""

exec tmux attach-session -t "$SESSION_NAME"