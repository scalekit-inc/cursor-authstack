# SaaSKit for Cursor

## Purpose

Production-ready auth for B2B SaaS apps. This plugin brings Scalekit SaaSKit into Cursor so agents can build production-ready B2B authentication into web applications. It covers the entire auth lifecycle: login, sessions, SSO, SCIM provisioning, MCP server auth, and more.

One integration enables: magic link & OTP, social sign-ins, enterprise SSO, workspaces, MCP authentication, SCIM provisioning, and user management.

## Installation

1. Run the bootstrap installer in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/scalekit-inc/cursor-authstack/main/install.sh | bash
```

2. Open Cursor, then run the plugin install command from the Command Palette:

```
> Plugins: Install Plugin
```

Select **SaaSKit** from the Scalekit Auth Stack.

## Skills Reference

- `/saaskit:setup`
  New to SaaSKit? Start here — answers 3 questions and routes you to the right skill.
- `implementing-saaskit` — Core auth flow: login, signup, callback, token exchange, session management, logout.
- `implementing-modular-sso` — Enterprise SSO (SAML/OIDC) with 20+ IdPs, admin portal, JIT provisioning.
- `implementing-scim-provisioning` — SCIM 2.0 webhooks, user/group lifecycle, directory API.
- `adding-mcp-oauth` — OAuth 2.1 for MCP servers (FastMCP, Express, FastAPI).
- `adding-api-auth` — API keys and client credentials for machine-to-machine auth.
- `implementing-access-control` — RBAC and permission enforcement using token claims.
- `implementing-saaskit-nextjs` — Next.js App Router integration with Scalekit.
- `implementing-saaskit-python` — Django, FastAPI, Flask integration with Scalekit.
- `managing-saaskit-sessions` — Token storage, validation, refresh, revocation.
- `migrating-to-saaskit` — Migration planner from existing auth systems.
- `testing-auth-setup` — Validates auth config with the dryrun CLI.
- `production-readiness-saaskit` — Unified production checklist across all SaaSKit domains.
- `/saaskit:scalekit-code-doctor` — Diagnoses SDK usage issues, import errors, and common mistakes across AgentKit and SaaSKit.

## Configuration

Required environment variables:

- `SCALEKIT_ENVIRONMENT_URL`
- `SCALEKIT_CLIENT_ID`
- `SCALEKIT_CLIENT_SECRET`

Get these from [app.scalekit.com](https://app.scalekit.com): Developers → Settings → API Credentials.

## Helpful Links

- [Full-stack auth quickstart](https://docs.scalekit.com/authenticate/fsa/quickstart/)
- [Modular SSO guide](https://docs.scalekit.com/authenticate/sso/add-modular-sso/)
- [SCIM directory sync](https://docs.scalekit.com/directory/scim/quickstart/)
- [MCP Auth quickstart](https://docs.scalekit.com/authenticate/mcp/quickstart/)
- [LLM docs map](https://docs.scalekit.com/llms.txt)

## Security

- Store `SCALEKIT_CLIENT_SECRET` in environment variables or a secrets manager. Never commit it to version control.
- All tokens (access, refresh, ID) should be stored in HttpOnly, Secure, SameSite cookies.
- Validate access tokens on every request before trusting embedded roles/permissions.
- Use the admin portal iframe for customer self-serve SSO configuration.
