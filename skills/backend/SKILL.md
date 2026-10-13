---
name: backend
description: Rules on how the agent should design and plan the backend, including APIs, databases, validation, and infrastructure. Use when creating or changing an API, a database schema or query, a server, a background job, or the Docker and deployment setup of a service.
---

These are the basic rules for planning and designing backend architecture, APIs, databases, and infrastructure. The main goal is to create a backend that is predictable, typed from end to end, easy to run anywhere, and safe to change. Use TypeScript with oRPC or Hono, Postgres with Drizzle, and Zod by default, unless the user or project specifies another language, framework, or library. Use organization and project rules as the base and apply these rules as long as they do not conflict with them.

This is my recommended stack for backend development. Recommend this stack unless the user or project specifies otherwise, and ask about any additional requirements or preferences:

- TypeScript running on Bun or Node.js
- oRPC for APIs consumed by my own apps, Hono for standalone HTTP services and public REST APIs
- Zod for every validation schema
- Postgres with Drizzle ORM and drizzle-kit for migrations
- Convex when the product needs real-time data synchronization
- better-auth or WorkOS for authentication
- Docker for every service and every local dependency
- Render for Docker deployments
- Sentry for error logging and monitoring
- Biome for code linting and formatting
- GitHub Actions for continuous integration

Read [app-architecture](../app-architecture/SKILL.md) for where the backend lives in the repository, branching, and environments, [frontend](../frontend/SKILL.md) for how clients consume the API, and [code-guidelines](../code-guidelines/SKILL.md) for how to write the code.

## Architecture and Planning

Plan the backend around the product's domain, the clients that consume it, and the data it owns before writing code. Inspect the existing project and follow organization conventions and mandatory framework requirements while applying my code guidelines wherever compatible. Define the resources, their relationships, the operations each client needs, who is allowed to perform them, and the unresolved assumptions before designing endpoints or tables.

