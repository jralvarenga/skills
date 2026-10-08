---
name: frontend
description: Rules on how the agent should design and plan the frontend application, components, pages and features.
---

These are the basic rules for planning and designing frontend application architecture, components, pages, and features. The main goal is to create an application that is easy to understand, maintain, and scale. Use React with TypeScript and Next.js or TanStack Start by default, unless the user or project specifies another library or framework.

This is my recommended stack for frontend development. Recommend this stack unless the user or project specifies otherwise, and ask about any additional requirements or preferences:

- React with TypeScript
- TanStack Start or Next.js
- TailwindCSS or Stylex
- Shadcn/ui with Base UI
- TanStack Query
- Zustand or Jotai
- Sentry for error logging and monitoring
- Biome for code linting and formatting
- Vercel or Cloudflare for deployment
- GitHub Actions for continuous integration

## Architecture and Planning

Plan the frontend around the product’s purpose, audience, primary user journeys, and platform constraints before writing code. Inspect the existing project and follow organization conventions and mandatory framework requirements while applying my design and code guidelines wherever compatible. Define the initial scope, routes, feature boundaries, acceptance criteria, and unresolved assumptions. Organize the architecture by technical responsibility, keeping components, hooks, models, contexts, and lib separate, with a folder for each feature inside its corresponding layer. Keep only app-wide functionality at the root of those layers. Pages should compose features, components should handle presentation, hooks should coordinate reusable behavior, models should define data contracts, contexts should own shared state, and lib should contain business logic and external integrations. Keep dependencies explicit, avoid circular dependencies and imports into another feature’s internal implementation, and introduce abstractions or dependencies only when concrete requirements justify them.

Before implementation, define each feature’s data flow, contracts, state ownership, and update behavior. Keep interaction state close to the component that uses it, use URL state for navigation and shareable views, manage server data through a consistent fetching and caching strategy, and introduce shared application state only when multiple parts of the app need it. Derive values instead of duplicating state, keep network calls and business rules outside presentation components, and plan loading, empty, error, success, retry, and permission states alongside the main flow. Establish the visual system before building individual screens, including semantic color tokens, light and dark themes, typography, spacing, responsive layouts, and one restrained signature element suited to the product. Apply my design guidelines consistently, and include accessibility, keyboard interaction, focus behavior, and responsive behavior in the component plan.

Keep components and files focused, names concise, contracts typed, and implementation consistent with my [code-guidelines](../code-guidelines/SKILL.md). Build reusable components where responsibilities and behavior are shared, while keeping feature-specific logic within its feature. Write the implementation plan as a sequence of usable feature slices, explaining what each slice delivers, what it depends on, and how its acceptance criteria will be verified. Record consequential architectural decisions, tradeoffs, risks, and assumptions without adding unnecessary documentation or speculative infrastructure. Validate critical user journeys, business behavior, and failure recovery with appropriate checks, review screenshots throughout implementation, and verify relevant layouts, themes, and interaction states before delivery. Finish by removing unnecessary abstractions, duplicated logic, and decorative elements so the app remains coherent, maintainable, and easy to extend.

### Fetching Data and State Management / API Integration

Use TanStack Query to own cached server data and share it through query hooks and the query cache. Do not copy query data into context or a separate client store. Create a context provider only for shared client state or dependencies that need one independently. Use Zustand or Jotai when cross-feature client state warrants it.

For SSR frameworks such as Next.js or TanStack Start, choose data-fetching and rendering boundaries based on framework conventions and feature requirements. Render UI on the server where appropriate and use client components for interaction or browser APIs. Use framework loaders, server components, or server functions where supported, and hydrate the query cache when client queries need server-fetched data. If an external API uses a different language from the frontend, discuss a typed wrapper API when it would improve integration; a language difference alone does not require one.

Prioritize the use of suspense and lazy loading to fetch the data and state and errorBoundary to handle the errors of the api calls and show a fallback UI if the data is not available, read [code-guidelines](../code-guidelines/SKILL.md) on how to implement this components and ui fallbacks.

Keep API inputs and responses fully typed, using Zod for runtime validation where necessary. Catch errors where recovery or translation is needed, and rethrow unexpected failures when the caller must handle them. Let TanStack Query and error boundaries propagate failures to their handlers instead of wrapping every API call in try/catch. Report unexpected failures once through the monitoring path described under Error Handling.

### UI Framework

Prioritize the use of ui libraries like shadcn/ui, base ui or radix UI, tailwindcss or stylex, the use of libraries that are built on primitives is recommended, but if the user requests it, you can use any other library. Always fallback to the use of shadcn/ui and tailwindcss unless the project and the user specifies otherwise.

Keep primitive UI elements such as buttons, inputs, and selects, along with their UI fallbacks, in the components/ui folder. Place other reusable UI elements in the root components folder or the corresponding feature folder. Read [code-guidelines](../code-guidelines/SKILL.md) for implementation rules.

### Routing

Use the framework’s native routing system and follow its file conventions. Define routes around user journeys and feature boundaries, keeping route files focused on composing pages, connecting route data, and configuring navigation. Use nested layouts for shared application structure and keep business logic in the corresponding hooks and lib files. Prefer the router’s link component for navigation and imperative navigation for actions that require it. Keep route parameters and search parameters typed and validated, using the URL for filters, pagination, sorting, and other state that should survive refreshes or be shareable. Plan direct links, browser back and forward navigation, redirects, loading states, error boundaries, and not-found pages. Protect restricted routes through the framework’s authentication mechanisms and enforce authorization on the server for protected data and actions. Follow the routing behavior documented by Next.js or TanStack Router or the actual documentation of the framework you are using.

