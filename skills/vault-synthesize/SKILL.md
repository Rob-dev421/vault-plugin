---
name: vault-synthesize
description: >
  Synthesize wiki entries from source concepts. Use when the user says
  "synthesize wiki", "create wiki entry", "vault-synthesize", or
  "/vault-synthesize". Claude reads source concepts and writes wiki entries
  directly using OKF rules. Shell finalize handles log updates.
user-invocable: true
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/bin/vault-synthesize-finalize:*)"]
---

# vault-synthesize

Claude-driven skill that creates or updates wiki entries from source concepts.

## What it does

1. Read source concept(s) from `sources/`
2. Decide the wiki target path (`wiki/concepts/<name>.md` or `wiki/projects/<name>.md`)
3. Author the wiki entry:
   - Frontmatter: `type: Wiki Concept`, `title`, `description`, `timestamp`
   - Body: prose synthesis of the source concepts
   - Use bundle-relative links (`/sources/slug/concept.md`), not relative links
   - `# Sources` section listing all source concepts used
   - `# Citations` for any external factual claims
4. MANUAL EDIT PRESERVATION: if the wiki entry already exists and has been
   edited since last synthesis, append new `# Sources` links only — never
   overwrite prose
5. Call `bin/vault-synthesize-finalize` as the final step:
   ```bash
   bash engine/bin/vault-synthesize-finalize <vault-root> <wiki-file> ...
   ```
6. Call `vault-index` to regenerate wiki indexes

## After synthesis

Run `vault-validate` to confirm all wiki entries are OKF-conformant.

## Shell invocation (finalize step)

After Claude writes wiki entry files, call:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/bin/vault-synthesize-finalize" ~/vault <wiki-file...>
```
