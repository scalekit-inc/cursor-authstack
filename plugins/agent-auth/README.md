# agent-auth

Implements Scalekit Agent Auth so AI agents can act in third-party apps (Gmail, Slack, Calendar, Notion) on behalf of users.

## Purpose

This plugin handles the full OAuth lifecycle — authorization URL generation, token storage, and automatic token refresh — so AI agents can call third-party APIs on behalf of users without managing OAuth themselves.

**Non-goals:** This plugin does not cover user-facing authentication flows (see `full-stack-auth`) or MCP server auth (see `mcp-auth`).

---

## Install

Clone or install the cursor-authstack repository and activate the `agent-auth` plugin from the Cursor plugin panel.

Required environment variables (add to `.env`):

```env
SCALEKIT_ENV_URL=https://your-env.scalekit.com
SCALEKIT_CLIENT_ID=your_client_id
SCALEKIT_CLIENT_SECRET=your_client_secret
```

Get credentials from [app.scalekit.com](https://app.scalekit.com) → Developers → Settings → API Credentials.

---

## Skills

### agent-auth

Integrates Scalekit Agent Auth into a project.

**When to use:** When a user wants to connect to an external service, authorize OAuth access, fetch access or refresh tokens, or execute API calls on behalf of a user.

**Example invocations:**
- "Set up agent auth so my agent can read Gmail"
- "Connect to Slack using Scalekit agent auth"
- "Add OAuth token refresh for Notion integration"

### building-agent-mcp-server

Creates a Scalekit MCP server with authenticated tool access.

**When to use:** When building an MCP server that manages authentication, creates personalized access URLs for users, and defines which tools are accessible.

**Example invocations:**
- "Build an MCP server that connects to Gmail and Google Calendar"
- "Create a Scalekit MCP server for my agent"

### production-readiness-scalekit

Walks through a production readiness checklist for Scalekit agent auth implementations.

**When to use:** When going live, launching to production, or doing a pre-launch review.

**Example invocations:**
- "Run a production readiness check on my agent auth setup"
- "What do I need to check before going live with agent auth?"

---

## Agents

### setup-scalekit

Sets up Scalekit env vars, installs/initializes the SDK, and verifies credentials. Use proactively when the user asks to set up, install, initialize, or configure Scalekit.

---

## Configuration

The MCP server configuration in `.mcp.json` connects to `https://mcp.scalekit.com` — the hosted Scalekit MCP server. No additional configuration is required.

### Connector setup (non-Gmail)

For connectors other than Gmail, you must first create the connector in the Scalekit Dashboard:
1. Go to **Scalekit Dashboard → Agent Auth → Connections**
2. Click **+ Create Connection**
3. Select the connector and enter a Connection Name
4. Save

The Connection Name you set is the exact value used as `connection_name` in your code.

---

## Troubleshooting

**"Connection not found"**: The connector must be created in the Scalekit Dashboard first (except Gmail). Verify the connection name matches exactly.

**"Invalid token"**: Always call `get_connected_account` immediately before any API call — Scalekit auto-refreshes tokens and this guarantees the latest valid token.

**"Authorization required"**: The user must complete OAuth via the authorization link. Check that the link was opened and OAuth was completed (status should be `ACTIVE`).

---

## Security notes

- Never log or store access tokens in version control
- Always use environment variables for `SCALEKIT_CLIENT_ID` and `SCALEKIT_CLIENT_SECRET`
- Call `get_connected_account` before each API call (not cached tokens) to ensure automatic refresh
- Revoke connected accounts when users disconnect or delete their account
