# Herdr naming

- When `HERDR_ENV=1`, use one concise title for every substantive task: an agent slug matching `^[a-z][a-z0-9_-]{0,31}$` for `herdr agent rename "$HERDR_PANE_ID" "<task-slug>"`, and a readable title for `herdr workspace rename "$HERDR_WORKSPACE_ID" "<task-title>"`.
- Rename both at the start of every task, even when already named. In shared workspaces, the most recently started agent task owns the workspace title.
