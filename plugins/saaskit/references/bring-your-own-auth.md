# Scalekit MCP - Bring Your Own Auth Integration Guide

## Overview

Scalekit offers the option to integrate your existing authentication infrastructure with Scalekit's OAuth 2.1 layer for MCP servers. This integration is ideal when you have an existing auth system and want to add MCP OAuth without migrating users.

### Why Use This Integration?

When your B2B application already has an established authentication system, you can connect it to your MCP server through Scalekit. This ensures that:

- Users see the same familiar login screen whether accessing your application or your MCP server
- No user migration required - your existing user accounts work immediately with MCP
- You maintain control over your authentication logic while gaining MCP OAuth 2.1 compliance

This "bring your own auth" approach standardizes the authorization layer without requiring you to rebuild your existing authentication infrastructure.

## Authentication Flow

When an MCP client initiates an authentication flow, Scalekit redirects to your login endpoint. You then provide user details to Scalekit via a secure backend call, and finally redirect back to Scalekit to complete the process.

```
MCP Client → Scalekit Auth Server: Initiate /oauth/authorize (DCR, CIMD)
Scalekit Auth Server → Your B2B App: Redirect to /login?login_request_id&state
Your B2B App → Scalekit Auth Server: POST user details (Machine-to-Machine)
Scalekit Auth Server → Your B2B App: 200 Success Response
Your B2B App → Scalekit Auth Server: Redirect to /partner:callback?state
Scalekit Auth Server → MCP Client: Continue Consent, token exchange
```

## Implementation Steps

### 1. Initiate Authentication

The MCP client starts the authentication flow by calling `/oauth/authorize` on Scalekit. Scalekit redirects the user to your login endpoint with two parameters:

- `login_request_id`: Unique identifier for the login request
- `state`: Value to maintain state between requests

**Example Redirect URL:**
```
https://app.example.com/login?login_request_id=lri_86659065219908156&state=HntJ_ENB6y161i9_P1yzuZVv2SSTfD3aZH-Tej0_Y33_Fk8Z3g
```

### 2. Handle Authentication in Your Application

Once the user lands on your login page:

#### a. Authenticate the User

Take the user through your regular authentication logic (e.g., username/password, SSO, etc.).

#### b. Send User Details to Scalekit

Send the authenticated user's profile details from your backend to Scalekit to complete the login handshake.

**Python Example:**

```bash
pip install scalekit-sdk-python
```

```python
from scalekit import ScalekitClient
import os

scalekit = ScalekitClient(
    os.environ.get('SCALEKIT_ENVIRONMENT_URL'),
    os.environ.get('SCALEKIT_CLIENT_ID'),
    os.environ.get('SCALEKIT_CLIENT_SECRET')
)

# Update login user details
scalekit.auth.update_login_user_details(
    connection_id="{{connection_id}}",
    login_request_id="{{login_request_id}}",
    user={
        "sub": "1234567890",
        "email": "alice@example.com"
    },
)
```

**Node.js Example:**

```bash
npm install @scalekit-sdk/node
```

```javascript
import { Scalekit } from '@scalekit-sdk/node';

const scalekit = new Scalekit(
  process.env.SCALEKIT_ENVIRONMENT_URL,
  process.env.SCALEKIT_CLIENT_ID,
  process.env.SCALEKIT_CLIENT_SECRET
);

await scalekit.auth.updateLoginUserDetails(
  '{{connection_id}}',
  '{{login_request_id}}',
  {
    sub: '1234567890',
    email: 'alice@example.com'
  }
);
```

**Go Example:**

```bash
go get -u github.com/scalekit-inc/scalekit-sdk-go/v2
```

```go
import (
    "context"
    "github.com/scalekit-inc/scalekit-sdk-go/v2"
    "os"
)

func updateLoggedInUserDetails() error {
    skClient := scalekit.NewScalekitClient(
        os.Getenv("SCALEKIT_ENVIRONMENT_URL"),
        os.Getenv("SCALEKIT_CLIENT_ID"),
        os.Getenv("SCALEKIT_CLIENT_SECRET"),
    )

    err := skClient.Auth().UpdateLoginUserDetails(
        context.Background(),
        &scalekit.UpdateLoginUserDetailsRequest{
            ConnectionId:   "{{connection_id}}",
            LoginRequestId: "{{login_request_id}}",
            User: &scalekit.LoggedInUserDetails{
                Sub:   "1234567890",
                Email: "alice@example.com",
            },
        },
    )

    if err != nil {
        return err
    }

    return nil
}
```

