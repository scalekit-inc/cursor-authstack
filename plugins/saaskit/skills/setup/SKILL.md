---
name: setup
description: Starting point for any Scalekit SaaSKit integration. Use when the user says "I want to add auth", "set up Scalekit", "where do I start", or is new to SaaSKit and doesn't know which skill to use. Routes to the right skill based on framework and what they're building.
---

# SaaSKit — Where to Start

Answer 3 questions, then follow the link for your exact skill.

---

## Step 1: Ask the user these questions

If answers aren't already clear from context, ask:

1. **New or existing codebase?**
   - New project
   - Adding auth to an existing app

2. **Framework?**
   - Next.js (App Router or Pages Router)
   - Python (Django / FastAPI / Flask)
   - Go
   - Other / not sure

3. **What are you adding?**
   - Login, sessions, and user management (most common starting point)
   - Enterprise SSO (Okta, Azure AD, Google Workspace, etc.)
   - SCIM / user provisioning (sync users from a directory)
   - Secure an MCP server with OAuth 2.1
   - API keys for developers
   - Not sure / full auth stack

---

## Step 2: Route to the right skill

| Framework | What you're adding | Skill |
|---|---|---|
| Next.js | Login + sessions | `/saaskit:implementing-saaskit-nextjs` |
| Python | Login + sessions | `/saaskit:implementing-saaskit-python` |
| Go / other | Login + sessions | `/saaskit:implementing-saaskit` |
| Any | Enterprise SSO | `/saaskit:implementing-modular-sso` |
| Any | SCIM provisioning | `/saaskit:implementing-scim-provisioning` |
| Any | MCP server auth | `/saaskit:adding-mcp-oauth` |
| Any | API keys | `/saaskit:adding-api-auth` |
| Any | RBAC / permissions | `/saaskit:implementing-access-control` |
| Any | Migrating from Auth0 / Firebase / custom auth | `/saaskit:migrating-to-saaskit` |

If the user wants **login + SSO + SCIM** (full B2B auth stack), start with `/saaskit:implementing-saaskit` or the framework-specific variant, then chain to `/saaskit:implementing-modular-sso` once login is working.

---

## Step 3: Environment setup (if new project)

Before starting any skill, verify credentials exist:

```bash
SCALEKIT_ENVIRONMENT_URL=https://your-env.scalekit.dev
SCALEKIT_CLIENT_ID=<from dashboard>
SCALEKIT_CLIENT_SECRET=<from dashboard>
```

Get these from [app.scalekit.com](https://app.scalekit.com) → Developers → Settings → API Credentials.

Use `/saaskit:testing-auth-setup` to validate credentials and connection end-to-end before writing any auth code.

---

## When to switch skills

- **Already know what you need?** Skip this skill and invoke the target directly.
- **SDK errors or wrong imports?** Use `/saaskit:scalekit-code-doctor`.
- **Production checklist?** Use `/saaskit:production-readiness-saaskit`.
