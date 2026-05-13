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
  mcp.json                      Optional: MCP server configuration
  hooks/hooks.json               Optional: lifecycle hooks
```

## Plugins

### agentkit

Authentication for AI agents. OAuth flows, token vault, 40+ connectors, tool discovery, and live testing.

Skills:
- `integrating-agentkit` — core integration: SDK setup, connected accounts, OAuth flows, token fetching, agent frameworks
- `discovering-connector-tools` — live tool metadata discovery, schema inspection, tool set narrowing
- `exposing-agentkit-via-mcp` — expose AgentKit tools through MCP for compatible runtimes
- `production-readiness-agentkit` — production readiness checklist for AgentKit integrations

Rules: `terminology.mdc`, `live-metadata-first.mdc`, `tool-selection.mdc`

References: `connected-accounts.md`, `code-samples.md`, `connectors.md`, `connections.md`, `byoc.md`, `redirects.md`, `tool-discovery.md`

### saaskit

Production-ready auth for B2B SaaS apps. Login, sessions, SSO, SCIM, MCP server auth.

Skills:
- `implementing-saaskit` — core auth flow: login, signup, callback, token exchange, session management, logout
- `implementing-modular-sso` — enterprise SSO (SAML/OIDC) with 20+ IdPs, admin portal, JIT provisioning
- `implementing-scim-provisioning` — SCIM 2.0 webhooks, user/group lifecycle, directory API
- `adding-mcp-oauth` — OAuth 2.1 for MCP servers (FastMCP, Express, FastAPI reference files included)
- `adding-api-auth` — API keys and client credentials for machine-to-machine auth
- `implementing-access-control` — RBAC and permission enforcement using token claims
- `implementing-saaskit-nextjs` — Next.js App Router integration
- `implementing-saaskit-python` — Django, FastAPI, Flask integration
- `managing-saaskit-sessions` — token storage, validation, refresh, revocation
- `migrating-to-saaskit` — migration planner from existing auth systems
- `testing-auth-setup` — validates auth config with the dryrun CLI
- `production-readiness-saaskit` — unified production checklist across all SaaSKit domains

Agents: `setup-scalekit.md`, `scalekit-mcp-auth-troubleshooter.md`

Rules: `terminology.mdc`, `redirect-urls.mdc`

References: `bring-your-own-auth.md`, `redirects.md`, `scalekit-logs.md`, `scalekit-mcp-server.md`, `scalekit-user-profiles.md`, `session-management-patterns.md`

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

- `mcp.json` must use environment variables for secrets, never inline credentials.
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
