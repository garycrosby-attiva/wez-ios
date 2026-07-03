# spotted-feed Specification

## Purpose

Defines the Spotted tab's editorial feed: persisted posts read back from the local backend,
ordered newest-first and capped at 50, rendered in Ez-the-editor's single-author register,
with an honest empty state and a "coming soon" placeholder for the "Try this spot"
affordance.

## Requirements

### Requirement: Spotted tab shows the editorial feed newest-first, capped at 50

The Spotted tab SHALL show the area's editorial feed: persisted posts read back from the
local backend via `PostStorage`, ordered newest-first, and limited to the most recent 50.
A freshly submitted post SHALL appear at the top of the feed.

#### Scenario: Feed reads back posts newest-first

- **WHEN** the Spotted tab is shown and posts exist in the backend
- **THEN** posts are listed newest-first
- **AND** at most the 50 most recent posts are shown

#### Scenario: A new post lands at the top

- **WHEN** the user submits a capture and returns to the feed
- **THEN** the new post appears at the top of the feed

### Requirement: Feed is in Ez's editorial register, single-author

Every post in this prototype SHALL be authored as Ez-the-editor; there is no multi-user
identity. The feed's framing and voice SHALL read as "the friend who shares" (Ez's
register), not a generic photo grid. The feed SHALL NOT present a post's stored conditions
snapshot as live, current conditions.

#### Scenario: Posts are Ez-authored

- **WHEN** the feed renders a post
- **THEN** the post is attributed to Ez-the-editor
- **AND** no other author identity is shown or selectable

### Requirement: "Try this spot" links to a coming-soon placeholder

Where a post surfaces its beach, the feed SHALL offer a "Try this spot" affordance. In this
change it SHALL navigate to an honest "coming soon" placeholder, NOT a real beach-detail
screen.

#### Scenario: Try this spot is honest about not existing yet

- **WHEN** the user taps "Try this spot" on a post
- **THEN** a "coming soon" placeholder is shown
- **AND** no real beach-detail screen is presented

### Requirement: Empty feed is honest

When no posts exist yet, the Spotted tab SHALL show a warm, honest empty state inviting the
user to capture, rather than fabricated or placeholder posts.

#### Scenario: No posts yet

- **WHEN** the Spotted tab is shown and no posts exist in the backend
- **THEN** an honest empty state is shown
- **AND** no fake or sample posts are displayed
