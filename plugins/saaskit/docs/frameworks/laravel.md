# Laravel

SaaSKit integration for Laravel using raw HTTP calls. There is no official Scalekit PHP SDK — the app uses Laravel's `Http` facade with `client_id`/`client_secret` Basic Auth.

Reference: [scalekit-inc/scalekit-laravel-auth-example](https://github.com/scalekit-inc/scalekit-laravel-auth-example)

## Project structure

```
app/Services/ScalekitClient.php          # Raw HTTP OAuth client
app/Http/Controllers/AuthController.php
app/Http/Middleware/
├── ScalekitAuth.php                     # Session auth gate
├── ScalekitPermission.php               # Per-route permission check
└── ScalekitTokenRefresh.php             # Auto token refresh
config/scalekit.php                      # Reads from env
routes/web.php                           # Named routes + middleware groups
```

## Environment

```env
SCALEKIT_ENV_URL=https://your-env.scalekit.io
SCALEKIT_CLIENT_ID=your-client-id
SCALEKIT_CLIENT_SECRET=your-client-secret
SCALEKIT_REDIRECT_URI=http://localhost:8000/auth/callback
```

Scopes are hardcoded in `config/scalekit.php`: `openid profile email offline_access`.

## ScalekitClient (raw HTTP)

Key methods and their HTTP calls:

| Method | HTTP call |
|---|---|
| `getAuthorizationUrl($state)` | Builds `{env_url}/oauth/authorize?...` |
| `exchangeCodeForTokens($code)` | `POST {env_url}/oauth/token` with Basic Auth |
| `refreshAccessToken($rt)` | `POST {env_url}/oauth/token` with Basic Auth |
| `validateTokenAndGetClaims($token)` | Base64 JWT decode (no signature verification) |
| `logout($accessToken)` | Builds `{env_url}/oidc/logout?...` |

JWT decode pattern:

```php
$parts = explode('.', $token);
$payload = base64_decode(strtr($parts[1], '-_', '+/'));
$claims = json_decode($payload, true);
```

Permission claim fallback:

```php
$permissions = $claims['permissions']
    ?? $claims['https://scalekit.com/permissions']
    ?? $claims['scalekit:permissions']
    ?? [];
```

## Session storage

All auth state in Laravel's session — no extra DB tables:

```php
session(['scalekit_user' => [...], 'scalekit_tokens' => [...],
         'scalekit_roles' => [...], 'scalekit_permissions' => [...]]);
```

## Middleware registration

Laravel 11 (`bootstrap/app.php`):

```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->alias([
        'scalekit.auth'       => ScalekitAuth::class,
        'scalekit.permission' => ScalekitPermission::class,
    ]);
    $middleware->append(ScalekitTokenRefresh::class);
})
```

## Routes

```php
Route::middleware(['scalekit.auth'])->group(function () {
    Route::get('/dashboard', [AuthController::class, 'dashboard']);
    Route::get('/organization/settings', [AuthController::class, 'organizationSettings'])
        ->middleware('scalekit.permission:organization:settings');
});
```

Permission middleware uses colon-separated syntax: `scalekit.permission:organization:settings`.

## Auth flow

**Login** — generates CSRF state, stores in session, builds auth URL, renders login template.

**Callback** — validates state, exchanges code via `Http::asForm()->withBasicAuth(...)`, decodes ID token for profile, gets access token claims for roles/permissions, writes session, redirects to dashboard.

**Logout** — reads access token, clears session with `session()->flush()`, redirects to Scalekit's `/oidc/logout`.

**Token refresh** — `ScalekitTokenRefresh` middleware runs on every request (skips login/callback/logout paths). Buffer: 5 minutes. On `invalid_grant`, flushes session.

## Tactics

- **SameSite=Lax** in `config/session.php` — `strict` breaks OAuth callbacks.
- **No CSRF exclusion needed** for the callback — it's a GET request.
- **Deep link preservation** — `ScalekitAuth` middleware passes `->with('next', $request->path())`. Read in `login()` with `$request->query('next')`.
- **Session fixation** — call `session()->regenerate()` after writing session data in `callback()`.
- **Cache-Control: no-store** — add `->header('Cache-Control', 'no-store')` to protected responses.
- **AJAX** — update `ScalekitAuth` to return `401` for `$request->expectsJson()`.
- **CORS** — configure `config/cors.php` with `supports_credentials => true` and explicit origins.

## Install

```bash
composer require firebase/php-jwt  # optional, for JWT signature verification
php artisan key:generate
php artisan migrate
php artisan serve
```

## Related docs

- [auth-flows.md](../auth-flows.md) — Framework-agnostic auth flow reference.
- [sessions.md](../sessions.md) — Token storage patterns.