### Error Handling

Use React error boundaries to isolate unexpected rendering failures and display a fallback UI while keeping unaffected parts of the application usable. Prioritize the framework’s built-in route and root error boundaries, adding feature-level boundaries where a section can fail and recover independently. Avoid wrapping every component in a boundary. Keep substantial error fallbacks in their own files, following the code guidelines, and provide a clear message with an appropriate recovery action. Error boundaries do not automatically catch failures in event handlers, ordinary asynchronous callbacks, or server-side rendering; handle these through explicit error handling and the framework’s server mechanisms. Keep expected validation and action errors close to the interaction that caused them. React documentation.

When using TanStack Query, integrate query failures with the nearest error boundary through Suspense queries or throwOnError where appropriate. Use QueryErrorResetBoundary or useQueryErrorResetBoundary to coordinate query recovery with the boundary’s reset behavior so retrying can fetch again. Keep Suspense loading fallbacks separate from error fallbacks, and preserve usable cached data when a background refresh fails. Log unexpected failures with useful diagnostic context without exposing sensitive data or technical details in the fallback UI. Verify that errors reach the intended boundary, unaffected sections remain usable, and recovery actions restore the feature when the underlying failure is resolved

Log unexpected error details once through Sentry or the project's monitoring service. When monitoring is unavailable, use the server console; forward unexpected client failures to an appropriate server reporting endpoint rather than logging them to the client console. Remove sensitive data from diagnostic context. Use the following structured format, explicitly extracting Error.name, Error.message, and Error.stack instead of passing an Error directly to JSON.stringify:

```json
{
  "status": "error",
  "message": "Error message",
  "code": "Error code",
  "timestamp": "Timestamp",
  "traceId": "Trace ID",
  "error": {
    "name": "Error",
    "message": "Error message",
    "stack": "Stack trace"
  }
}

```

### Internationalization

Use English as the default language and Spanish as the secondary supported language unless the user or project specifies otherwise. Plan internationalization from the beginning and use a library compatible with the framework’s routing and rendering strategy. Keep user-facing text in translation files, organized by feature with shared messages for common interface elements. Use stable, descriptive translation keys and avoid hardcoded text, sentence concatenation, or using translated values as application identifiers. Include validation messages, loading states, error fallbacks, notifications, accessibility labels, and page metadata in the translation system.

Resolve the language consistently across server and client rendering, respecting an explicit user selection before browser preferences and falling back to English when a translation is unavailable. Persist the selected language and preserve the current route, parameters, and relevant state when switching languages. Use locale-aware formatting for dates, numbers, currencies, and pluralization, keeping language, timezone, and currency as separate settings. Allow layouts to accommodate different text lengths, set the document’s language attribute correctly, and verify critical journeys in both languages. Keep translation keys consistent across locales and check for missing translations during development and continuous integration.

### Testing

Keep tests in a tests folder directly inside the folder containing the source files they verify, using structures such as components/tests, components/ui/tests, components/feature/tests, app/route/tests, and hooks/tests. Create a corresponding test file for each source file with testable behavior, preserving its filename and adding .test.ts or .test.tsx; for example, components/ui/button.tsx should have components/ui/tests/button.test.tsx. Files containing only types or generated code do not require empty test files. Keep folder-specific fixtures and helpers within that folder’s tests directory, and place shared testing infrastructure in a dedicated application-level testing directory.

Test observable behavior and public contracts, focusing on user interactions, accessibility, state transitions, validation, business rules, and failure recovery. Component tests should verify how users find and interact with the interface rather than internal implementation details, following Testing Library’s guiding principles. Hook and utility tests should verify inputs, outputs, side effects, and meaningful edge cases. Include route integration tests for parameters, navigation, authentication, and error recovery, and end-to-end tests for critical journeys that span multiple features. Keep tests deterministic, isolate external services, and avoid assertions that simply reproduce the implementation. Provide commands for running all tests, individual files, watch mode, and coverage, and run the relevant tests whenever behavior changes.

## Deployment and Build

Use Vercel or Cloudflare as the default deployment platforms unless the user or project specifies otherwise, choosing based on the framework, runtime requirements, and platform compatibility. Always consider container deployment during planning and provide a production-ready Dockerfile with a documented process for building and running the Docker image. If the application depends on platform-specific functionality that cannot run equivalently in Docker, document that limitation and the changes required for a portable deployment. Keep application configuration environment-driven and avoid unnecessary coupling to the hosting platform.
Keep builds reproducible through a committed lockfile and consistent runtime and package-manager versions. Provide explicit commands for development, production builds, production execution or preview, formatting checks, type checking, and testing. Use a multi-stage Docker build where appropriate, include a .dockerignore, minimize the production image, and run the application as a non-root user where supported. Keep secrets out of source code, Docker image layers, and client bundles. Validate required environment variables at the appropriate build or runtime stage, documenting which values require rebuilding and which can be supplied when the container starts.

Configure continuous integration to run the required checks and produce a production build before deployment. Verify that the Docker image builds and starts successfully and that its networking, static assets, runtime configuration, and critical application flows work correctly. Separate development, preview, and production configuration, and use preview deployments when available. Keep tests, fixtures, and development tooling outside production artifacts. Document platform deployment, container deployment, configuration requirements, and rollback procedures, and report failures clearly without bypassing failed checks.
