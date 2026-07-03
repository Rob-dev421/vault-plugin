---
name: vault-freshness
description: >
  Detect source concepts that have drifted from their origin. Use when the user
  says "check freshness", "vault-freshness", "/vault-freshness", or "are sources
  up to date". Read-only — never modifies any file.
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-freshness:*)"]
---

# vault-freshness

Detects stale source concepts by comparing timestamps. Read-only.

```bash
bash engine/bin/vault-freshness <vault-root>
bash engine/bin/vault-freshness <vault-root> --check-resources
```

Compares each source concept's `timestamp:` frontmatter field against its
`derived_from` inbox item's `timestamp:`. Flags when concept predates inbox.

`--check-resources`: also checks `resource:` URIs for HTTP 404 (off by default — safe for CI).

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-freshness" ~/vault
```
