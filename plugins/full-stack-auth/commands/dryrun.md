---
description: Run Scalekit dryrun in fsa
argument-hint: "<mode:fsa|sso> <env_url> <client_id> [organization_id]"
allowed-tools: Bash(node *), Bash(npx *)
---

Run Scalekit dryrun with explicit arguments.

Expected arguments:
1. mode (`fsa`)
2. env_url
3. client_id
4. organization_id (required only for `sso`)

Behavior:
- If mode is `fsa`, run:
  `npx @scalekit-sdk/dryrun --env_url=<env_url> --client_id=<client_id> --mode=fsa`
- If mode is `sso`, run:
  `npx @scalekit-sdk/dryrun --env_url=<env_url> --client_id=<client_id> --mode=sso --organization_id=<organization_id>`
- If mode is missing/invalid, explain the usage and ask for valid arguments.
- If `sso` is selected but organization_id is missing, ask for it before running.
