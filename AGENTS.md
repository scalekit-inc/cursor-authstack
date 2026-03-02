# AGENTS.md

This repository is a monorepo of Claude Code plugins intended for marketplace distribution.
Any agent changing this repo must follow this document.

## What this repo contains

Everything under `plugins/` is a Claude Code plugin that can be installed and shared across teams.
A plugin may include skills, agents, hooks, and MCP configuration.

## Monorepo layout

Repo root

- `plugins/` Plugin directories live here
- `AGENTS.md` This file
- `README.md` Repo overview and usage notes
- `CHANGELOG.md` Release notes at repo level (also check plugin level files)
- `.lsp.json` Language server config for local development

Expected plugin layout
plugins/<plugin-name>/

- `.claude-plugin/plugin.json` Required plugin manifest
- `README.md` Required plugin documentation
- `skills/<skill-name>/SKILL.md` Required skill entrypoint
- `skills/<skill-name>/reference.md` Optional deep docs loaded only when needed
- `skills/<skill-name>/examples.md` Optional input output pairs loaded only when needed
- `skills/<skill-name>/scripts/` Optional scripts executed by Claude, not loaded as context
- `agents/` Optional custom sub agents
- `hooks/hooks.json` Optional lifecycle hooks
- `.mcp.json` Optional MCP server configuration
- `settings.json` Optional default settings

## Non negotiable rules

- Work on one plugin at a time unless the user explicitly asks for cross plugin changes.
- Never add secrets, tokens, credentials, or private endpoints to any file.
- Prefer minimal changes that improve correctness, security, and user clarity.
- Keep instructions stable, avoid time dependent guidance.
- Use forward slashes in all paths.

## Plugin manifest rules

- Manifest must exist at `plugins/<plugin-name>/.claude-plugin/plugin.json`.
- Plugin name is the namespace for skills: `/plugin-name:skill-name`.
- Use lowercase letters, numbers, and hyphens only for plugin names.
- Follow semantic versioning: major.minor.patch.
- Avoid reserved or misleading names, do not include anthropic or claude in the plugin name.

## Skill authoring rules

Each skill is a folder with `SKILL.md` as its entrypoint.

Frontmatter requirements

- `name` must be lowercase, hyphenated, max 64 chars, and ideally gerund form like `reviewing-prs`.
- `description` must be third person and include both what it does and when to use it.

Context budget

- Keep `SKILL.md` short and practical.
- Put deep docs in `reference.md` and examples in `examples.md`.
- Do not create multi hop reference chains, all supporting files should be linked directly from `SKILL.md`.

Side effects

- If a skill can run destructive commands or mutate state, set it up to be user invoked only.
- Prefer safe defaults, explicit confirmation, and clear guardrails.

## Hooks rules

- Hooks must be safe by default.
- If a hook can run `Bash`, validate the command and block dangerous patterns.
- Document how to disable hooks in the plugin README.

## MCP rules

- `.mcp.json` must use environment variables for secrets, never inline credentials.
- Tools must be outcome focused and handle common failures inside the tool, returning actionable errors.
- Validate all tool inputs at boundaries.

## Documentation rules

Each plugin README must include

- Purpose and non goals
- Install instructions
- Skills list with example invocations
- Configuration and required env vars
- Troubleshooting section
- Security notes

If behavior changes, update the plugin README in the same PR.

## Local verification checklist

Before marking a change done

- Load the plugin locally from its folder
- Invoke at least one relevant skill
- Ensure naming and frontmatter rules are followed
- Ensure no secrets were introduced
- Update README when behavior changes
