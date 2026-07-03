#!/bin/bash
# engine/lib/slug.sh
# slug_from <string> → prints URL-safe slug to stdout
# Rules: lowercase, hyphens only, max 60 chars, no trailing hyphen, ASCII only

slug_from() {
  local input="$1"
  if [[ -z "$input" ]]; then
    echo "empty input" >&2
    return 1
  fi

  # Transliterate unicode to ASCII, then normalise
  local result
  result=$(py -3 - "$input" <<'PYEOF'
import sys, unicodedata, re

text = sys.argv[1]
# Normalize unicode: decompose then strip non-ASCII
text = unicodedata.normalize('NFKD', text)
text = text.encode('ascii', 'ignore').decode('ascii')
# Lowercase
text = text.lower()
# Replace non-alphanumeric runs with single hyphen
text = re.sub(r'[^a-z0-9]+', '-', text)
# Strip leading/trailing hyphens
text = text.strip('-')
# Truncate at 60 chars at a word boundary
if len(text) > 60:
    text = text[:60].rsplit('-', 1)[0]
    text = text.strip('-')
print(text)
PYEOF
  )
  echo "$result"
}
