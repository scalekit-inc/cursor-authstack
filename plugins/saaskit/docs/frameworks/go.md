# Go (Gin)

SaaSKit integration for Go using `scalekit-sdk-go/v2` with the Gin framework.

Reference: [scalekit-inc/coffee-desk-demo](https://github.com/scalekit-inc/coffee-desk-demo)

## Dependencies

```bash
go get github.com/scalekit-inc/scalekit-sdk-go/v2
go get github.com/gin-gonic/gin
go get github.com/gin-contrib/cors
go get github.com/golang-jwt/jwt/v5
```

## Environment

```bash
SCALEKIT_ENVIRONMENT_URL=https://your-env.scalekit.dev
SCALEKIT_CLIENT_ID=your_client_id
SCALEKIT_CLIENT_SECRET=your_client_secret
```

## Client initialization

Use `sync.Once` to create a single client instance:

```go
var (
    globalClient scalekit.Scalekit
    clientOnce   sync.Once
)

func GetScaleKitClient() scalekit.Scalekit {
    clientOnce.Do(func() {
        globalClient = scalekit.NewScalekitClient(
            os.Getenv("SCALEKIT_ENVIRONMENT_URL"),
            os.Getenv("SCALEKIT_CLIENT_ID"),
            os.Getenv("SCALEKIT_CLIENT_SECRET"),
        )
    })
    return globalClient
}
```

## Auth flow

### Authorize

```go
func AuthorizeHandler(c *gin.Context) {
    sc := GetScaleKitClient()
    opts := scalekit.AuthorizationUrlOptions{
        State:  base64EncodedState, // includes CSRF token + next URL
        Scopes: []string{"openid", "profile", "email", "offline_access"},
    }
    if v := c.Query("organization_id"); v != "" { opts.OrganizationId = v }
    authURL, _ := sc.GetAuthorizationUrl(callbackURL(c), opts)
    c.Redirect(http.StatusFound, authURL.String())
}
```

### Callback

```go
func CallbackHandler(c *gin.Context) {
    sc := GetScaleKitClient()
    resp, _ := sc.AuthenticateWithCode(c.Request.Context(), c.Query("code"), callbackURL(c),
        scalekit.AuthenticationOptions{})
    c.SetCookie("auth_access_token", resp.AccessToken, 86400, "/", "", false, true)
    c.SetCookie("auth_refresh_token", resp.RefreshToken, 2592000, "/", "", false, true)
    c.SetCookie("id_token", resp.IdToken, 86400, "/", "", false, false)
    // Route based on xoid claim: present → /dashboard, absent → /onboarding
}
```

### Session validation and refresh

```go
func SessionHandler(c *gin.Context) {
    c.Header("Cache-Control", "no-store")
    accessToken, _ := c.Cookie("auth_access_token")
    sc := GetScaleKitClient()
    valid, _ := sc.ValidateAccessToken(c.Request.Context(), accessToken)
    if !valid {
        refreshToken, _ := c.Cookie("auth_refresh_token")
        refreshed, err := sc.RefreshAccessToken(c.Request.Context(), refreshToken)
        if err != nil { LogoutHandler(c); return }
        c.SetCookie("auth_access_token", refreshed.AccessToken, 86400, "/", "", false, true)
        accessToken = refreshed.AccessToken
    }
    claims, _ := decodeJWTPayload(accessToken)
    // Return user info from claims
}
```

### Logout

```go
func LogoutHandler(c *gin.Context) {
    idToken, _ := c.Cookie("id_token")
    sc := GetScaleKitClient()
    logoutURL, _ := sc.GetLogoutUrl(scalekit.LogoutUrlOptions{
        IdTokenHint: idToken, PostLogoutRedirectUri: getUIBaseURL(c),
    })
    c.SetCookie("auth_access_token", "", -1, "/", "", false, true)
    c.SetCookie("auth_refresh_token", "", -1, "/", "", false, true)
    c.SetCookie("id_token", "", -1, "/", "", false, false)
    c.Redirect(http.StatusFound, logoutURL.String())
}
```

### IdP-initiated login

```go
func IdpInitiatedLoginHandler(c *gin.Context) {
    sc := GetScaleKitClient()
    claims, _ := sc.GetIdpInitiatedLoginClaims(c.Request.Context(), c.Query("idp_initiated_login"))
    opts := scalekit.AuthorizationUrlOptions{
        Scopes: []string{"openid", "profile", "email", "offline_access"},
    }
    if claims.OrganizationID != "" { opts.OrganizationId = claims.OrganizationID }
    if claims.ConnectionID != "" { opts.ConnectionId = claims.ConnectionID }
    authURL, _ := sc.GetAuthorizationUrl(callbackURL(c), opts)
    c.Redirect(http.StatusFound, authURL.String())
}
```

## JWT claims

| Claim | Meaning |
|---|---|
| `sub` | Scalekit user ID |
| `xoid` | External org ID. Absent = user has no org → route to onboarding. |
| `xuid` | App's user DB ID. Absent = create user locally. |
| `permissions` | User permissions in org |
| `roles` | User roles in org |

## Route registration

```go
api := r.Group("/api")
api.GET("/authorize", AuthorizeHandler)
api.GET("/login/initiate", IdpInitiatedLoginHandler)
api.GET("/scalekit/callback", CallbackHandler)
api.GET("/session", SessionHandler)
api.GET("/logout", LogoutHandler)
```

## Tactics

- **SameSite=Lax** — Gin's `c.SetCookie` doesn't expose SameSite. Use `http.SetCookie` directly with `SameSite: http.SameSiteLaxMode`.
- **Secure flag** — detect localhost at runtime: `!strings.Contains(c.Request.Host, "localhost")`.
- **CORS** — `AllowCredentials: true` is required for cookie-based auth.
- **Token refresh race** — use a per-user mutex or treat `invalid_grant` as session expiry.
- **JSON clients** — return `401` for `Accept: application/json`, redirect otherwise.

## Related docs

- [auth-flows.md](../auth-flows.md) — Framework-agnostic auth flow reference.
- [sessions.md](../sessions.md) — Token storage patterns.
