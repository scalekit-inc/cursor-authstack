# modular-sso

Modular SSO flows using Scalekit for apps with existing user management systems.

## Purpose

This plugin integrates enterprise SSO into applications that already manage their own users. It handles IdP-initiated and SP-initiated login, attribute mapping, JIT provisioning, and enterprise customer onboarding via the admin portal — without requiring a full auth system replacement.

**Non-goals:** This plugin does not cover full authentication flows (see `full-stack-auth`), SCIM user provisioning (see `modular-scim`), or MCP server auth (see `mcp-auth`).

---

## Install

Clone or install the cursor-authstack repository and activate the `modular-sso` plugin from the Cursor plugin panel.

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

### modular-sso

Implements complete SSO and authentication flows using Scalekit. Handles SP-initiated and IdP-initiated login, user session management, and enterprise customer onboarding.

**Example invocations:**
- "Add enterprise SSO to my app using Scalekit"
- "Implement SAML login with Okta for my SaaS"
- "Set up Scalekit SSO with existing user management"

### implementing-admin-portal

Creates Scalekit's admin portal so customers can self-serve their SSO configuration. Generates portal links server-side and embeds the portal as an iframe in your app's settings UI.

**Example invocations:**
- "Add an admin portal so customers can configure their own SSO"
- "Embed the Scalekit admin portal in my settings page"
- "Generate a shareable SSO setup link for my customer"

### production-readiness-scalekit

Walks through a structured production readiness checklist for Scalekit SSO implementations.

**Example invocations:**
- "Run a production readiness check on my SSO setup"
- "What do I need to verify before going live with enterprise SSO?"

---

## Agents

### setup-scalekit

Sets up Scalekit env vars, installs/initializes the SDK, and verifies credentials. Use proactively when the user asks to set up, install, initialize, or configure Scalekit.

### sso-validate

Validates an SSO configuration end-to-end: checks environment variables, SDK initialization, redirect URI registration, and connection status.

---

## Commands

### dryrun-sso

Runs the Scalekit dryrun tool to verify your SSO configuration end-to-end.

```
/dryrun-sso <env_url> <client_id>
```

---

## Configuration

The `.mcp.json` connects to the Scalekit hosted MCP server. The `SCALEKIT_REDIRECT_URI` must exactly match the callback URL registered in your Scalekit dashboard under Authentication → Redirect URLs.

---

## Troubleshooting

**"Invalid redirect_uri"**: The callback URL in your code must exactly match what is registered in Dashboard → Authentication → Redirect URLs.

**IdP-initiated login not working**: Ensure your app handles the `connection_id` parameter in the callback and maps it to the correct organization.

**Attribute mapping issues**: Check the attribute mapping configuration in Dashboard → SSO → Connections → your connection → Attribute Mapping.

**JIT provisioning not creating users**: Verify the JIT provisioning setting is enabled in Dashboard → SSO → Connections → your connection → User Provisioning.

---

## Security notes

- Always validate the `state` parameter in the OAuth callback to prevent CSRF attacks
- Verify the `iss` and `aud` claims in ID tokens before trusting them
- Use the `offline_access` scope to receive refresh tokens for long-lived sessions
- Never expose the `SCALEKIT_CLIENT_SECRET` to client-side code
- Store all tokens in HttpOnly cookies, not localStorage
