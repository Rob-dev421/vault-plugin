---
name: vault-status
description: >
  Show a lightweight vault health summary. Use when the user says "vault status",
  "how is the vault", "/vault-status", or "what's pending". Always exits 0.
  Shows pending/failed counts and last-run timestamps for validate and audit.
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-status:*)"]
---

# vault-status

Lightweight health summary. ≤ 20 lines. Always exits 0.

```bash
bash engine/bin/vault-status <vault-root>
```

Shows: pending count, failed count, processed count, last vault-validate run,
last vault-audit run, and a one-line health verdict.

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-status" ~/vault
```
