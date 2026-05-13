---
name: adding-api-auth
description: Implements machine-to-machine authentication using Scalekit — either long-lived opaque API keys (org or user scoped) or OAuth 2.0 client credentials for service-to-service auth. Use when adding API key auth, building key management, or implementing client credentials flows.
---

# SaaSKit API Authentication

Implements machine-to-machine auth for APIs using Scalekit — API keys or OAuth 2.0 client credentials.

## Two approaches

| Approach | Best for | Token type | Lifetime |
|---|---|---|---|
| **API keys** | Developer-facing APIs, integrations | Opaque string | Long-lived, manually revoked |
| **Client credentials** | Service-to-service, microservices | JWT (access token) | Short-lived, auto-refreshed |

## When to use each

### API keys
- Your users need to call your API from scripts, CI/CD, or third-party integrations.
- You want org-scoped or user-scoped keys with custom permissions.
- You need a key management UI (create, list, revoke).

### Client credentials
- Backend services calling each other (no user context).
- You want automatic token rotation and expiry.
- You need audience-scoped tokens for zero-trust architectures.

## Workflow overview

### API keys

1. Create key via Scalekit SDK or dashboard (org-scoped or user-scoped).
2. Client sends key in `Authorization: Bearer <key>` header.
3. Your middleware validates the key via Scalekit API on each request.
4. Extract org/user context and permissions from the key metadata.

### Client credentials

1. Register a service client in Scalekit dashboard.
2. Service calls `POST /oauth/token` with `grant_type=client_credentials`.
3. Scalekit returns a short-lived JWT access token.
4. Receiving service validates the JWT using Scalekit's JWKS endpoint.

## Deep reference

- API auth patterns and code: [../../docs/api-auth.md](../../docs/api-auth.md)
- Access control (permission enforcement): [../../docs/access-control.md](../../docs/access-control.md)

## When to switch skills

- Use `implementing-saaskit` for user-facing browser authentication.
- Use `implementing-access-control` for permission enforcement on API endpoints.
- Use `adding-mcp-oauth` for MCP server authentication specifically.
