---
name: testing-auth-setup
description: Validates a Scalekit auth integration by running the dryrun CLI against a live environment. Use when the user says "test my auth", "verify SSO setup", "check my login flow", "dryrun", or wants to confirm their Scalekit credentials and configuration are working.
argument-hint: "[fsa|sso]"
---

# Testing Auth Setup

Runs the Scalekit dryrun CLI to validate that your auth integration is correctly configured against a live environment.

## Modes

| Mode | What it tests | When to use |
|------|--------------|-------------|
| `fsa` | Full-stack auth login flow | User is setting up or verifying login, callback, and session handling |
| `sso` | Enterprise SSO flow | User is setting up or verifying SAML/OIDC SSO with an identity provider |

## Prerequisites

Install the Scalekit CLI globally if not already available:

```bash
npm i -g @scalekit-inc/cli
```

Confirm these environment variables are available:

- `SCALEKIT_ENV_URL` — your Scalekit environment URL
- `SCALEKIT_CLIENT_ID` — your client ID from app.scalekit.com → Settings

If either is missing, ask the user to provide them. Do not write credentials into source-controlled files.

## Running the test

### Full-stack auth (fsa)

```bash
npx @scalekit-sdk/dryrun --env_url=<env_url> --client_id=<client_id> --mode=fsa
```

### Enterprise SSO

Requires an `organization_id` — ask for it if not provided.

```bash
npx @scalekit-sdk/dryrun --env_url=<env_url> --client_id=<client_id> --mode=sso --organization_id=<organization_id>
```

## Choosing the mode

If the user doesn't specify a mode:

1. Check the project context — if there's SSO configuration (identity providers, SAML metadata), suggest `sso`.
2. Otherwise default to `fsa` as the most common starting point.
3. If ambiguous, ask which mode to use.

## After running

- Show the command output.
- Explain what passed and what failed in plain language.
- If the test fails, suggest specific next steps based on the error (missing redirect URI, invalid credentials, organization not found, etc.).