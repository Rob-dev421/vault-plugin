#!/bin/bash
# engine/lib/validate.sh
# Usage: bash validate.sh <path>   — path can be a file or a vault directory
# Output: one finding per line: "<SEVERITY> [<RULE-ID>] <filepath>: <message>"
# Exit: 0 if no ERRORs; 1 if any ERRORs found

_VALIDATE_ERRORS=0
_VALIDATE_FINDINGS=()

_emit() {
  local severity="$1" rule="$2" filepath="$3" message="$4"
  _VALIDATE_FINDINGS+=("$severity [$rule] $filepath: $message")
  [[ "$severity" == "ERROR" ]] && _VALIDATE_ERRORS=$((_VALIDATE_ERRORS + 1))
}

_is_reserved() {
  local name
  name="$(basename "$1")"
  [[ "$name" == "index.md" || "$name" == "log.md" || "$name" == "transcript.md" ]]
}

_check_file() {
  local filepath="$1" bundle_root="$2"

  local name
  name="$(basename "$filepath")"

  # ── RULE-004: non-root index.md must not have frontmatter ─────────────────
  if [[ "$name" == "index.md" ]]; then
    local rel_path="${filepath#$bundle_root/}"
    local is_root=false
    # root index.md has no directory separator
    [[ "$rel_path" == "index.md" ]] && is_root=true

    if $is_root; then
      # RULE-005: root index.md should have okf_version
      if ! grep -q "^okf_version:" "$filepath" 2>/dev/null; then
        _emit "WARNING" "RULE-005" "$filepath" "bundle-root index.md missing okf_version field"
      fi
    else
      # non-root: must NOT have frontmatter
      if head -1 "$filepath" | grep -q "^---"; then
        _emit "ERROR" "RULE-004" "$filepath" "non-root index.md must not contain frontmatter"
      fi
    fi
    return
  fi

  # ── RULE-006: log.md date headings must be ISO 8601 ───────────────────────
  if [[ "$name" == "log.md" ]]; then
    while IFS= read -r line; do
      if [[ "$line" =~ ^##[[:space:]] ]]; then
        local heading="${line#\#\# }"
        if ! [[ "$heading" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
          _emit "WARNING" "RULE-006" "$filepath" "log.md date heading not ISO 8601 YYYY-MM-DD: '$heading'"
          break
        fi
      fi
    done < "$filepath"
    return
  fi

  # ── RULE-013/020/021: transcript.md rules ────────────────────────────────
  if [[ "$name" == "transcript.md" ]]; then
    # RULE-013: should not have a type field
    if grep -q "^type:" "$filepath" 2>/dev/null; then
      _emit "WARNING" "RULE-013" "$filepath" "transcript.md is reserved; type field is ignored by consumers"
    fi
    # RULE-020: must have source_file
    if ! grep -q "^source_file:" "$filepath" 2>/dev/null; then
      _emit "ERROR" "RULE-020" "$filepath" "transcript.md missing required 'source_file' field"
    fi
    # RULE-021: must have source_type
    if ! grep -q "^source_type:" "$filepath" 2>/dev/null; then
      _emit "ERROR" "RULE-021" "$filepath" "transcript.md missing required 'source_type' field"
    fi
    return
  fi

  # ── RULE-010/011/012: inbox rules for files with type: Raw Input ─────────
  # Applied to any .md file with type: Raw Input (typically input.md)
  local is_input_file=false
  if head -1 "$filepath" | grep -q "^---" && grep -q "^type: Raw Input" "$filepath" 2>/dev/null; then
    is_input_file=true
  fi

  # ── Non-reserved .md concept files ────────────────────────────────────────
  # RULE-001: must have frontmatter
  if ! head -1 "$filepath" | grep -q "^---"; then
    _emit "ERROR" "RULE-001" "$filepath" "concept file missing YAML frontmatter"
    return
  fi

  # RULE-002/003: type field presence and value
  local type_check
  type_check=$(py -3 - "$filepath" <<'PYEOF' 2>/dev/null
import sys, re
content = open(sys.argv[1], encoding='utf-8').read()
if not content.startswith('---'):
    sys.exit(1)
end = content.find('\n---', 3)
if end == -1:
    sys.exit(1)
fm = content[3:end]
m = re.search(r'^type:[ \t]*([^\n]*)$', fm, re.MULTILINE)
if not m:
    print('MISSING')
elif not m.group(1).strip():
    print('EMPTY')
else:
    print('OK:' + m.group(1).strip())
PYEOF
  )

  case "$type_check" in
    MISSING)
      _emit "ERROR" "RULE-002" "$filepath" "frontmatter missing required 'type' field"
      return ;;
    EMPTY)
      _emit "ERROR" "RULE-003" "$filepath" "frontmatter 'type' field is empty"
      return ;;
  esac

  # ── RULE-010/011/012: inbox rules (type: Raw Input) ───────────────────────
  if $is_input_file; then
    local status_val
    status_val=$(py -3 - "$filepath" <<'PYEOF' 2>/dev/null
import sys, re
content = open(sys.argv[1], encoding='utf-8').read()
if not content.startswith('---'): sys.exit(1)
end = content.find('\n---', 3)
fm = content[3:end] if end != -1 else content[3:]
m = re.search(r'^status:[ \t]*([^\n]*)$', fm, re.MULTILINE)
if not m: print('MISSING')
else: print(m.group(1).strip() or 'MISSING')
PYEOF
    )
    if [[ "$status_val" == "MISSING" ]]; then
      _emit "ERROR" "RULE-010" "$filepath" "Raw Input missing required 'status' field"
    elif [[ "$status_val" != "pending" && "$status_val" != "processed" && "$status_val" != "failed" ]]; then
      _emit "ERROR" "RULE-011" "$filepath" "'status' must be pending|processed|failed, got: $status_val"
    fi
    # RULE-012: spawned paths must resolve
    local spawned_check
    spawned_check=$(py -3 - "$filepath" "$bundle_root" <<'PYEOF' 2>/dev/null
import sys, re, os
filepath, bundle_root = sys.argv[1], sys.argv[2]
content = open(filepath, encoding='utf-8').read()
if not content.startswith('---'): sys.exit(0)
end = content.find('\n---', 3)
fm = content[3:end] if end != -1 else content[3:]
in_spawned = False
for line in fm.splitlines():
    if re.match(r'^spawned:', line): in_spawned = True; continue
    if in_spawned:
        m2 = re.match(r'^\s+-\s+(.*)', line)
        if m2:
            link = m2.group(1).strip()
            if link.startswith('/'):
                check = os.path.join(bundle_root, link.lstrip('/'))
                if not os.path.isfile(check): print(link)
        elif line and not line.startswith(' '): in_spawned = False
PYEOF
    )
    if [[ -n "$spawned_check" ]]; then
      while IFS= read -r broken; do
        [[ -n "$broken" ]] && _emit "WARNING" "RULE-012" "$filepath" "spawned path does not resolve: $broken"
      done <<< "$spawned_check"
    fi
  fi

  # RULE-007: internal markdown links must resolve (delegated to python)
  local broken_links
  broken_links=$(py -3 - "$filepath" "$bundle_root" <<'PYEOF' 2>/dev/null
import sys, re, os
filepath, bundle_root = sys.argv[1], sys.argv[2]
content = open(filepath, encoding='utf-8').read()
for m in re.finditer(r'\[([^\]]+)\]\((/[^)]+\.md)\)', content):
    link = m.group(2)
    target = os.path.join(bundle_root, link.lstrip('/'))
    if not os.path.isfile(target):
        print(link)
PYEOF
  )
  if [[ -n "$broken_links" ]]; then
    while IFS= read -r link; do
      [[ -n "$link" ]] && _emit "WARNING" "RULE-007" "$filepath" "broken internal link: $link"
    done <<< "$broken_links"
  fi
}

_validate_path() {
  local target="$1"
  local bundle_root

  if [[ -f "$target" ]]; then
    bundle_root="$(dirname "$target")"
    _check_file "$target" "$bundle_root"
  elif [[ -d "$target" ]]; then
    bundle_root="$target"
    while IFS= read -r -d '' f; do
      _check_file "$f" "$bundle_root"
    done < <(find "$target" -name "*.md" -type f -print0 | sort -z)
  else
    echo "validate.sh: path not found: $target" >&2
    exit 2
  fi
}

# Main
_validate_path "${1:-.}"

# Sort and print findings deterministically
IFS=$'\n' sorted=($(printf '%s\n' "${_VALIDATE_FINDINGS[@]}" | sort))
for finding in "${sorted[@]}"; do
  echo "$finding"
done

[[ $_VALIDATE_ERRORS -eq 0 ]]
