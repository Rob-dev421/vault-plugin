#!/bin/bash
# engine/lib/log.sh
# log_append <vault_root> <log_file_path> <message> [<link>]
# Prepends a dated entry to log_file_path. Creates the file if missing.
# No stdout output. Writes only to the log file.

log_append() {
  local vault_root="$1"
  local log_path="$2"
  local message="$3"
  local link="${4:-}"

  local today
  today=$(date +%Y-%m-%d)

  # Build the bullet line
  local bullet="- $message"
  [[ -n "$link" ]] && bullet="- [$message]($link)"

  if [[ ! -f "$log_path" ]]; then
    # Create new log file
    {
      echo "# Update Log"
      echo ""
      echo "## $today"
      echo ""
      echo "$bullet"
    } > "$log_path"
    return
  fi

  # Check if today's heading already exists
  if grep -q "^## $today$" "$log_path"; then
    # Insert bullet after today's heading
    py -3 - "$log_path" "$today" "$bullet" <<'PYEOF'
import sys
log_path, today, bullet = sys.argv[1], sys.argv[2], sys.argv[3]
lines = open(log_path, encoding='utf-8').readlines()
out = []
inserted = False
i = 0
while i < len(lines):
    out.append(lines[i])
    if not inserted and lines[i].strip() == f'## {today}':
        # Insert after heading, skip blank line if present
        if i + 1 < len(lines) and lines[i+1].strip() == '':
            out.append(lines[i+1])
            i += 1
        out.append(bullet + '\n')
        inserted = True
    i += 1
open(log_path, 'w', encoding='utf-8').writelines(out)
PYEOF
  else
    # Prepend new heading + bullet before existing content
    local existing
    existing=$(cat "$log_path")
    {
      echo "# Update Log"
      echo ""
      echo "## $today"
      echo ""
      echo "$bullet"
      echo ""
      # Strip leading header from existing if present
      echo "$existing" | grep -v "^# Update Log" | sed '/./,$!d'
    } > "$log_path"
  fi
}
