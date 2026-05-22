# Next.js (App Router)

SaaSKit integration for Next.js using `@scalekit-sdk/node` with the App Router.

Reference: [scalekit-inc/scalekit-nextjs-auth-example](https://github.com/scalekit-inc/scalekit-nextjs-auth-example)

## Project structure

```
app/api/auth/
├── login/route.ts       # GET — auth URL + CSRF state
├── callback/route.ts    # GET — code exchange, set session cookie
├── logout/route.ts      # POST — clear session, return Scalekit logout URL
├── refresh/route.ts     # POST — refresh access token
└── validate/route.ts    # Token validation

lib/
├── scalekit.ts          # Singleton client + default scopes
├── cookies.ts           # Session read/write/clear + OAuth state
└── auth.ts              # isAuthenticated(), getCurrentUser(), hasPermission()
```

## Environment

```env
SCALEKIT_ENVIRONMENT_URL=https://your-env.scalekit.com
SCALEKIT_CLIENT_ID=your-client-id
SCALEKIT_CLIENT_SECRET=your-client-secret
SCALEKIT_REDIRECT_URI=http://localhost:3000/auth/callback
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## Session shape

Single `scalekit_session` HttpOnly cookie containing JSON:

```ts
interface SessionData {
  user: { sub, email, name, given_name, family_name, preferred_username };
  tokens: { access_token, refresh_token, id_token, expires_at, expires_in };
  roles?: string[];
  permissions?: string[];
}
```

Cookie config: `httpOnly: true`, `secure` in production, `sameSite: 'lax'`, `path: '/'`.

## Auth flow

**Login** — `GET /api/auth/login` generates a CSRF state, stores it in a cookie, and returns `{ authUrl }`. The client must do a full page navigation: `window.location.href = authUrl`.

**Callback** — `GET /api/auth/callback` validates the state parameter, exchanges the code, validates the access token to extract roles/permissions, writes the session cookie, and redirects to `/dashboard`.

**Logout** — `POST /api/auth/logout` builds the Scalekit logout URL using the session's `id_token`, clears the session cookie, and returns `{ logoutUrl }`. The client navigates to it: `window.location.href = logoutUrl`.

**Refresh** — `POST /api/auth/refresh` refreshes the access token using the stored refresh token and updates the session cookie.

## Protecting routes

### Edge middleware

```ts
// middleware.ts (project root)
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const PROTECTED = ['/dashboard', '/sessions', '/organization'];

export function middleware(request: NextRequest) {
  const session = request.cookies.get('scalekit_session');
  const isProtected = PROTECTED.some(p => request.nextUrl.pathname.startsWith(p));
  if (isProtected && !session) {
    const loginUrl = new URL('/login', request.url);
    loginUrl.searchParams.set('next', request.nextUrl.pathname);
    return NextResponse.redirect(loginUrl);
  }
  return NextResponse.next();
}

export const config = { matcher: ['/((?!_next|api|favicon).*)'] };
```

### Server Components

```ts
import { isAuthenticated, getCurrentUser, hasPermission } from '@/lib/auth';
import { redirect } from 'next/navigation';

const authed = await isAuthenticated();
if (!authed) redirect('/login');

const allowed = await hasPermission('org:admin');
if (!allowed) redirect('/permission-denied');
```

## Tactics

- **SameSite=Lax** — never Strict. Strict drops the cookie on the OAuth redirect from Scalekit, breaking state validation.
- **Full page navigation for OAuth** — `window.location.href`, not `router.push`. OAuth requires a top-level redirect.
- **Deep link preservation** — store `?next` in session state, validate it's a relative path to prevent open redirect.
- **Cache-Control: no-store** — use `export const dynamic = 'force-dynamic'` on protected pages to prevent cached authenticated pages after logout.
- **Token refresh race condition** — multiple tabs can attempt concurrent refresh. Use a short-lived `refresh_in_progress` flag in the session.

## Dependencies

```bash
npm install @scalekit-sdk/node jose date-fns js-cookie
```

## Related docs

- [auth-flows.md](../auth-flows.md) — Framework-agnostic auth flow reference.
- [sessions.md](../sessions.md) — Token storage patterns.
- [access-control.md](../access-control.md) — Permission checks.
