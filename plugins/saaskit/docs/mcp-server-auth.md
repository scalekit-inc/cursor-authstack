# MCP Server Auth

Secure MCP (Model Context Protocol) servers with OAuth 2.1 using Scalekit as the authorization server. This enables authenticated access from AI hosts like Claude Desktop, Cursor, and VS Code.

## Prerequisites

MCP OAuth requires **Streamable HTTP** transport. Stdio transport does not support OAuth. If your server uses stdio, migrate to HTTP first.

```js
// Node.js — required transport
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
```

```python
# Python — Streamable HTTP via ASGI app
from mcp.server.fastmcp import FastMCP
mcp = FastMCP("My Server")
app = mcp.streamable_http_app(path="/mcp")
# Run with: uvicorn module:app --host 0.0.0.0 --port 8000
```

## Flow

1. MCP client sends a request — server returns `401` with `WWW-Authenticate` header.
2. Client reads the resource metadata endpoint to discover the authorization server.
3. Client completes OAuth 2.1 flow with Scalekit, obtains a bearer token.
4. Client retries with `Authorization: Bearer <token>` — server validates and processes.

## Dashboard setup

1. **MCP Servers > Add MCP Server** — provide a name, server URL, and scopes (e.g., `todo:read`, `todo:write`).
2. Enable **dynamic client registration** (allows MCP hosts to register automatically).
3. Copy the metadata JSON from **Dashboard > MCP Servers > Metadata JSON**.

## Discovery endpoint

Expose `/.well-known/oauth-protected-resource` on your server:

```js
// Node.js (Express)
app.get('/.well-known/oauth-protected-resource', (req, res) => {
  res.json({
    authorization_servers: ['https://<ENV_URL>/resources/<RESOURCE_ID>'],
    bearer_methods_supported: ['header'],
    resource: 'https://mcp.yourapp.com',
    scopes_supported: ['todo:read', 'todo:write'],
  });
});
```

```python
# Python (FastAPI)
@app.get("/.well-known/oauth-protected-resource")
async def oauth_metadata():
    return {
        "authorization_servers": ["https://<ENV_URL>/resources/<RESOURCE_ID>"],
        "bearer_methods_supported": ["header"],
        "resource": "https://mcp.yourapp.com",
        "scopes_supported": ["todo:read", "todo:write"],
    }
```

## Token validation middleware

```js
// Node.js (Express)
async function authMiddleware(req, res, next) {
  if (req.path.includes('.well-known')) return next();
  const token = req.headers.authorization?.replace('Bearer ', '');
  if (!token) return res.status(401).set('WWW-Authenticate', wwwHeader).end();
  try {
    await scalekit.validateToken(token, { audience: [RESOURCE_ID] });
    next();
  } catch {
    res.status(401).set('WWW-Authenticate', wwwHeader).end();
  }
}
```

```python
# Python (FastAPI)
@app.middleware("http")
async def auth_middleware(request: Request, call_next):
    if request.url.path.startswith("/.well-known"):
        return await call_next(request)
    auth_header = request.headers.get("Authorization", "")
    token = auth_header.removeprefix("Bearer ").strip() if auth_header.startswith("Bearer ") else None
    if not token:
        raise HTTPException(status_code=401, headers=www_header)
    try:
        scalekit_client.validate_access_token(token, options=TokenValidationOptions(
            issuer=os.getenv("SCALEKIT_ENVIRONMENT_URL"), audience=[RESOURCE_ID]
        ))
    except Exception:
        raise HTTPException(status_code=401, headers=www_header)
    return await call_next(request)
```

The `WWW-Authenticate` header must include `resource_metadata` pointing to your discovery endpoint — this is what triggers the MCP client's OAuth flow.

## Scope-based authorization

Enforce per-tool scopes after validating the token:

```js
// Node.js
await scalekit.validateToken(token, {
  audience: [RESOURCE_ID],
  requiredScopes: ['todo:write'],
});
```

```python
# Python
scalekit_client.validate_access_token(token, options=TokenValidationOptions(
    audience=[RESOURCE_ID], required_scopes=['todo:write']
))
```

## Implementation approaches

| Approach | Complexity | Language |
|---|---|---|
| **FastMCP + ScalekitProvider** | Simplest (~5 lines) | Python |
| **Express.js + manual middleware** | Medium (full control) | Node.js |
| **FastAPI + FastMCP + custom middleware** | Medium (existing FastAPI apps) | Python |

### FastMCP (minimal code)

```python
from fastmcp import FastMCP
from fastmcp.server.auth.providers.scalekit import ScalekitProvider

mcp = FastMCP("My Server", stateless_http=True, auth=ScalekitProvider(
    environment_url=os.getenv("SCALEKIT_ENVIRONMENT_URL"),
    client_id=os.getenv("SCALEKIT_CLIENT_ID"),
    resource_id=os.getenv("SCALEKIT_RESOURCE_ID"),
    mcp_url=os.getenv("MCP_URL"),
))
mcp.run(transport="http", port=3002)
```

The provider handles discovery, token validation, and `WWW-Authenticate` responses automatically.

## Verification checklist

1. `curl -i <your-mcp-url>` returns `401` with `WWW-Authenticate` header.
2. `curl <your-domain>/.well-known/oauth-protected-resource` returns valid metadata JSON.
3. Test with MCP Inspector: `npx @modelcontextprotocol/inspector@latest`.

## Related docs

- [api-auth.md](api-auth.md) — API keys and client credentials for non-MCP APIs.
