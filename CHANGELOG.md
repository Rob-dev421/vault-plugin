# Changelog

## v1.3.4 — 2026-07-03

Add installation guide with ordered dependency setup.

### Added

- `INSTALL.md` — full installation guide: prerequisites in correct order
  (claude-code → git → python → bash → uv → graphify → vault plugin),
  vault-init steps, first-time graphify setup, DEPENDENCIES.md bootstrap,
  update procedure, and dependency order summary table

### Changed

- `after-install.md` — updated to point to INSTALL.md for first-time setup
- `README.md` — added INSTALL.md link after plugin install command

---

## v1.3.3 — 2026-07-03

Ponytail review pass on v1.3.2 diff — 3 more findings.

### Removed

- `LAYER_FILTER` var + `--layer` arg parsing in `bin/vault-validate` — stub body was `:` with dead comment
- `--layer` docs from `skills/vault-validate/SKILL.md`
- `/open-knowledge-format` references from vault-validate recommendations (skill removed in v1.2.3)
- "Two modes" section from `skills/vault-validate/SKILL.md` (second mode no longer exists)

### Changed

- `bin/vault-validate` — collapsed duplicate `.vault-state.json` write heredocs into one (pattern from vault-audit)

---

## v1.3.2 — 2026-07-03

Ponytail audit cleanup — 10 findings, -110 lines.

### Removed

- `lib/vault-root.sh` — zero callers; all bin scripts take `VAULT_ROOT` as `$1`
- `_is_reserved()` in `lib/validate.sh` — duplicate of `is_reserved_filename()` in `reserved.sh`
- `skipped=()` array in `bin/vault-process-finalize` — declared, never read
- `warnings=()` array in `bin/vault-review` — declared, never read
- `CHECK_RESOURCES` flag in `bin/vault-freshness` — parsed, never referenced
- `--check-resources` documentation from `skills/vault-freshness/SKILL.md`
- `--layer` filter stub in `bin/vault-validate` — wired in but body was only `:`
- Windows platform notice in `bin/vault-init` — printed "Proceeding...", no side effects
- `_today()` wrapper in `bin/vault-deps` — inlined `date -u +"%Y-%m-%d"` at call sites

### Changed

- `bin/vault-status` — collapsed 4 separate `py -3 -c` subprocess spawns into one Python call

---

## v1.3.1 — 2026-07-03

Add missing ponytail-gain skill.

### Added

- `skills/ponytail-gain/` — ponytail impact scoreboard (upstream: [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail), v4.8.4); was accidentally omitted from the v1.2.0 ponytail bundle

---

## v1.3.0 — 2026-07-03

Add vault-deps skill and DEPENDENCIES.md tracking.

### Added

- `bin/vault-deps` — shell script with `add`, `update`, `check` commands; manages `DEPENDENCIES.md`
- `skills/vault-deps/SKILL.md` — user-invocable skill; Claude appends automatically when a new
  dependency is installed; tracks name, type, version, GH URL, install date
- `vault/DEPENDENCIES.md` — created in vault root with current dependency state (vault v1.2.3,
  OKF spec v0.1, graphify v0.9.5, ponytail v4.8.4, grillme f9df31c, karpathy-guidelines 1b69b2e)

### Changed

- `lib/validate.sh` — added RULE-030: ERROR if `DEPENDENCIES.md` is missing from vault root;
  WARNING if it exists but has no entries
- `skills/vault-validate/SKILL.md` — documented RULE-030 in rules table

---

## v1.2.3 — 2026-07-03

Remove open-knowledge-format external skill; inline OKF authoring rules directly.

### Changed

- `skills/vault-process/SKILL.md` — removed `open-knowledge-format` skill call; OKF concept authoring rules now inline
- `skills/vault-synthesize/SKILL.md` — removed `open-knowledge-format` skill call; wiki entry authoring rules now inline

### Removed

- `skills/open-knowledge-format/` — no longer needed; vault pipeline skills own OKF authoring directly

---

## v1.2.2 — 2026-07-03

Move open-knowledge-format skill into vault-plugin bundle.

### Changed

