# Scalekit AuthStack for Cursor

A Cursor plugin marketplace that brings production-ready authentication to your existing projects — right from inside Cursor.

Pick the auth you need: MCP auth, SSO, SCIM provisioning, agent auth, or full-stack authentication — and let Cursor's agent do the wiring for you.

> 🚧 **Actively under development.** New plugins are shipping in the coming days. **MCP Auth is fully available today.**

---

## Plugins

| Plugin | What it does | Status |
|--------|--------------|--------|
| `mcp-auth` | OAuth 2.1 authorization for MCP servers — discovery endpoint, token validation, scope enforcement | ✅ Available |
| `agent-auth` | Secure OAuth flows for AI agents and service-to-service communication | 🔜 Coming soon |
| `fsa` | Full-stack web authentication — login pages, sessions, and protected routes | 🔜 Coming soon |
| `modular-sso` | Enterprise SSO with 20+ identity providers (Okta, Entra ID, JumpCloud) via SAML/OIDC | 🔜 Coming soon |
| `modular-scim` | SCIM 2.0 user provisioning and directory sync | 🔜 Coming soon |

---

## Installation

The plugin bundle is currently **under review for the [Cursor Marketplace](https://cursor.com/marketplace)**. Once approved, you will be able to install it directly from the Cursor plugin panel in a single click.

Until then, you can load it manually by cloning this repository into your workspace. See [Cursor's plugin documentation](https://cursor.com/docs/plugins) for how to configure and activate local plugins.

---

## mcp-auth — Available Now

The `mcp-auth` plugin adds production-ready OAuth 2.1 authorization to any MCP server. Once installed, Cursor's agent will:

- Serve a `/.well-known/oauth-protected-resource` discovery endpoint so MCP clients (Claude Desktop, Cursor, VS Code) can automatically find your authorization server
- Add a Bearer token validation middleware that checks audience, issuer, expiry, and scopes before any MCP tool runs
- Wire up per-tool scope enforcement so each tool only executes for users with the right permissions
- Support both **Node.js** (Express / FastMCP) and **Python** (FastAPI / FastMCP) out of the box

This plugin uses [Scalekit](https://docs.scalekit.com/authenticate/mcp/start-mcp-auth-coding-agents/) as the OAuth 2.1 authorization server — no auth infrastructure to build or maintain yourself.

---

## License

[MIT](./LICENSE)
