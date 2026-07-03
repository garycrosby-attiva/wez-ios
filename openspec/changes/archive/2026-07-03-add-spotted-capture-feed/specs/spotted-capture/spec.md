## ADDED Requirements

### Requirement: Capture is a focused task over the Spotted tab

The capture flow SHALL be presented as a focused modal task (full-screen) over the
Spotted tab, covering the tab bar for its duration, and SHALL return to the Spotted feed
when completed or dismissed. The flow SHALL proceed through four steps in order: capture,
auto-tag, join-me alert, post.

#### Scenario: Entering and leaving capture

- **WHEN** the user starts capture from the Spotted tab
- **THEN** the capture flow is presented modally over the tab, covering the tab bar
- **AND** completing or dismissing the flow returns to the Spotted feed

### Requirement: Capture is live-camera-only

Capture SHALL use the live camera only and SHALL NOT offer a photo-library picker or any
other way to attach a pre-existing image. On a device this is the real camera; in the
simulator, where no camera exists, the flow SHALL present a faithful "happening now"
camera-framed capture surface for demonstration rather than substituting a library picker.

#### Scenario: No library fallback on device

- **WHEN** the user is on the capture step on a device
- **THEN** only the live camera is offered as the image source
- **AND** no photo-library or file picker is presented

#### Scenario: Simulator presents a faithful live surface

- **WHEN** the app runs in the simulator, where no camera is available
- **THEN** a camera-framed "happening now" capture surface is shown
- **AND** the flow does not fall back to a library picker

### Requirement: GPS auto-tag resolves to a seeded beach and is confirmed

After capture the app SHALL read the device GPS coordinate and resolve it to the nearest
known beach using the in-app `BeachResolver` over the seeded beach list. The resolved
beach SHALL be presented for the user to confirm before posting. When the resolver returns
out-of-range (no beach within the radius), the flow SHALL say so plainly and SHALL NOT
attach an arbitrary beach.

#### Scenario: Resolves and confirms the nearest beach

- **WHEN** capture has a photo and the device coordinate is within range of a seeded beach
- **THEN** the nearest seeded beach is shown for confirmation
- **AND** the post is tagged with the confirmed beach

#### Scenario: Out-of-range is honest

- **WHEN** the device coordinate resolves to out-of-range
- **THEN** the flow states plainly that no known beach is nearby
- **AND** it does not tag the post with an arbitrary or nearest-anyway beach

### Requirement: Join-me alert is present but does not send

The flow SHALL include a "come join me" proximity alert step that is visually complete and
interactive, but SHALL NOT actually send or schedule any notification in this version. Its
non-sending nature SHALL be honest within the flow — it is not presented as having sent.

#### Scenario: Join-me is shown and quietly inert

- **WHEN** the user reaches the join-me alert step
- **THEN** the alert UI is presented and interactive
- **AND** confirming it sends no notification and schedules no delivery

### Requirement: Submitting persists the post and its photo

Submitting SHALL persist the photo via `PhotoStorage` and the post metadata via
`PostStorage`, both wired to the local dev backend. The persisted `SpottedPost` SHALL be
authored as Ez-the-editor (editorial `summary`/`author` populated together, satisfying the
editorial-pair invariant), tagged with the confirmed beach. `captureConditions` SHALL be
populated from a seeded `BeachConditionsProvider` stub for the beach, and `derivedTags`
SHALL be the union of the beach's static tags and the condition-derived tags. These stub
condition values SHALL NOT be presented anywhere as live, current conditions.

#### Scenario: A submitted post persists end-to-end

- **WHEN** the user submits a confirmed capture
- **THEN** the photo is persisted via `PhotoStorage` and the post via `PostStorage` to the local backend
- **AND** the persisted post carries the confirmed beach, an Ez-the-editor editorial pair, a seeded conditions snapshot, and derived tags

#### Scenario: Stub conditions are not surfaced as live

- **WHEN** a post is created with seeded stub conditions
- **THEN** no part of the capture or feed UI presents those values as the beach's live or current conditions
