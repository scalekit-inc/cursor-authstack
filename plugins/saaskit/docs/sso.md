# SSO

SaaSKit supports two SSO modes:

- **SaaSKit (Full-Stack Auth)**: Scalekit manages users and sessions. SSO is built in.
- **Modular SSO**: Your app manages users and sessions. Scalekit handles the IdP redirect and token exchange.

This doc covers Modular SSO and the admin portal for customer self-serve configuration.

## Modular SSO flow

1. Generate an authorization URL with a connection selector.
2. Redirect the user to the IdP (via Scalekit).
3. Handle the callback — exchange the code for user profile and tokens.
4. Create a session in your app using the returned user data.

### Connection selectors (precedence order)

| Selector | Use case |
|---|---|
| `connectionId` | Direct SSO connection reference |
| `organizationId` | Routes to the org's active SSO connection |
| `loginHint` | Email — Scalekit extracts the domain to find the connection |

```js
// Node.js
const authUrl = scalekit.getAuthorizationUrl(redirectUri, {
  organizationId: 'org_15421144869927830',
});
res.redirect(authUrl);
```

```python
# Python
options = AuthorizationUrlOptions()
options.organization_id = 'org_15421144869927830'
auth_url = scalekit_client.get_authorization_url(redirect_uri, options=options)
```

## IdP-initiated login

When a user starts login from their IdP portal (e.g., Okta tile), Scalekit sends a signed JWT to your login endpoint. Decode it and convert to a standard SP-initiated flow:

```js
// Node.js
app.get('/login', async (req, res) => {
  const { idp_initiated_login } = req.query;
  if (idp_initiated_login) {
    const claims = await scalekit.getIdpInitiatedLoginClaims(idp_initiated_login);
    const authUrl = scalekit.getAuthorizationUrl(redirectUri, {
      connectionId: claims.connection_id,
      organizationId: claims.organization_id,
      loginHint: claims.login_hint,
    });
    return res.redirect(authUrl);
  }
  // Normal login flow
});
```

Configure the initiate login endpoint in **Dashboard > Authentication > Redirects**.

## Supported IdPs

Okta, Azure AD, Google Workspace, and any SAML 2.0 or OIDC-compliant identity provider. Customers configure their IdP through the admin portal.

## Admin portal

The admin portal lets your customers configure their own SSO (and SCIM) settings. Embed it as an iframe in your app's settings UI, or share a one-time link for onboarding.

### Generate a portal link (server-side)

```js
// Node.js
const { location } = await scalekit.organization.generatePortalLink(organizationId);
// Pass `location` to the frontend — links are single-use.
```

```python
# Python
portal = scalekit_client.organization.generate_portal_link(organization_id)
location = portal.location
```

### Embed the iframe

```html
<iframe src="{{ portalLink }}" width="100%" height="600px"
  frameborder="0" allow="clipboard-write"></iframe>
```

### Handle portal events

```js
window.addEventListener('message', (event) => {
  if (event.origin !== process.env.SCALEKIT_ENVIRONMENT_URL) return;
  if (event.data.type === 'SESSION_EXPIRED') {
    // Re-fetch portal link and reload iframe
  }
});
```

**Requirements:**
- Register your app domain in **Dashboard > Redirect URIs** — the iframe is blocked otherwise.
- Generate a new link on every page load — links are single-use.
- Handle `SESSION_EXPIRED` events to prevent silent portal failures.

### Shareable link (no-code)

For one-time onboarding: **Dashboard > Organizations** > select org > **Generate link**. Share the URL and the [SSO setup guide](https://docs.scalekit.com/guides/integrations/sso-integrations/) with the customer's IT admin.

## Related docs

- [auth-flows.md](auth-flows.md) — The underlying OIDC flow that SSO builds on.
- [scim.md](scim.md) — Directory sync, often configured alongside SSO.
