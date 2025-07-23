#!/bin/bash
# Bill Sloth Sync Script - Sync adaptations and maintain overlay system
# Equivalent to the audit-recommended bill-sync.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source overlay system
source "$PROJECT_ROOT/lib/overlay_system.sh"

echo "🔄 BILL SLOTH ADAPTATION SYNC"
echo "============================="
echo ""

# Sync all adaptations
sync_bill_adaptations

# Validate system integrity
echo ""
validate_overlay_system

echo ""
echo "✅ Bill Sloth sync complete!"