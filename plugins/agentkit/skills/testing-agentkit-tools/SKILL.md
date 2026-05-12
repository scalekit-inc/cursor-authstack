---
name: testing-agentkit-tools
description: Tests live Scalekit AgentKit flows by generating authorization links, fetching tool metadata, and executing a tool for a connected account. Use when a user wants to validate a connector, inspect the exact payload for execute_tool, or build a workflow step by step.
---

# Testing AgentKit Tools

This skill is the live playground for AgentKit. Use it to:

- generate an authorization link for a connection
- fetch live tool metadata for a connector or tool name
- execute a tool with real inputs
- inspect the exact JSON payload sent to AgentKit

## Prerequisites

Confirm the environment variables are available:
- `SCALEKIT_ENV_URL`
- `SCALEKIT_CLIENT_ID`
- `SCALEKIT_CLIENT_SECRET`

## Operations

### Generate authorization link

Creates or fetches the connected account and prints an authorization link if the account is not yet `ACTIVE`.

**Python**
```python
response = actions.get_or_create_connected_account(
    connection_name="<connection_name>",
    identifier="<user_id>"
)
if response.connected_account.status != "ACTIVE":
    link_response = actions.get_authorization_link(
        connection_name="<connection_name>",
        identifier="<user_id>"
    )
    print("Authorize here:", link_response.link)
```

### Fetch tool metadata

Fetches live tool metadata. Omitting `tool_name` returns all matching tools for the filter.

**Python**
```python
tools = actions.get_tools(providers=["GMAIL"], page_size=100)
for tool in tools:
    print(tool.name, tool.input_schema)
```

**Node.js**
```typescript
const tools = await scalekitClient.connectedAccounts.getTools({
  providers: ['GMAIL'],
  pageSize: 100,
});
```

### Execute a tool

Creates or fetches the connected account, prints an authorization link if needed, and executes the tool.

**Python**
```python
result = actions.execute_tool(
    tool_name="gmail_fetch_mails",
    connection_name="<connection_name>",
    identifier="<user_id>",
    tool_input={"query": "is:unread", "max_results": 5}
)
```

## Default workflow

1. Discover the tool first when the schema is unknown.
2. Generate an authorization link if the connected account is not `ACTIVE`.
3. Execute the tool with the smallest valid `tool_input`.
4. Show the exact command and payload used so the user can translate it into app code.

## Guardrails

- Treat live metadata as the source of truth for `input_schema` and `output_schema`.
- Do not assume the dashboard `connection_name` matches the connector slug.
- Ask for missing credentials instead of inventing placeholder values.
- Keep the tool set constrained to the current workflow.

## Deep reference

- Integration workflow: [../integrating-agentkit/SKILL.md](../integrating-agentkit/SKILL.md)
- Connector reference: [../../references/agent-connectors/README.md](../../references/agent-connectors/README.md)
- Connected accounts: [../../references/connected-accounts.md](../../references/connected-accounts.md)
