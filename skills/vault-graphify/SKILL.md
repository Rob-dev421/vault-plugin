---
name: vault-graphify
description: >
  Build or update the graphify knowledge graph for the vault. Use when the
  user says "update graph", "build graph", "vault-graphify", "/vault-graphify",
  "regenerate knowledge graph", or after vault-synthesize adds new wiki entries.
  Requires graphify to be installed (uv tool install graphifyy). Soft dependency
  — vault works without it.
user-invocable: true
argument-hint: "[--full]"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-graphify:*)"]
---

# vault-graphify

Builds or incrementally updates the graphify knowledge graph over the vault's
`sources/` and `wiki/` layers.

## Shell usage

```bash
# Incremental update (AST-only, no API cost — run after any vault-synthesize)
bash engine/bin/vault-graphify <vault-root>

# Full rebuild (semantic extraction, uses LLM API — run when graph is stale)
bash engine/bin/vault-graphify <vault-root> --full
```

## What it produces

```
graphify-out/
├── graph.html       interactive browser view — click nodes, filter, search
├── GRAPH_REPORT.md  god nodes, communities, surprising connections, knowledge gaps
└── graph.json       full queryable graph (no re-read needed)
```

## OKF node semantics

| Layer | Node meaning | Key frontmatter |
|-------|-------------|-----------------|
| `sources/` | Extracted facts from inbox items | `confidence: low\|medium\|high` |
| `wiki/` | Synthesized, curated knowledge | Higher authority than sources |

## OKF edge semantics

| Edge type | Meaning |
|-----------|---------|
| `derived_from` | Concept → its inbox source document |
| `synthesized_from` | Wiki entry → source concepts it synthesized from |
| `references` | In-body cross-link between concepts |

## Querying the graph

```bash
graphify query "<topic>"               # find relevant concept nodes
graphify path "wiki/X" "sources/Y"    # trace provenance chain
graphify explain "<concept>"           # focused subgraph
```

Or read `graphify-out/GRAPH_REPORT.md` for a full vault-wide overview.

## God nodes

God nodes in this vault are knowledge hubs — concepts referenced by many others
or source documents that produced many extracted concepts. GRAPH_REPORT.md
surfaces them. They indicate the vault's most load-bearing knowledge.

## First run

On first run (no `graphify-out/` exists), vault-graphify automatically:
1. Runs a full semantic build
2. Installs always-on Claude instructions (`graphify claude install`)
3. Appends OKF-aware query guidance to `CLAUDE.md`

## Modes

| Mode | Cost | When to use |
|------|------|-------------|
| Incremental (default) | Free — AST only | After every vault-synthesize or vault-process |
| Full (`--full`) | LLM API call | First run, or when semantic graph is stale |

## When vault-graphify runs automatically

- After `vault-process-finalize` (incremental — new source concepts extracted)
- After `vault-synthesize-finalize` (incremental — new wiki entries written)

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-graphify" ~/vault
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-graphify" ~/vault --full
```
