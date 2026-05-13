---
name: managing-saaskit-sessions
description: Manages Scalekit SaaSKit user sessions by securely storing tokens, validating access tokens on requests, refreshing tokens in middleware, and revoking sessions via Scalekit APIs. Use when building session persistence for web apps or auditing session management.
---

# SaaSKit Session Management

Covers secure token storage, validation middleware, silent refresh, and session revocation for Scalekit-powered apps.

## What this skill covers

- Choosing a token storage strategy (httpOnly cookies vs server-side session store)
- Validating access tokens on every authenticated request
- Implementing silent token refresh in middleware
- Revoking sessions and handling forced logout
- Auditing active sessions

## Inputs to collect

Before implementing, determine:

1. **App type** — server-rendered (Next.js, Django, Rails) or SPA + API?
2. **Framework** — which SDK/framework is in use? (routes to correct patterns)
3. **Token storage plan** — httpOnly cookies (default recommendation) or server-side store (Redis, DB)?

## Session lifecycle

```
Login callback → Store tokens → Validate on each request → Refresh when expired → Revoke on logout
```

### Storage recommendations

| App type | Recommended storage | Notes |
|---|---|---|
| Server-rendered | httpOnly + secure + SameSite=Lax cookies | Simplest; no JS access to tokens |
| SPA + API | Server-side session store (Redis) | API sets a session ID cookie; tokens stay server-side |
| Mobile / native | Secure enclave / Keychain | Never store in localStorage |

### Token refresh pattern

Middleware should check token expiry **before** it expires — use a 5-minute buffer:

```
if (tokenExpiresAt - now < 5 minutes) → refresh silently
if (refresh fails with invalid_grant) → clear session → redirect to login
```

### Session revocation

On logout, always:
1. Clear local session/cookies
2. Redirect to Scalekit's end-session endpoint (OIDC RP-initiated logout)
3. The end-session endpoint invalidates the refresh token server-side

## Deep reference

- Session patterns and code: [../../docs/sessions.md](../../docs/sessions.md)
- Auth flow (where tokens come from): [../../docs/auth-flows.md](../../docs/auth-flows.md)
- Framework-specific session handling: [../../docs/frameworks/](../../docs/frameworks/)

## When to switch skills

- Use `implementing-saaskit` for the initial auth setup that produces the tokens.
- Use `implementing-access-control` for RBAC checks on the validated session.
- Use `production-readiness-saaskit` to audit session security before launch.
