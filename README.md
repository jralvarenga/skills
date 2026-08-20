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

## Bundled design skills

The `design` skill includes these external skills so they are available after cloning this repository:

- [`frontend-design`](https://github.com/anthropics/skills/tree/main/skills/frontend-design) from `anthropics/skills`
- [`ui-ux-pro-max`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/tree/main/.claude/skills/ui-ux-pro-max) from `nextlevelbuilder/ui-ux-pro-max-skill`

## Update bundled design skills

```bash
bun run update
```

This command updates `frontend-design` and `ui-ux-pro-max` inside `.agents/skills`, then copies each complete skill into its folder inside `skills/design`.

If the `.agents` copies are already current, only run the copy step:

```bash
./scripts/update-design-skills.sh
```
