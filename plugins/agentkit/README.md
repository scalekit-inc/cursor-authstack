# AgentKit for Cursor

## Purpose

Authentication for AI agents. This plugin brings Scalekit AgentKit into Cursor so agents can connect users to third-party apps, discover the right tools, and execute authenticated tool calls on their behalf.

AgentKit handles the full OAuth lifecycle — authorization, token vault, and automatic refresh — across 40+ connectors (Gmail, Slack, Salesforce, Notion, and more).

The plugin treats live AgentKit metadata as the source of truth for tool names, `input_schema`, and `output_schema`. Connector notes in `references/agent-connectors/` are curated guidance, not a guaranteed exhaustive catalog.

## Installation

Install from the Scalekit Auth Stack marketplace in Cursor.

## Skills Reference

- `integrating-agentkit` — Core integration: SDK setup, connected accounts, OAuth flows, token fetching, downstream API calls, and agent framework examples.
- `discovering-connector-tools` — Uses live AgentKit metadata to find tools, inspect schemas, and narrow the tool set.
- `testing-agentkit-tools` — Generates authorization links, fetches live tool metadata, and executes tools.
- `exposing-agentkit-via-mcp` — Exposes AgentKit tools through MCP for MCP-compatible runtimes.
- `production-readiness-agentkit` — Structured production readiness checklist for AgentKit integrations.

## Configuration

Required environment variables:

- `SCALEKIT_ENV_URL`
- `SCALEKIT_CLIENT_ID`
- `SCALEKIT_CLIENT_SECRET`

Get these from [app.scalekit.com](https://app.scalekit.com): Developers → Settings → API Credentials.

## Helpful Links

- [AgentKit overview](https://docs.scalekit.com/agentkit/overview.md)
- [AgentKit quickstart](https://docs.scalekit.com/agentkit/quickstart.md)
- [LLM docs map](https://docs.scalekit.com/llms.txt)
- [Docs sitemap](https://docs.scalekit.com/sitemap-0.xml)

## Security

Store API credentials in environment variables or a secret manager. Never commit them to source control.

Connected accounts are per-user authorization boundaries. Use the correct identifier, request minimum necessary scopes, and keep the tool set constrained before handing tools to an LLM.
