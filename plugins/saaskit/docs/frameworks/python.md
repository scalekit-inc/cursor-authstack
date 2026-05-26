# Python Frameworks

SaaSKit integration for Django, FastAPI, and Flask. All three use `scalekit-sdk-python` and share the same SDK methods, but differ in session handling and middleware patterns.

## Common setup

```bash
pip install scalekit-sdk-python python-dotenv
```

```env
SCALEKIT_ENVIRONMENT_URL=https://your-env.scalekit.com
SCALEKIT_CLIENT_ID=your_client_id
SCALEKIT_CLIENT_SECRET=your_client_secret
SCALEKIT_REDIRECT_URI=http://localhost:8000/auth/callback
```

Include `offline_access` in scopes to receive a refresh token.

### SDK client wrapper

All frameworks use the same SDK under the hood:

```python
from scalekit import ScalekitClient

client = ScalekitClient(
    env_url=os.getenv('SCALEKIT_ENVIRONMENT_URL'),
    client_id=os.getenv('SCALEKIT_CLIENT_ID'),
    client_secret=os.getenv('SCALEKIT_CLIENT_SECRET'),
)
```

### Session data schema

All three frameworks store the same keys in the session:

| Key | Contents |
|---|---|
| `scalekit_user` | `sub`, `email`, `name`, `given_name`, `family_name` |
| `scalekit_tokens` | `access_token`, `refresh_token`, `id_token`, `expires_at`, `expires_in` |
| `scalekit_roles` | `['admin', ...]` |
| `scalekit_permissions` | `['organization:settings', ...]` |

---

## Django

Reference: [scalekit-inc/scalekit-django-auth-example](https://github.com/scalekit-inc/scalekit-django-auth-example)

### Key settings

```python
MIDDLEWARE = [
    'django.contrib.sessions.middleware.SessionMiddleware',
    'auth_app.middleware.ScalekitTokenRefreshMiddleware',  # after SessionMiddleware
]
SESSION_COOKIE_SAMESITE = 'Lax'      # never Strict
SESSION_SAVE_EVERY_REQUEST = True     # ensures OAuth state survives redirects
```

### Route protection

```python
from auth_app.decorators import login_required, permission_required

@login_required
def dashboard_view(request): ...

@permission_required('organization:settings')
def org_settings_view(request): ...
```

`@login_required` appends `?next=<path>` for deep link preservation. Session fixation: call `request.session.cycle_key()` after writing session data in the callback.

### Token refresh

`ScalekitTokenRefreshMiddleware` runs on every request (skips `/login`, `/auth/callback`, `/logout`). Buffer: 1 minute before expiry.

---

## FastAPI

Reference: [scalekit-inc/scalekit-fastapi-auth-example](https://github.com/scalekit-inc/scalekit-fastapi-auth-example)

### App setup

```python
from starlette.middleware.sessions import SessionMiddleware

app = FastAPI()
app.add_middleware(ScalekitTokenRefreshMiddleware)  # add first (runs after session)
app.add_middleware(SessionMiddleware, secret_key=settings.secret_key,
    max_age=3600, same_site='lax', https_only=False)
```

Middleware registration order matters in Starlette: middleware added later wraps earlier ones and executes first. `SessionMiddleware` must run before `ScalekitTokenRefreshMiddleware`.

### Route protection

```python
from app.dependencies import require_login, require_permission

@router.get("/dashboard")
async def dashboard(request: Request, user: dict = Depends(require_login)):
    return {"user": user}

@router.get("/admin/settings")
async def admin(request: Request, user: dict = Depends(require_permission('organization:settings'))):
    return {"message": "Authorized"}
```

### Token refresh

`ScalekitTokenRefreshMiddleware` auto-refreshes 5 minutes before expiry. On `invalid_grant`, clear the session to force re-login.

---

## Flask

Reference: [scalekit-inc/scalekit-flask-auth-example](https://github.com/scalekit-inc/scalekit-flask-auth-example)

### App factory

```python
def create_app():
    app = Flask(__name__)
    app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
    app.config['SESSION_COOKIE_HTTPONLY'] = True
    app.before_request(TokenRefreshMiddleware.process_request)
    return app
```

`ScalekitClient` must be instantiated inside a request context (not at module level) because it reads from `current_app.config`.

### Route protection

```python
from auth_app.decorators import login_required, permission_required

@auth_bp.route('/dashboard')
@login_required
def dashboard(): ...

@auth_bp.route('/organization/settings')
@permission_required('organization:settings')
def org_settings(): ...
```

### Token refresh

`TokenRefreshMiddleware` runs as a `before_request` hook. Buffer: 5 minutes. On `invalid_grant`, clears the session.

---

## Cross-framework notes

- **SameSite=Lax** is required for all three. `Strict` drops the session cookie on the OAuth redirect from Scalekit, breaking the CSRF state check.
- **AJAX clients** expect `401`, not `302`. Detect `Accept: application/json` in auth guards and return JSON errors.
- **Cache-Control: no-store** on protected responses prevents the browser back button from serving cached authenticated pages after logout.
- **Permission claim fallback chain**: `permissions` → `https://scalekit.com/permissions` → `scalekit:permissions`.

## Related docs

- [auth-flows.md](../auth-flows.md) — Framework-agnostic auth flow reference.
- [sessions.md](../sessions.md) — Token storage and refresh patterns.
