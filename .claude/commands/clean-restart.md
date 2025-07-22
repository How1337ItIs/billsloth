# Bill Sloth Project Clean Restart

Project-specific procedure for starting fresh Claude Code sessions while preserving Bill Sloth system state.

## Pre-Restart Backup

### Save Current Project Context
```bash
# Create timestamped project backup
BACKUP_DIR="$HOME/.bill-sloth/claude-sessions/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Save current task context to Bill Sloth data system
source lib/data_persistence.sh
store_data "claude_session" "current_task" "$(pwd):$(date):$USER_TASK_DESCRIPTION"

# Backup any modified files
git status --porcelain > "$BACKUP_DIR/git-status.txt"
git diff > "$BACKUP_DIR/git-changes.diff"
```

### Save Bill Sloth System State
```bash
# Export current system configuration
source lib/data_sharing.sh
export_system_state "$BACKUP_DIR/system-state.json"

# Save adaptive learning context
cp -r ~/.bill-sloth/learning/ "$BACKUP_DIR/learning-state/" 2>/dev/null || true

# Save workflow orchestration state
source lib/workflow_orchestration.sh
save_workflow_state "$BACKUP_DIR/workflow-state.json"
```

## Session Restart Process

### Step 1: Exit Current Session Safely
```bash
# Let Bill Sloth know we're ending session
source lib/notification_system.sh
notify_info "Claude Session Ending" "Saving state and restarting session"

# Exit current session
exit
```

### Step 2: Clean Start New Session
```bash
# Start fresh with claunch
cd ~/bill-sloth
claunch --tmux
```

### Step 3: Restore Bill Sloth Context
```bash
# Restore project context quickly
source lib/data_persistence.sh
LAST_TASK=$(get_data "claude_session" "current_task")
echo "Restored context: $LAST_TASK"

# Load system state
source lib/data_sharing.sh
import_system_state "$HOME/.bill-sloth/claude-sessions/*/system-state.json"

# Re-initialize core systems
source lib/error_handling.sh
source lib/notification_system.sh
source lib/workflow_orchestration.sh
```

## Integration with Bill Sloth Infrastructure

### Leverage Existing Systems
```bash
# Use Bill Sloth's health monitoring
source lib/system_health_monitoring.sh
check_session_health

# Integrate with task runner
source lib/task_runner.sh
resume_interrupted_tasks

# Connect to backup system
source lib/backup_management.sh
verify_backup_integrity
```

### Adaptive Learning Integration
```bash
# Let adaptive system know about session restart
echo "claude_session_restart:$(date)" >> ~/.bill-sloth/learning/session-events.log

# Update pattern learning
source lib/adaptive_learning.sh
record_session_pattern "restart"
```

## Quick Context Recovery

### Minimal Context Restoration
```bash
# Show current project status
cat CLAUDE.md | head -30

# Display recent development activity
git log --oneline -5

# Show any pending tasks
source lib/task_runner.sh
list_pending_tasks
```

### Full Context Restoration
```bash
# Comprehensive project brief
echo "=== BILL SLOTH PROJECT STATUS ==="
bash bill_command_center.sh | head -20

# Recent changes summary
echo "=== RECENT DEVELOPMENT ==="
git log --since="1 week ago" --oneline

# Current health status
echo "=== SYSTEM HEALTH ==="
source lib/system_health_monitoring.sh
get_quick_status
```

## Prevention for Next Session

### Session Hygiene
- Use `/clear` when switching between different modules
- Save progress to Bill Sloth data persistence before large operations
- Monitor context usage during development sessions
- Exit sessions cleanly using Bill Sloth notification system

### Integration Checkpoints
- Create workflow checkpoints before major changes
- Use Bill Sloth's backup system proactively
- Leverage adaptive learning to improve session management