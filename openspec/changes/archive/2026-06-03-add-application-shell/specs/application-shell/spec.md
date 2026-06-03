## ADDED Requirements

### Requirement: App launches into a four-tab shell

The app SHALL launch directly into a tab-based shell carrying exactly four tabs —
Home, Spotted, Saved, and Profile — mounted at the composition root. The shell SHALL
be the app's root view; no probe or template screen SHALL precede it.

#### Scenario: Cold launch shows the shell

- **WHEN** the app is launched in the simulator
- **THEN** the four-tab shell is the first and only root surface shown
- **AND** the tab bar presents Home, Spotted, Saved, and Profile

#### Scenario: Temporary probe is gone

- **WHEN** the app starts
- **THEN** the temporary backend-probe screen is not shown
- **AND** no code path mounts the probe as the app root

### Requirement: Each tab owns an independent navigation stack

Each of the four tabs SHALL wrap its content in its own navigation stack, created with
the shell. Pushing a destination in one tab SHALL NOT affect the navigation state of any
other tab, and switching away from and back to a tab SHALL preserve that tab's place in
its stack.

#### Scenario: Push is isolated to its tab

- **WHEN** a destination is pushed within one tab's stack
- **THEN** the other tabs' stacks remain at their own current positions

#### Scenario: Tab switch preserves a tab's stack depth

Preservation is observable only while the tab bar remains visible — switching tabs
requires the bar, and per the chrome rule a *detail* push hides it (so you go back, not
sideways, from a detail). This scenario therefore concerns a push that keeps the bar.

- **WHEN** the user pushes a tab-bar-preserving destination in one tab, switches to another
  tab, then switches back
- **THEN** the first tab is still showing its pushed destination
- **AND** the tab it switched to was unaffected, sitting at its own current position

### Requirement: Tab-bar chrome is determined by presentation, not a route list

Tab-bar visibility SHALL be determined by how a screen is presented, with no central
list of routes that hide the navigation:

- A root-level gate (e.g. onboarding) SHALL sit outside the tab view, so no tab bar
  exists while it is shown. (This shape is the documented extension point; the gate
  itself is not built by this change — the root mounts the tab view directly.)
- A focused modal task SHALL be presented modally (full-screen cover or sheet), covering
  the tab bar without explicit hiding.
- An in-tab pushed destination SHALL hide the tab bar while it is on screen.

The shell SHALL NOT introduce a central registry of "hide-the-nav" routes.

#### Scenario: Pushed destination hides the tab bar

- **WHEN** a destination is pushed within a tab's navigation stack
- **THEN** the tab bar is hidden while that destination is on screen
- **AND** the tab bar reappears when the destination is popped

#### Scenario: No central hide-the-nav route list exists

- **WHEN** the shell's navigation code is inspected
- **THEN** there is no central list or registry enumerating routes that hide the tab bar
- **AND** chrome behaviour follows from each screen's presentation mechanism alone

### Requirement: Saved and Profile show honest placeholders

The Saved and Profile tabs SHALL each show a placeholder screen that plainly states the
capability is not yet available, in a warm and truthful tone. The shell SHALL NOT fake
or simulate save-and-recall or profile-feed behaviour.

#### Scenario: Saved placeholder

- **WHEN** the user opens the Saved tab
- **THEN** a placeholder screen states that nothing is saved yet and that saving is coming
- **AND** no save-and-recall functionality is offered

#### Scenario: Profile placeholder

- **WHEN** the user opens the Profile tab
- **THEN** a placeholder screen states that the user's feed and future spots will live here
- **AND** no profile-feed functionality is offered

### Requirement: Home and Spotted are navigable empty states

The Home and Spotted tabs SHALL present real, navigable empty states within their own
navigation stacks, with no feature content. The shell SHALL NOT show any live data in
these tabs.

#### Scenario: Home and Spotted open as empty navigable tabs

- **WHEN** the user opens the Home tab or the Spotted tab
- **THEN** the tab shows a minimal empty state inside its navigation stack
- **AND** no recommendation, friend-voice, capture, or feed content is shown
- **AND** no live backend data is displayed
