# Agent Auth

Enable AI agents to act on behalf of users in third-party apps like Gmail, Slack, Calendar, and Notion.

## Overview

This plugin implements Scalekit Agent Auth to handle the full OAuth lifecycle:

- **Authorization**: Generate authorization URLs for users to grant access to third-party services
- **Token storage**: Scalekit securely stores access and refresh tokens
- **Automatic refresh**: Tokens are automatically refreshed when expired
- **Framework integrations**: Works with LangChain, Google ADK, and custom agents

## Installation

This plugin will be available from the Cursor Marketplace. For local development:

```bash
git clone https://github.com/scalekit-inc/cursor-authstack
```

## Skills

| Skill | Description |
|-------|-------------|
| `integrating-agent-auth` | Full Agent Auth integration with OAuth flows, token management |
| `building-agent-mcp-server` | Build an MCP server that uses Agent Auth tools |
| `production-readiness-scalekit` | Production deployment checklist and security hardening |

## Supported Connectors

- Gmail, Google Calendar, Google Drive, Google Sheets, Google Docs
- Slack, Notion, Linear, Asana, Trello, Monday
- Salesforce, HubSpot, Zendesk, Intercom
- Jira, Confluence, GitHub
- Microsoft Teams, Outlook, OneDrive, SharePoint
- And 40+ more...

## Requirements

- Scalekit account ([app.scalekit.com](https://app.scalekit.com))
- Environment variables: `SCALEKIT_CLIENT_ID`, `SCALEKIT_CLIENT_SECRET`, `SCALEKIT_ENV_URL`

## License

MIT
