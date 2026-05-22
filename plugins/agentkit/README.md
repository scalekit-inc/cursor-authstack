# AgentKit for Cursor

## Purpose

Authentication for AI agents. This plugin brings Scalekit AgentKit into Cursor so agents can connect users to third-party apps, discover the right tools, and execute authenticated tool calls on their behalf.

AgentKit handles the full OAuth lifecycle — authorization, token vault, and automatic refresh — across 100+ connectors (Gmail, Slack, Salesforce, Notion, and more).

The plugin treats live AgentKit metadata as the source of truth for tool names, `input_schema`, and `output_schema`. For per-connector details, see the [AgentKit connectors catalog](https://docs.scalekit.com/agentkit/connectors/).

## Installation

1. Run the bootstrap installer in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/scalekit-inc/cursor-authstack/main/install.sh | bash
```

2. Open Cursor, then run the plugin install command from the Command Palette:

```
> Plugins: Install Plugin
```

Select **AgentKit** from the Scalekit Auth Stack.

## Skills Reference

- `/agentkit:setup`
  New to AgentKit? Start here — answers 2 questions and routes you to the right skill.
- `integrating-agentkit` — Core integration: SDK setup, connected accounts, OAuth flows, token fetching, downstream API calls, and agent framework examples.
- `discovering-connector-tools` — Uses live AgentKit metadata to find tools, inspect schemas, and narrow the tool set.
- `exposing-agentkit-via-mcp` — Exposes AgentKit tools through MCP for MCP-compatible runtimes.
- `production-readiness-agentkit` — Structured production readiness checklist for AgentKit integrations.
- `/saaskit:scalekit-code-doctor (cross-plugin)`
  Diagnoses SDK usage issues, import errors, and common mistakes across AgentKit and SaaSKit. Requires the saaskit plugin.

## Configuration

Required environment variables:

- `SCALEKIT_ENVIRONMENT_URL`
- `SCALEKIT_CLIENT_ID`
- `SCALEKIT_CLIENT_SECRET`

Get these from [app.scalekit.com](https://app.scalekit.com): Developers → Settings → API Credentials.

## Helpful Links

- [AgentKit overview](https://docs.scalekit.com/agentkit/overview)
- [AgentKit quickstart](https://docs.scalekit.com/agentkit/quickstart)
- [LLM docs map](https://docs.scalekit.com/llms.txt)
- [Docs sitemap](https://docs.scalekit.com/sitemap-0.xml)

## Security

Store API credentials in environment variables or a secret manager. Never commit them to source control.

Connected accounts are per-user authorization boundaries. Use the correct identifier, request minimum necessary scopes, and keep the tool set constrained before handing tools to an LLM.
