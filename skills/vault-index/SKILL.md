---
name: vault-index
description: >
  Regenerate index.md files for the vault or a specific directory. Use when
  the user says "regenerate indexes", "update vault index", "/vault-index",
  or after vault-process or vault-synthesize add new concept files.
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-index:*)"]
---

# vault-index

Regenerates `index.md` files deterministically for navigation.

## Shell usage

```bash
# Regenerate all indexes in vault
bash engine/bin/vault-index <vault-root>

# Regenerate for a specific directory
bash engine/bin/vault-index <vault-root> <directory>
```

## Rules enforced

- Reserved files (`index.md`, `log.md`, `transcript.md`) are never listed
- Non-root `index.md` has no YAML frontmatter (RULE-004 compliant)
- Bundle-root `index.md` has `okf_version: "0.1"` frontmatter
- Entries sorted alphabetically (deterministic for clean git diffs)
- Concepts with no `title` fall back to filename without `.md`

## When to run

- After `vault-process` extracts new concepts into `sources/`
- After `vault-synthesize` writes new wiki entries
- After any manual creation of concept files

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-index" ~/vault
```
