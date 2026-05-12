---
name: production-readiness-saaskit
description: Walks through a structured production readiness checklist for Scalekit SaaSKit implementations covering authentication, SSO, SCIM, MCP server auth, and API security. Use when going live, launching to production, or doing a pre-launch review.
---

# SaaSKit Production Readiness

Unified checklist for all SaaSKit domains. Work through in order — skip sections that don't apply.

## Quick checks (run first)

- [ ] Production env URL, client ID, and client secret set (not dev/staging)
- [ ] HTTPS enforced; CORS restricted to your domains only
- [ ] All credentials in environment variables — never committed to code
- [ ] Only enabled auth methods active in production

## Customization

- [ ] Login page branded; email templates customized
- [ ] Custom domain configured (if applicable); email deliverability tested
- [ ] Webhooks configured with signature validation

## Core auth flows

- [ ] Login initiation, code exchange, and redirect URLs match dashboard exactly
- [ ] `state` parameter validated in callbacks (CSRF); tokens stored with `httpOnly`, `secure`, `sameSite`
- [ ] Token refresh and session timeout working; logout calls Scalekit end-session
- [ ] Each enabled auth method tested; errors handled gracefully

## SSO (if applicable)

- [ ] SSO tested with target IdPs (Okta, Azure AD, Google Workspace)
- [ ] SP-initiated and IdP-initiated flows both working
- [ ] Admin portal configured for self-serve SSO setup
- [ ] JIT provisioning: domains registered, default roles set, attribute sync enabled

## SCIM provisioning (if applicable)

- [ ] Webhook endpoints receiving events with signature validation
- [ ] User provisioning, deprovisioning, and profile updates tested
- [ ] Group-based role sync working; idempotent handling verified

## MCP authentication (if applicable)

- [ ] MCP auth flow tested end-to-end; resource metadata published
- [ ] Scopes enforced per tool; client reconnection after token expiry working

## Network / firewall

Enterprise VPN customers must whitelist: `<your-env>.scalekit.com`, `cdn.scalekit.com`, `fonts.googleapis.com`.

## Monitoring

- [ ] Auth logs monitoring active; alerts for suspicious activity configured
- [ ] Webhook monitoring active; error tracking for auth and provisioning failures
- [ ] Incident response runbook written; rollback plan ready (feature flag)
- **Key metrics:** login success/failure rates, session duration, webhook delivery, SSO completion rate

## Deep reference

- [Scalekit Documentation](https://docs.scalekit.com)
- [Modular SSO guide](https://docs.scalekit.com/authenticate/sso/add-modular-sso/)
- [SCIM directory sync](https://docs.scalekit.com/directory/scim/quickstart/)
- [MCP Auth quickstart](https://docs.scalekit.com/authenticate/mcp/quickstart/)
