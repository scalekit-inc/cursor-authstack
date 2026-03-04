# Scalekit: User Profiles & Custom Attributes Reference

## Standard User Profile Shape

```json
{
  "id": "usp_96194455173923084",
  "first_name": "John",
  "last_name": "Doe",
  "name": "John Doe",
  "locale": "en-US",
  "email_verified": true,
  "phone_number": "+14155552671",
  "metadata": {},
  "custom_attributes": {}
}
```

Fields available via `GET /api/v1/users/{id}`. The two extensible fields are:
- `custom_attributes` — structured, named fields defined in the dashboard
- `metadata` — unstructured key-value store for system integration data

---

## Custom Attributes

### Creating via Dashboard
1. Navigate to **Dashboard > User Attributes > Add Attribute**
2. Set **Display name** (e.g., "Employee Number") and **Attribute key** (e.g., `employee_id`)
3. Once created, the attribute is available across all users under `custom_attributes`

### Reading Custom Attributes
Custom attributes appear in the user profile response under `custom_attributes`:
```json
{
  "custom_attributes": {
    "pin_number": "123456",
    "zip_code": "90210"
  }
}
```

### Updating Custom Attributes via API

**Node.js**
```javascript
await scalekit.user.updateUser("<userId>", {
  userProfile: {
    customAttributes: { zip_code: "11120" },
    firstName: "John",
    lastName: "Doe",
    locale: "en-US",
    name: "John Michael Doe",
    phoneNumber: "+14155552671"
  }
});
```

**Python**
```python
scalekit.user.update_user("<user_id>", user_profile={
    "custom_attributes": { "zip_code": "11120" },
    "first_name": "John",
    "last_name": "Doe",
    "locale": "en-US",
    "name": "John Michael Doe",
    "phone_number": "+14155552671"
})
```

**Go**
```go
updateUser := &usersv1.UpdateUser{
    UserProfile: &usersv1.UpdateUserProfile{
        CustomAttributes: map[string]string{"zip_code": "11120"},
        FirstName: "John", LastName: "Doe",
        Locale: "en-US", Name: "John Michael Doe",
        PhoneNumber: "+14155552671",
    },
}
updatedUser, err := scalekitClient.User().UpdateUser(ctx, "<userId>", updateUser)
```

**Java**
```java
UpdateUser updateUser = UpdateUser.newBuilder()
    .setUserProfile(UpdateUserProfile.newBuilder()
        .putCustomAttributes("zip_code", "11120")
        .setFirstName("John").setLastName("Doe")
        .setLocale("en-US").setName("John Michael Doe")
        .setPhoneNumber("+14155552671").build())
    .build();
scalekitClient.users().updateUser("<userId>", UpdateUserRequest.newBuilder().setUser(updateUser).build());
```

**cURL**
```sh
curl -L -X PATCH '<SCALEKIT_ENVIRONMENT_URL>/api/v1/users/<USER_ID>' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer <TOKEN>' \
  -d '{ "user_profile": { "custom_attributes": { "zip_code": "90210" } } }'
```

---

## Identity Provider Attribute Mapping

When users authenticate via SSO, Scalekit syncs user profile fields (including custom
attributes) from the identity provider through the ID token during login completion.

- Admins configure attribute mapping per organization in the Scalekit dashboard
- Supports both standard and custom attributes
- SCIM Provisioning (directory provider → user profile) is available — contact Scalekit sales

---

## External IDs

External IDs let you reference Scalekit entities using your own system's identifiers
(CRM IDs, database PKs, etc.) instead of Scalekit-generated IDs.

### Organization External IDs

**Create with external ID**
```javascript
// Node.js
const org = await scalekit.organization.create({
  display_name: 'Acme Corporation',
  external_id: 'CUST-12345-ACME'
});
```

**Lookup by external ID**
```javascript
// Node.js
const org = await scalekit.organization.getByExternalId('CUST-12345-ACME');
```

**Update external ID**
```javascript
// Node.js
const updatedOrg = await scalekit.organization.update(orgId, {
  external_id: 'NEW-CUST-12345-ACME'
});
```

> Same pattern exists for Python (`get_by_external_id`), Go (`GetByExternalId`), and Java (`getByExternalId`).

---

### User External IDs & Metadata

Use `externalId` to link Scalekit users to CRM, HR, or billing records.
Use `metadata` for richer context that doesn't belong in `custom_attributes`.

| Field | Purpose | Example values |
|---|---|---|
| `externalId` | Link to external system record | `SALESFORCE-003921` |
| `metadata` | Business context, integration data | department, territory, quota, CRM IDs |
| `custom_attributes` | Structured app-level profile fields | zip_code, employee_id, access_level |

**Create user with external ID + metadata**
```javascript
// Node.js
const { user } = await scalekit.user.createUserAndMembership("<orgId>", {
  email: "john.doe@company.com",
  externalId: "SALESFORCE-003921",
  metadata: {
    department: "Sales",
    employeeId: "EMP-002",
    territory: "West Coast",
    quota: 150000,
    crmAccountId: "ACC-789",
    hubspotContactId: "12345"
  },
  userProfile: { firstName: "John", lastName: "Doe" },
  sendInvitationEmail: true
});
```

**Update user external ID + metadata**
```javascript
// Node.js
const updatedUser = await scalekit.user.updateUser("<userId>", {
  externalId: "SALESFORCE-003921",
  metadata: { department: "Sales", territory: "West Coast" }
});
```

**Find user by external ID**
```javascript
// Node.js
const user = await scalekit.user.getUserByExternalId("<orgId>", "SALESFORCE-003921");
```

> Python uses `get_user_by_external_id`, Go uses `GetUserByExternalId`, Java uses `getUserByExternalId`.

---

## Key Decision Guide for Agents

When reviewing a codebase that uses Scalekit users, apply this logic:

| Scenario | Recommended field |
|---|---|
| App-specific structured data (zip code, tier, access level) | `custom_attributes` |
| Migrating from another system, need to keep old IDs | `externalId` |
| CRM/HR integration context (quota, territory, manager) | `metadata` |
| Syncing attributes from IdP (SAML/OIDC) automatically | IdP attribute mapping |
| Auditing/logging context without profile pollution | `metadata` |

---

## SDK Method Reference

| Operation | Node.js | Python | Go | Java |
|---|---|---|---|---|
| Update profile/custom attrs | `user.updateUser` | `user.update_user` | `User().UpdateUser` | `users().updateUser` |
| Create user + membership | `user.createUserAndMembership` | `user.create_user_and_membership` | `User().CreateUserAndMembership` | `users().createUserAndMembership` |
| Get user by external ID | `user.getUserByExternalId` | `user.get_user_by_external_id` | `User().GetUserByExternalId` | `users().getUserByExternalId` |
| Get org by external ID | `organization.getByExternalId` | `organization.get_by_external_id` | `Organization.GetByExternalId` | `organization().getByExternalId` |
