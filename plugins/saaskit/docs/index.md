# SaaSKit Docs

This `docs/` directory is the canonical documentation layer for the `saaskit` plugin.

SaaSKit (formerly Full-Stack Auth) is Scalekit's end-to-end authentication and authorization toolkit for SaaS applications. It covers the complete lifecycle: login, sessions, access control, SSO, SCIM provisioning, API auth, and MCP server auth.

## Official Scalekit docs

- [LLM docs map](https://docs.scalekit.com/llms.txt)
- [Docs sitemap](https://docs.scalekit.com/sitemap-0.xml)
- [Authentication overview](https://docs.scalekit.com/authentication)
- [SSO integrations](https://docs.scalekit.com/guides/integrations/sso-integrations/)
- [SCIM quickstart](https://docs.scalekit.com/directory/scim/quickstart/)
- [MCP authentication](https://docs.scalekit.com/guides/mcp/)
- [API references](https://docs.scalekit.com/apis/)

## How this directory is organized

Core concepts:

- [auth-flows.md](auth-flows.md) — Login, signup, callback, token exchange, logout, and token refresh.
- [sessions.md](sessions.md) — Secure cookie storage, token separation, encryption, refresh middleware, remote revocation.
- [access-control.md](access-control.md) — Decoding access tokens for roles/permissions, middleware guards.

Enterprise features:

- [sso.md](sso.md) — Modular SSO flow, IdP-initiated login, admin portal embed.
- [scim.md](scim.md) — Directory sync webhooks, user lifecycle events, group sync.

API and machine auth:

- [api-auth.md](api-auth.md) — API key creation/validation/revocation, OAuth 2.0 client credentials for M2M.
- [mcp-server-auth.md](mcp-server-auth.md) — OAuth 2.1 for MCP servers, discovery endpoints, token validation.

Framework guides:

- [frameworks/nextjs.md](frameworks/nextjs.md) — Next.js App Router integration.
- [frameworks/python.md](frameworks/python.md) — Django, FastAPI, and Flask integration.
- [frameworks/go.md](frameworks/go.md) — Go/Gin integration.
- [frameworks/springboot.md](frameworks/springboot.md) — Spring Boot 3.x integration.
- [frameworks/laravel.md](frameworks/laravel.md) — Laravel integration (raw HTTP, no PHP SDK).

## Relationship to skills and rules

- `skills/` contains task-oriented workflows that should stay thin and point here for deeper reference.
- These docs extract the durable, canonical knowledge from skill files into a navigable reference layer.
