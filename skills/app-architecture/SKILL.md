---
name: app-architecture
description: Rules on how the agent should structure, set up, and deploy applications, including monorepo vs single repo, branching and protection, environments, deployment targets, and auth. Use when creating a new app, adding a package or service, configuring CI/CD or deployments, or implementing auth.
---

This are my rules and guidelines on how to set up and structuring applications, from the repository layout to branching, environments, deployment, and authentication. The main goal is to have every app follow the same shape so it is predictable to work in, safe to deploy, and easy to scale. Use organization and project rules as the base and apply these rules as long as they do not conflict with them. When an existing project already made a different decision, follow the project and mention the difference instead of migrating it unless the user asks.

This are my recommended stack for the application setup, this stack is thought for an app where the main programming language is Typescript and the main framework is React, if project requirements or user specifies another one, apply as much as possible of this stack, use it unless the user or project specifies otherwise, and ask about any additional requirements or preferences:

- Bun as the package manager
- Monorepo as the repository layout
- Turborepo as the monorepo manager
- Typescript as the programming language for frontend and backend
- Postgres with Drizzle for the database
- Vercel or Cloudflare for web deployment, EAS for React Native
- GitHub with protected branches and GitHub Actions for continuous integration
- Sentry for error logging and monitoring
- Biome for linting and formatting
- Convex for real-time data synchronization
- better-auth or WorkOS for authentication
- Validator using zod

Read [frontend](../frontend/SKILL.md) for frontend architecture, [backend](../backend/SKILL.md) for backend architecture, and [code-guidelines](../code-guidelines/SKILL.md) for how to write the code inside each app or package.

## Monorepo structure

Always prioritize the use of a single repository for the entire application, ignore this rule if the app requires different programming languages, for example ts/js for web, swift for ios kotlin for android, etc. Always recommend and use monorepo with Turborepo, unless the user or project specifies otherwise, do not create a monorepo for speculative future apps; move to one when a second app or shared package actually exists.

In a monorepo, keep deployable applications in apps and shared code in packages, using names such as apps/web, apps/native, apps/api, packages/ui, packages/api, packages/db, and packages/config. Each package should have one clear responsibility, a typed public entry point, and no imports into another package's internal files. Keep shared TypeScript, Biome, and test configuration in packages/config and extend it from every app and package. Use workspace dependencies instead of relative imports across packages, and run tasks through Turborepo so builds, checks, and tests are cached and ordered by their dependencies.

```
apps/
  landing/
  web/
  mobile/
  backend/
  .../
packages/
  utils/
  ui/
  db/
  auth/
  .../
```

If the app can have its own backend, for example in Next.js or Tanstack Start, don't create a separate backend folder unless the backend is using a different framework like Express, NestJS, etc. If the backend is an extension of the app like oRPC o tRPC or using something like supabase or convex, create a separated package as backend.

```
packages/
  backend/
```

In both layouts, keep a single lockfile at the root, pin the runtime and package-manager versions, and provide root commands for development, build, format, check, type check, and test.

## Branching

Never commit directly to main or next. Both branches are protected, require a pull request, require the CI checks to pass, and block force pushes and deletions.

- main: the stable source of truth. It always matches what is running in production.
- next: the integration branch. Every feature, fix, and chore branch is created from next and merged back into next through a pull request.
- dev, staging, prod: deployment branches. Each one deploys automatically to its environment and only receives promotions, never direct work.

Promote through pull requests so each environment has a reviewable record of what changed. Hotfixes branch from prod, merge into prod, and are merged back into main and next so no branch loses the fix. Protect dev, staging, and prod with the same rules as main, and require approval for promotions into staging and prod.

Name branches after the issue they resolve, such as 17-add-application-setup, and keep each branch focused on one issue. Squash or rebase feature branches when merging into next to keep its history readable, and use merge commits for promotions so the environment branches share history.

This is the promotion flow:

```
feature,fix,chore/branch-name -> next -> main -> prod

next -> dev -> staging
```

## Deployment

Set the default target for each type of app:
- Web: Vercel or Cloudflare
- React Native: EAS
- Server (Docker): Render
- Convex: Convex

Deploy web apps to Vercel or Cloudflare, choosing based on the framework and runtime requirements. Deploy Convex through its own deployment per environment, and React Native apps through EAS with a build profile and update channel for each environment. Always provide a production-ready Dockerfile for server apps so they can run outside the default platform, following the build rules in [frontend](../frontend/SKILL.md).

Configure GitHub Actions to run format check, lint, type check, tests, and a production build on every pull request into next and on every promotion. Deploy only from the deployment branches, and only after the checks pass. Run database migrations as an explicit deployment step before the new version receives traffic, and keep migrations backwards compatible with the version currently running. Document how to roll back each environment, and never bypass failed checks to deploy.