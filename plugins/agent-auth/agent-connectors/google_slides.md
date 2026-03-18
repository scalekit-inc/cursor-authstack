Connect to Google Slides to create, read, and modify presentations programmatically.

Supports authentication: OAuth 2.0

## Table of Contents

- [Tool list](#tool-list)

---

## Tool list

## `googleslides_create_presentation`

Create a new Google Slides presentation with an optional title.

| Properties | Description | Type |
| --- | --- | --- |
| `schema_version` | Optional schema version to use for tool execution | string | null |
| `title` | Title of the new presentation | string | null |
| `tool_version` | Optional tool version to use for execution | string | null |

## `googleslides_read_presentation`

Read the complete structure and content of a Google Slides presentation including slides, text, images, shapes, and metadata.

| Properties | Description | Type |
| --- | --- | --- |
| `fields` | Fields to include in the response | string | null |
| `presentation_id` | The ID of the Google Slides presentation to read | string |
| `schema_version` | Optional schema version to use for tool execution | string | null |
| `tool_version` | Optional tool version to use for execution | string | null |
