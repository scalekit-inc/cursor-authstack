# MCP Auth

OAuth 2.1 authorization for MCP servers using Scalekit to protect tools used by AI IDEs and agents.

## Overview

This plugin adds production-ready OAuth 2.1 authorization to any MCP server. Once installed, Cursor's agent will:

- Serve a `/.well-known/oauth-protected-resource` discovery endpoint so MCP clients (Claude Desktop, Cursor, VS Code) can automatically find your authorization server
- Add Bearer token validation middleware that checks audience, issuer, expiry, and scopes before any MCP tool runs
- Wire up per-tool scope enforcement so each tool only executes for users with the right permissions
- Support both **Node.js** (Express / FastMCP) and **Python** (FastAPI / FastMCP) out of the box

## Installation

This plugin will be available from the Cursor Marketplace. For local development:

```bash
git clone https://github.com/scalekit-inc/cursor-authstack
```

Then configure Cursor to load the plugin from the local directory.

## Skills

| Skill | Description |
|-------|-------------|
| `add-mcp-auth` | Add OAuth 2.1 authorization to an MCP server using Scalekit |
| `mcp-auth-expressjs-scalekit` | Express.js MCP server with Scalekit OAuth |
| `mcp-auth-fastmcp-scalekit` | FastMCP (Node.js) with Scalekit OAuth |
| `mcp-auth-fastapi-fastmcp-scalekit` | FastAPI + FastMCP (Python) with Scalekit OAuth |

## Requirements

- Scalekit account ([app.scalekit.com](https://app.scalekit.com))
- Environment variables: `SCALEKIT_ENVIRONMENT_URL`, `SCALEKIT_CLIENT_ID`, `SCALEKIT_CLIENT_SECRET`

## License

MIT
