---
name: vault-validate
description: >
  Validate an OKF vault or file for conformance with OKF v0.1. Use when the
  user says "validate the vault", "check vault conformance", "run vault-validate",
  or "/vault-validate". Two modes: shell gate for CI/pre-commit (bin/vault-validate),
  and interactive report via /open-knowledge-format for human review.
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-validate:*)"]
---

# vault-validate

Validates OKF v0.1 conformance for a vault or individual file.

## Two modes

| Mode | Command | Use case |
|---|---|---|
| **Shell gate** | `bash engine/bin/vault-validate <path>` | CI, pre-commit hook, scripting — exits 0/1 |
| **Interactive report** | `/open-knowledge-format` → validate | Human review — richer recommendations |

Both modes must agree on errors. The OKF skill may surface additional quality
recommendations beyond what the shell rules encode.

## Shell gate usage

```bash
# Validate entire vault
bash engine/bin/vault-validate /path/to/vault

# Validate a single file
bash engine/bin/vault-validate sources/slug/concept.md

# Validate only inbox layer rules
bash engine/bin/vault-validate /path/to/vault --layer inbox
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

## When to run

- Before every commit (via pre-commit hook — installed by `engine/bin/install-hook`)
- After running `vault-process` or `vault-synthesize`
- As part of `vault-review` contribution gate

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-validate" ~/vault
```
