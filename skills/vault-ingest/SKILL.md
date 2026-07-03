---
name: vault-ingest
description: >
  Ingest a raw file or pasted content into the vault inbox as a tracked item.
  Use when the user says "ingest this file", "add to vault", "vault-ingest",
  "/vault-ingest", or drops a file path to be processed. Creates a dated inbox
  dir and input.md, then immediately triggers vault-process on the new item.
user-invocable: true
argument-hint: "<file-path>"
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-ingest:*)"]
---

# vault-ingest

Creates a tracked inbox item from a raw file and immediately processes it.

## Shell usage

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-ingest" <vault-root> <file-path>
```

## What it does

1. Generates a dated slug dir: `inbox/YYYY-MM-DD-<slug>/`
2. Copies the raw file into the dir
3. Writes `input.md` with `type: Raw Input`, `status: pending`, `resource:` link
4. Updates `inbox/log.md`
5. Signals vault-process to run immediately on the new item

## Idempotent

Running vault-ingest twice on the same file produces one inbox item, not two.
The second call prints an informational message and exits 0.

## Supported input types

All file types accepted. vault-process handles transcription:
- Text files (.txt, .md) — direct extraction
- PDFs (.pdf) — Claude reads natively
- Images (.png, .jpg) — Claude produces structured JSON description
- Docs (.docx) — Claude reads natively

## After ingestion

vault-process runs immediately. If multiple files are ingested in rapid
succession, subsequent items are queued (processed in timestamp order by
scanning for `status: pending` items).

## Shell invocation

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-ingest" ~/vault "$ARGUMENTS"
```
