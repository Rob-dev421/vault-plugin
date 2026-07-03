---
name: vault-process
description: >
  Process a pending inbox item: transcribe the raw file and extract OKF concept
  files into sources/. Use when the user says "process inbox", "vault-process",
  "/vault-process", or when vault-ingest has just created a new pending item.
  Runs immediately after vault-ingest by default.
user-invocable: true
argument-hint: "<inbox-item-path>"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-process-finalize:*)"]
---

# vault-process

Claude-driven skill that transcribes raw inputs and extracts OKF concepts.

## What it does

For a given `inbox/<date-slug>/` item with `status: pending`:

1. Read `input.md` to find the raw file path (`resource:` field)
2. Read the raw file using the Read tool (handles PDF, image, doc, text natively)
3. Write `sources/<slug>/transcript.md` with frontmatter:
   ```yaml
   source_file: /inbox/<date-slug>/input.md
   source_type: pdf | doc | image | text
   transcription_method: claude
   timestamp: <ISO 8601>
   ```
   For images: body contains a structured JSON block describing the image schema/content
4. Author each extracted concept file at `sources/<slug>/<concept>.md`:

   **Frontmatter:**
   - Required: `type`, `title`, `description`, `derived_from`
   - Recommended: `tags`, `timestamp`, `confidence: low | medium | high`

   **Body sections:** `# Overview`, `# Schema` (if applicable), `# Examples`, `# Citations`

   Use bundle-relative cross-links to related concepts (`/sources/slug/other.md`).

### OKF body encoding for graphify

Apply these rules when authoring each concept file body (graphify reads body links, not frontmatter):

**T02-1 — Provenance link:** Insert this line immediately after the `# Overview` heading, using the `derived_from` frontmatter value:
```
Extracted from [source document](/inbox/<date-slug>/input.md).
```

**T02-2 — Confidence callout:** Place directly below the provenance line:
- `confidence: low` → `> Confidence: low — speculative, needs human review.`
- `confidence: medium` → `> Confidence: medium — inferred from context.`
- `confidence: high` → omit (no callout)

**T02-3 — Topics section:** If `tags:` is set, append before `# Citations` (or at end of body if no Citations section):
```markdown
## Topics
tag1, tag2, tag3
```
Tags are the `tags:` frontmatter values joined with `, `.

5. Call `bin/vault-process-finalize` as the final step:
   ```bash
   bash engine/bin/vault-process-finalize \
     <inbox-item-path> \
     <sources-slug-path> \
     <concept1.md> <concept2.md> ...
   ```

## Confidence field

Add `confidence: low | medium | high` to each extracted concept based on how
clearly the source material supports the extraction:
- `high` — directly stated, unambiguous
- `medium` — inferred from context, likely correct
- `low` — speculative, needs human review

vault-audit flags `confidence: low` items for review.

## Reprocessing

If a previous run left `status: failed`, re-run vault-process on the same item.
vault-process-finalize will overwrite partial output UNLESS a concept file has
been manually edited since the last run — those are preserved.

## Queue behaviour

If multiple items are `status: pending`, process them in timestamp order
(oldest `inbox/` dir first). vault-status shows the pending count.

## Shell invocation (finalize step)

After Claude writes transcript.md and concept files, call:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-process-finalize" \
  <inbox-item-path> <sources-slug-path> <concept-files...>
```
