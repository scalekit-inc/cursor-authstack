# full-stack-auth

Production-ready authentication flows using Scalekit full-stack auth across common stacks.

## Purpose

This plugin adds complete authentication to B2B and AI apps — sign-up, login, logout, sessions, RBAC, admin portal, API key auth, and more. One Scalekit integration unlocks social sign-in, magic links, passkeys, enterprise SSO, workspaces, MCP authentication, and SCIM provisioning.

**Non-goals:** This plugin does not cover MCP server auth (see `mcp-auth`) or agent-to-service OAuth (see `agent-auth`). For apps with existing user management that only need SSO, see `modular-sso`.

---

## Install

Clone or install the cursor-authstack repository and activate the `full-stack-auth` plugin from the Cursor plugin panel.

Required environment variables (add to `.env`):

```env
SCALEKIT_ENV_URL=https://your-env.scalekit.com
SCALEKIT_CLIENT_ID=your_client_id
SCALEKIT_CLIENT_SECRET=your_client_secret
SCALEKIT_REDIRECT_URI=http://localhost:3000/auth/callback
```

Get credentials from [app.scalekit.com](https://app.scalekit.com) → Developers → Settings → API Credentials.

---

## Skills

### full-stack-auth
Core auth flow: authorization URL, token exchange, session management, logout. Supports Node.js, Python, Go, and Java.

### Framework-specific skills

| Skill | Framework |
|-------|-----------|
| `implementing-scalekit-nextjs-auth` | Next.js App Router |
| `implementing-scalekit-django-auth` | Django |
| `implementing-scalekit-fastapi-auth` | FastAPI |
| `implementing-scalekit-flask-auth` | Flask |
| `implementing-scalekit-go-auth` | Go (Gin) |
| `implementing-scalekit-springboot-auth` | Spring Boot 3.x |
| `implementing-scalekit-laravel-auth` | Laravel |

### Additional skills

| Skill | Purpose |
|-------|---------|
| `implement-logout` | Complete logout flows (OIDC end-session) |
| `implementing-access-control` | RBAC and permission checks from access tokens |
| `implementing-admin-portal` | Self-serve SSO/SCIM customer portal (iframe embed) |
| `adding-api-key-auth` | API key creation, validation, and revocation |
| `adding-oauth2-to-apis` | OAuth 2.0 client-credentials for machine-to-machine auth |
| `manage-user-sessions` | Secure session storage and transparent token refresh |
| `migrating-to-scalekit-auth` | Incremental migration from existing auth systems |
| `production-readiness-scalekit` | Pre-launch production readiness checklist |

---

## Commands

### dryrun

Runs the Scalekit dryrun tool to verify your auth configuration end-to-end.

```
/dryrun fsa <env_url> <client_id>
```

---

## Configuration

The `.mcp.json` connects to the Scalekit hosted MCP server. The `SCALEKIT_REDIRECT_URI` must exactly match the callback URL registered in your Scalekit dashboard.

---

## Troubleshooting

**"Invalid redirect_uri"**: The callback URL in your code must exactly match what is registered in Dashboard → Authentication → Redirect URLs.

**"invalid_grant" on token refresh**: The refresh token expired or was revoked. Clear the session and redirect to login.

**SameSite cookie issues**: Use `SameSite=Lax` (not Strict) — the OAuth callback is a cross-site redirect that drops cookies with Strict mode.

---

## Security notes

- Store all tokens in HttpOnly cookies, not localStorage
- Always validate access tokens server-side before trusting claims
- Use the `offline_access` scope to receive refresh tokens
- Set `Secure: true` on all cookies in production (HTTPS)
- Never commit credentials to version control
