# SaaSKit for Cursor

## Purpose

Production-ready auth for B2B SaaS apps. This plugin brings Scalekit SaaSKit into Cursor so agents can build production-ready B2B authentication into web applications. It covers the entire auth lifecycle: login, sessions, SSO, SCIM provisioning, MCP server auth, and more.

One integration enables: magic link & OTP, social sign-ins, enterprise SSO, workspaces, MCP authentication, SCIM provisioning, and user management.

## Installation

Install from the Scalekit Auth Stack marketplace in Cursor.

## Skills Reference

- `implementing-saaskit` — Core auth flow: login, signup, callback, token exchange, session management, logout.
- `implementing-modular-sso` — Enterprise SSO (SAML/OIDC) with 20+ IdPs, admin portal, JIT provisioning.
- `implementing-scim-provisioning` — SCIM 2.0 webhooks, user/group lifecycle, directory API.
- `adding-mcp-oauth` — OAuth 2.1 for MCP servers (FastMCP, Express, FastAPI).
- `production-readiness-saaskit` — Unified production checklist across all SaaSKit domains.

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
