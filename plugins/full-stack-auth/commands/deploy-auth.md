---
name: deploy-auth
description: Deploy authentication configuration and verify production readiness.
---

# Deploy Auth

## Deployment checklist
1. Review environment-specific configuration
2. Verify all secrets are set in production
3. Test auth flows in staging environment
4. Run smoke tests on critical auth paths
5. Monitor for errors after deployment

## Steps
1. Validate configuration in target environment
2. Run integration tests
3. Deploy configuration changes
4. Verify health endpoints
5. Check logs for any auth errors
