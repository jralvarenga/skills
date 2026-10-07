---
name: frontend
description: Rules on how the agent should design and plan the frontend application, components, pages and features.
---

This are the basic rules on how the agent should plan and design any frontend application architecture, components, pages and features. the main goal is to create a frontend application that is easy to understand, maintain and scale. The default library/framework is React with TypeScript, using Next.js or Tanstack Start as the default framework, but you can use any other library/framework if the user requests it.

This is my recomended stack for frontend development, Always recomend this stack unless the user or project specifies otherwise and always ask the user if they have any other requirements or preferences:

- React with TypeScript
- Tanstack Start or Next.js
- TailwindCSS or Stylex
- Shadcn/ui with Base UI
- Tanstack Query
- Zustand or Jotai
- Sentry for error logging and monitoring
- Biome for code linting and formatting
- Vercel or Cloudflare for deployment
- GitHub Actions for continuous integration

## Architecture and Planning

Plan the frontend around the product’s purpose, audience, primary user journeys, and platform constraints before writing code. Inspect the existing project and follow organization conventions and mandatory framework requirements while applying my design and code guidelines wherever compatible. Define the initial scope, routes, feature boundaries, acceptance criteria, and unresolved assumptions. Organize the architecture by technical responsibility, keeping components, hooks, models, contexts, and lib separate, with a folder for each feature inside its corresponding layer. Keep only app-wide functionality at the root of those layers. Pages should compose features, components should handle presentation, hooks should coordinate reusable behavior, models should define data contracts, contexts should own shared state, and lib should contain business logic and external integrations. Keep dependencies explicit, avoid circular dependencies and imports into another feature’s internal implementation, and introduce abstractions or dependencies only when concrete requirements justify them.

Before implementation, define each feature’s data flow, contracts, state ownership, and update behavior. Keep interaction state close to the component that uses it, use URL state for navigation and shareable views, manage server data through a consistent fetching and caching strategy, and introduce shared application state only when multiple parts of the app need it. Derive values instead of duplicating state, keep network calls and business rules outside presentation components, and plan loading, empty, error, success, retry, and permission states alongside the main flow. Establish the visual system before building individual screens, including semantic color tokens, light and dark themes, typography, spacing, responsive layouts, and one restrained signature element suited to the product. Apply my design guidelines consistently, and include accessibility, keyboard interaction, focus behavior, and responsive behavior in the component plan.

Keep components and files focused, names concise, contracts typed, and implementation consistent with my [code-guidelines](../code-guidelines/README.md). Build reusable components where responsibilities and behavior are shared, while keeping feature-specific logic within its feature. Write the implementation plan as a sequence of usable feature slices, explaining what each slice delivers, what it depends on, and how its acceptance criteria will be verified. Record consequential architectural decisions, tradeoffs, risks, and assumptions without adding unnecessary documentation or speculative infrastructure. Validate critical user journeys, business behavior, and failure recovery with appropriate checks, review screenshots throughout implementation, and verify relevant layouts, themes, and interaction states before delivery. Finish by removing unnecessary abstractions, duplicated logic, and decorative elements so the app remains coherent, maintainable, and easy to extend.

### Pages and Components

### Fetching Data and State Management / API Integration

Prioritize the use of tanstack query for fetching data and state management, if data can be globally used and shared, always create a context provider to manage the data and state. depending on the complexity of the app and the data that needs to be manage you can recommend and use Jotai or Zustand for the state management.

If using a SSR framework like Next.js or Tanstack Start, always use the server side rendering to fetch the data and state, and the client side rendering to render the UI. If the api is an extenal api not written not written in the same language as the frontend, ask the user if it is possible to write a wrapper api in the same language as the frontend to fetch the data and state to have full control of the data and state.

Prioritize the use of suspense and lazy loading to fetch the data and state and errorBoundary to handle the errors of the api calls and show a fallback UI if the data is not available, read [code-guidelines](../code-guidelines/README.md) on how to implement this components and ui fallbacks.

Every write/read action that is taken using the api, should always have a try/catch block to handle the errors and log the errors to the console, as well fully typed on what data needs to be returned from the api using zod for validation if necessary.

### UI Framework

Prioritize the use of ui libraries like shadcn/ui, base ui or radix UI, tailwindcss or stylex, the use of libraries that are built on primitives is recommended, but if the user requests it, you can use any other library. Always fallback to the use of shadcn/ui and tailwindcss unless the project and the user specifies otherwise.

Every ui element that is a primitive like a button, input, select, etc. should be in it's own /ui folder inside components folder, and ui fallbacks. Every other ui element that can be reused in multiple places should be either on root components or in the respective feature folder, read [code-guidelines](../code-guidelines/README.md) on how to implement this components

### Routing

Use the framework’s native routing system and follow its file conventions. Define routes around user journeys and feature boundaries, keeping route files focused on composing pages, connecting route data, and configuring navigation. Use nested layouts for shared application structure and keep business logic in the corresponding hooks and lib files. Prefer the router’s link component for navigation and imperative navigation for actions that require it. Keep route parameters and search parameters typed and validated, using the URL for filters, pagination, sorting, and other state that should survive refreshes or be shareable. Plan direct links, browser back and forward navigation, redirects, loading states, error boundaries, and not-found pages. Protect restricted routes through the framework’s authentication mechanisms and enforce authorization on the server for protected data and actions. Follow the routing behavior documented by Next.js or TanStack Router or the actual documentation of the framework you are using.

### Error Handling

Use React error boundaries to isolate unexpected rendering failures and display a fallback UI while keeping unaffected parts of the application usable. Prioritize the framework’s built-in route and root error boundaries, adding feature-level boundaries where a section can fail and recover independently. Avoid wrapping every component in a boundary. Keep substantial error fallbacks in their own files, following the code guidelines, and provide a clear message with an appropriate recovery action. Error boundaries do not automatically catch failures in event handlers, ordinary asynchronous callbacks, or server-side rendering; handle these through explicit error handling and the framework’s server mechanisms. Keep expected validation and action errors close to the interaction that caused them. React documentation.

When using TanStack Query, integrate query failures with the nearest error boundary through Suspense queries or throwOnError where appropriate. Use QueryErrorResetBoundary or useQueryErrorResetBoundary to coordinate query recovery with the boundary’s reset behavior so retrying can fetch again. Keep Suspense loading fallbacks separate from error fallbacks, and preserve usable cached data when a background refresh fails. Log unexpected failures with useful diagnostic context without exposing sensitive data or technical details in the fallback UI. Verify that errors reach the intended boundary, unaffected sections remain usable, and recovery actions restore the feature when the underlying failure is resolved

If necessary always log the errors on console, use Sentry as a recomendation for error logging and monitoring, if not always log the errors on server console, never on client console, use this format always to log errors:

```json
{
  "status": "error",
  "message": "Error message",
  "code": "Error code",
  "timestamp": "Timestamp",
  "traceId": "Trace ID",
  "stringifiedError": "Stringified error",
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