# Vault Plugin for Claude Code

An OKF knowledge vault that turns raw inputs (PDFs, docs, images, notes) into a structured, searchable, agent-readable knowledge base — all managed by Claude.

```
inbox/    ← drop raw files here
sources/  ← Claude extracts OKF concept files
wiki/     ← Claude synthesizes curated knowledge
```

## Install

```
/plugin install vault@github.com/mateffy/vault-plugin
```

See [INSTALL.md](INSTALL.md) for the full setup guide including prerequisite install order.

## Quick start

After installing, run:

```
/vault-init
```

This creates `~/vault` with all layers, initializes git, and installs the pre-commit validation hook.

Then:

```
/vault-ingest ~/Documents/some-doc.pdf
/vault-status
/vault-onboard
```

## Skills

| Command | What it does |
|---|---|
| `/vault-init` | Create your vault (run once) |
| `/vault-ingest <file>` | Add a raw file to inbox |
| `/vault-process` | Claude transcribes + extracts concepts |
| `/vault-synthesize` | Claude writes wiki entries from sources |
| `/vault-validate` | OKF conformance check |
| `/vault-audit` | Find stale/orphaned/low-quality items |
| `/vault-status` | Quick health summary |
| `/vault-freshness` | Detect drifted source concepts |
| `/vault-review` | Pre-commit contribution gate |
| `/vault-index` | Regenerate navigation indexes |
| `/vault-onboard` | Full orientation for new users |

## Requirements

- Claude Code
- bash (Git Bash or WSL on Windows)
- Python 3
- git

## How it works

Built on the [Open Knowledge Format (OKF) v0.1](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) — Markdown files with YAML frontmatter, designed to be readable by humans and agents.

The vault engine (shell + Python 3 stdlib, no external dependencies) handles all file operations. Claude handles transcription, concept extraction, and wiki synthesis using the `open-knowledge-format` skill.

## Updating

When a new version is released, re-install the plugin. Your vault data (`~/vault/inbox`, `sources`, `wiki`) is never touched by plugin updates.
