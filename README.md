<div align="center">

<img src="./images/scalekit.jpg" alt="Scalekit" height="64">

<p><strong>Scalekit Auth Plugins for Cursor — the auth stack for agents.</strong><br>
Add SSO, SCIM, MCP Auth, agent auth, and tool-calling from your Cursor editor.</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/scalekit-inc/cursor-authstack/pulls)

**[📖 Documentation](https://docs.scalekit.com)** · **[💬 Slack](https://join.slack.com/t/scalekit-community/shared_invite/zt-3gsxwr4hc-0tvhwT2b_qgVSIZQBQCWRw)**

</div>

---

A Cursor plugin marketplace that brings production-ready authentication to your existing projects — right from inside Cursor.

Pick the auth you need: MCP auth, SSO, SCIM provisioning, agent auth, or full-stack authentication — and let Cursor's agent do the wiring for you.

---

### Plugins

| Plugin | What it does | Status |
|--------|--------------|--------|
| `mcp-auth` | OAuth 2.1 authorization for MCP servers — discovery endpoint, token validation, scope enforcement | Available |
| `agent-auth` | Scalekit Agent Auth so AI agents can act in third-party apps (Gmail, Slack, Calendar, Notion) on behalf of users | Available |
| `full-stack-auth` | Full-stack web authentication — login pages, sessions, protected routes, RBAC, and more | Available |
| `modular-sso` | Enterprise SSO with 20+ identity providers (Okta, Entra ID, JumpCloud) via SAML/OIDC | Available |
| `modular-scim` | SCIM 2.0 user provisioning, group sync, and directory lifecycle management | Available |

---

### Installation

The plugin bundle is currently **under review for the [Cursor Marketplace](https://cursor.com/marketplace)**. Once approved, you you will be able to install it directly from the Cursor plugin panel in a single click.

Until then, you can load it manually by cloning this repository into your workspace. See [Cursor's plugin documentation](https://cursor.com/docs/plugins) for how to configure and activate local plugins.

---

### Plugin Details

#### mcp-auth

The `mcp-auth` plugin adds production-ready OAuth 2.1 authorization to any MCP server. Once installed, Cursor's agent will:

- Serve a `/.well-known/oauth-protected-resource` discovery endpoint so MCP clients (Claude Desktop, Cursor, VS Code) can automatically find your authorization server
- Add a Bearer token validation middleware that checks audience, issuer, expiry, and scopes before any MCP tool runs
- Wire up per-tool scope enforcement so each tool only executes for users with the right permissions
- Support both **Node.js** (Express / FastMCP) and **Python** (FastAPI / FastMCP) out of the box

This plugin uses [Scalekit](https://docs.scalekit.com/authenticate/mcp/start-mcp-auth-coding-agents/) as the OAuth 2.1 authorization server.

#### agent-auth

The `agent-auth` plugin implements Scalekit Agent Auth — so your AI agents can act on behalf of users in Gmail, Slack, Notion, Google Calendar, and 40+ other connected services.

Skills:
- `agent-auth` — integrates Scalekit Agent Auth with OAuth flows and automatic token refresh
- `building-agent-mcp-server` — creates a Scalekit MCP server with multi-service tool access
- `production-readiness-scalekit` — production readiness checklist for agent OAuth flows

#### full-stack-auth

The `full-stack-auth` plugin adds end-to-end authentication to B2B and AI apps using Scalekit. One integration enables: social sign-in, magic links, enterprise SSO, workspaces, MCP authentication, SCIM provisioning, and user management.

Skills for major stacks: Next.js, Django, FastAPI, Flask, Go (Gin), Spring Boot, Laravel.

Additional skills: logout, access control, admin portal, API key auth, OAuth2 for APIs, session management, auth migration, and production readiness.

#### modular-sso

The `modular-sso` plugin integrates enterprise SSO with existing user management systems. It handles IdP-initiated and SP-initiated login, attribute mapping, JIT provisioning, and enterprise customer onboarding via the admin portal.

#### modular-scim

The `modular-scim` plugin adds SCIM 2.0 directory sync to applications. It handles real-time user provisioning, deprovisioning, and group membership changes from enterprise identity providers.

---

### Prerequisites

- [Scalekit account](https://scalekit.com) with `client_id` and `client_secret`
- Cursor installed and configured
- Project where you want to add authentication

---

### Helpful Links

#### Documentation

- [Scalekit Documentation](https://docs.scalekit.com) — Complete guides and API reference
- [SSO Quickstart](https://docs.scalekit.com/sso/quickstart/) — Implement enterprise SSO
- [MCP Auth Guide](https://docs.scalekit.com/mcp-auth/quickstart/) — Secure MCP servers
- [Agent Auth Guide](https://docs.scalekit.com/agent-auth/quickstart/) — Authentication for AI agents

#### Resources

- [Admin Portal](https://app.scalekit.com) — Manage your Scalekit account
- [API Reference](https://docs.scalekit.com/apis) — Complete API documentation
- [Code Examples](https://docs.scalekit.com/directory/code-examples/) — Ready-to-use snippets

---

### Contributing

Contributions are welcome! Please see [AGENTS.md](AGENTS.md) for contribution guidelines.

1. Fork this repository
2. Create a branch — `git checkout -b feature/my-plugin`
3. Make your changes following the plugin structure
4. Test locally
5. Open a Pull Request

---

### License

This project is licensed under the **MIT license**. See the [LICENSE](LICENSE) file for more information.