**cURL Example:**

First, acquire an access token:

```bash
curl --location '{{env_url}}/oauth/token' \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=client_credentials' \
  --data-urlencode 'client_id={{sk_client_id}}' \
  --data-urlencode 'client_secret={{sk_client_secret}}'
```

Then send user details:

```bash
curl --location '{{env_url}}/api/v1/connections/{{connection_id}}/auth-requests/{{login_request_id}}/user' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer {{access_token}}' \
  --data-raw '{
    "sub": "1234567890",
    "email": "alice@example.com"
  }'
```

**Important Notes:**

- Replace placeholders like `{{env_url}}`, `{{connection_id}}`, `{{login_request_id}}`, and `{{access_token}}` with actual values
- Only `sub` and `email` are required fields; all other properties are optional
- Get the `{{connection_id}}` from the User Info Post URL in your Scalekit MCP server dashboard
- Example: If the URL is `https://yourapp.scalekit.com/api/v1/connections/conn_1234567890/auth-requests/{{login_request_id}}/user`, your connection_id is `conn_1234567890`

### 3. Redirect Back to Scalekit

Once you receive a successful response from Scalekit, redirect the user back to Scalekit using the provided `state` value:

**Redirect URL:**
```
{{envurl}}/sso/v1/connections/{{connection_id}}/partner:callback?state={{state_value}}
```

The `state_value` should match the `state` parameter you received in Step 1.

### 4. Completion

After processing the callback from your auth system, Scalekit handles the remaining steps automatically:
- Showing the consent screen to the user
- Token exchange
- Permissions delegation

## Security Best Practices

- Ensure your backend securely stores and transmits all sensitive data
- The `login_request_id` and `state` parameters are essential for correlating requests and maintaining security
- Never expose client secrets or access tokens in client-side code
- Validate all redirect URLs to prevent open redirect vulnerabilities

## Next Steps

### Complete Working Examples

Production-ready MCP server implementations with different OAuth integration approaches:

1. **FastMCP (Simplest)**
   - 5-line OAuth integration with Scalekit provider
   - Automatic token validation and scope enforcement
   - [todo-fastmcp](https://github.com/scalekit-inc/mcp-auth-demos/tree/main/todo-fastmcp)
   - Skill: [add-auth-fastmcp](../skills/add-auth-fastmcp/SKILL.md)

2. **Express.js (Full Control)**
   - Manual OAuth middleware implementation
   - Modular architecture with complete control
   - [greeting-mcp-node](https://github.com/scalekit-inc/mcp-auth-demos/tree/main/greeting-mcp-node)
   - Skill: [express-mcp-server](../skills/express-mcp-server/SKILL.md)

3. **FastAPI + FastMCP (Python)**
   - Custom middleware with FastMCP tooling
   - Ideal for existing FastAPI applications
   - [greeting-mcp-python](https://github.com/scalekit-inc/mcp-auth-demos/tree/main/greeting-mcp-python)
   - Skill: [fastapi-fastmcp](../skills/fastapi-fastmcp/SKILL.md)

4. **Scalekit MCP Server (Production Reference)**
   - Official Scalekit implementation with advanced patterns
   - Comprehensive tooling and best practices
   - [scalekit-mcp-server](https://github.com/scalekit-inc/scalekit-mcp-server)
   - Reference: [scalekit-mcp-server.md](./scalekit-mcp-server.md)

**Download Sample MCP Server:**
Check out a working MCP server implementation with complete authentication and authorization:
https://github.com/scalekit-inc/mcp-auth-demos

## Troubleshooting

### Invalid login_request_id
- Ensure the `login_request_id` hasn't expired (typically valid for 10 minutes)
- Verify you're using the exact value from the redirect URL

### State mismatch errors
- The `state` parameter must match exactly between the initial redirect and callback
- Ensure you're not modifying or encoding the state value

### Connection not found
- Verify your `connection_id` is correct from the Scalekit dashboard
- Check that the connection is active and properly configured

## Additional Resources

- [Scalekit Documentation](https://docs.scalekit.com)
- [MCP Authentication Guide](https://docs.scalekit.com/mcp/authentication)
- [OAuth 2.1 Specification](https://oauth.net/2.1/)
