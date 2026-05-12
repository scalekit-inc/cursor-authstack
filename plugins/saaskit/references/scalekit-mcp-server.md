# Scalekit MCP Server - Production Reference Implementation

## Overview

This document provides an architectural overview and key patterns from Scalekit's official MCP server implementation. This production-ready server demonstrates advanced OAuth 2.1 patterns, comprehensive tooling, and best practices for building secure, scalable MCP servers.

**GitHub Repository:** [scalekit-inc/scalekit-mcp-server](https://github.com/scalekit-inc/scalekit-mcp-server)

**Hosted Version:** [https://mcp.scalekit.com](https://mcp.scalekit.com)

## Key Features

- **OAuth 2.1 Authorization**: Complete token validation with Scalekit SDK
- **Modular Architecture**: Organized tool categories for different operations
- **Scope-Based Access Control**: Fine-grained permissions per tool category
- **Type-Safe Implementation**: Full TypeScript with Zod validation
- **Production Ready**: Logging, error handling, monitoring support

## Architecture

### Project Structure

```
src/
├── config/           # Configuration management
├── lib/              # Core utilities (auth, transport, middleware)
├── tools/            # MCP tool implementations
│   ├── connections.ts     # OIDC connection management
│   ├── environments.ts    # Environment operations
│   ├── organizations.ts   # Organization management
│   ├── resource.ts       # Generic resource handlers
│   └── workspace.ts     # Workspace operations
├── types/            # TypeScript type definitions
├── validators/       # Input validation schemas
└── scalekit.ts       # Main server entry point
```

### Key Components

**1. Express Server Setup** (scalekit.ts)
- Express.js application with CORS configuration
- OAuth 2.1 middleware for token validation
- MCP transport integration
- Health check and discovery endpoints

**2. Authentication Layer**
- Scalekit SDK integration for token validation
- Audience and issuer validation
- WWW-Authenticate header handling
- Public endpoint exemption (health, discovery)

**3. Tool Categories**

| Category | Purpose | Example Tools |
|----------|---------|---------------|
| **Environments** | Manage Scalekit environments | `list_environments`, `get_environment_details`, `create_environment_scope` |
| **Organizations** | Enterprise organization management | `list_organizations`, `create_organization`, `create_organization_user` |
| **Connections** | OIDC/SAML provider configuration | `create_environment_oidc_connection`, `update_environment_oidc_connection` |
| **Workspace** | Team and member administration | `list_workspace_members`, `invite_workspace_member` |
| **MCP Servers** | MCP server registry management | `register_mcp_server`, `update_mcp_server`, `switch_mcp_auth_to_scalekit` |

## Implementation Patterns

### 1. Tool Registration Pattern

```typescript
server.tool(
  'create_organization',
  'Create a new organization under the specified environment',
  {
    environmentId: z.string().regex(/^env_\d+$/, 'Invalid environment ID format'),
    name: z.string().min(1, 'Organization name is required'),
  },
  async ({ environmentId, name }, { token }) => {
    // Token already validated by middleware
    const organization = await scalekit.createOrganization({
      environmentId,
      name,
    });

    return {
      content: [{
        type: 'text',
        text: JSON.stringify(organization, null, 2)
      }]
    };
  }
);
```

**Key practices:**
- Use descriptive names and documentation
- Zod schemas for input validation
- Async tool handlers
- Return MCP-compliant response format

### 2. Scope-Based Authorization

```typescript
server.tool(
  'create_environment_scope',
  'Create a new scope in the specified environment',
  zodSchema,
  async (params, { token }) => {
    // Verify required scopes from token
    if (!token.scopes?.includes('environment:write')) {
      throw new Error('Missing required scope: environment:write');
    }

    // Proceed with operation
    const scope = await scalekit.createScope(params);
    return { content: [{ type: 'text', text: JSON.stringify(scope) }] };
  }
);
```

**Scope categories:**
- `environment:read` / `environment:write`
- `organization:read` / `organization:write`
- `workspace:read` / `workspace:write`

### 3. Error Handling Pattern

```typescript
try {
  const result = await scalekitApiCall(params);
  return {
    content: [{ type: 'text', text: JSON.stringify(result) }]
  };
} catch (error) {
  logger.error({ error, params }, 'Tool execution failed');

  return {
    content: [{
      type: 'text',
      text: `Error: ${error instanceof Error ? error.message : 'Unknown error'}`
    }],
    isError: true
  };
}
```

### 4. Middleware Token Access

Tools receive validated token via context:

```typescript
server.tool(
  'list_environments',
  'List all available environments',
  {},
  async (_params, { token }) => {
    // Access token metadata
    const userId = token.sub;
    const orgId = token.org_id;

    // Use token information in business logic
    const environments = await scalekit.listEnvironments({ userId });
    return { content: [{ type: 'text', text: JSON.stringify(environments) }] };
  }
);
```

## Advanced Patterns

### 1. Pagination Support

```typescript
server.tool(
  'list_organizations',
  'List all organizations under the specified environment',
  {
    environmentId: z.string(),
    pageToken: z.string().optional().default('1'),
  },
  async ({ environmentId, pageToken }) => {
    const result = await scalekit.listOrganizations({
      environmentId,
      page: parseInt(pageToken, 10),
    });

    return {
      content: [{
        type: 'text',
        text: JSON.stringify({
          organizations: result.data,
          nextPageToken: result.hasMore ? String(result.page + 1) : null
        })
      }]
    };
  }
);
```

### 2. Resource ID Validation

```typescript
const environmentIdSchema = z.string()
  .regex(/^env_\d+$/, 'Environment ID must match format env_<number>');

const organizationIdSchema = z.string()
  .regex(/^org_\d+$/, 'Organization ID must match format org_<number>');

server.tool(
  'get_organization_details',
  'Get details of an organization by ID',
  {
    environmentId: environmentIdSchema,
    organizationId: organizationIdSchema,
  },
  async ({ environmentId, organizationId }) => {
    // Safe to proceed with validated IDs
    const organization = await scalekit.getOrganization({
      environmentId,
      organizationId
    });
    return { content: [{ type: 'text', text: JSON.stringify(organization) }] };
  }
);
```

### 3. Multi-Step Operations

```typescript
server.tool(
  'switch_mcp_auth_to_scalekit',
  'Switch the authentication of an existing MCP server to Scalekit authentication',
  {
    environmentId: environmentIdSchema,
    id: z.string().regex(/^mcp_\d+$/, 'Invalid MCP server ID'),
  },
  async ({ environmentId, id }) => {
    // Step 1: Get current server configuration
    const server = await scalekit.getMcpServer({ id });

    // Step 2: Update to use Scalekit auth
    const updated = await scalekit.updateMcpServer({
      id,
      use_scalekit_authentication: true,
    });

    logger.info({ id }, 'Switched MCP server to Scalekit authentication');

    return {
      content: [{
        type: 'text',
        text: `Successfully switched MCP server ${id} to Scalekit authentication.`
      }]
    };
  }
);
```

## Configuration

### Environment Variables

```bash
# Scalekit Configuration
SCALEKIT_ENV_URL=https://your-env.scalekit.com
SCALEKIT_CLIENT_ID=your_client_id
SCALEKIT_CLIENT_SECRET=your_client_secret

# Server Configuration
PORT=3002
EXPECTED_AUDIENCE=http://localhost:3002/
PROTECTED_RESOURCE_METADATA='{"authorization_servers":[...],"resource":"..."}'

# Optional
LOG_LEVEL=info
NODE_ENV=production
```

### Server Configuration

```typescript
const config = {
  port: parseInt(process.env.PORT || '3002', 10),
  environmentUrl: process.env.SCALEKIT_ENV_URL,
  clientId: process.env.SCALEKIT_CLIENT_ID,
  clientSecret: process.env.SCALEKIT_CLIENT_SECRET,
  expectedAudience: process.env.EXPECTED_AUDIENCE,
  protectedResourceMetadata: JSON.parse(
    process.env.PROTECTED_RESOURCE_METADATA || '{}'
  ),
};
```

## Security Considerations

### Token Validation

- **Issuer Validation**: Ensures tokens come from correct Scalekit environment
- **Audience Validation**: Prevents token substitution attacks
- **Signature Verification**: Automatic via Scalekit SDK
- **Expiration Checking**: Built-in SDK validation

### Scope Enforcement

Each tool checks required scopes before execution:

```typescript
const REQUIRED_SCOPES = {
  create_organization: ['organization:write'],
  list_organizations: ['organization:read'],
  create_organization_user: ['organization:write'],
};
```

### CORS Configuration

```typescript
app.use(cors({
  origin: (origin, callback) => callback(null, true),
  credentials: false,
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Mcp-Protocol-Version', 'Content-Type', 'Authorization'],
  exposedHeaders: ['WWW-Authenticate'],
  maxAge: 86400,
}));
```

## Monitoring and Logging

### Structured Logging

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'mcp-server.log' })
  ]
});

