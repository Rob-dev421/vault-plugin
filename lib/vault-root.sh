#!/bin/bash
# engine/lib/vault-root.sh
# Find the vault root by walking up from cwd looking for a .vault marker.
# Usage (sourced):  source vault-root.sh   → exports VAULT_ROOT, VAULT_INBOX, etc.
# Usage (direct):   bash vault-root.sh     → prints VAULT_ROOT path or env dump

_vault_find_root() {
  local dir
  dir="$(pwd)"
  while true; do
    if [[ -f "$dir/.vault" ]]; then
      echo "$dir"
      return 0
    fi
    local parent
    parent="$(dirname "$dir")"
    if [[ "$parent" == "$dir" ]]; then
      echo "not inside a vault" >&2
      return 1
    fi
    dir="$parent"
  done
}

_vault_load_config() {
  local root="$1"
  local cfg="$root/vault.json"
  if [[ ! -f "$cfg" ]]; then
    echo "vault.json not found at $root" >&2
    return 1
  fi
  py -3 - "$cfg" <<'PYEOF'
import json, sys, os
cfg = json.load(open(sys.argv[1]))
root = os.path.dirname(os.path.abspath(sys.argv[1]))
layers = cfg.get("layers", {})
print(f"VAULT_ROOT={root}")
print(f"VAULT_INBOX={root}/{layers.get('inbox','inbox')}")
print(f"VAULT_SOURCES={root}/{layers.get('sources','sources')}")
print(f"VAULT_WIKI={root}/{layers.get('wiki','wiki')}")
print(f"VAULT_ENGINE={root}/{cfg.get('engine','engine')}")
print(f"VAULT_STALE_INBOX_DAYS={cfg.get('stale_inbox_days',7)}")
PYEOF
}

_vault_root="$(_vault_find_root)" || exit 1
_vault_env="$(_vault_load_config "$_vault_root")" || exit 1

# When run directly: print root path (default) or full env dump (VAULT_ROOT_ENV=1)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [[ "${VAULT_ROOT_ENV:-}" == "1" ]]; then
    echo "$_vault_env"
  else
    echo "$_vault_root"
  fi
  exit 0
fi

# When sourced: export all vars
while IFS='=' read -r key val; do
  export "$key=$val"
done <<< "$_vault_env"
