# Tool Discovery

## Overview

In AgentKit, the live tool metadata is the source of truth for:

- current connector coverage
- tool names
- `input_schema`
- `output_schema`

For connector-specific guidance, auth quirks, and example workflows, see the canonical connector docs at [docs.scalekit.com/agentkit/connectors](https://docs.scalekit.com/agentkit/connectors/).

## Terminology

- `connector`: the integration, such as Gmail, Slack, Salesforce, or a custom connector
- `connection`: the dashboard configuration created once per environment
- `connected account`: the per-user authorized instance of a connection
- `tool`: the executable action exposed by a connector

Use `connector` in user-facing explanations. Use `provider` only when the SDK or API filter field literally uses that name.

## Discovery rules

1. Prefer live lookup over hand-maintained docs.
2. Narrow the search to a single connector or tool name whenever possible.
3. Summarize required inputs from `input_schema.required`.
4. Summarize optional inputs from `input_schema.properties`.
5. Describe likely results from `output_schema.properties`.
6. Recommend the smallest useful tool set before handing tools to an LLM.

## What to inspect

When live metadata is available, capture:

- tool `name`
- tool `description`
- connector / provider slug
- `input_schema.properties`
- `input_schema.required`
- `output_schema.properties`

If the metadata contains pagination or large result fields, mention them so the user can limit tool scope or post-process results before sending them back to the model.

## How to use this in Cursor

For interactive discovery, use the Scalekit MCP server. When connected at `https://mcp.scalekit.com`, you can query tool metadata, generate auth links, and execute tools directly through MCP tool calls.

For implementation guidance, use:

- `discovering-connector-tools` when the user needs the current tool list or schema
- The Scalekit MCP server when the user wants to execute a tool and inspect the payload interactively
- `integrating-agentkit` when the user wants to wire the result into application code

For per-connector tool specifications, see [agent-connectors/README.md](agent-connectors/README.md).

## Connection names vs connector names

Do not confuse:

- dashboard `connection_name`: exact value from `AgentKit -> Connections`
- connector / provider slug: value used to group live tools in metadata

The first is for authorization and connected account flows.
The second is for catalog discovery and tool grouping.

They are related, but they are not always the same string.

## Example reasoning pattern

1. User says: "What tools can I use for Google Sheets?"
2. Discover the live tool list for the Google Sheets connector.
3. Inspect the candidate tools and their `input_schema`.
4. Recommend only the few tools needed for the workflow, such as read values, update values, or append rows.
5. If the user wants to validate the flow, generate an auth link if needed and execute one tool with minimal input.

## Fallback behavior

If live credentials are not available:

- refer to [docs.scalekit.com/agentkit/connectors](https://docs.scalekit.com/agentkit/connectors/) as a directional guide
- clearly say the catalog may be stale without live credentials
- avoid claiming that the listed tools are exhaustive
