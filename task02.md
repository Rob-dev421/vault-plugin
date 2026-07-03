# Task 02 — Boost Graphify with OKF Structure

**Goal:** Make graphify's semantic extraction understand OKF vault structure by
encoding OKF metadata (provenance, confidence, tags) into file bodies where
graphify can read them. Also guard against graphify flags that conflict with
vault structure.

**Status:** `done`

---

## Changes

| # | File | What | Status |
|---|------|------|--------|
| T02-1 | `skills/vault-process/SKILL.md` | Add body `derived_from` link instruction | ✅ done |
| T02-2 | `skills/vault-process/SKILL.md` | Add body confidence note instruction | ✅ done |
| T02-3 | `skills/vault-process/SKILL.md` | Add `## Topics` section with tags instruction | ✅ done |
| T02-4 | `bin/vault-graphify` | Guard against `--wiki` and `--obsidian` flags | ✅ done |
| T02-5 | vault root | Write `.graphifyignore` to existing vault | ✅ done |
| T02-6 | `CHANGELOG.md` + `plugin.json` | Version bump to v1.1.2 | ✅ done |

---

## Tests

Each test is a concrete, verifiable assertion. Run after implementation.

### T02-1 — derived_from body link

**Test:** Create a concept file via vault-process instructions. Verify it
contains a markdown link pointing to its inbox source.

```
GIVEN a concept extracted from inbox/2026-07-03-test/input.md
WHEN vault-process writes sources/test/concept.md
THEN the body contains a line matching:
     Extracted from [.*]\(/inbox/2026-07-03-test/input\.md\)
```

**Verify:** `grep -r "Extracted from \[" sources/` returns at least one match
on a real concept file.

**Why:** `derived_from` frontmatter is invisible to graphify. This body link
makes the provenance chain appear as a graph edge, enabling
`graphify path "wiki/X" "inbox/Y"`.

---

### T02-2 — Confidence body note

**Test:** Create a concept with `confidence: low`. Verify body contains
the confidence callout.

```
GIVEN a concept file with frontmatter confidence: low
WHEN vault-process writes the file
THEN the body contains:
     > Confidence: low —
```

```
GIVEN a concept file with frontmatter confidence: medium
WHEN vault-process writes the file
THEN the body contains:
     > Confidence: medium —
```

```
GIVEN a concept file with frontmatter confidence: high
WHEN vault-process writes the file
THEN the body does NOT contain a confidence callout
     (high confidence is the default, no noise needed)
```

**Verify:** Inspect a real extracted concept file body.

**Why:** Graphify's GRAPH_REPORT surfaces nodes by label. Without this,
low-confidence speculative extractions look identical to high-confidence facts.

---

### T02-3 — Topics section

**Test:** Create a concept with `tags: [api, auth, core]`. Verify body
contains a Topics section.

```
GIVEN a concept file with tags: [api, auth, core]
WHEN vault-process writes the file
THEN the body contains a section:
     ## Topics
     api, auth, core
```

**Verify:** `grep -A2 "## Topics" sources/` returns tag content.

**Why:** Tags in frontmatter are invisible to graphify's semantic pass.
Body `## Topics` sections make tags visible as node attributes and create
`conceptually_related_to` edges between concepts sharing the same topics,
biasing community detection toward OKF's taxonomy.

---

### T02-4 — vault-graphify flag guards

**Test:** Verify `bin/vault-graphify` does not pass `--wiki` or `--obsidian`
to graphify in any code path.

```
GIVEN bin/vault-graphify source
WHEN grepped for "--wiki" and "--obsidian"
THEN neither string appears as a passed argument
AND a comment explains why they are off-limits
```

**Verify:**
```bash
grep -n "\-\-wiki\|\-\-obsidian" bin/vault-graphify
# Expected: only comment lines (# ...), never in graphify . or graphify update .
```

**Why:** `--wiki` generates a competing markdown wiki inside graphify-out/wiki/,
conflicting with OKF's wiki/ layer. `--obsidian` writes files directly into
the vault directory, bypassing OKF structure entirely.

---

### T02-5 — .graphifyignore in existing vault

**Test:** Verify `.graphifyignore` exists at vault root and contains correct patterns.

```
GIVEN C:\Users\C5414552\Desktop\vault\.graphifyignore
WHEN read
THEN contains all of:
     inbox/
     graphify-out/
     **/index.md
     **/log.md
     **/transcript.md
```

**Verify:**
```bash
cat ~/Desktop/vault/.graphifyignore
```

**Why:** This vault predates v1.1.0. Without `.graphifyignore`, graphify
processes reserved files (index.md, log.md, transcript.md) and inbox raw
inputs, creating spurious nodes that pollute god-node detection.

---

### T02-6 — Version and changelog

**Test:** Verify version is bumped and changelog entry exists.

```
GIVEN .claude-plugin/plugin.json
WHEN read
THEN "version" == "1.1.2"

GIVEN CHANGELOG.md
WHEN read
THEN contains heading "## v1.1.2"
AND lists all T02-1 through T02-5 changes
```

**Verify:** `grep "v1.1.2" CHANGELOG.md .claude-plugin/plugin.json`

---

## Definition of done

- [ ] All 6 test assertions pass
- [ ] `plugin.json` at `1.1.2`
- [ ] `CHANGELOG.md` entry written
- [ ] No regressions: existing vault-process skill instructions still work
      for concept files without tags or confidence fields
