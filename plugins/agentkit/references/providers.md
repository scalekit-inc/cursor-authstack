# Providers

Providers in Agent Auth represent third-party applications that your users can connect to and interact with through Scalekit's unified API. Each provider offers a set of tools and capabilities that can be executed on behalf of connected users.

## What are providers?

Providers are pre-configured integrations with popular third-party applications that enable your users to:

- **Connect their accounts** using secure authentication methods
- **Execute tools and actions** through a unified API interface
- **Access data and functionality** from external applications
- **Maintain secure connections** with proper authorization scopes

## Supported providers

Agent Auth supports a wide range of popular business applications:

| Category | Providers |
|---|---|
| **Google Workspace** | Gmail, Google Calendar, Google Drive, Google Docs, Google Sheets, Google Forms, Google Meet, Google Ads |
| **Microsoft 365** | Outlook, OneDrive, SharePoint, Microsoft Teams, Microsoft Excel, Microsoft Word, OneNote |
| **Communication** | Slack, Zoom |
| **Project Management** | Jira, Asana, Trello, Monday.com, ClickUp, Linear, Confluence |
| **CRM & Sales** | Salesforce, HubSpot, Zendesk, Freshdesk, Intercom, Gong |
| **Development** | GitHub |
| **Productivity** | Notion, Airtable, Dropbox |
| **Data & Analytics** | BigQuery, Snowflake, Fathom |
| **Service Management** | ServiceNow |

For per-connector tool specifications, see [agent-connectors/README.md](agent-connectors/README.md).

## Provider capabilities

Each provider offers different capabilities based on their API and authentication model.

### Authentication methods

- **OAuth 2.0**: Standard method for all supported providers

### Available tools

Providers expose various tools that can be executed through Agent Auth:

> **Note:** Tool availability depends on the specific provider and the user's permissions within that application.

**Common tool categories:**

- **Data retrieval**: Fetch emails, calendar events, files, or records
- **Data creation**: Create new items, send messages, or schedule events
- **Data modification**: Update existing records or settings
- **File operations**: Upload, download, or manage files
- **Communication**: Send notifications, messages, or alerts

### Rate limits and quotas

Each provider has different rate limits and quotas:

- **API rate limits**: Requests per minute/hour limitations
- **Data quotas**: Storage or transfer limitations
- **Feature restrictions**: Premium features or enterprise-only capabilities

## Provider configuration

### Adding a provider

1. **Navigate to providers** in your Agent Auth dashboard
2. **Select provider** from the available options
3. **Configure settings** such as scopes and permissions
4. **Set up authentication** — configure OAuth client credentials if using custom OAuth apps
5. **Test connection** to verify provider setup

### Provider settings

Each provider can be configured with:

**Authentication settings:**
- OAuth client credentials (if using custom OAuth apps)
- API endpoint URLs
- Supported scopes and permissions
- Token refresh settings

**Rate limiting:**
- Request throttling settings
- Backoff strategies for rate limit errors

## Working with provider APIs

### API integration

The Scalekit SDK abstracts provider-specific APIs — the workflow (create account → authorize → fetch token → call API) is identical for all providers. Only the downstream API call changes:

```python
# Step 3: Fetch token (always call this immediately before the API call)
response = actions.get_connected_account(
    connection_name="slack",   # Replace with any connector name
    identifier="user_123"
)
tokens = response.connected_account.authorization_details["oauth_token"]
access_token = tokens["access_token"]

# Step 4: Call the provider API with the token
headers = {"Authorization": f"Bearer {access_token}"}
```

Scalekit automatically refreshes expired tokens on `get_connected_account` — no manual refresh logic needed.

### Error handling

Agent Auth normalizes provider-specific errors into consistent error responses:

```javascript
{
  error: {
    code: 'RATE_LIMIT_EXCEEDED',
    message: 'Provider rate limit exceeded',
    provider: 'gmail',
    details: {
      retryAfter: 60,
      limitType: 'requests_per_minute'
    }
  }
}
```

## Provider-specific considerations

### Google Workspace

- **OAuth scopes**: Requires specific scopes for different Google services
- **Rate limits**: Generous limits but varies by service
- **Data access**: Supports both personal and organization data
- **Security**: Supports domain-wide delegation for enterprise

### Microsoft 365

- **Authentication**: Supports both personal and work accounts
- **Graph API**: Unified API for all Microsoft services
- **Permissions**: Granular permission model
- **Compliance**: Built-in compliance and audit features

### Slack

- **Workspace apps**: Requires installation in each workspace
- **Bot tokens**: Different capabilities for bot vs user tokens
- **Rate limits**: Tier-based limits depending on workspace size
- **Channels**: Requires specific permissions for private channels

### Jira

- **Project access**: Permissions are project-specific
- **Issue types**: Different issue types have different fields
- **Workflows**: Custom workflows affect available actions

## Best practices

### Authentication setup

- **Use minimal scopes**: Request only necessary permissions
- **Token refresh**: Scalekit handles this automatically — call `get_connected_account` before every API call
- **Monitor auth status**: Track connected account status; re-authorize if status is not `ACTIVE`

### Tool execution

- **Respect rate limits**: Implement throttling and exponential backoff for 429 errors
- **Cache results**: Cache frequently accessed data to avoid redundant API calls
- **Error recovery**: Retry transient failures; surface permanent errors to users

## Monitoring and analytics

### Provider health

- **API uptime**: Track provider API availability
- **Response times**: Monitor latency for different operations
- **Error rates**: Track errors by provider and tool type
- **Rate limit usage**: Monitor quota consumption

### Usage analytics

- **Popular providers**: Which providers are used most
- **Tool usage**: Which tools are executed most frequently
- **User adoption**: How many users connect to each provider
- **Error patterns**: Common failure modes by provider

## Related documentation

- [connections.md](connections.md) — how to configure authentication credentials for a provider
- [connected-accounts.md](connected-accounts.md) — per-user account lifecycle and token management
- [agent-connectors/README.md](agent-connectors/README.md) — detailed API tools for each provider
- [code-samples.md](code-samples.md) — implementation examples by framework
