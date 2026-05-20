# API Auth

Two mechanisms for authenticating API requests: opaque **API keys** for simple bearer auth, and **OAuth 2.0 client credentials** for M2M (machine-to-machine) JWT auth.

## API keys

Long-lived opaque tokens scoped to an organization or user. Scalekit manages creation, validation, and revocation.

### Create

```js
// Node.js — org-scoped
const { token, tokenId } = await scalekit.token.createToken(organizationId, {
  description: 'CI/CD pipeline token',
});
// token is the plain-text key — shown only once. tokenId is for lifecycle ops.
```

```python
# Python — user-scoped with custom claims
response = scalekit_client.tokens.create_token(
    organization_id=org_id,
    user_id='usr_12345',
    custom_claims={'team': 'engineering', 'environment': 'production'},
    description='Deployment token',
)
opaque_token = response.token
token_id = response.token_id
```

The plain-text key is **returned only once at creation**. Store it securely — Scalekit never stores it.

### Validate

Call on every incoming API request. Returns org/user context on success, throws on invalid or revoked keys.

```js
// Node.js
const result = await scalekit.token.validateToken(bearerToken);
const { organizationId, userId, customClaims } = result.tokenInfo;
```

```python
# Python
result = scalekit_client.tokens.validate_token(token=bearer_token)
org_id = result.token_info.organization_id
user_id = result.token_info.user_id  # empty for org-scoped keys
```

### Revoke

Instant and idempotent — safe to call on already-revoked keys.

```js
await scalekit.token.invalidateToken(tokenOrTokenId);
```

```python
scalekit_client.tokens.invalidate_token(token=token_or_token_id)
```

### Middleware pattern

```js
// Node.js (Express)
async function authenticateToken(req, res, next) {
  const token = (req.headers.authorization || '').replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Missing token' });
  try {
    const result = await scalekit.token.validateToken(token);
    req.tokenInfo = result.tokenInfo;
    next();
  } catch { return res.status(401).json({ error: 'Invalid or expired token' }); }
}
```

```python
# Python (Flask)
def authenticate_token(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        auth = request.headers.get('Authorization', '')
        if not auth.startswith('Bearer '):
            return jsonify({'error': 'Missing token'}), 401
        try:
            result = scalekit_client.tokens.validate_token(token=auth.split(' ', 1)[1])
            g.token_info = result.token_info
        except Exception:
            return jsonify({'error': 'Invalid or expired token'}), 401
        return f(*args, **kwargs)
    return wrapper
```

### Key rules

- **Show `token` once** — display at creation, then discard.
- **Use `token_id`** for list/revoke operations (not the key itself).
- **Rotate safely** — create new → update consumer → verify → revoke old.

## OAuth 2.0 client credentials (M2M)

For service-to-service auth. Register an API client, issue `client_id` + `client_secret`, and the client fetches short-lived JWTs from Scalekit's token endpoint.

### Register a client

```python
from scalekit.v1.clients.clients_pb2 import OrganizationClient

response = scalekit_client.m2m_client.create_organization_client(
    organization_id='<ORG_ID>',
    m2m_client=OrganizationClient(
        name='GitHub Actions',
        scopes=['deploy:applications', 'read:deployments'],
        audience=['deployment-api.acmecorp.com'],
        expiry=3600,
    )
)
client_id = response.client.client_id
plain_secret = response.plain_secret  # shown once
```

### Client fetches a token

```bash
curl -X POST "$SCALEKIT_ENVIRONMENT_URL/oauth/token" \
  -d "grant_type=client_credentials" \
  -d "client_id=<CLIENT_ID>" \
  -d "client_secret=<CLIENT_SECRET>"
```

Returns a JWT with `scopes`, `oid` (org ID), `iss`, and `exp`.

### Validate and enforce scopes

```python
# Python — SDK handles JWKS automatically
claims = scalekit_client.validate_access_token_and_get_claims(token=bearer_token)
if required_scope not in claims.get('scopes', []):
    return 403
```

```js
// Node.js — manual JWKS
import jwksClient from 'jwks-rsa';
import jwt from 'jsonwebtoken';

const jwks = jwksClient({ jwksUri: `${ENV_URL}/.well-known/jwks.json`, cache: true });
const decoded = jwt.decode(token, { complete: true });
const key = await jwks.getSigningKey(decoded.header.kid);
const payload = jwt.verify(token, key.getPublicKey(), { algorithms: ['RS256'] });
if (!payload.scopes.includes(requiredScope)) return res.status(403).end();
```

### Scope naming

Use `resource:action` convention: `deployments:read`, `applications:create`.

## Related docs

- [mcp-server-auth.md](mcp-server-auth.md) — OAuth 2.1 for MCP servers.
- [access-control.md](access-control.md) — Role/permission checks for user-facing auth.
