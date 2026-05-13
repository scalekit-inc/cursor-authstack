---
name: implementing-access-control
description: Implements server-side RBAC and permission checks by validating access tokens, extracting roles and permissions, and enforcing them with middleware or decorators. Use when building authorization around Scalekit tokens.
---

# SaaSKit Access Control

Implements RBAC and permission enforcement using claims from Scalekit access tokens.

## When to use

Use this skill **after** authentication is working (tokens are being issued and validated). Access control builds on top of a working auth flow — if login/sessions aren't set up yet, start with `implementing-saaskit`.

## How it works

Scalekit embeds `roles` and `permissions` claims directly in the access token JWT. Your app extracts these claims and enforces them at the middleware or handler level.

### Token claims used for access control

| Claim | Type | Example |
|---|---|---|
| `roles` | `string[]` | `["admin", "member"]` |
| `permissions` | `string[]` | `["organization:settings", "billing:read"]` |
| `xoid` | `string` | `wspace_abc` — the org context |

## Workflow overview

1. **Define roles and permissions** in Scalekit dashboard (User Management → Roles).
2. **Assign roles** to users during import, invitation, or via the SDK.
3. **Extract claims** from the validated access token in your middleware.
4. **Enforce** — check `permissions` array before allowing the action.

## Enforcement patterns

### Middleware-based (recommended)

```
Request → Auth middleware (validate token) → Permission middleware (check claims) → Handler
```

### Decorator/guard-based

```python
@require_permission("billing:read")
def get_invoices(request):
    ...
```

### Inline check

```typescript
if (!tokenClaims.permissions.includes('organization:settings')) {
  return res.status(403).json({ error: 'Forbidden' });
}
```

## Best practices

- Check `permissions`, not `roles` — permissions are granular and composable.
- Return `403 Forbidden` (not `401`) when the user is authenticated but lacks permission.
- Log permission denials for security auditing.
- Set default roles for new users and JIT-provisioned users.

## Deep reference

- Access control patterns and code: [../../docs/access-control.md](../../docs/access-control.md)
- Session management (where claims are extracted): [../../docs/sessions.md](../../docs/sessions.md)
- Framework-specific examples: [../../docs/frameworks/](../../docs/frameworks/)

## When to switch skills

- Use `implementing-saaskit` if auth isn't set up yet.
- Use `managing-saaskit-sessions` for token validation and refresh.
- Use `production-readiness-saaskit` to verify RBAC enforcement before launch.