- `skills/open-knowledge-format/` — moved from `~/.claude/skills/` into plugin bundle;
  no longer requires separate global install; sourced from
  [GoogleCloudPlatform/knowledge-catalog](https://github.com/GoogleCloudPlatform/knowledge-catalog),
  pinned at commit **d44368c** (2026-06-21)

---

## v1.2.1 — 2026-07-03

Bundle grillme and karpathy-guidelines skills into vault-plugin.

### Added

- `skills/grillme/` — Socratic interview skill (upstream: [Jekudy/grillme-skill](https://github.com/Jekudy/grillme-skill), pinned at **f9df31c** 2026-03-16)
- `skills/karpathy-guidelines/` — Karpathy LLM coding guidelines (upstream: [Jing-Fu/karpathy-guidelines-skill](https://github.com/Jing-Fu/karpathy-guidelines-skill), pinned at **1b69b2e** 2026-05-20)

---

## v1.2.0 — 2026-07-03

Bundle ponytail skills into vault-plugin.

### Added

- `skills/ponytail/` — lazy senior dev coding mode (upstream: [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail), pinned at **v4.8.4**)
- `skills/ponytail-review/` — over-engineering review (same upstream, v4.8.4)
- `skills/ponytail-audit/` — whole-repo bloat audit (same upstream, v4.8.4)
- `skills/ponytail-debt/` — deferred shortcut ledger (same upstream, v4.8.4)
- `skills/ponytail-help/` — reference card (same upstream, v4.8.4)

### Notes

- ponytail is already active via CLAUDE.md for plugin development sessions
- These skills are now bundled so vault plugin contributors get the full ponytail
  workflow without a separate install
- To update ponytail skills: re-copy from a fresh `ponytail` plugin install and bump
  the version entry here

---

## v1.1.3 — 2026-07-03

Use Claude Code as graphify backend — no API key required.

### Changed

- `bin/vault-graphify` — full rebuild now uses `graphify . --backend claude-cli` instead of
  bare `graphify .`, so semantic extraction works via Claude Code with no separate API key

---

## v1.1.2 — 2026-07-03

Boost graphify with OKF structure (task02).

### Changed

- `skills/vault-process/SKILL.md` — new `### OKF body encoding for graphify` subsection:
  - T02-1: concept files now include a body provenance link (`Extracted from [source document](...)`)
    using the `derived_from` frontmatter value, making the inbox→sources edge visible to graphify
  - T02-2: `confidence: low` and `confidence: medium` concepts include a blockquote callout;
    `confidence: high` is silent (default, no noise)
  - T02-3: concepts with `tags:` get a `## Topics` section (comma-joined) so tags become
    visible to graphify's semantic pass and bias community detection toward OKF taxonomy
- `bin/vault-graphify` — added comment block guarding against `--wiki` (conflicts with OKF wiki/ layer)
  and `--obsidian` (bypasses OKF structure) flags

### Added

- `vault/.graphifyignore` — written to the existing vault (predates v1.1.0); excludes `inbox/`,
  `graphify-out/`, `**/index.md`, `**/log.md`, `**/transcript.md` from graph extraction
- `vault/.gitignore` — `graphify-out/` appended (was missing from pre-v1.1.0 vault)

---

## v1.1.1 — 2026-07-03

Developer experience hardening.

### Added

- `CLAUDE.md` — project-level instruction requiring version bump and CHANGELOG entry
  on every session that modifies plugin source files; includes done checklist

### Changed

- `skills/vault-review/SKILL.md` — added Scope section clarifying that vault-review
  gates vault content only; plugin source versioning is enforced via CLAUDE.md

---

## v1.1.0 — 2026-07-03

Graphify knowledge graph integration.

### Dependencies

- graphify (upstream: [safishamsi/graphify](https://github.com/safishamsi/graphify), PyPI: `graphifyy`, pinned at **v0.9.5**)
  Install: `uv tool install graphifyy` — soft dependency, vault works without it

### Added

- `vault-graphify` skill and script — builds/updates a graphify knowledge graph over `sources/` and `wiki/`
  - Incremental mode (AST-only, no API cost) runs automatically after `vault-process` and `vault-synthesize`
  - Full mode (`--full`) triggers semantic extraction via LLM API
  - Soft dependency: vault works normally if graphify is not installed
  - First run installs always-on Claude instructions with OKF node/edge semantics
- `.graphifyignore` — written by `vault-init` to exclude `inbox/`, reserved files, and `graphify-out/` from the graph
- `graphify-out/` added to `.gitignore` by `vault-init`

### Changed

- `vault-process-finalize` — calls `vault-graphify` (incremental) after source concepts are extracted
- `vault-synthesize-finalize` — calls `vault-graphify` (incremental) after wiki entries are written
- `vault-validate` — excludes `graphify-out/` from OKF scan (prevents RULE-001 false positives on graph output files)
- `vault-index` — skips `graphify-out/` when regenerating navigation indexes
- `vault-status` — shows `last_graphify` timestamp and mode alongside `last_validate` and `last_audit`
- `vault-audit` — warns when `graphify-out/graph.json` is older than the newest OKF concept file
- `vault-onboard` — lists `vault-graphify` in skills table; shows graphify query commands if graphify is installed

---

## v1.0.0 — 2026-07-03

Initial release.

### Dependencies

- OKF spec (upstream: [GoogleCloudPlatform/knowledge-catalog](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md), pinned at **v0.1 Draft** commit **ee67a5c** 2026-06-12)

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