// Usage
logger.info({ tool: 'create_organization', userId }, 'Organization created');
logger.error({ error, params }, 'Tool execution failed');
```

### Health Check Endpoint

```typescript
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0'
  });
});
```

## Deployment

### Docker Deployment

```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

EXPOSE 3002

CMD ["npm", "start"]
```

### Production Considerations

- **HTTPS**: Run behind reverse proxy with TLS termination
- **Process Management**: Use PM2 or Kubernetes for high availability
- **Rate Limiting**: Implement per-client/token rate limits
- **Monitoring**: Integrate with Datadog, New Relic, or similar
- **Secret Management**: Use AWS Secrets Manager, HashiCorp Vault
- **Load Balancing**: Configure multiple instances with round-robin

## Available Tools Reference

### Environment Management
- `list_environments` - List all environments
- `get_environment_details` - Get environment by ID
- `list_environment_roles` - List environment roles
- `create_environment_role` - Create new role
- `list_environment_scopes` - List environment scopes
- `create_environment_scope` - Create new scope

### Organization Management
- `list_organizations` - List organizations in environment
- `get_organization_details` - Get organization details
- `create_organization` - Create new organization
- `generate_admin_portal_link` - Generate admin portal magic link
- `create_organization_user` - Create user in organization
- `list_organization_users` - List organization users
- `update_organization_settings` - Update organization settings

### Connection Management
- `list_environment_connections` - List environment connections
- `list_organization_connections` - List organization connections
- `create_environment_oidc_connection` - Create OIDC connection
- `update_environment_oidc_connection` - Update OIDC connection
- `enable_environment_connection` - Enable connection

### Workspace Management
- `list_workspace_members` - List workspace members
- `invite_workspace_member` - Invite new member

### MCP Server Management
- `list_mcp_servers` - List MCP servers
- `register_mcp_server` - Register new MCP server
- `update_mcp_server` - Update MCP server
- `switch_mcp_auth_to_scalekit` - Switch to Scalekit auth

See [GitHub README](https://github.com/scalekit-inc/scalekit-mcp-server) for complete tool documentation with parameters and examples.

## Resources

- **GitHub Repository**: [scalekit-inc/scalekit-mcp-server](https://github.com/scalekit-inc/scalekit-mcp-server)
- **Hosted Server**: [https://mcp.scalekit.com](https://mcp.scalekit.com)
- **Scalekit Documentation**: [docs.scalekit.com](https://docs.scalekit.com)
- **MCP Protocol Spec**: [spec.modelcontextprotocol.io](https://spec.modelcontextprotocol.io/)
- **Scalekit Node SDK**: [github.com/scalekit-inc/scalekit-sdk-node](https://github.com/scalekit-inc/scalekit-sdk-node)

## Quick Start

### Using Hosted Server

The Scalekit MCP server is already hosted and ready to use:

```json
{
  "mcpServers": {
    "scalekit": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.scalekit.com/"]
    }
  }
}
```

### Running Your Own Instance

```bash
# Clone repository
git clone https://github.com/scalekit-inc/scalekit-mcp-server.git
cd scalekit-mcp-server

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with your Scalekit credentials

# Build and run
npm run build
npm start
```

## Key Takeaways

1. **Modular Tool Organization**: Group tools by domain (environments, organizations, connections)
2. **Scope-Based Authorization**: Enforce fine-grained permissions at the tool level
3. **Type Safety**: Use TypeScript and Zod for reliable input validation
4. **Error Handling**: Graceful error responses with proper logging
5. **Production Ready**: Include health checks, structured logging, monitoring hooks
6. **Security**: Validate issuer and audience on every request
7. **Documentation**: Clear tool descriptions for AI discoverability

This implementation serves as a reference for building production-grade MCP servers with OAuth 2.1 authentication and comprehensive tooling.
