# mcp-auth

OAuth 2.1 authorization for MCP servers using Scalekit as the authorization server.

## Purpose

This plugin adds production-ready OAuth 2.1 authorization to any MCP server. It serves the `/.well-known/oauth-protected-resource` discovery endpoint, validates Bearer tokens in middleware, and enforces per-tool scope checks — so MCP clients like Claude Desktop, Cursor, and VS Code can automatically discover and authenticate with your server.

**Non-goals:** This plugin does not cover user-facing authentication flows (see `full-stack-auth`) or agent-to-service OAuth (see `agent-auth`).

---

## Install

Clone or install the cursor-authstack repository and activate the `mcp-auth` plugin from the Cursor plugin panel.

Required environment variables (add to `.env`):

```env
SCALEKIT_ENVIRONMENT_URL=https://your-env.scalekit.com
SCALEKIT_CLIENT_ID=your_client_id
SCALEKIT_CLIENT_SECRET=your_client_secret
```

Get credentials from [app.scalekit.com](https://app.scalekit.com) → Developers → Settings → API Credentials.

---

## Skills

### mcp-auth (add-mcp-auth)

Adds OAuth 2.1 authorization to any MCP server. Implements the discovery endpoint, Bearer token validation middleware, and scope enforcement. Supports Node.js (Express) and Python (FastAPI).

**Example invocations:**
- "Add OAuth 2.1 auth to my MCP server"
- "Protect my MCP tools with Scalekit token validation"
- "Set up the OAuth discovery endpoint for my MCP server"

### mcp-auth-expressjs-scalekit

Implements a complete Express.js MCP server with OAuth 2.1 authorization using Scalekit.

**Example invocations:**
- "Build an Express MCP server with OAuth auth"
- "Add Scalekit token validation to my Express MCP server"

### mcp-auth-fastapi-fastmcp-scalekit

Implements OAuth 2.1 authorization for FastAPI + FastMCP servers using Scalekit.

**Example invocations:**
- "Add auth to my FastAPI MCP server"
- "Protect my FastMCP tools with Scalekit OAuth"

### mcp-auth-fastmcp-scalekit (add-auth-fastmcp)

Adds OAuth 2.1 authorization to FastMCP servers using the Scalekit provider plugin for minimal setup.

**Example invocations:**
- "Add Scalekit OAuth to my FastMCP server with minimal code"
- "Use the Scalekit FastMCP provider plugin"

### production-readiness-scalekit

Walks through a structured production readiness checklist for Scalekit MCP authentication implementations.

**Example invocations:**
- "Run a production readiness check on my MCP auth setup"
- "What do I need to verify before going live with MCP auth?"

---

## Agents

### scalekit-setup

Sets up Scalekit env vars, installs/initializes the SDK, and verifies credentials. Use when the user asks to set up, install, initialize, or configure Scalekit for an MCP server.

### mcp-auth-troubleshooter

Diagnoses and fixes common MCP authentication issues: discovery endpoint problems, token validation failures, scope errors, and client configuration issues.

---

## Configuration

The `.mcp.json` connects to the Scalekit hosted MCP server at `https://mcp.scalekit.com`. No additional configuration is required beyond the environment variables above.

The `RESOURCE_ID` used in token validation must match the Server URL registered in the Scalekit dashboard under MCP Servers → your server.

---

## Troubleshooting

**MCP client cannot discover auth server**: The `/.well-known/oauth-protected-resource` endpoint must be publicly accessible without any authentication. Verify it returns the correct `authorization_servers` URL from your Scalekit dashboard.

**"Token validation failed"**: Ensure `SCALEKIT_ENVIRONMENT_URL` is set correctly and the `audience` in `validateToken()` matches the Server URL registered in the Scalekit dashboard.

**"insufficient_scope" errors**: Check that the required scopes are configured in Dashboard → MCP Servers → your server → Scopes, and that the client is requesting those scopes during authorization.

**FastMCP `resource` must use base URL with trailing slash**: When using FastMCP, the `RESOURCE_ID` must be the base URL with a trailing slash (e.g., `https://mcp.yourapp.com/`).

---

## Security notes

- Never authenticate the `/.well-known/oauth-protected-resource` endpoint — it must be public
- Always validate `aud`, `iss`, `exp`, and `scope` claims using the Scalekit SDK, never manually
- Return HTTP 401 with a `WWW-Authenticate` header on token validation failure
- Return HTTP 403 (not 401) when scopes are insufficient — authorization is valid but permissions are not
- Store `SCALEKIT_CLIENT_SECRET` in environment variables only, never in source code
