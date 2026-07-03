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
git diff --cached --name-only | bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-review" <vault-root>

# On specific files
echo "sources/slug/concept.md" | bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-review" <vault-root>
```

## Checks

- Source concept without `derived_from` → ERROR (blocks commit)
- Wiki entry without any source link → ERROR (blocks commit)
- Modified concept without today's `log.md` entry → WARNING (allows commit)

## Scope

vault-review gates **vault content** (OKF concept files in sources/ and wiki/).
It does not gate plugin source changes (bin/, lib/, skills/).

Plugin source changes are governed by the plugin repo's CLAUDE.md — which
requires a version bump in `.claude-plugin/plugin.json` and a CHANGELOG.md
entry for every session that modifies bin/, lib/, skills/, or templates/.

## Setup

Install the pre-commit hook once per clone:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/install-hook"
```

Windows requires Git Bash or WSL for hooks to work.

## Shell invocation

```bash
git diff --cached --name-only | bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-review" ~/vault
```
