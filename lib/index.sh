#!/bin/bash
# engine/lib/index.sh
# index_for_dir <dir> <is_root> → prints index.md content to stdout
# Skips reserved filenames. Alphabetical sort. Pure function — no file I/O.

SCRIPT_DIR_INDEX="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR_INDEX/reserved.sh"

index_for_dir() {
  local dir="$1" is_root="${2:-false}"

  # Header
  if [[ "$is_root" == "true" ]]; then
    printf -- '---\nokf_version: "0.1"\n---\n\n'
  fi

  local dir_name
  dir_name=$(basename "$dir")
  printf '# %s\n\n' "$(echo "$dir_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')"

  # Collect non-reserved .md files, sort alphabetically
  local entries=()
  while IFS= read -r -d '' f; do
    local fname
    fname=$(basename "$f")
    is_reserved_filename "$fname" && continue
    entries+=("$f")
  done < <(find "$dir" -maxdepth 1 -name "*.md" -type f -print0 | sort -z)

  if [[ ${#entries[@]} -eq 0 ]]; then
    printf '_No concepts yet._\n'
    return
  fi

  # Extract title and description from each concept
  for f in "${entries[@]}"; do
    local fname title desc rel_path
    fname=$(basename "$f")
    rel_path="./${fname}"

    # Parse frontmatter for title and description
    local meta
    meta=$(py -3 - "$f" <<'PYEOF'
import sys, re
content = open(sys.argv[1], encoding='utf-8').read()
title = desc = ''
if content.startswith('---'):
    end = content.find('\n---', 3)
    fm = content[3:end] if end != -1 else content[3:]
    m = re.search(r'^title:[ \t]*([^\n]+)$', fm, re.MULTILINE)
    if m: title = m.group(1).strip()
    m = re.search(r'^description:[ \t]*([^\n]+)$', fm, re.MULTILINE)
    if m: desc = m.group(1).strip()
print(f'{title}|||{desc}')
PYEOF
    )
    title_clean="${meta%%|||*}"
    desc_clean="${meta##*|||}"
    title_clean=$(echo "$title_clean" | xargs)
    desc_clean=$(echo "$desc_clean" | xargs)

    [[ -z "$title_clean" ]] && title_clean="${fname%.md}"

    if [[ -n "$desc_clean" ]]; then
      printf -- '- [%s](%s) — %s\n' "$title_clean" "$rel_path" "$desc_clean"
    else
      printf -- '- [%s](%s)\n' "$title_clean" "$rel_path"
    fi
  done
}
