<div align="center">

<img src="./images/scalekit.jpg" alt="Scalekit" height="64">

<p><strong>Scalekit Auth Stack for Cursor — AgentKit and SaaSKit plugins.</strong><br>
Add agent auth, tool calling, SSO, SCIM, MCP auth, and session management from Cursor.</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/scalekit-inc/cursor-authstack/pulls)

**[📖 Documentation](https://docs.scalekit.com)** · **[💬 Slack](https://join.slack.com/t/scalekit-community/shared_invite/zt-3gsxwr4hc-0tvhwT2b_qgVSIZQBQCWRw)**

</div>

---

Setting up auth for B2B and AI apps is complex. Between agent OAuth flows, SSO providers, SCIM provisioning, MCP server auth, and session management, most developers spend weeks on auth instead of shipping features.

This marketplace adds the complete Scalekit auth stack to your projects — whether that's an AI agent, a B2B SaaS app, or an MCP server — directly from Cursor.

---

### Available Plugins

| Plugin | Description |
|--------|-------------|
| **AgentKit** | Authentication for AI agents. OAuth flows, token vault, 40+ connectors (Gmail, Slack, Salesforce, etc.), tool discovery, and live testing — so agents can act on behalf of users. |
| **SaaSKit** | Production-ready auth for B2B SaaS apps. Login, sessions, SSO (Okta, Azure AD, Google), SCIM provisioning, RBAC, MCP server auth, and API key management. |

---

### Installation

The plugin bundle is currently **under review for the [Cursor Marketplace](https://cursor.com/marketplace)**. Once approved, you you will be able to install it directly from the Cursor plugin panel in a single click.

Until then, use the bootstrap installer:

```bash
curl -fsSL https://raw.githubusercontent.com/scalekit-inc/cursor-authstack/main/install.sh | bash
```

The installer:

- downloads the latest `cursor-authstack` repository
- installs each plugin into `~/.cursor/plugins/local/<plugin-name>`
- verifies each installed plugin root contains `.cursor-plugin/plugin.json`
- prints the next steps to reload Cursor and confirm the plugins loaded

After it finishes:

1. Restart Cursor, or run `Developer: Reload Window`
2. Open `Settings > Plugins`
3. Verify the Scalekit plugins are available and their rules, skills, and MCP servers load correctly

### Local development

If you're iterating on this repository locally, run the installer from your working tree:

```bash
CURSOR_AUTHSTACK_SOURCE_DIR="$PWD" ./install.sh
```

That uses the repo-local installer directly. To symlink plugins into `~/.cursor/plugins/local` instead of copying them, use:

```bash
CURSOR_AUTHSTACK_SOURCE_DIR="$PWD" CURSOR_AUTHSTACK_INSTALL_MODE=symlink ./install.sh
```

If you prefer a manual install, each plugin can also be copied into `~/.cursor/plugins/local/<plugin-name>` as long as `.cursor-plugin/plugin.json` sits at that plugin root.

---

### Repository Structure

```
.
├── plugins/
│   ├── agentkit/         # AI agent authentication (AgentKit)
│   └── saaskit/          # B2B SaaS authentication (SaaSKit)
├── images/               # Documentation images
├── scripts/              # Install scripts
├── AGENTS.md             # Contribution guidelines
└── LICENSE               # MIT License
```

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
