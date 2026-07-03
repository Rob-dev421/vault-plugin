---
name: vault-audit
description: >
  Operational health sweep — find rot before it accumulates. Use when the user
  says "audit vault", "vault-audit", "/vault-audit", or "what needs attention".
  Checks: stale pending items, low-confidence extractions, orphaned sources,
  unsourced wiki entries, broken spawned links.
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-audit:*)"]
---

# vault-audit

Deep health sweep. Reports issues by category.

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-audit" <vault-root>
```

## Checks

| Check | Trigger |
|---|---|
| Stale pending | `status: pending` item older than `stale_inbox_days` from vault.json |
| Low confidence | Source concept has `confidence: low` |
| Orphaned source | Source concept not referenced from any wiki entry |
| Unsourced wiki | Wiki entry with no source link |
| Broken spawned | `spawned:` path in input.md doesn't resolve |

Writes `last_audit` timestamp to `.vault-state.json`.

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-audit" ~/vault
```
