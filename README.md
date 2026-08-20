# Skills

Personal coding skills shared between Codex, Claude Code, Cursor and any agent that supports the Agent Skills format.

This repository is distributed through [skills.sh](https://skills.sh), not npm. The package is private so Changesets can manage versions, tags and GitHub Releases without publishing it to a registry.

The source of every skill is inside `skills/`. Don't copy the skills manually.

## Install from skills.sh

Install every skill globally for Claude Code:

```bash
npx skills add jralvarenga/skills --skill '*' --global --agent claude-code --yes
```

Install every skill globally for Claude Code, Codex and Cursor:

```bash
npx skills add jralvarenga/skills --skill '*' --global \
  --agent claude-code \
  --agent codex \
  --agent cursor \
  --yes
```

## Link a local clone

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

## Versioning

Add a changeset to every pull request that should create a new release:

```bash
bun run changeset
```

Choose `patch`, `minor` or `major`, write a short summary and commit the generated file inside `.changeset` with the rest of the pull request.

After the pull request is merged into `main`, the release workflow creates or updates a pull request named `chore: version skills`. That pull request updates `package.json` and `CHANGELOG.md`. Once it is approved and merged, the workflow creates a `vX.Y.Z` Git tag and a GitHub Release.

The commands used by the workflow are also available locally:

```bash
bun run version
bun run release
```

`bun run release` only creates a Git tag. It does not publish to npm.

## GitHub setup

Protect the `main` branch with these settings:

- Require pull requests with one approval.
- Dismiss stale approvals and require resolved conversations.
- Allow repository administrators to bypass approval requirements.
- Block force pushes and branch deletion.

In **Settings → Actions → General**, set workflow permissions to read and write and allow GitHub Actions to create pull requests.

No repository secrets are required. GitHub provides `GITHUB_TOKEN` automatically, and this repository does not use an `NPM_TOKEN`.
