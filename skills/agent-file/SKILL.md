---
name: agent-file
description: Rules on how the agent should create and update a project's agent files, AGENTS.md, CLAUDE.md and DESIGN.md, by reading the codebase. Use when setting up a new project, when asked to write or refresh AGENTS.md, CLAUDE.md or DESIGN.md, or after a change to the architecture, commands, or design system that makes them stale.
---

This are my rules on how to write the agent files of a project. The goal is that any agent opening the project understands what the app is, how it is built, how to work in it, and how it should look, without rediscovering it from the code every time. Use organization and project rules as the base and apply these rules as long as they do not conflict with them.

## Files

Every project has these three files at the root:

- `AGENTS.md` is the source of truth for the product, architecture, commands, and workflow. Every agent reads it.
- `CLAUDE.md` only imports `AGENTS.md` with `@AGENTS.md` and adds instructions that are exclusive to Claude Code, if any. Never duplicate content from `AGENTS.md`.
- `DESIGN.md` is the source of truth for the design system and UI/UX. ALWAYS create it, even when the project has no interface yet.

In a monorepo, keep these files at the root and only add a nested `AGENTS.md` inside an app or package when it has its own commands, stack, or rules that don't apply to the rest of the repository. Nested files only describe what is different, never repeat the root.

## Separation between AGENTS.md and DESIGN.md

Keep a strict separation, each topic lives in exactly one file:

- `AGENTS.md` owns how the app works: product purpose, stack, architecture, data flow, folder structure, commands, environments, deployment, testing, conventions, and rules for the agent.
- `DESIGN.md` owns how the app looks and feels: product direction, audience, tone, colors, typography, spacing, layout, components, motion, states, accessibility, and responsive behavior.

`AGENTS.md` never contains tokens, colors, fonts, or visual rules, it only says "Read DESIGN.md before any UI work". `DESIGN.md` never contains architecture, folder structure, or commands, it only references the component and theme file paths where the system is implemented. If a rule fits in both, for example how components are organized, the code part goes to `AGENTS.md` and the visual part goes to `DESIGN.md`.

## Reading the codebase

Before writing anything, read the project instead of guessing:

- Existing agent files, `README.md`, and any docs folder
- Package manifests, lockfiles, workspace and monorepo config
- Scripts in `package.json`, `Makefile`, or equivalent, to get the exact commands
- Framework, TypeScript, formatter, linter, and test configuration
- Routes, entry points, and the folders for components, hooks, models, contexts, and lib
- Database schema, API layer, auth, and integrations
- `.env.example` and env type definitions, never read or copy values from real `.env` files
- CI workflows, deployment config, and branch rules
- Theme files, design tokens, Tailwind or Stylex config, fonts, and the UI components folder for `DESIGN.md`

Ask the user only for what the code cannot answer, like the product purpose, the audience, the design direction, or decisions that are still open. Never invent requirements, mark them as open questions instead.

## Writing AGENTS.md

Follow this order and skip any section that doesn't apply:

```md
# Project name

One or two sentences on what the app is, who it is for, and the problem it solves.

Read DESIGN.md before any UI work.

## Stack
## Architecture
## Project structure
## Commands
## Environment
## Conventions
## Testing
## Deployment
## Rules
## Open questions
```

- Architecture explains how the pieces connect and where data flows, not a list of every file.
- Project structure only lists the top level folders and what belongs in each one.
- Commands are exact and copy pasteable, include install, dev, build, format, check, test, and database tasks. Run them when possible to confirm they work.
- Environment lists the variable names and what they are for, never values or secrets.
- Conventions only include what is specific to this project, link to the skills instead of repeating them, for example [code-guidelines](../code-guidelines/SKILL.md), [frontend](../frontend/SKILL.md), and [app-architecture](../app-architecture/SKILL.md).
- Rules are the things the agent must always or never do in this project, for example never edit generated files or always run the check command before finishing.

## Writing DESIGN.md

Follow [design](../design/SKILL.md) and use this order:

```md
# Design

## Direction
## Signature
## Colors
## Typography
## Spacing and layout
## Components
## States
## Motion
## Accessibility
## Open questions
```

- Always read first ui tokens: colors, fonts, spacing, and layout. Then component primitives like buttons, inputs, cards, etc. and their variants.
- Direction describes the product personality, the audience, and the feeling the interface should give.
- Signature names the one distinctive element of the product and where it is used.
- Colors list every semantic token with its light and dark value and its purpose, and where the tokens are defined.
- Typography lists the display, body, and utility fonts with sizes, weights, and line heights.
- Components list the base components, where they live, and the variants that exist, so the agent reuses them instead of creating new ones.
- States cover loading, empty, error, success, disabled, and permission states.

When the project doesn't have a design system yet, write the direction and the decisions taken so far, and list the rest as open questions. When the project has no interface, for example a CLI or a library, still create `DESIGN.md` and describe the user facing output instead, like the tone of messages, errors, and formatting.

## Writing style

- Write for an agent, short, direct, and specific to this project.
- Only include what an agent cannot infer quickly from the code, skip generic advice like "write clean code".
- Use relative links to files and folders instead of copying their content.
- Keep each file under 200 lines, if it grows past that move details to the docs folder and link them.
- No placeholder sections, delete a section instead of leaving it empty.

## Updating

When the files already exist, update them instead of rewriting:

- Keep content written by the user unless it is wrong, and ask before deleting rules you don't understand.
- Remove anything stale, like old commands, deleted folders, or replaced libraries.
- Move content to the right file if it breaks the separation between `AGENTS.md` and `DESIGN.md`.
- If the project uses a different file as the source of truth, for example `CLAUDE.md` with the full content, follow the project and mention the difference instead of migrating it unless the user asks.
- Update the agent files in the same change that modifies the architecture, commands, or design system.
