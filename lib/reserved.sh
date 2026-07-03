#!/bin/bash
# engine/lib/reserved.sh
# Shared list of reserved OKF filenames — sourced by validate.sh and index.sh

VAULT_RESERVED_FILENAMES=("index.md" "log.md" "transcript.md")

is_reserved_filename() {
  local name="$1"
  for r in "${VAULT_RESERVED_FILENAMES[@]}"; do
    [[ "$name" == "$r" ]] && return 0
  done
  return 1
}
