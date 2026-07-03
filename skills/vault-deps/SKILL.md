---
name: vault-deps
description: >
  Track and update the vault dependency list. Use when the user says
  "vault-deps", "/vault-deps", "add dependency", "update dependency",
  "show dependencies", "what's installed", or when a new skill, tool,
  or specification is added to the vault. Automatically appends to
  vault/DEPENDENCIES.md. Also runs as a check via vault-validate.
user-invocable: true
argument-hint: "[add|update|check]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-deps:*)"]
---

# vault-deps

Tracks all skills, tools, and specifications required by this vault in
`DEPENDENCIES.md` at the vault root.

## Shell usage

```bash
# Add a new dependency
bash engine/bin/vault-deps <vault-root> add <name> <gh-url> <version> [--type skill|tool|spec]

# Update an existing dependency's version
bash engine/bin/vault-deps <vault-root> update <name> <version>

# Check DEPENDENCIES.md exists and is non-empty (used by vault-validate)
bash engine/bin/vault-deps <vault-root> check
```

## DEPENDENCIES.md format

```markdown
# Dependencies

| Name | Type | Version | GH URL | Installed |
|------|------|---------|--------|-----------|
| ponytail | skill | v4.8.4 | https://github.com/DietrichGebert/ponytail | 2026-07-03 |
```

## Fields

| Field | Description |
|-------|-------------|
| Name | Bundle name — one entry per bundle even if it ships multiple sub-skills |
| Type | `skill`, `tool`, or `spec` |
| Version | Release tag (e.g. `v4.8.4`) or commit SHA (e.g. `f9df31c`) |
| GH URL | Upstream GitHub URL |
| Installed | ISO date when first added to this vault |

## When Claude updates DEPENDENCIES.md automatically

When a user installs or updates any of:
- A new skill bundled into the vault-plugin
- A new tool dependency (e.g. graphify, uv)
- A new spec or standard the vault implements

Claude calls `bin/vault-deps add` or `bin/vault-deps update` as part of
the install flow — same pattern as `vault-process-finalize` or
`vault-synthesize-finalize` for their respective steps.

## Validation

`vault-validate` enforces RULE-030: DEPENDENCIES.md must exist and have
at least one entry. A missing file is an ERROR; an empty file is a WARNING.

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-deps" ~/vault add ponytail \
  https://github.com/DietrichGebert/ponytail v4.8.4 --type skill

bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-deps" ~/vault update graphify v0.9.6

bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-deps" ~/vault check
```
