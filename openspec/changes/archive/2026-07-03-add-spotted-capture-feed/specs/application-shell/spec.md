## RENAMED Requirements

- FROM: `### Requirement: Home and Spotted are navigable empty states`
- TO: `### Requirement: Home is a navigable empty state`

## MODIFIED Requirements

### Requirement: Home is a navigable empty state

The Home tab SHALL present a real, navigable empty state within its own navigation stack,
with no feature content and no live data. (Spotted is no longer an empty state — it now
hosts the Spotted feed and capture flow; see the `spotted-feed` and `spotted-capture`
capabilities.)

#### Scenario: Home opens as an empty navigable tab

- **WHEN** the user opens the Home tab
- **THEN** the tab shows a minimal empty state inside its navigation stack
- **AND** no recommendation or friend-voice content is shown
- **AND** no live backend data is displayed
