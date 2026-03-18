# Modular SCIM

SCIM 2.0 user provisioning and directory sync for real-time user lifecycle management.

## Overview

This plugin implements SCIM provisioning using Scalekit's Directory API and webhooks. Once installed, Cursor's agent will help you:

- Set up real-time user provisioning via webhooks
- Sync users and groups from identity providers
- Handle user lifecycle events (create, update, deactivate)
- Integrate with existing user management systems

## Skills

| Skill | Description |
|-------|-------------|
| `implementing-scim-provisioning` | Core SCIM implementation with webhooks |
| `implementing-admin-portal` | Set up self-service SCIM configuration for customers |
| `production-readiness-scalekit` | Production deployment checklist |

## How It Works

1. **Directory API**: Poll or on-demand sync of users and groups
2. **Webhooks**: Real-time provisioning events (user created/updated/deleted)
3. **Event Handling**: Map directory events to local user operations

## Supported Identity Providers

- Okta
- Microsoft Entra ID (Azure AD)
- Google Workspace
- JumpCloud
- OneLogin
- And more...

## Requirements

- Scalekit account ([app.scalekit.com](https://app.scalekit.com))
- Environment variables: `SCALEKIT_ENVIRONMENT_URL`, `SCALEKIT_CLIENT_ID`, `SCALEKIT_CLIENT_SECRET`, `SCALEKIT_WEBHOOK_SECRET`

## License

MIT
