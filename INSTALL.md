# Vault Plugin — Installation Guide

Complete setup from a fresh machine to a working vault.

---

## Prerequisites

Install these first, in order. Each step depends on the previous.

### 1. Claude Code

The runtime for all vault skills.

```powershell
# Windows
winget install Anthropic.ClaudeCode
```

Verify: `claude --version` → `2.1.159` or later

### 2. Git

Required by vault-init (git init, pre-commit hook).

```powershell
# Windows
winget install Git.Git
```

Verify: `git --version` → `2.54.0` or later

### 3. Python 3.10+

Used by all bin/ scripts for frontmatter parsing and JSON state management. No external packages needed — stdlib only.

```powershell
# Windows
winget install Python.Python.3.13
```

Verify: `python --version` → `3.10` or later

### 4. bash (Git Bash or WSL)

All vault scripts are bash. On Windows, Git Bash (installed with Git above) is sufficient.

Verify: `bash --version` → `5.x`

### 5. uv (optional — required only for graphify)

Package manager used to install graphify. Skip if you don't want the knowledge graph feature.

```powershell
winget install astral-sh.uv
```

Then open a new terminal. Verify: `uv --version` → `0.11.26` or later

### 6. graphify (optional — knowledge graph)

Semantic knowledge graph over vault sources and wiki. Soft dependency — vault works fully without it.

```bash
uv tool install graphifyy
```

Verify: `graphify --version` → `0.9.5` or later

---

## Install the vault plugin

```
/plugin install vault@github.com/mateffy/vault-plugin
```

This installs all 21 bundled skills including the full ponytail suite, grillme, and karpathy-guidelines.

---

## Initialize your vault

```
/vault-init
```

Creates `~/vault` with full OKF structure, initializes git, and installs the pre-commit validation hook. Takes ~5 seconds.

---

## First-time graphify setup (optional)

If graphify is installed, run a full semantic build once:

```
/vault-graphify --full
```

This builds the knowledge graph using Claude Code as the LLM backend (no separate API key needed) and installs always-on graph query instructions into `~/vault/CLAUDE.md`.

---

## Verify installation

```
/vault-status
/vault-validate ~/vault
```

Both should report clean. `vault-validate` checks OKF conformance including `DEPENDENCIES.md` presence (RULE-030).

---

## Initialize DEPENDENCIES.md

If the vault was created before v1.3.0, `DEPENDENCIES.md` won't exist yet. Create it:

```
/vault-deps
```

Then add your installed dependencies:

```bash
bash engine/bin/vault-deps ~/vault add vault https://github.com/mateffy/vault-plugin v1.3.5 --type skill
bash engine/bin/vault-deps ~/vault add okf https://github.com/GoogleCloudPlatform/knowledge-catalog "v0.1 ee67a5c" --type spec
bash engine/bin/vault-deps ~/vault add graphify https://github.com/safishamsi/graphify v0.9.5 --type tool
bash engine/bin/vault-deps ~/vault add ponytail https://github.com/DietrichGebert/ponytail v4.8.4 --type skill
bash engine/bin/vault-deps ~/vault add grillme https://github.com/Jekudy/grillme-skill f9df31c --type skill
bash engine/bin/vault-deps ~/vault add karpathy-guidelines https://github.com/Jing-Fu/karpathy-guidelines-skill 1b69b2e --type skill
bash engine/bin/vault-deps ~/vault add uv https://github.com/astral-sh/uv v0.11.26 --type tool
bash engine/bin/vault-deps ~/vault add claude-code https://github.com/anthropics/claude-code v2.1.159 --type tool
bash engine/bin/vault-deps ~/vault add bash https://github.com/bminor/bash 5.3.9 --type tool
bash engine/bin/vault-deps ~/vault add git https://github.com/git/git 2.54.0 --type tool
bash engine/bin/vault-deps ~/vault add python https://github.com/python/cpython 3.13.14 --type tool
```

---

## Quick start after setup

```
/vault-ingest ~/Documents/some-doc.pdf   ← add your first document
/vault-status                             ← health check
/vault-onboard                            ← full orientation
```

---

## Updating

Re-install the plugin to get the latest version:

```
/plugin install vault@github.com/mateffy/vault-plugin
```

Your vault data (`~/vault/inbox`, `sources`, `wiki`) is never touched by plugin updates.

To update graphify:

```bash
uv tool upgrade graphifyy
graphify --version
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-deps" ~/vault update graphify <new-version>
```

---

## Dependency install order summary

| Order | Dependency | Required | Why |
|-------|-----------|----------|-----|
| 1 | claude-code | ✅ | Runtime for all skills |
| 2 | git | ✅ | vault-init, pre-commit hook |
| 3 | python 3.10+ | ✅ | All bin/ scripts |
| 4 | bash | ✅ | All bin/ scripts |
| 5 | uv | optional | Only if using graphify |
| 6 | graphify | optional | Knowledge graph feature |
| 7 | vault plugin | ✅ | The vault itself |
