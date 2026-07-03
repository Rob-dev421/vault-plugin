---
name: vault-validate
description: >
  Validate an OKF vault or file for conformance with OKF v0.1. Use when the
  user says "validate the vault", "check vault conformance", "run vault-validate",
  or "/vault-validate". Shell gate for CI/pre-commit (bin/vault-validate).
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-validate:*)"]
---

# vault-validate

Validates OKF v0.1 conformance for a vault or individual file.

## Shell gate usage

```bash
# Validate entire vault
bash engine/bin/vault-validate /path/to/vault

# Validate a single file
bash engine/bin/vault-validate sources/slug/concept.md
```

## Report format

```
# OKF Validation Report

## Summary
- Errors: N
- Warnings: M

## Errors
- ERROR [RULE-XXX] filepath: message

## Warnings
- WARNING [RULE-XXX] filepath: message

## Recommendations
...
```

## Rules enforced

| Rule | Severity | Description |
|---|---|---|
| RULE-001 | ERROR | Non-reserved .md file missing YAML frontmatter |
| RULE-002 | ERROR | Frontmatter missing `type` field |
| RULE-003 | ERROR | `type` field is empty string |
| RULE-004 | ERROR | Non-root `index.md` contains frontmatter |
| RULE-005 | WARNING | Bundle-root `index.md` missing `okf_version` |
| RULE-006 | WARNING | `log.md` date heading not ISO 8601 YYYY-MM-DD |
| RULE-007 | WARNING | Internal markdown link target does not exist |
| RULE-010 | ERROR | `input.md` missing `status` field |
| RULE-011 | ERROR | `input.md` `status` not in [pending, processed, failed] |
| RULE-012 | WARNING | `spawned:` path does not resolve in bundle |
| RULE-013 | WARNING | `transcript.md` has `type` field (reserved file) |
| RULE-020 | ERROR | `transcript.md` missing required `source_file` field |
| RULE-021 | ERROR | `transcript.md` missing required `source_type` field |
| RULE-030 | ERROR | vault root missing `DEPENDENCIES.md` |
| RULE-030 | WARNING | `DEPENDENCIES.md` exists but has no entries |

## When to run

- Before every commit (via pre-commit hook — installed by `/vault-init`)
- After running `vault-process` or `vault-synthesize`
- As part of `vault-review` contribution gate

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-validate" ~/vault
```
