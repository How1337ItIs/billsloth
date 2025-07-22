#!/bin/bash
# Lists all available Bill Sloth installer/configuration plugins
set -e

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
echo "\n🧩 Available Bill Sloth Plugins:\n"
for plugin in "$PLUGIN_DIR"/*.sh; do
  [ -f "$plugin" ] || continue
  name=$(basename "$plugin")
  desc=$(grep -m1 '^#' "$plugin" | sed 's/^# *//')
  printf "- %-25s  %s\n" "$name" "$desc"
done

echo "\nTo run a plugin: bash plugins/<plugin_name>.sh\n" 