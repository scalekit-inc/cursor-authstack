Connect to Linear. Manage issues, projects, sprints, and development workflows

Supports authentication: OAuth 2.0

## Tool list

## `linear_graphql_query`

Execute a custom GraphQL query or mutation against the Linear API. Allows running any valid GraphQL operation with variables support for advanced use cases.

| Properties | Description | Type |
| --- | --- | --- |
| `query` | The GraphQL query or mutation to execute | string |
| `variables` | Variables to pass to the GraphQL query | `object` | null |

## `linear_issue_create`

Create a new issue in Linear using the issueCreate mutation. Requires a team ID and title at minimum.

| Properties | Description | Type |
| --- | --- | --- |
| `assigneeId` | ID of the user to assign the issue to | string | null |
| `description` | Description of the issue | string | null |
| `estimate` | Story point estimate for the issue | string | null |
| `labelIds` | Array of label IDs to apply to the issue | `array<string>` | null |
| `priority` | Priority level of the issue (1-4, where 1 is urgent) | string | null |
| `projectId` | ID of the project to associate the issue with | string | null |
| `stateId` | ID of the workflow state to set | string | null |
| `teamId` | ID of the team to create the issue in | string |
| `title` | Title of the issue | string |

## `linear_issue_update`

Update an existing issue in Linear. You can update title, description, priority, state, and assignee.

| Properties | Description | Type |
| --- | --- | --- |
| `assigneeId` | ID of the user to assign the issue to | string | null |
| `description` | New description for the issue | string | null |
| `issueId` | ID of the issue to update | string |
| `priority` | Priority level of the issue (1-4, where 1 is urgent) | string | null |
| `stateId` | ID of the workflow state to set | string | null |
| `title` | New title for the issue | string | null |

## `linear_issues_list`

List issues in Linear using the issues query with simple filtering and pagination support.

| Properties | Description | Type |
| --- | --- | --- |
| `after` | Cursor for pagination (returns issues after this cursor) | string | null |
| `assignee` | Filter by assignee email (e.g., 'user@example.com') | string | null |
| `before` | Cursor for pagination (returns issues before this cursor) | string | null |
| `first` | Number of issues to return (pagination) | integer | null |
| `labels` | Filter by label names (array of strings) | `array<string>` | null |
| `priority` | Filter by priority level (1=Urgent, 2=High, 3=Medium, 4=Low) | string | null |
| `project` | Filter by project name (e.g., 'Q4 Goals') | string | null |
| `state` | Filter by state name (e.g., 'In Progress', 'Done') | string | null |
