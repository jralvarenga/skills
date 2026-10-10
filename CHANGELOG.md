# jralvarenga-skills

## 2.3.0

### Minor Changes

- f86beb1: Add the `app-architecture` skill for repository structure, branching and protection, environments, deployment, and authentication.

## 2.2.0

### Minor Changes

- e05d49e: Add the `code-review` skill for reviewing pull requests against project rules and the code guidelines, with severity-ranked summary and inline comments.

## 2.1.0

### Minor Changes

- 1c0cacf: chore: update code guidelines and design agent description (#14)

### Patch Changes

- a3e788a: Clarify frontend rendering boundaries, query state ownership, and error reporting. Align design metadata with its frontend scope and correct wording and the structured error example.
- eb2b41b: Fix frontend references to the code guidelines, remove obsolete repository-owned links when relinking skills, and put Codex display metadata in the supported interface object.

## 2.0.0

### Major Changes

- 5e4377a: Rename `jralv-code-guidelines` to `code-guidelines` and `jralv-design` to `design`, and stop vendoring the external `frontend-design` and `ui-ux-pro-max` skills.

  Ship the repository as a plugin for Claude Code, Grok Build, Codex, ChatGPT and Cursor, with one manifest per agent and the version kept in sync on release.

### Minor Changes

- 71eb458: chore: remove outdated skills and update code guidelines

## 1.0.0

### Major Changes

- c5ed0ef: Initial skills package release.
