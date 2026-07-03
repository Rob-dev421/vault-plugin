# vault-plugin — Development Instructions

## Code style: ponytail (lazy senior dev)

ponytail is active for all vault-plugin development. Before writing any code,
climb the ladder — stop at the first rung that holds:

1. Does this need to exist at all? (YAGNI)
2. Already in this codebase? (`lib/` has frontmatter, log, slug, validate, index, reserved)
3. Stdlib/shell builtins cover it? (`grep`, `sed`, `awk`, `find` over hand-rolled loops)
4. Can it be one line?
5. Only then: the minimum that works

**Mark deliberate simplifications** with a `# ponytail:` comment naming the
ceiling and upgrade path:
```bash
# ponytail: sequential processing, parallelize with xargs -P if queue > 100 items
```

Use `/ponytail-review` on any diff before declaring done.
Use `/ponytail-audit` to find bloat in the full plugin source.
Use `/ponytail-debt` to list all deferred shortcuts.

---

## Versioning is MANDATORY on every change

This is a versioned Claude Code plugin. Every session that modifies any file
in this repo MUST update both of these before finishing:

1. `.claude-plugin/plugin.json` — bump `"version"` field
2. `CHANGELOG.md` — add an entry at the top under a new version heading

**Versioning convention** (from CHANGELOG.md):
- `x.x.N` patch — bug fix, no behaviour change
- `x.N.0` minor — new skill, new rule, new feature
- `N.0.0` major — breaking change to vault structure or workflow

**What counts as a change that requires a version bump:**
- Any new file in `bin/`, `lib/`, `skills/`, or `templates/`
- Any modification to existing bin scripts or skill SKILL.md files
- Any new or changed rule in `lib/validate.sh`
- Any change to `bin/vault-init` (affects all new vaults)

**What does NOT require a version bump:**
- Changes to `CLAUDE.md` itself
- Changes to `CHANGELOG.md` itself
- Changes to `README.md` or other documentation only

## Checklist before declaring any task done

- [ ] All changed files are saved
- [ ] `plugin.json` version bumped if any code/skill changed
- [ ] `CHANGELOG.md` entry written with date and full list of changes
- [ ] No `graphify-out/` files referenced or created in plugin source
