---
name: vault-init
description: >
  Initialize a new personal vault at ~/vault. Use when the user says
  "vault-init", "/vault-init", "set up my vault", "create vault",
  "initialize vault", "get started with vault", or has just installed
  the vault plugin. Run this FIRST before any other vault command.
  Creates the full OKF vault structure, initializes git, and installs
  the pre-commit validation hook. Safe to run if vault already exists.
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-init:*)"]
---

# vault-init

Initializes your personal vault at `~/vault` in one step.

## What it creates

```
~/vault/
├── .vault              ← vault root marker
├── vault.json          ← config: layers, engine path, stale thresholds
├── .gitignore          ← excludes binaries and state files
├── index.md            ← OKF bundle root
├── log.md
├── inbox/              ← raw inputs land here
├── sources/            ← Claude extracts concepts here
└── wiki/               ← Claude synthesizes wiki entries here
    ├── concepts/
    └── projects/
```

Git is initialized and the pre-commit validation hook is installed automatically.

## Instructions

Run the init script:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-init" "${CLAUDE_PLUGIN_ROOT}"
```

After it completes, tell the user:
- Their vault is ready at `~/vault`
- Next step: `/vault-ingest <file>` to add their first document
- Or `/vault-onboard` for a full walkthrough
- If they already had a vault, tell them it was not modified and to run `/vault-status`
