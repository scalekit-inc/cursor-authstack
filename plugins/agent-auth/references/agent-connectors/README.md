# Agent Connectors Reference

This directory contains documentation for all supported agent connectors in the Scalekit Agent Auth platform.

## Available Connectors

| Connector | Description | Auth Type |
|-----------|-------------|-----------|
| [Airtable](airtable.md) | Connect to Airtable bases for data management | OAuth 2.0 |
| [Asana](asana.md) | Project management and task tracking | OAuth 2.0 |
| [BigQuery](bigquery.md) | Google BigQuery data warehouse | OAuth 2.0 |
| [ClickUp](clickup.md) | Project management and collaboration | OAuth 2.0 |
| [Confluence](confluence.md) | Atlassian Confluence wiki pages | OAuth 2.0 |
| [Dropbox](dropbox.md) | File storage and sharing | OAuth 2.0 |
| [Fathom](fathom.md) | Website analytics | OAuth 2.0 |
| [Freshdesk](freshdesk.md) | Customer support ticketing | OAuth 2.0 |
| [GitHub](github.md) | Code repository and development tools | OAuth 2.0 |
| [Gmail](gmail.md) | Google Gmail email service | OAuth 2.0 |
| [Google Ads](google_ads.md) | Google advertising platform | OAuth 2.0 |
| [Google Calendar](googlecalendar.md) | Google Calendar events and scheduling | OAuth 2.0 |
| [Google Docs](google_docs.md) | Google Docs document editing | OAuth 2.0 |
| [Google Drive](google_drive.md) | Google Drive file storage | OAuth 2.0 |
| [Google Forms](google_forms.md) | Google Forms survey creation | OAuth 2.0 |
| [Google Meet](google_meets.md) | Google Meet video conferencing | OAuth 2.0 |
| [Google Sheets](google_sheets.md) | Google Sheets spreadsheet editing | OAuth 2.0 |
| [Gong](gong.md) | Sales conversation intelligence | OAuth 2.0 |
| [HubSpot](hubspot.md) | CRM and marketing automation | OAuth 2.0 |
| [Intercom](intercom.md) | Customer messaging platform | OAuth 2.0 |
| [Jira](jira.md) | Atlassian Jira issue tracking | OAuth 2.0 |
| [Linear](linear.md) | Software development issue tracking | OAuth 2.0 |
| [Microsoft Excel](microsoft_excel.md) | Microsoft Excel spreadsheet editing | OAuth 2.0 |
| [Microsoft Teams](microsoft_teams.md) | Microsoft Teams collaboration | OAuth 2.0 |
| [Microsoft Word](microsoft_word.md) | Microsoft Word document editing | OAuth 2.0 |
| [Monday](monday.md) | Work management platform | OAuth 2.0 |
| [Notion](notion.md) | Notion workspace and pages | OAuth 2.0 |
| [OneDrive](onedrive.md) | Microsoft OneDrive file storage | OAuth 2.0 |
| [OneNote](onenote.md) | Microsoft OneNote note-taking | OAuth 2.0 |
| [Outlook](outlook.md) | Microsoft Outlook email | OAuth 2.0 |
| [Salesforce](salesforce.md) | Salesforce CRM platform | OAuth 2.0 |
| [ServiceNow](servicenow.md) | IT service management | OAuth 2.0 |
| [SharePoint](sharepoint.md) | Microsoft SharePoint collaboration | OAuth 2.0 |
| [Slack](slack.md) | Slack messaging and collaboration | OAuth 2.0 |
| [Snowflake](snowflake.md) | Snowflake data warehouse | OAuth 2.0 |
| [Trello](trello.md) | Trello project boards | OAuth 2.0 |
| [Zendesk](zendesk.md) | Customer support platform | OAuth 2.0 |
| [Zoom](zoom.md) | Zoom video conferencing | OAuth 2.0 |

## Getting Started

Each connector documentation includes:

- Service description and capabilities
- Authentication requirements
- Complete API reference for all available tools
- Parameter specifications and examples
- Usage guidelines and best practices

## Authentication

All connectors support OAuth 2.0 authentication through the Agent Auth platform. You'll need to:

1. Create a connection for the desired service
2. Configure OAuth credentials in your connection
3. Create connected accounts for your users
4. Use the connection in your agent workflows

For detailed authentication setup, see the [Connected Accounts](../connected-accounts.md) documentation.