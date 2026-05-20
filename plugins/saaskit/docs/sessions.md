# Sessions

After authentication, the app receives access, refresh, and (optionally) ID tokens. This doc covers secure storage, transparent refresh, and remote session management.

## Storage rules

- Store access and refresh tokens in **separate** HttpOnly cookies.
- Set `Secure` in production (HTTPS only). Set `SameSite` to `Lax` (not `Strict` — Strict breaks OAuth redirects).
- Scope cookies with `Path` to reduce exposure: access token to `/api`, refresh token to `/auth/refresh`.
- Encrypt tokens before storing them in cookies as an extra layer against cookie theft.

## Storing tokens

```js
// Node.js (Express)
res.cookie('accessToken', encrypt(accessToken), {
  maxAge: (expiresIn - 60) * 1000,
  httpOnly: true, secure: isProd, sameSite: 'lax', path: '/api',
});
res.cookie('refreshToken', encrypt(refreshToken), {
  httpOnly: true, secure: isProd, sameSite: 'lax', path: '/auth/refresh',
});
```

```python
# Python (Flask)
resp.set_cookie('accessToken', encrypt(access_token),
    max_age=expires_in - 60, httponly=True, secure=is_prod,
    samesite='Lax', path='/api')
resp.set_cookie('refreshToken', encrypt(refresh_token),
    httponly=True, secure=is_prod, samesite='Lax', path='/auth/refresh')
```

Store the ID token separately if your logout flow needs it (see [auth-flows.md](auth-flows.md)).

## Validate-and-refresh middleware

Run on every protected request:

1. Read and decrypt the access token cookie.
2. Call `validateAccessToken()`. If valid, proceed.
3. If invalid and a refresh token exists, call `refreshAccessToken()`, update cookies, proceed.
4. If refresh fails, return 401 — force re-login.

```js
// Node.js
async function verifySession(req, res, next) {
  const accessCookie = req.cookies?.accessToken;
  if (!accessCookie) return res.status(401).json({ error: 'Authentication required' });
  try {
    const token = decrypt(accessCookie);
    if (await scalekit.validateAccessToken(token)) return next();
    const refreshCookie = req.cookies?.refreshToken;
    if (!refreshCookie) return res.status(401).json({ error: 'Session expired' });
    const result = await scalekit.refreshAccessToken(decrypt(refreshCookie));
    // Rewrite cookies with new tokens, then next()
  } catch { return res.status(401).json({ error: 'Authentication failed' }); }
}
```

```python
# Python (Flask decorator)
def verify_session(f):
    @wraps(f)
    def inner(*args, **kwargs):
        access_cookie = request.cookies.get('accessToken')
        if not access_cookie:
            return jsonify({'error': 'Authentication required'}), 401
        try:
            token = decrypt(access_cookie)
            if scalekit_client.validate_access_token(token):
                return f(*args, **kwargs)
            refresh_cookie = request.cookies.get('refreshToken')
            if not refresh_cookie:
                return jsonify({'error': 'Session expired'}), 401
            result = scalekit_client.refresh_access_token(decrypt(refresh_cookie))
            # Rewrite cookies with new tokens, then call f()
        except Exception:
            return jsonify({'error': 'Authentication failed'}), 401
    return inner
```

## Remote session management

Use Scalekit session APIs for multi-device controls:

```js
// Node.js
// List active sessions for a user
const sessions = await scalekit.session.getUserSessions(userId, {
  pageSize: 10, filter: { status: ['ACTIVE'] }
});
// Revoke a single session
await scalekit.session.revokeSession(sessionId);
// Revoke all sessions for a user
await scalekit.session.revokeAllUserSessions(userId);
```

## Dashboard-driven configuration

Session timeouts and token lifetimes are configurable in the Scalekit dashboard without code changes:
- Absolute session timeout (max total session time)
- Idle session timeout (logout after inactivity)
- Access token lifetime (drives refresh frequency)

## SPA/mobile note

For SPAs, prefer: access token in memory via `Authorization: Bearer` headers, refresh token in an HttpOnly cookie. Configure CSRF protections explicitly when using cookies in browser SPAs.

## Related docs

- [auth-flows.md](auth-flows.md) — Login, callback, logout flows.
- [access-control.md](access-control.md) — Extracting roles/permissions from validated tokens.
