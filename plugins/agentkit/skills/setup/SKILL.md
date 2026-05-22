---
name: setup
description: Starting point for any Scalekit AgentKit integration. Use when the user says "I want to add agent auth", "set up AgentKit", "where do I start", or is new to AgentKit and doesn't know which skill to use. Routes to the right skill based on what they're building.
---

# AgentKit — Where to Start

Answer 2 questions, then follow the link for your exact skill.

---

## Step 1: Ask the user these questions

If answers aren't already clear from context, ask:

1. **What are you building?**
   - New agent that needs to call third-party tools on behalf of users (Gmail, Slack, Salesforce, etc.)
   - Existing agent — adding connector access or fixing auth
   - MCP server that exposes AgentKit tools

2. **What's your current state?**
   - Starting from scratch
   - Have a Scalekit account and environment already
   - Have AgentKit set up, stuck on a specific step

---

## Step 2: Route to the right skill

| What you're building | Skill |
|---|---|
| Connect users to third-party apps, execute tools on their behalf | `/agentkit:integrating-agentkit` |
| Discover available tools for a connector, inspect schemas | `/agentkit:discovering-connector-tools` |
| Expose AgentKit tools over MCP for Cursor, Claude Desktop, VS Code | `/agentkit:exposing-agentkit-via-mcp` |
| Pre-launch checklist for production | `/agentkit:production-readiness-agentkit` |
| SDK errors, wrong imports, broken auth calls | `/saaskit:scalekit-code-doctor` |

---

## Step 3: Environment setup (if new project)

Before starting any skill, verify credentials exist:

```bash
SCALEKIT_ENVIRONMENT_URL=https://your-env.scalekit.dev
SCALEKIT_CLIENT_ID=<from dashboard>
SCALEKIT_CLIENT_SECRET=<from dashboard>
```

Get these from [app.scalekit.com](https://app.scalekit.com) → Developers → Settings → API Credentials.

The Scalekit MCP server (`https://mcp.scalekit.com`) is pre-configured in `mcp.json`. Cursor handles OAuth 2.1 auth automatically — no additional setup needed.

---

## Core AgentKit concepts (30-second orientation)

| Concept | What it is |
|---|---|
| **Connector** | A third-party app (Gmail, Slack, Salesforce, GitHub, etc.) |
| **Connection** | Your app's agreement with a connector (configured in dashboard) |
| **Connected account** | A specific user's authorization to use a connection |
| **Tool** | An action the agent can take (send email, create issue, etc.) |

Flow: User authorizes → connected account created → agent discovers tools → agent executes tool calls using that account.

---

## When to switch skills

- **Already know what you need?** Skip this skill and invoke the target directly.
- **SDK errors?** Use `/saaskit:scalekit-code-doctor`.
- **Want to add B2B auth (login, SSO, SCIM) to your app?** Switch to the `saaskit` plugin: `/saaskit:setup`.
