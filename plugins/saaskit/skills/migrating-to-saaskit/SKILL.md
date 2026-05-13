---
name: migrating-to-saaskit
description: Plans and executes incremental migration from any existing authentication system (Auth0, Firebase, Cognito, custom) to Scalekit SaaSKit. Use when a user mentions migrating, switching, or moving away from their current auth provider.
---

# SaaSKit Migration Planner

Guides an incremental, reversible migration from an existing auth system to Scalekit SaaSKit. Follow these phases in order — do not skip phases.

## Migration checklist

```
Migration Progress:
- [ ] Phase 1: Audit and export existing auth data
- [ ] Phase 2: Import organizations and users into Scalekit
- [ ] Phase 3: Configure redirects and roles
- [ ] Phase 4: Update application code
- [ ] Phase 5: Deploy and monitor
```

## Phase 1: Audit and export

Conduct a code audit covering:
- Sign-up/login flows, session middleware, token validation
- RBAC logic, email verification, logout/session termination

Export: user records, org/tenant structure, role assignments, SSO/IdP configs.

**Before proceeding:**
- [ ] Export a sample JWT or session cookie (understand current format)
- [ ] Set up a feature flag to roll back to old auth system
- [ ] Document rollback procedure

See [AUDIT-CHECKLIST.md](AUDIT-CHECKLIST.md) for full code audit patterns.

## Phase 2: Import organizations and users

`external_id` is critical — store original PKs to preserve mappings.

1. Create organizations first (with `externalId`).
2. Create users within organizations (with `externalId`).
3. Set `sendInvitationEmail: false` during import to skip invite emails.
4. Batch imports in parallel; respect Scalekit rate limits.

For language-specific samples (Node.js, Python, Go, Java, cURL): See [IMPORT-SAMPLES.md](IMPORT-SAMPLES.md).

## Phase 3: Configure redirects and roles

- Register callback URLs in **Settings → Redirects** in Scalekit dashboard.
- Define roles under **User Management → Roles** or via SDK.
- Verify role claims are readable from the token after login.

## Phase 4: Update application code

- Replace legacy JWT validation with Scalekit SDK or JWKS endpoint.
- Update login page branding in Scalekit dashboard.
- Update secondary flows: email verification, logout redirect.

## Phase 5: Deploy and monitor

1. Test login with a subset of migrated users.
2. Enable feature flag → route 5–10% of traffic to Scalekit.
3. Expand after stability confirmed.
4. Keep rollback plan active for first 48 hours.

## Deep reference

- Auth flows: [../../docs/auth-flows.md](../../docs/auth-flows.md) | Sessions: [../../docs/sessions.md](../../docs/sessions.md) | SSO: [../../docs/sso.md](../../docs/sso.md)

## When to switch skills

- Use `implementing-saaskit` for the new auth integration code.
- Use `implementing-modular-sso` if migrating SSO connections.
- Use `production-readiness-saaskit` before going live with the migration.
