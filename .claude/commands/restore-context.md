# Bill Sloth Context Restoration

Quickly restore project context after Claude Code session restarts using Bill Sloth's integrated systems.

## Quick Context Recovery

### Essential Project Context
```bash
# Show current project status
echo "=== BILL SLOTH PROJECT STATUS ==="
cat CLAUDE.md | head -30

# Display recent development activity  
echo "=== RECENT CHANGES ==="
git log --oneline -5
git status --short
```

### System State Recovery
```bash
# Load Bill Sloth system context
source lib/data_persistence.sh
LAST_SESSION=$(get_data "claude_session" "current_task")
echo "Previous session: $LAST_SESSION"

# Restore workflow context
source lib/workflow_orchestration.sh
show_active_workflows

# Check system health
source lib/system_health_monitoring.sh
get_quick_status
```

## Comprehensive Context Restoration

### Full Project Brief
```bash
# Complete system overview
bash bill_command_center.sh | head -30

# Module system status
find modules/ -name "*.sh" -executable | wc -l
echo "modules available"

# Current development focus
ls -la lib/ | grep -E "\\.sh$" | tail -5
echo "recently modified libraries"
```

### Adaptive Learning Context
```bash
# Recent learning patterns
source lib/adaptive_learning.sh
show_recent_patterns

# Development session history
tail -10 ~/.bill-sloth/learning/development-sessions.log

# Usage analytics
source lib/data_sharing.sh
show_usage_summary
```

### Voice Control Status
```bash
# Voice integration status
ls -la external/linux-voice-control/linux-voice-control*

# Configuration status
if [ -f "external/bill-sloth-voice-config.json" ]; then
    echo "✅ Voice control configured"
else
    echo "⚠️ Voice control needs setup"
fi
```

## Specialized Context Recovery

### For Module Development
```bash
# Module system overview
echo "=== MODULE DEVELOPMENT CONTEXT ==="
ls -la modules/ | grep -E "interactive\\.sh$" | wc -l
echo "interactive modules"

# Recent module activity
find modules/ -name "*.sh" -mtime -7 -exec basename {} \;
```

### For Library Development
```bash
# Library system status
echo "=== LIBRARY DEVELOPMENT CONTEXT ==="
source lib/error_handling.sh && echo "✅ Error handling loaded"
source lib/data_persistence.sh && echo "✅ Data persistence loaded"
source lib/system_health_monitoring.sh && echo "✅ Health monitoring loaded"
```

### For Integration Work
```bash
# Integration points overview
echo "=== INTEGRATION CONTEXT ==="
ls -la external/
echo "External integrations available"

# API and service status
ps aux | grep -E "(voice|backup|monitor)" | grep -v grep || echo "No services running"
```

## Context Validation

### Health Checks
```bash
# Validate restored context
bash scripts/health_check.sh | head -10

# Verify data integrity
source lib/data_persistence.sh
verify_data_integrity

# Check backup system
source lib/backup_management.sh
verify_backup_system
```

### Missing Context Recovery
```bash
# If context seems incomplete
echo "Checking for missing context..."

# Restore from latest backup if needed
LATEST_BACKUP=$(ls -t ~/.bill-sloth/backups/system-*.json | head -1)
if [ -f "$LATEST_BACKUP" ]; then
    source lib/data_sharing.sh
    import_system_state "$LATEST_BACKUP"
    echo "✅ Restored from: $LATEST_BACKUP"
fi
```

## Notification Integration

### Context Recovery Notification
```bash
# Notify successful context restoration
source lib/notification_system.sh
notify_info "Context Restored" "Bill Sloth project context successfully loaded"
```

This ensures seamless continuation of development work using Bill Sloth's existing infrastructure and design patterns.