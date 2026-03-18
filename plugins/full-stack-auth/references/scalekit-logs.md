# Scalekit: Logs Reference (Auth & Webhooks)

## Auth Logs

Access via **Dashboard > Auth Logs**. Records all authentication events across the environment.

### Authentication Statuses

| Status | Meaning | When to investigate |
|---|---|---|
| **Initiated** | User hit `/oauth/authorize` — flow started | Spike with no Pending/Success = client-side issue |
| **Pending** | Mid-flow: redirects + profile exchange in progress | Stuck here = IdP or redirect misconfiguration |
| **Success** | Code exchanged, identity verified, access granted | Baseline for normal traffic |
| **Failure** | Access denied — bad credentials, network, or interceptor rejection | Always review error details |

### Auth Log Filters

- `Time range` — investigate specific windows or historical events
- `User email` — track individual user activity or troubleshoot sign-in failures
- `Authentication status` — isolate Initiated / Pending / Success / Failure
- `Organization` — scope to multi-tenant apps

**Useful combination:** `User email` + `Failure` status → fastest path to diagnosing why a specific user can't sign in.

---

## Webhook Logs

Access via **Dashboard > Webhooks** → select endpoint → **"..."** (more options) → delivery logs.

### Webhook Delivery Statuses

| Status | Meaning | Action |
|---|---|---|
| **Success** | Endpoint returned 2xx | None needed |
| **Queued** | High volume or rate limiting — event waiting to send | Monitor queue drain |
| **Failed** | No response, non-2xx, or timeout — retries triggered | Review endpoint availability and response logic |
| **Retrying** | Exponential backoff retry in progress (up to 4 attempts) | Check endpoint health; fix before retries exhaust |

### Retry Schedule

| Attempt | Timing |
|---|---|
| 1 | Immediate |
| 2 | After 1 minute |
| 3 | After 5 minutes |
| 4 | After 15 minutes |

After attempt 4 fails, event is marked **permanently failed**. Manual replay is available from the logs UI.

### Webhook Log Filters

- Time range — last 5 minutes up to last 30 days
- `Event type` — e.g., `organization.directory.user_created`, `organization.directory.user_updated`
- `Delivery status` — Success / Queued / Failed / Retrying

**Useful combination:** `Failed` + specific event type → narrow down why a particular event class is not being processed.

### Webhook Log Detail Fields

Each log entry exposes:

**Request side:**
- Event ID and type
- Timestamp
- Request payload
- Headers (including webhook signature)

**Response side:**
- HTTP status code
- Response body
- Response latency
- Retry attempt number

---

## Webhook Endpoint Best Practices

- Respond within **10 seconds** — requests that time out are treated as failures
- Return **2xx** for all successfully received events, even if processing is async
- Implement **idempotency** — retries can deliver the same event multiple times; use event ID as deduplication key
- Monitor **Failed** status actively — patterns in failed webhooks signal endpoint availability or validation bugs
