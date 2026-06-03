## Why

Where's Ez is greenfield: the only user-facing screen today is a disposable backend
probe. There is no navigable frame for the product to live inside, so no feature can be
built without first deciding how the app is structured and entered. This change creates
that frame — the application shell — so every later feature has a home to mount into.

## What Changes

- Add a `MainTabView` at the app's composition root carrying four tabs — **Home**,
  **Spotted**, **Saved**, **Profile** — each wrapping its own independent `NavigationStack`.
- Add honest placeholder screens for **Saved** and **Profile** (not-yet-functional, warm
  and truthful copy — pending the creative's voice review).
- Add minimal, navigable empty states for **Home** and **Spotted** (real tabs, no feature
  content yet).
- Establish chrome-by-presentation as the navigation rule: tab-bar behaviour is decided by
  how a screen is presented (root gate / modal / pushed), with no central hide-the-nav route
  list to maintain.
- **BREAKING** (internal only): mount `MainTabView` as the app root, deleting the temporary
  `PingView` probe screen and its `@main` wiring.

## Capabilities

### New Capabilities
- `application-shell`: the navigable four-tab frame the whole app launches into — per-tab
  navigation stacks, chrome-by-presentation, and honest placeholders for not-yet-built tabs.

### Modified Capabilities
<!-- None — no existing specs in openspec/specs/. -->

## Impact

- **App target (`WheresEz`)**: new `MainTabView` and per-tab root views; `WheresEzApp`
  rewired to mount the shell. `PingView.swift` removed (and `ContentView.swift`, the unused
  template view, if present).
- **WezKit**: no new seams expected — the shell shows no live data, so no contract,
  implementation, or test double is added. (Confirmed in design.)
- **Backend**: none. The shell wires no live data and needs no endpoint.
- **Out of scope**: Home recommendation/friend-voice content, Spotted capture-and-feed,
  onboarding content, Saved's save-and-recall behaviour, any backend/live-data wiring.
