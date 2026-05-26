# Auth Flows

SaaSKit implements OIDC/OAuth 2.0 authorization code flow. The app redirects the user to Scalekit, receives an authorization code on callback, and exchanges it for tokens.

## Environment setup

```sh
SCALEKIT_ENVIRONMENT_URL=<your-environment-url>
SCALEKIT_CLIENT_ID=<your-client-id>
SCALEKIT_CLIENT_SECRET=<your-client-secret>
```

## Login redirect

Generate an authorization URL and redirect the user's browser:

```js
// Node.js
const authorizationUrl = scalekit.getAuthorizationUrl(redirectUri, {
  scopes: ['openid', 'profile', 'email', 'offline_access']
});
res.redirect(authorizationUrl);
```

```python
# Python
options = AuthorizationUrlOptions()
options.scopes = ['openid', 'profile', 'email', 'offline_access']
auth_url = scalekit_client.get_authorization_url(redirect_uri, options=options)
```

`redirectUri` must exactly match the callback URL registered in the Scalekit dashboard. Include `offline_access` to receive a refresh token.

## Dedicated signup

To force the signup UI instead of login, add `prompt: 'create'` to the authorization URL options.

## Callback and token exchange

Exchange the authorization code for tokens:

```js
// Node.js
const { user, idToken, accessToken, refreshToken } =
  await scalekit.authenticateWithCode(code, redirectUri);
```

```python
# Python
result = scalekit_client.authenticate_with_code(code, redirect_uri)
access_token = result.get('access_token')
refresh_token = result.get('refresh_token')
```

### Token purposes

| Token | Purpose | Lifetime |
|---|---|---|
| `accessToken` | Roles, permissions, org context. Used for API authorization. | ~5 min (configurable) |
| `refreshToken` | Renew access tokens without re-authentication. | Long-lived |
| `idToken` | User profile claims (sub, email, name). Used for logout. | ~15 min |

## Token refresh

When the access token expires, use the refresh token to obtain new tokens:

```js
// Node.js
const refreshed = await scalekit.refreshAccessToken(refreshToken);
```

```python
# Python
refreshed = scalekit_client.refresh_access_token(refresh_token)
```

If refresh fails (e.g., `invalid_grant`), the user must re-authenticate. See [sessions.md](sessions.md) for middleware patterns that handle this transparently.

## Logout

Logout requires two steps: clear your application session, then redirect the browser to Scalekit's OIDC end-session endpoint.

**Key constraints:**
- The logout call **must** be a browser redirect (top-level navigation), not a `fetch`/XHR.
- Read `idToken` **before** clearing cookies — it's used as `id_token_hint`.
- `post_logout_redirect_uri` must be allowlisted in the Scalekit dashboard.

```js
// Node.js
const idTokenHint = req.cookies?.idToken; // read BEFORE clearing
const logoutUrl = scalekit.getLogoutUrl({ idTokenHint, postLogoutRedirectUri });
res.clearCookie('accessToken', { path: '/' });
res.clearCookie('refreshToken', { path: '/' });
res.redirect(logoutUrl);
```

```python
# Python (Flask)
id_token = request.cookies.get("idToken")
from scalekit.common.scalekit import LogoutUrlOptions
logout_url = scalekit_client.get_logout_url(options=LogoutUrlOptions(
    id_token_hint=id_token,
    post_logout_redirect_uri=post_logout_redirect_uri,
))
resp = make_response(redirect(logout_url))
resp.set_cookie("accessToken", "", max_age=0, path="/")
resp.set_cookie("refreshToken", "", max_age=0, path="/")
return resp
```

## Cross-language SDK reference

| Operation | Node.js | Python | Go | Java |
|---|---|---|---|---|
| Auth URL | `getAuthorizationUrl` | `get_authorization_url` | `GetAuthorizationUrl` | `getAuthorizationUrl` |
| Exchange code | `authenticateWithCode` | `authenticate_with_code` | `AuthenticateWithCode` | `authenticateWithCode` |
| Validate token | `validateAccessToken` | `validate_access_token` | `ValidateAccessToken` | `validateAccessToken` |
| Refresh token | `refreshAccessToken` | `refresh_access_token` | `RefreshAccessToken` | `refreshToken` |
| Logout URL | `getLogoutUrl` | `get_logout_url` | `GetLogoutUrl` | `getLogoutUrl` |

## Related docs

- [sessions.md](sessions.md) — Storing tokens, refresh middleware, remote revocation.
- [access-control.md](access-control.md) — Using token claims for authorization.
- [sso.md](sso.md) — Enterprise SSO flows that build on the same auth flow.
