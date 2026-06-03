## Context

Where's Ez is a greenfield SwiftUI iOS app. The only user-facing screen today is
`PingView` — a disposable Lap 1 probe proving the running app reaches the local Worker.
There is no navigable structure: no tabs, no navigation stacks, no app root beyond the
probe. This change establishes the **application shell** — the frame every later feature
mounts into — and removes the probe.

Constraints carried from the project:
- SwiftUI, Swift 6 strict concurrency. App target `WheresEz`.
- Spec/impl/test separation in WezKit via dependency inversion. A new capability *seam*
  = protocol in WezSpecs, concrete in WezImplementations, double in WezTestSupport.
- Honest-about-state product principle: never fake a capability; placeholders are warm
  and truthful.
- Backend not deployed; nothing in scope may depend on a live endpoint.

## Goals / Non-Goals

**Goals:**
- A `MainTabView` mounted at the composition root, carrying four tabs (Home, Spotted,
  Saved, Profile), each owning an independent `NavigationStack`.
- Tab-bar chrome decided structurally by *how a screen is presented* — no central
  hide-the-nav route list.
- Honest placeholder screens for Saved and Profile; minimal navigable empty states for
  Home and Spotted.
- Remove `PingView` and its `@main` wiring; the shell becomes the app root.

**Non-Goals:**
- Feature content of Home (recommendation/friend-voice) and Spotted (capture-and-feed).
- Onboarding content — only the documented root-gate *shape* is recorded, not built.
- Saved's save-and-recall behaviour.
- Any live data, backend deployment, or WezKit seam.

## Decisions

**1. `TabView` with one `NavigationStack` per tab.**
Each tab's root view wraps its content in its own `NavigationStack`, created with the
shell. Navigation state is independent per tab and preserved across tab switches.
- *Why:* establishing per-tab stacks from the start means an empty tab today can gain
  pushed depth later without retrofitting its stack.
- *Alternative considered:* a single shared `NavigationStack` outside the `TabView` —
  rejected because it couples tabs' navigation state and breaks the "switching tabs
  preserves each tab's place" expectation.

**2. Chrome-by-presentation; no central route list.**
Tab-bar behaviour follows the presentation mechanism, three cases by construction:
- Root-level gates (e.g. onboarding) sit *outside* the `TabView` — `if !onboarded {…}
  else { MainTabView() }`. No tab bar exists to hide.
- Focused modal tasks use `.fullScreenCover`/`.sheet` — modal presentation covers the
  bar with no explicit hiding.
- In-tab pushed destinations use `.toolbar(.hidden, for: .tabBar)` to suppress the bar
  while pushed.
- *Why:* presentation already determines correct chrome, so a new modal/pushed screen
  later carries its own behaviour. A central "hide-the-nav routes" list is redundant
  state that drifts out of sync.
- *Alternative considered:* a route enum + observer that toggles bar visibility —
  rejected as the redundant-state anti-pattern above.

**3. Root mounts `MainTabView` directly; onboarding gate is documented, not built.**
`WheresEzApp` mounts `MainTabView()` as the sole root view. The `if !onboarded` gate is
recorded in the spec as the shape for when onboarding exists.
- *Why:* onboarding content is out of scope; building the gate now would be speculative.

**4. No WezKit seam.** The shell shows no live data, so it adds no contract,
implementation, or test double. All shell code lives in the `WheresEz` app target.
- *Why:* a seam exists to invert a dependency on a capability; the frame depends on no
  capability. Adding one would be speculative per "minimum code that solves the problem".

**5. Honest placeholders as first-class views.** Saved and Profile get dedicated
placeholder views stating plainly they are not yet functional. Copy is drafted but
marked *pending the creative's voice review* before shipping.
- Draft — Saved: "Nothing saved yet. Soon you'll be able to keep the spots you want to
  come back to." Profile: "Your feed and your future spots will live here."

**6. File layout.** New views in the `WheresEz` app target: `MainTabView.swift` and one
file per tab root (`HomeView`, `SpottedView`, `SavedView`, `ProfileView`) — or grouped
pragmatically. `PingView.swift` is deleted; the unused Xcode-template `ContentView.swift`
is deleted if present. `WheresEzApp.swift` is rewired to mount the shell.

## Risks / Trade-offs

- **Placeholder copy ships before voice review** → Mark copy as draft/pending in code
  comments and the spec; flag for the creative's review before any release build.
- **No automated UI test harness yet** → Verification of "launches into four-tab shell"
  is manual in the simulator for this change; acceptance criteria are written to be
  checkable by inspection. Spec keeps requirements behaviour-shaped so a later UI test
  can assert them.
- **`PingView` removal loses the only running-app backend check** → Acceptable: the live
  round-trip is still covered by the WezImplementations integration test; the probe was
  always marked disposable.
- **Chrome-by-presentation relies on team discipline** (no future route list) → Captured
  as an explicit spec requirement and design rationale so the constraint is enforceable
  in review.

## Migration Plan

In-app only; no deployment or data migration. Steps:
1. Add shell views (`MainTabView` + tab roots).
2. Rewire `WheresEzApp` to mount `MainTabView`.
3. Delete `PingView.swift` (and template `ContentView.swift` if present).
4. Build and launch in the simulator to confirm the four-tab shell and per-tab pushes.

Rollback: revert the commit — the probe is restored from git history. No external state.

## Open Questions

- Final placeholder copy for Saved and Profile (owner: creative). Draft copy above is a
  stand-in.
- Tab iconography/labels and SF Symbol choices — cosmetic, can be settled during build;
  not a blocker.
