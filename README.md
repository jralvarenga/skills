# Skills

Personal coding skills shared between Claude Code, Codex, ChatGPT, Cursor, Grok Build and any agent that supports the Agent Skills format.

This repository is distributed as an agent plugin and through [skills.sh](https://skills.sh), not npm. The package is private so Changesets can manage versions, tags and GitHub Releases without publishing it to a registry.

The source of every skill is inside `skills/`. Don't copy the skills manually.

## Install as a plugin

The repository is a plugin for every supported agent. Each agent reads its own manifest, and all of them load the same `skills/` folder:

| Agent | Manifest | Marketplace |
| --- | --- | --- |
| Claude Code and Grok Build | `.claude-plugin/plugin.json` | `.claude-plugin/marketplace.json` |
| Codex and ChatGPT | `.codex-plugin/plugin.json` | `.agents/plugins/marketplace.json` |
| Cursor | `.cursor-plugin/plugin.json` | `.cursor-plugin/marketplace.json` |
| Any [Agent Plugins](https://agent-plugins.org) client | `plugin.json` | |

### Claude Code

```bash
claude plugin marketplace add jralvarenga/skills
```

```bash
claude plugin install jralvarenga-skills@jralvarenga
```

Or inside a session: `/plugin marketplace add jralvarenga/skills`, then `/plugin install jralvarenga-skills@jralvarenga`.

### Grok Build

Grok Build reads Claude Code marketplaces and plugins, so install the plugin in Claude Code first and Grok picks it up. Otherwise add `jralvarenga/skills` as a marketplace from Grok's Marketplace tab.

### Codex and ChatGPT

```bash
codex plugin marketplace add jralvarenga/skills
```

```bash
codex plugin add jralvarenga-skills@jralvarenga
```

### Cursor

Add `jralvarenga/skills` as a team marketplace, then open **Customize**, find `jralvarenga-skills` and select **Install**. For a local clone, link it into Cursor's local plugins and reload the window:

```bash
ln -s "$PWD" ~/.cursor/plugins/local/jralvarenga-skills
```

## Install from skills.sh

Install every skill globally without the plugin system:

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

## External design skill

The `design` skill uses [`frontend-design`](https://github.com/anthropics/skills/tree/main/skills/frontend-design) as inspiration and a fallback when a project doesn't include it. It is not vendored in this repository, install it alongside these skills:

```bash
npx skills add anthropics/skills --skill frontend-design --global --agent claude-code --yes
```

## Contributing

- Feature pull requests target `next`.
- The Changesets version pull request (`chore: version skills`) also targets `next`.
- Open a pull request from `next` into `main` when you want to release. The `Enforce main source` check rejects pull requests into `main` unless they come from this repository's `next` branch.

## Versioning

Add a changeset to every pull request that should create a new release:

```bash
bun run changeset
```

Choose `patch`, `minor` or `major`, write a short summary and commit the generated file inside `.changeset` with the rest of the pull request.

After the pull request is merged into `next`, the release workflow creates or updates a pull request named `chore: version skills` against `next`. That pull request updates `package.json`, `CHANGELOG.md` and the version in every plugin manifest. Once it is approved and merged into `next`, the workflow creates a `vX.Y.Z` Git tag and a GitHub Release. Merge `next` into `main` to update the default branch with the released changes; this does not publish another release.

The commands used by the workflow are also available locally:

```bash
bun run version
bun run release
```

`bun run release` only creates a Git tag. It does not publish to npm.

## GitHub setup

Protect the `main` and `next` branches with these settings:

- Require pull requests with one approval.
- On `main`, require the `main-only-from-next` status check so only `next` can be merged into it.
- Dismiss stale approvals and require resolved conversations.
- Allow repository administrators to bypass approval requirements. This bypass also skips the `main-only-from-next` check, so only non-admin contributors are held to it.
- Block force pushes and branch deletion.

In **Settings → Actions → General**, set workflow permissions to read and write and allow GitHub Actions to create pull requests.

No repository secrets are required. GitHub provides `GITHUB_TOKEN` automatically, and this repository does not use an `NPM_TOKEN`.
