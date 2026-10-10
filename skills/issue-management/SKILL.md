---
name: issue-management
description: Rules on how the agent should create and manage issues in Linear, GitHub, or any other issue tracker, including routing, defaults, priority, the issue body, batches of related issues, and updates like reassigning, comments, sub-issues, and moving to In Review. Use when asked to create, refine, rename, split, assign, hand off, comment on, or triage issues.
---

These are my rules on how to file and manage issues. The goal is that every issue looks the same, lands in the right place, and is clear enough to implement without asking me again. Use organization and project rules as the base and apply these rules as long as they do not conflict with them.

Act on the request. I usually give a one-line ask and expect a filed issue back, not a draft or a list of questions. Only ask when the destination is genuinely unclear and picking wrong would change the result, and then ask one focused question. If I ask for a draft, don't create anything.

## Where issues go

- Product work goes to the tracker the product team uses, for example Linear. Pick the team and the project by the area of the work, like frontend, backend, or database, and add a milestone only when one already fits.
- Work tied to a single repository goes to that repository's issues, for example GitHub Issues.
- When I mention a platform or a package, like "on iOS", scope the issue to it only.
- Follow the routing the project or organization already documents when it exists.

Use the connected integration for the tracker to create and update issues. Never use the browser to file issues, and never say an issue was created or updated without a successful tool response.

## Before creating

- Search the target team, project, or repository for an existing issue that covers the same work. If one exists, update it instead of opening a duplicate, and tell me which one you used.
- Look up the real teams, projects, milestones, labels, states, and users. Never invent labels, milestones, cycles, estimates, or due dates to fill fields.
- If code or context is available and relevant, read it before writing the body. Never imply code was inspected when it wasn't.

## Defaults

Apply these without asking unless I say otherwise:

- **Assignee:** me, the current user of the integration.
- **State:** Todo, or the tracker's equivalent of ready to start. Open when the tracker has no states.
- **Label:** an existing type label like Feature, Improvement, or Bug for regressions and breakage. Skip labels the tracker doesn't have.
- **Priority:** following the priority guide, when the tracker supports it.
- **Due date:** only when I give a deadline.

If assignment or any field fails, say so instead of reporting success.

## Priority guide

- **Urgent:** production is broken, data is lost or leaked, or a security hole is open. Only when I say it or the impact is clear.
- **High:** hits every user or every launch, or blocks core functionality. For example slow first-open performance or a broken core integration.
- **Medium:** the default for features, refactors, and normal bugs.
- **Low:** cosmetic or nice-to-have. For example swapping icons.

When the priority is not Medium, say why in the report.

## Language

Write titles, bodies, comments, and the report in English, even when I ask in another language. Keep non-English words only when they are exact product names or quotes.

## Title

- Short, specific, and imperative. Describe the outcome.
- Prefix with the platform when the issue is scoped to one, for example `iOS: ...`.
- Add the design reference in parentheses when I name one, for example `iOS: date picker (Horizon Calendar style)`.
- Regressions say what is broken and the fix, for example `iOS: tab bar regressing to one full row (restore separated tabs)`.
- Follow the naming the repository already uses for similar issues, for example `Add <skill-name> skill: <what it does>` in a skills repository. Use the exact names I give. If I rename something, update the title and every reference in the body right away.

## Body

Start with one bold line stating the scope, for example **iOS app only**. Then use these sections, deleting any that don't apply:

```md
## Problem

What is wrong or missing today and why it matters. For bugs, the observed behavior, the expected behavior, and reproduction steps when known.

## Target

- Concrete bullets of what to build or change.
- Every specific I gave: exact options, behavior, names, and references.
- Engineering detail that follows from the ask, like edge cases, error and empty states, accessibility, or profiling.

## Out of scope

What this issue does not cover, for example web and desktop on an iOS-only issue.

## Related

Links to issues and PRs this depends on, touches, or could undo.

## Done when

One or two verifiable sentences.
```

- Keep my intent literally. "Cascade-like delete" of a category means its items get a null category and are not deleted. "Transcribe and send immediately" means there is no edit step before sending.
- Never invent product behavior, design decisions, deadlines, or constraints. Put open questions and unclear details inside the body instead of blocking on them or guessing. A garbled detail from a voice transcription gets flagged as unclear, not turned into a requirement.
- Link design references when I name them.
- When the issue asks for a new file or folder, include the exact path, for example `skills/<skill-name>/SKILL.md`.
- Third-party code or content is referenced from its upstream source with attribution, never copied in as my own.

## Several issues at once

When I list two or more things, split them into one issue per independently deliverable piece of work and never bundle unrelated work. Create them in the same pass and link related ones to each other in Related so they share a pipeline and don't undo each other. When the work has a clear parent, create the parent and add the rest as sub-issues.

## Managing existing issues

- **Refinements:** "add an option for X" updates the existing issue's body. Don't open a new one.
- **Reassigning:** change the assignee and keep the rest as it is. For a handoff, assign the teammate and note in the body or a comment that they open the PR and I review it.
- **In Review:** when a PR is up, move the issue to In Review, or the tracker's equivalent, and link the PR. Reference the issue from the PR with a closing keyword when the tracker supports it.
- **Comments:** use a comment for updates, decisions, and findings that come after creation. Change the body only when the scope or target changes.
- **Sub-issues:** use them to break down a large issue. Each sub-issue follows the same title and body rules and links back to the parent. When the tracker has no sub-issues, use a checklist of linked issues in the parent.
- **Triage:** for duplicates, keep the most complete issue, or the oldest when they match. Link the other to it, and close or cancel the duplicate. Fix wrong routing, labels, or priority following these rules.

## Report back

After creating or updating, confirm the fields from the tool response, and fetch the issue if the response is incomplete. Then reply with one short message:

- A link per issue using its identifier, for example `[ENG-99](url)` or `[repo#21](url)`, with the title.
- Project, assignee, state, and priority.
- One sentence on what it covers.

For batches, one line per issue. Mention any non-default value and why, and any open question left in the body. Don't imply the work has started; creating an issue is not implementing it.
