---
name: discovering-connector-tools
description: Discovers live tools for a Scalekit AgentKit connector and explains their input and output schemas. Use when a user asks what tools are available for Gmail, Slack, Salesforce, or another connector, wants to inspect input_schema or output_schema, or needs help narrowing the tool set for an agent.
---

# Discovering Connector Tools

Use live AgentKit metadata as the source of truth for tool names, required inputs, and output schemas.

Do not rely on the static connector notes as a complete catalog. Those files are curated reference material and may lag the live platform.

## When to use this skill

Use this skill when the user asks:

- what tools exist for a connector
- which tool should the agent use
- what inputs a tool requires
- what output shape a tool returns
- how to reduce the tool set before giving tools to an LLM

## Discovery workflow

1. Identify the target connector or exact tool name.
2. Use the Scalekit MCP server or SDK to fetch live tool metadata.
3. Summarize:
   - tool name
   - connector
   - what the tool does
   - required fields from `input_schema.required`
   - optional fields from `input_schema.properties`
   - important fields from `output_schema.properties`
4. Recommend the smallest useful tool set for the workflow.
5. If live credentials are unavailable, use the connector notes only as a fallback and say they may be stale.

## Terminology

- `connector`: Gmail, Slack, Salesforce, Notion, or a custom connector
- `connection`: the exact dashboard configuration name used for authorization
- `connected account`: the per-user authorized record
- `tool`: the executable action exposed by a connector

Use `connector` in explanations. Only use `provider` when the SDK or API filter field literally expects that name.

## What to emphasize

- `connection_name` is the exact dashboard value and may not equal the connector slug.
- Tool metadata is the durable way to determine current inputs and outputs.
- Restrict the tool set before handing it to an LLM. Fewer relevant tools improve tool selection and parameter filling.

## Deep reference

- Connector reference: [AgentKit connectors catalog](https://docs.scalekit.com/agentkit/connectors/)
- Connected accounts lifecycle: [../../references/connected-accounts.md](../../references/connected-accounts.md)
- Code samples: [../../references/code-samples.md](../../references/code-samples.md)
