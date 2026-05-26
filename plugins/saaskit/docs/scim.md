# SCIM Provisioning

Scalekit acts as a SCIM bridge: the customer's IdP (Okta, Azure AD, etc.) pushes user/group changes to Scalekit, and your app consumes them via the Directory API or webhooks.

## Two integration paths

| Path | Use case |
|---|---|
| **Directory API** (polling) | Scheduled sync jobs, bulk imports, onboarding flows |
| **Webhooks** (real-time) | Instant user create/update/deactivate as changes happen |

Most apps use webhooks for real-time and the Directory API for initial sync.

## Directory API

Fetch users and groups for an organization:

```js
// Node.js
const { directories } = await scalekit.directory.listDirectories(orgId);
const directory = directories[0];
const { users } = await scalekit.directory.listDirectoryUsers(orgId, directory.id);
for (const user of users) {
  await upsertUser({ email: user.email, name: user.name, orgId });
}
```

```python
# Python
directories = scalekit_client.directory.list_directories(organization_id=org_id).directories
directory = directories[0]
users = scalekit_client.directory.list_directory_users(org_id, directory.id)
for user in users:
    upsert_user(email=user.email, name=user.name, org_id=org_id)
```

Group sync for RBAC:

```js
const { groups } = await scalekit.directory.listDirectoryGroups(orgId, directory.id);
for (const group of groups) {
  await syncGroupPermissions(group.id, group.name);
}
```

## Webhooks

### Endpoint setup

Add a POST route, verify the signature, and dispatch events:

```js
// Node.js (Express)
app.post('/webhooks/scalekit', express.raw({ type: 'application/json' }), async (req, res) => {
  const ok = scalekit.verifyWebhookPayload(
    process.env.SCALEKIT_WEBHOOK_SECRET, req.headers, req.body
  );
  if (!ok) return res.status(401).end();
  const { type, data } = JSON.parse(req.body.toString('utf8'));
  await handleDirectoryEvent(type, data);
  res.status(201).json({ status: 'processed' });
});
```

```python
# Python (FastAPI)
@app.post("/webhooks/scalekit")
async def scalekit_webhook(request: Request):
    raw_body = await request.body()
    valid = scalekit_client.verify_webhook_payload(
        secret=os.getenv("SCALEKIT_WEBHOOK_SECRET"),
        headers=dict(request.headers),
        payload=raw_body,
    )
    if not valid:
        raise HTTPException(status_code=401, detail="Invalid signature")
    body = json.loads(raw_body)
    await handle_directory_event(body.get("type"), body.get("data", {}))
    return JSONResponse(status_code=201, content={"status": "processed"})
```

### Event types

| Event | Action |
|---|---|
| `organization.directory.user_created` | Create or activate user |
| `organization.directory.user_updated` | Update user profile |
| `organization.directory.user_deleted` | Deactivate user (prefer over hard delete) |
| `organization.directory.group_created` | Create group / sync roles |
| `organization.directory.group_updated` | Update group membership |

### Event handler pattern

```js
async function handleDirectoryEvent(type, data) {
  switch (type) {
    case 'organization.directory.user_created':
      return createUser(data.email, data.name, data.organization_id);
    case 'organization.directory.user_updated':
      return updateUser(data.email, data.name);
    case 'organization.directory.user_deleted':
      return deactivateUser(data.email);
    case 'organization.directory.group_created':
    case 'organization.directory.group_updated':
      return syncGroup(data);
  }
}
```

## Dashboard registration

1. **Dashboard > Webhooks > +Add Endpoint** — enter your public HTTPS URL.
2. Subscribe to the events above.
3. Copy the webhook secret into `SCALEKIT_WEBHOOK_SECRET`.
4. Share the [SCIM setup guide](https://docs.scalekit.com/guides/integrations/scim-integrations/) with the customer's IT admin.

## Guardrails

- **Validate signatures** on every webhook request.
- **Idempotent operations** — `upsertUser` must handle duplicate events safely.
- **Return 2xx quickly** — offload heavy work to a queue. Scalekit retries non-2xx with exponential backoff (up to 8 attempts over ~10 hours).
- **Deactivate, don't delete** — unless the codebase explicitly hard-deletes users.

## Related docs

- [sso.md](sso.md) — SSO and admin portal, often configured alongside SCIM.
