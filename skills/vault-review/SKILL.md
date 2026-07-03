---
name: vault-review
description: >
  Pre-merge gate for vault contributions. Validates a set of changed files
  before commit. Use when the user says "review contribution", "vault-review",
  or "/vault-review". Runs automatically as a pre-commit git hook.
  Accepts file list from stdin (git diff --name-only output).
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-review:*)"]
---

# vault-review

Pre-commit validation gate. Blocks non-conformant contributions.

## Shell usage

```bash
# Via pre-commit hook (automatic)
git commit  # hook runs vault-review on staged files

# Manually
git diff --cached --name-only | bash engine/bin/vault-review <vault-root>

# On specific files
echo "sources/slug/concept.md" | bash engine/bin/vault-review <vault-root>
```

## Checks

- Source concept without `derived_from` → ERROR (blocks commit)
- Wiki entry without any source link → ERROR (blocks commit)
- Modified concept without today's `log.md` entry → WARNING (allows commit)

## Setup

Install the pre-commit hook once per clone:

```bash
bash engine/bin/install-hook
```

Windows requires Git Bash or WSL for hooks to work.

## Shell invocation

```bash
git diff --cached --name-only | bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-review" ~/vault
```
