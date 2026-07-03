# Changelog

## v1.0.0 — 2026-07-03

Initial release.

### Added

- `vault-init` skill and script — creates `~/vault` with full OKF structure, git, and pre-commit hook in one command
- `vault-ingest` — ingests raw files (PDF, doc, image, text) into inbox
- `vault-process` — Claude-driven transcription and concept extraction into sources/
- `vault-synthesize` — Claude-driven wiki synthesis from source concepts
- `vault-validate` — OKF v0.1 conformance checker (8 rules: RULE-001 through RULE-013)
- `vault-audit` — operational health sweep: stale items, orphaned sources, low-confidence flags
- `vault-status` — lightweight daily summary (≤20 lines, always exits 0)
- `vault-freshness` — detects source concepts that have drifted from their origin
- `vault-review` — pre-merge contribution gate (runs as pre-commit hook)
- `vault-index` — regenerates index.md files deterministically
- `vault-onboard` — generates contextual onboarding from live vault data
- Full engine: `lib/` (frontmatter, slug, log, validate, index, reserved, vault-root)
- OKF wiki concept template
- `after-install.md` directing users to `/vault-init`

### Notes

- Vault data (`~/vault`) is never touched by plugin updates — safe to update at any time
- Engine requires bash (Git Bash or WSL on Windows) and Python 3
- The `engine` path in `~/vault/vault.json` points to the plugin install directory

---

## Versioning convention

- **patch** (x.x.N): bug fixes in scripts or skill descriptions, no behaviour change
- **minor** (x.N.0): new skills, new validation rules, new OKF features
- **major** (N.0.0): breaking changes to vault structure or workflow

## How to update

Re-install the plugin from the GitHub repo. Your vault data (`~/vault`) is never modified.
If a new version changes `vault.json` format, migration notes will appear here.
