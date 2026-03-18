# AGENTS.md

This repository is a monorepo of Cursor plugins intended for marketplace distribution.
Any agent changing this repo must follow this document.

## What this repo contains

Everything under `plugins/` is a Cursor plugin that can be installed and shared across teams.
A plugin may include skills, agents, rules, commands, and MCP configuration.

## Monorepo layout

Repo root

- `plugins/` Plugin directories live here
- `.cursor-plugin/` Cursor marketplace manifest (marketplace.json)
- `AGENTS.md` This file
- `README.md` Repo overview and usage notes
- `assets/` Shared assets (logos, images)

Expected plugin layout:
```
plugins/<plugin-name>/
  .cursor-plugin/plugin.json    Required: plugin manifest
  README.md                     Required: plugin documentation
  skills/<skill-name>/SKILL.md  Required: skill entrypoint
  agents/                       Optional: custom sub-agents
  rules/                        Optional: Cursor rules (.mdc files with frontmatter)
  commands/                     Optional: slash commands
  .mcp.json                     Optional: MCP server configuration
```

## Plugins

### mcp-auth

OAuth 2.1 authorization for MCP servers using Scalekit.

Skills:
- `add-mcp-auth` — adds OAuth 2.1 auth to any MCP server
- `mcp-auth-expressjs-scalekit` — Express.js MCP server with OAuth
- `mcp-auth-fastapi-fastmcp-scalekit` — FastAPI + FastMCP with OAuth
- `mcp-auth-fastmcp-scalekit` — FastMCP with Scalekit provider
- `production-readiness-scalekit` — MCP auth production readiness checklist

Agents: `setup-auth.md`, `validate-mcp-auth.md`

Rules: `mcp-oauth-discovery.mdc`, `mcp-scope-authorization.mdc`, `mcp-secrets-hygiene.mdc`, `mcp-token-validation.mdc`, `no-secrets.mdc`

### agent-auth

Implements Scalekit Agent Auth so AI agents can act in third-party apps (Gmail, Slack, Calendar, Notion) on behalf of users.

Skills:
- `agent-auth` — integrates Scalekit Agent Auth (OAuth flows, token storage, auto-refresh)
- `building-agent-mcp-server` — creates Scalekit MCP servers with authenticated tool access
- `production-readiness-scalekit` — agent auth production readiness checklist

Agents: `setup-scalekit.md`

Rules: `oauth-security.mdc`

References: `agent-connectors/` (connector-specific docs), `connected-accounts.md`, `code-samples.md`, `providers.md`, `connections.md`, `byoc.md`, `redirects.md`

### full-stack-auth

Production-ready authentication flows using Scalekit full-stack auth across common stacks.

Skills:
- `full-stack-auth` — complete auth flow (sign-up, login, logout, sessions)
- `implementing-scalekit-nextjs-auth` — Next.js App Router integration
- `implementing-scalekit-django-auth` — Django integration
- `implementing-scalekit-fastapi-auth` — FastAPI integration
- `implementing-scalekit-flask-auth` — Flask integration
- `implementing-scalekit-go-auth` — Go (Gin) integration
- `implementing-scalekit-springboot-auth` — Spring Boot integration
- `implementing-scalekit-laravel-auth` — Laravel integration
- `implement-logout` — complete logout flows across stacks
- `implementing-access-control` — RBAC and permission checks
- `implementing-admin-portal` — self-serve SSO/SCIM customer portal
- `adding-api-key-auth` — API key creation, validation, and revocation
- `adding-oauth2-to-apis` — OAuth 2.0 client-credentials for machine-to-machine auth
- `manage-user-sessions` — secure session storage and token refresh
- `migrating-to-scalekit-auth` — incremental migration from existing auth
- `production-readiness-scalekit` — production readiness checklist

Agents: `setup-scalekit.md`, `sdk-version-advisor.md`, `session-management-reviewer.md`, `scalekit-mcp-helper.md`

Commands: `dryrun.md`

Rules: `web-auth-security.mdc`

References: `redirects.md`, `scalekit-logs.md`, `scalekit-user-profiles.md`

### modular-sso

Modular SSO flows using Scalekit for apps with existing user management.

Skills:
- `modular-sso` — complete SSO and authentication flows, IdP-initiated login, enterprise onboarding
- `implementing-admin-portal` — self-serve SSO configuration portal
- `production-readiness-scalekit` — SSO production readiness checklist

Agents: `setup-scalekit.md`, `sso-validate.md`

Commands: `dryrun-sso.md`

Rules: `sso-security.mdc`

References: `redirects.md`

### modular-scim

SCIM webhook provisioning with Scalekit for real-time user and group lifecycle management.

Skills:
- `modular-scim` — SCIM user provisioning via Scalekit's Directory API and webhooks
- `implementing-admin-portal` — self-serve SCIM configuration portal
- `production-readiness-scalekit` — SCIM production readiness checklist

Agents: `setup-scalekit.md`, `scim-validate.md`

Commands: `dryrun-scim.md`

Rules: `scim-security.mdc`

References: `redirects.md`

## Non-negotiable rules

- Work on one plugin at a time unless the user explicitly asks for cross-plugin changes.
- Never add secrets, tokens, credentials, or private endpoints to any file.
- Prefer minimal changes that improve correctness, security, and user clarity.
- Keep instructions stable, avoid time-dependent guidance.
- Use forward slashes in all paths.

## Plugin manifest rules

- Manifest must exist at `plugins/<plugin-name>/.cursor-plugin/plugin.json`.
- Use lowercase letters, numbers, and hyphens only for plugin names.
- Follow semantic versioning: major.minor.patch.
- Avoid reserved or misleading names.

## Cursor rules (.mdc) authoring rules

Every `.mdc` file in a `rules/` directory MUST have valid YAML frontmatter:

```yaml
---
description: Short description of what this rule enforces
alwaysApply: true
globs: ["**/*.{js,ts,py,go}"]  # optional - file patterns this rule applies to
---
```

- `description` is required (string).
- `alwaysApply` is required (boolean: true or false).
- `globs` is optional (string or array of strings).

## Skill authoring rules

Each skill is a folder with `SKILL.md` as its entrypoint.

Frontmatter requirements:
- `name` must be lowercase, hyphenated, max 64 chars.
- `description` must be third person and include both what it does and when to use it.

Context budget:
- Keep `SKILL.md` short and practical.
- Put deep docs in reference files linked from `SKILL.md`.
- Do not create multi-hop reference chains.

## MCP rules

- `.mcp.json` must use environment variables for secrets, never inline credentials.
- Tools must be outcome-focused and handle common failures inside the tool.
- Validate all tool inputs at boundaries.

## Documentation rules

Each plugin README must include:
- Purpose and non-goals
- Install instructions
- Skills list with example invocations
- Configuration and required env vars
- Troubleshooting section
- Security notes

## Local verification checklist

Before marking a change done:
- Load the plugin locally from its folder
- Invoke at least one relevant skill
- Ensure naming and frontmatter rules are followed
- Ensure no secrets were introduced
- Update README when behavior changes
