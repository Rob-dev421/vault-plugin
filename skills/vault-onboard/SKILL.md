---
name: vault-onboard
description: >
  Explain the vault to a new team member from the actual vault state.
  Use when the user says "onboard", "vault-onboard", "/vault-onboard",
  "how does this vault work", or "I'm new here". Output is generated
  entirely from live vault data — no hardcoded content.
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-onboard:*)"]
---

# vault-onboard

Generates a contextual onboarding guide from the live vault state.

```bash
bash engine/bin/vault-onboard <vault-root>
```

Output includes: vault location, layer names from vault.json, current item
counts, a sample concept from sources, all skill commands, and setup steps
including install-hook. All paths and names are derived at runtime.

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-onboard" ~/vault
```
