# Skills

Personal coding skills shared between Codex, Claude Code, Cursor and any agent that supports the Agent Skills format.

The source of every skill is inside `skills/`. Don't copy the skills manually.

## Install

```bash
./scripts/link-skills.sh
```

This links every skill to:

- `~/.agents/skills` for Codex and Cursor
- `~/.claude/skills` for Claude Code

Run it again after adding, removing or renaming a skill.
