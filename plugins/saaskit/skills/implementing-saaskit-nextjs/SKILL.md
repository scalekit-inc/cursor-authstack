---
name: implementing-saaskit-nextjs
description: Implements Scalekit SaaSKit authentication in a Next.js App Router project using @scalekit-sdk/node. Use when adding auth routes, protecting pages, managing sessions, or checking permissions in Next.js with Scalekit.
---

# SaaSKit Auth — Next.js

Implements Scalekit authentication in Next.js App Router projects using `@scalekit-sdk/node`.

## Reference repo

[scalekit-inc/scalekit-nextjs-example](https://github.com/scalekit-inc/scalekit-nextjs-example)

## Project structure overview

```
app/
├── api/
│   ├── auth/
│   │   ├── login/route.ts       # Builds auth URL → redirects to Scalekit
│   │   ├── callback/route.ts    # Exchanges code → sets session cookie
│   │   ├── session/route.ts     # Validates token → returns user JSON
│   │   └── logout/route.ts      # Clears session → redirects to end-session
│   └── ...
├── dashboard/
│   └── page.tsx                 # Protected page
├── middleware.ts                # Checks session on every request
└── lib/
    └── scalekit.ts              # SDK singleton
```

## Setup

```bash
npm install @scalekit-sdk/node
```

```env
SCALEKIT_ENV_URL=https://your-env.scalekit.dev
SCALEKIT_CLIENT_ID=your_client_id
SCALEKIT_CLIENT_SECRET=your_client_secret
```

## Key patterns

- **Route Handlers** (`app/api/auth/*/route.ts`) implement the OAuth flow.
- **Middleware** (`middleware.ts`) protects pages by checking for a valid session cookie.
- **Server Components** can read session data from cookies for SSR.
- **Client Components** call `/api/auth/session` to get user data.

## Auth flow

1. User clicks login → `GET /api/auth/login` → redirect to Scalekit
2. Scalekit redirects back → `GET /api/auth/callback` → exchange code → set httpOnly cookie
3. Middleware checks cookie on every navigation
4. Logout → `GET /api/auth/logout` → clear cookie → redirect to Scalekit end-session

## Deep reference

- Next.js patterns and code: [../../docs/frameworks/nextjs.md](../../docs/frameworks/nextjs.md)
- Auth flows: [../../docs/auth-flows.md](../../docs/auth-flows.md)
- Sessions: [../../docs/sessions.md](../../docs/sessions.md)

## When to switch skills

- Use `implementing-saaskit` for the general (non-framework-specific) guide.
- Use `managing-saaskit-sessions` for advanced session handling.
- Use `implementing-access-control` for RBAC and permission checks.
