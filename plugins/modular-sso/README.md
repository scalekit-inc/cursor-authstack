# Modular SSO

Enterprise SSO integration for applications with existing user management.

## Overview

This plugin implements modular SSO flows using Scalekit for apps that already have their own user/session management. Once installed, Cursor's agent will help you:

- Configure SSO with enterprise identity providers (Okta, Entra ID, JumpCloud, etc.)
- Handle both SP-initiated and IdP-initiated SSO flows
- Set up customer onboarding via Admin Portal
- Integrate with existing auth systems (Auth0, Firebase, AWS Cognito)

## Skills

| Skill | Description |
|-------|-------------|
| `implementing-sso` | Core SSO implementation with Scalekit |
| `implementing-admin-portal` | Set up self-service SSO configuration for customers |
| `production-readiness-scalekit` | Production deployment checklist |

## Supported Identity Providers

- Okta
- Microsoft Entra ID (Azure AD)
- Google Workspace
- JumpCloud
- OneLogin
- Ping Identity
- And 20+ more via SAML 2.0 / OIDC

## Requirements

- Scalekit account ([app.scalekit.com](https://app.scalekit.com))
- Environment variables: `SCALEKIT_ENVIRONMENT_URL`, `SCALEKIT_CLIENT_ID`, `SCALEKIT_CLIENT_SECRET`

## License

MIT
