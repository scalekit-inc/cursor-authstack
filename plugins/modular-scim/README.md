# modular-scim

SCIM 2.0 user provisioning and directory sync using Scalekit for real-time user and group lifecycle management.

## Purpose

This plugin adds SCIM 2.0 directory sync to applications that already manage their own users. It handles real-time user provisioning, deprovisioning, group sync, and role mapping via Scalekit webhooks — without requiring a full auth system replacement.

**Non-goals:** This plugin does not cover SSO authentication flows (see `modular-sso`), full-stack authentication (see `full-stack-auth`), or MCP server auth (see `mcp-auth`).

---

## Install

Clone or install the cursor-authstack repository and activate the `modular-scim` plugin from the Cursor plugin panel.

Required environment variables (add to `.env`):

```env
SCALEKIT_ENV_URL=https://your-env.scalekit.com
SCALEKIT_CLIENT_ID=your_client_id
SCALEKIT_CLIENT_SECRET=your_client_secret
SCALEKIT_WEBHOOK_SECRET=your_webhook_secret
```

Get credentials from [app.scalekit.com](https://app.scalekit.com) → Developers → Settings → API Credentials.

---

## Skills

### modular-scim

Implements SCIM user provisioning using Scalekit's Directory API and webhooks. Handles user create, update, deactivate, group create, and group membership changes.

**Example invocations:**
- "Add SCIM provisioning to my app using Scalekit"
- "Set up directory sync so Okta can provision users"
- "Handle SCIM webhooks for user lifecycle events"

### implementing-admin-portal

Creates Scalekit's admin portal so customers can self-serve their SCIM configuration. Generates portal links server-side and embeds the portal as an iframe in your app's settings UI.

**Example invocations:**
- "Add an admin portal so customers can configure their own SCIM"
- "Embed the Scalekit admin portal in my settings page"
- "Generate a shareable SCIM setup link for my enterprise customer"

### production-readiness-scalekit

Walks through a structured production readiness checklist for Scalekit SCIM provisioning implementations.

**Example invocations:**
- "Run a production readiness check on my SCIM setup"
- "What do I need to verify before going live with SCIM provisioning?"

---

## Agents

### setup-scalekit

Sets up Scalekit env vars, installs/initializes the SDK, and verifies credentials. Use proactively when the user asks to set up, install, initialize, or configure Scalekit.

### scim-validate

Validates a SCIM configuration end-to-end: checks environment variables, webhook endpoint accessibility, event handler registration, and directory connection status.

---

## Commands

### dryrun-scim

Runs the Scalekit dryrun tool to verify your SCIM configuration end-to-end.

```
/dryrun-scim <env_url> <client_id>
```

---

## Configuration

The `.mcp.json` connects to the Scalekit hosted MCP server. The webhook endpoint must be publicly accessible and registered in your Scalekit dashboard under Directory Sync → Webhooks.

---

## Troubleshooting

**Webhook not receiving events**: Verify the webhook URL is publicly accessible (use ngrok for local development) and matches what is registered in Dashboard → Directory Sync → Webhooks.

**"Invalid webhook signature"**: The `SCALEKIT_WEBHOOK_SECRET` must match the secret shown in Dashboard → Directory Sync → Webhooks → your endpoint.

**Users not being provisioned**: Check that the directory connection status is Active in Dashboard → Directory Sync → Connections. Also verify your webhook handler returns HTTP 200 within 30 seconds.

**Group sync not working**: Ensure group provisioning is enabled for the connection and your app handles the `group.created` and `group.updated` event types.

---

## Security notes

- Always verify the webhook signature before processing any event
- Implement idempotency in your webhook handler — Scalekit may retry events on failure
- Use HTTPS for all webhook endpoints in production
- Never log user PII from SCIM payloads
- Apply least-privilege when granting directory access to Scalekit
