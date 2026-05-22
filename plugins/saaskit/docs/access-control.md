# Access Control

Scalekit embeds `roles` and `permissions` in the access token. After validating the token, decode it to extract claims and enforce authorization server-side.

## Workflow

1. Validate the access token (expiry, signature).
2. Decode to extract `sub`, `oid` (organization ID), `roles`, and `permissions`.
3. Attach an auth context to the request for downstream handlers.
4. Enforce role or permission checks at route boundaries.

## Token claims

| Claim | Purpose |
|---|---|
| `sub` | Scalekit user ID |
| `oid` | Organization ID |
| `roles` | User roles in the organization (e.g., `admin`, `member`) |
| `permissions` | Granular permissions (e.g., `projects:read`, `tasks:assign`) |

## Middleware pattern

### Node.js (Express)

```js
const validateAndExtractAuth = async (req, res, next) => {
  try {
    const accessToken = decrypt(req.cookies.accessToken);
    const claims = await scalekit.validateAccessTokenAndGetClaims(accessToken);
    if (!claims)
      return res.status(401).json({ error: 'Invalid or expired token' });
    req.user = {
      id: claims.sub,
      organizationId: claims.oid,
      roles: claims.roles || [],
      permissions: claims.permissions || [],
    };
    next();
  } catch { return res.status(401).json({ error: 'Authentication failed' }); }
};

const requireRole = (role) => (req, res, next) =>
  req.user.roles.includes(role)
    ? next()
    : res.status(403).json({ error: `Required role: ${role}` });

const requirePermission = (perm) => (req, res, next) =>
  req.user.permissions.includes(perm)
    ? next()
    : res.status(403).json({ error: `Required permission: ${perm}` });

// Usage
app.get('/api/projects', validateAndExtractAuth, requirePermission('projects:read'), handler);
app.get('/api/admin/users', validateAndExtractAuth, requireRole('admin'), handler);
```

### Python (Flask)

```python
def validate_and_extract_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        access_token = decrypt(request.cookies.get('accessToken'))
        try:
            claims = scalekit_client.validate_access_token_and_get_claims(access_token)
        except Exception:
            return jsonify({'error': 'Invalid or expired token'}), 401
        request.user = {
            'id': claims.get('sub'),
            'organization_id': claims.get('oid'),
            'roles': claims.get('roles', []),
            'permissions': claims.get('permissions', []),
        }
        return f(*args, **kwargs)
    return decorated

def require_role(role):
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            if role not in getattr(request, 'user', {}).get('roles', []):
                return jsonify({'error': f'Required role: {role}'}), 403
            return f(*args, **kwargs)
        return decorated
    return decorator

def require_permission(permission):
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            if permission not in getattr(request, 'user', {}).get('permissions', []):
                return jsonify({'error': f'Required permission: {permission}'}), 403
            return f(*args, **kwargs)
        return decorated
    return decorator
```

## Guidance

- Use **roles** for broad access tiers (`admin`, `manager`, `member`).
- Use **permissions** for granular actions (`projects:create`, `reports:read`). Follow a `resource:action` naming convention.
- Common pattern: "admin bypass" — admins skip certain permission checks. "Resource ownership" — users can edit only their own resources unless elevated.
- Client-side checks are UX only. Server-side checks are authoritative.
- Always validate the token before trusting any claims.

## Permission claim fallback

SDKs check multiple claim keys for compatibility:

```
permissions → https://scalekit.com/permissions → scalekit:permissions
```

Use the first non-empty value.

## Related docs

- [auth-flows.md](auth-flows.md) — How tokens are obtained.
- [sessions.md](sessions.md) — Token validation and refresh middleware.