Organize the backend by technical responsibility, with a folder for each feature inside its corresponding layer, following the [files and directories](../code-guidelines/SKILL.md#files-and-directories) rules. Keep only app-wide functionality at the root of those layers:

- routers: transport only. Define procedures or routes, attach their schemas and middleware, and call a service. No business rules or queries.
- services: business logic. Coordinate queries, enforce rules, and call external integrations. Never depend on the request or response objects of the framework.
- db: the Drizzle schema, queries, migrations, and seeds. In a monorepo this lives in packages/db.
- models: Zod schemas and the types inferred from them. This is the contract shared by the routers, the services, and the clients.
- lib: external integrations, clients, and shared utilities.

```
src/
  routers/
    orders/
      orders.ts
  services/
    orders/
      create-order.ts
  models/
    orders/
      order.ts
  db/
    schema/
      orders.ts
    migrations/
  lib/
  env.ts
  server.ts
```

Keep dependencies flowing in one direction, routers to services to db, and never import a router from a service or a service from the db layer. Introduce queues, caches, background jobs, or extra services only when a concrete requirement justifies them. Write the implementation plan as a sequence of usable slices, each one including its schema, migration, service, procedure, and tests, and explain how its acceptance criteria will be verified. Record consequential decisions, tradeoffs, and risks without adding speculative infrastructure.

## Validation and Types

Always use Zod for validation. Define the validation schema first and infer the TypeScript type from it with `z.infer`, `z.input`, or `z.output`. Never write a type or interface by hand that duplicates the shape of a schema, because the two will drift apart. Write a standalone type only when the data never crosses a boundary and has nothing to validate, and prefer `type` over `interface` as described in the code guidelines.

Every request and every response must be typed through a schema or a type inferred from one. This includes request bodies, route and query parameters, headers the server relies on, responses, error payloads, webhooks, queue messages, cron job payloads, and the responses of external APIs. Validate everything that enters the system at the boundary where it enters, and trust the inferred type after that point. Validate responses from external APIs instead of casting them, and never use `any` or `as` to silence a type that should come from a schema.

```ts
import { z } from 'zod'

export const createOrderInput = z.object({
  customerId: z.uuid(),
  items: z.array(z.object({ productId: z.uuid(), quantity: z.int().positive() })).min(1),
})

export const order = z.object({
  id: z.uuid(),
  status: z.enum(["pending", "paid", "cancelled"]),
  total: z.number().nonnegative(),
  createdAt: z.date(),
})

export type CreateOrderInput = z.infer<typeof createOrderInput>
export type Order = z.infer<typeof order>
```

Keep schemas in the models layer of their feature and share them with the clients through the API contract or a shared package, so the frontend validates forms with the same schemas the backend uses. Compose schemas with `pick`, `omit`, `extend`, and `partial` instead of redefining fields. Validate environment variables with a Zod schema in a single env file at startup and fail fast when a required value is missing or invalid. Keep validation messages translatable as described in the frontend internationalization rules.

## Database

Use Postgres with Drizzle as the default database and ORM. Define the database schema with Drizzle and generate the Zod schemas from it with drizzle-zod, using `createSelectSchema`, `createInsertSchema`, and `createUpdateSchema`, or the Zod integration built into Drizzle when the project's version includes it. Refine the generated schemas in the models layer with the business rules the database cannot express, and infer the types from those schemas instead of using Drizzle's `$inferSelect` and `$inferInsert` directly in services. Validate the data before it reaches a query; the database constraints are the last line of defense, not the validation layer.

Design tables around the domain and its access patterns. Use plural snake_case table names and snake_case columns mapped to camelCase in TypeScript through Drizzle's casing option. Give every table a primary key, `created_at` and `updated_at` timestamps stored with time zone, explicit foreign keys with a deliberate delete behavior, and `not null` by default. Add unique constraints for business uniqueness, check constraints for simple invariants, and indexes for the columns used to filter, join, and sort. Store money as integers in the smallest currency unit or as `numeric`, never as floating point. Use soft deletes only when the product needs to restore or audit deleted records.

Keep queries in the db layer of their feature and expose them as named functions with typed inputs and outputs. Select only the columns the caller needs, avoid N+1 queries by using joins or Drizzle's relational queries, and use cursor-based pagination for lists that can grow. Wrap operations that must succeed or fail together in a transaction, and keep external calls outside of transactions. Use parameterized queries only and never build SQL by concatenating strings.

Generate migrations with drizzle-kit, commit them, and review the generated SQL before merging. Never use `drizzle-kit push` against a shared environment. Keep every migration backwards compatible with the version currently running, splitting breaking changes into expand and contract steps, and run migrations as an explicit deployment step as described in [app-architecture](../app-architecture/SKILL.md#deployment). Provide seed scripts for local development and tests, never seed production with fake data, and configure connection pooling suited to the deployment platform.

When the project uses Convex, define tables and function arguments with Convex validators and keep the same schema-first rule: infer types from the validators with `Infer` and validate every argument and return value. Use the Zod integration from convex-helpers when the schemas must be shared with a Zod-based client or API.

## API

Use oRPC for APIs consumed by my own apps and Hono for standalone services or public REST APIs, unless the user or project specifies otherwise. Prefer contract-first design: define the contract with its input, output, and error schemas, implement it on the server, and give clients a typed client generated from that same contract. Every oRPC procedure must declare `.input()` and `.output()` with Zod schemas, and every Hono route must validate its body, parameters, and query with `@hono/zod-validator` and type its response with a schema. Expose an OpenAPI document generated from the schemas for any API consumed outside the repository.

Design endpoints around resources and user actions, with consistent naming, plural resource names, and predictable status codes. Use GET for reads without side effects, POST to create or trigger actions, PATCH for partial updates, and DELETE for removals. Return lists with a consistent pagination shape that includes the items and the next cursor. Accept idempotency keys for operations that create payments, orders, or other records that must not be duplicated on retry. Version public APIs and never ship a breaking change to an existing version.

Authenticate requests in middleware and authorize every operation on the server, checking ownership or permissions in the service before reading or changing data. Never trust identifiers, roles, or prices sent by the client. Add rate limiting to authentication and other abuse-prone endpoints, configure CORS with an explicit list of origins, set request body size limits, and apply timeouts and bounded retries with backoff to every external call.

## Error Handling

Define expected errors as part of the contract, using oRPC's typed errors or a shared error schema for Hono, so clients can handle them without parsing messages. Return the same error shape from every endpoint with a stable code, a safe message, and a trace ID, and never expose stack traces, SQL, or internal identifiers to clients. Throw expected errors from services and let a single error handler translate them into responses. Catch errors only where recovery or translation is needed and let unexpected failures reach that handler.

Log unexpected errors once, at the handler, through Sentry or the project's monitoring service, and fall back to structured logs on the server console when monitoring is unavailable. Use the structured format described in the [frontend error handling](../frontend/SKILL.md#error-handling) rules, extract `Error.name`, `Error.message`, and `Error.stack` explicitly, propagate the trace ID across services, and remove secrets and personal data from the diagnostic context. Validation failures are expected errors: return them with the field-level issues from Zod and do not report them to monitoring.

## Infrastructure

Give priority to Docker images. Every backend service must have a production-ready Dockerfile, and every local dependency, such as Postgres, Redis, queues, object storage emulators, or mail catchers, must run from a Docker image through a `compose.yaml` at the root of the repository instead of being installed on the host. Prefer official, maintained images, pin them to a specific version and never to `latest`, and use the same major versions locally, in CI, and in production. A new contributor should be able to start the whole backend with a single command.

Build images with a multi-stage Dockerfile that installs dependencies with the committed lockfile, builds the app, and copies only the production output into a slim or distroless runtime image. Include a `.dockerignore`, order layers so dependency installation is cached, run the process as a non-root user, and expose a single port configured through an environment variable. Add a health check endpoint and a readiness check that verifies the database connection, handle `SIGTERM` to finish in-flight requests and close connections gracefully, and write logs to standard output. Keep secrets out of the image layers and pass all configuration through environment variables validated at startup.

Deploy Docker services to Render unless the user or project specifies otherwise, and keep the image portable to any container platform. Tag images with the commit SHA, build them once, and promote the same image through each environment instead of rebuilding. Configure continuous integration to run format check, lint, type check, tests, a Docker build, and a startup smoke test of the built image on every pull request. Scan images for known vulnerabilities, keep base images updated, and document how to build, run, configure, and roll back each service.

## Testing

Keep tests in a tests folder directly inside the folder containing the source files they verify, following the same structure and naming described in the [frontend testing](../frontend/SKILL.md#testing) rules, for example services/orders/tests/create-order.test.ts.

Test the public contract and the business behavior: valid and invalid inputs against the schemas, authorization rules, error codes, state transitions, and edge cases. Run integration tests for services and queries against a real Postgres database started from the same Docker image used in development instead of mocking the database, and reset it between tests through migrations and seeds. Test procedures and routes through the server handler to verify validation, authentication, status codes, and response shapes. Isolate external services with fakes at the lib layer, keep tests deterministic, and run the relevant tests whenever behavior changes.
