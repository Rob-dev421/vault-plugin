#!/bin/bash
# engine/lib/frontmatter.sh
# get_field <filepath> <key>        → prints value to stdout; exit 1 if no frontmatter
# set_field <filepath> <key> <val>  → updates file in-place; preserves body exactly

get_field() {
  local filepath="$1" key="$2"
  py -3 - "$filepath" "$key" <<'PYEOF'
import sys, re

filepath, key = sys.argv[1], sys.argv[2]
content = open(filepath, encoding='utf-8').read()

# Check for frontmatter
if not content.startswith('---'):
    print("no frontmatter", file=sys.stderr)
    sys.exit(1)

end = content.find('\n---', 3)
if end == -1:
    print("no frontmatter", file=sys.stderr)
    sys.exit(1)

fm_block = content[3:end]

# Simple key: value parse (no nested YAML)
for line in fm_block.splitlines():
    m = re.match(r'^' + re.escape(key) + r':\s*(.*)', line)
    if m:
        print(m.group(1).strip())
        sys.exit(0)

# Key not found — return empty string, exit 0
print("")
sys.exit(0)
PYEOF
}

set_field() {
  local filepath="$1" key="$2" value="$3"
  py -3 - "$filepath" "$key" "$value" <<'PYEOF'
import sys, re

filepath, key, value = sys.argv[1], sys.argv[2], sys.argv[3]
content = open(filepath, encoding='utf-8').read()

if not content.startswith('---'):
    print("no frontmatter", file=sys.stderr)
    sys.exit(1)

end = content.find('\n---', 3)
if end == -1:
    print("no frontmatter", file=sys.stderr)
    sys.exit(1)

fm_block = content[3:end]
body = content[end+4:]  # after closing ---\n

# Try to replace existing key
pattern = re.compile(r'^(' + re.escape(key) + r':\s*).*$', re.MULTILINE)
if pattern.search(fm_block):
    new_fm = pattern.sub(rf'{key}: {value}', fm_block)
else:
    new_fm = fm_block.rstrip('\n') + f'\n{key}: {value}'

result = '---' + new_fm + '\n---' + body
open(filepath, 'w', encoding='utf-8').write(result)
PYEOF
}
