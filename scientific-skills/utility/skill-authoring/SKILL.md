---
name: skill-authoring
description: Reference for creating and editing Claude Code skills — SKILL.md format, frontmatter fields, and adding skills to activation modes.
---

# Skill Authoring Reference

## SKILL.md Format

Every skill lives at `scientific-skills/<group>/<skill-name>/SKILL.md`.

```markdown
---
name: skill-name                  # must match directory name
description: one sentence — used by Claude to decide when to load this skill
allowed-tools: Read Write Edit Bash   # omit for reference-only skills
---

# Skill Title

Short description of what this skill does and when to use it.

## Section 1
...
```

### Frontmatter Fields

| Field | Required | Notes |
|---|---|---|
| `name` | Yes | Lowercase, hyphenated, matches directory name |
| `description` | Yes | One sentence; used for relevance matching |
| `allowed-tools` | No | Only include if the skill needs to run code; omit for documentation-only skills |

## Skill Groups

Skills are organized into group subdirectories:

| Group | Path | Purpose |
|---|---|---|
| bioinformatics | `scientific-skills/bioinformatics/` | Python bioinformatics tools |
| ml | `scientific-skills/ml/` | ML and deep learning |
| stats | `scientific-skills/stats/` | Statistics and modeling |
| databases | `scientific-skills/databases/` | Biological and literature databases |
| writing | `scientific-skills/writing/` | Scientific communication |
| utility | `scientific-skills/utility/` | File handling, tooling, reproducibility |
| visualization | `scientific-skills/visualization/` | Plotting libraries |

## Adding a Skill to a Mode

After creating the skill directory and SKILL.md, add the skill name to the appropriate array in `.claude/scripts/skills.sh`:

```bash
SKILLS_utility=(
  ...
  new-skill-name
)
```

Then verify:
```bash
bash .claude/scripts/skills.sh activate utility
ls .claude/skills/
bash .claude/scripts/skills.sh deactivate
```

## Creating a New Skill Mode

Add a new array and register it in the dispatch section:

```bash
# In skills.sh — array definition
SKILLS_mymode=(skill1 skill2 skill3)

# In cmd_activate and cmd_deactivate help strings — add "mymode" to the modes list
```

## Quality Checklist

- [ ] Directory name matches `name` field in frontmatter
- [ ] `description` is one sentence, specific enough to trigger relevance matching
- [ ] Code examples are minimal and copy-pasteable
- [ ] Skill is added to the correct group directory
- [ ] Skill name is added to the appropriate mode array in `skills.sh`
- [ ] `allowed-tools` only present if the skill needs to write/run files
