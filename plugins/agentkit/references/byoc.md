# Bring Your Own Credentials

Bring Your Own Credentials (BYOC) allows you to use your own OAuth applications and authentication credentials with Agent Auth instead of Scalekit's shared credentials. This provides complete control over the authentication experience and enables full whitelabeling of your application.

## Why bring your own credentials?

### Complete whitelabeling

When you use your own OAuth credentials, users see your application name and branding throughout the authentication flow instead of Scalekit's:

- **OAuth consent screens** display your app name and logo
- **Authorization URLs** use your domain and branding
- **Email notifications** from providers reference your application
- **User permissions** are granted directly to your application

### Enhanced security and control

- **Direct relationship**: Maintain direct OAuth relationships with providers
- **Full audit trail**: Complete visibility into authentication flows and user consent
- **Custom verification**: Complete OAuth app verification with your company details
- **Compliance control**: Meet regulatory requirements for direct provider relationships

### Production-grade capabilities

- **Dedicated quotas**: Avoid sharing rate limits with other Scalekit customers
- **Higher limits**: Access provider-specific quota increases for your application
- **Priority support**: Direct support relationships with OAuth providers
- **Custom integrations**: Build provider-specific customizations

## How BYOC works

With BYOC, authentication flows work as follows:

1. **Scalekit** handles the initial authentication request with your OAuth client-id details
2. **Provider** authenticates the user and returns tokens to Scalekit
3. **Agent Auth** uses your tokens to execute tools on behalf of users

## Setting up BYOC

1. Log in to the Scalekit Dashboard and click **Edit Connection** for the connector you want to configure.
2. Choose the option **"Use your own credentials"** and enter the **Client ID** and **Client Secret** obtained from the provider.
3. Copy the **Redirect URL** shown in the dashboard and add it as one of the authorized redirect URIs in the provider's developer console.

> In the dashboard: Edit Connection → "Use your own credentials" → enter Client ID and Client Secret → copy the Redirect URL shown and add it to your OAuth app's authorized redirect URIs.

## Migration from shared credentials

If you're currently using Scalekit's shared credentials and want to migrate to BYOC:

> **Note:** Migration considerations:
> - Users will need to re-authenticate with your OAuth applications
> - OAuth consent screens will change to show your branding
> - Rate limits and quotas will change to your application's limits
> - Some users may need to re-grant permissions

By implementing BYOC, you gain complete control over your users' authentication experience while maintaining the power and flexibility of Agent Auth's unified API for tool execution.
