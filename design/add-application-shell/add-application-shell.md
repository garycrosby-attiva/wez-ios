# Brief — The Application Shell

Where's Ez is a SwiftUI iOS app. This change establishes its **application shell** —
the navigable frame the whole product lives inside. It is the first feature-shaped change
taken through OpenSpec on the app, so this brief explains the shell's concepts in full
rather than assuming them.

The app is greenfield: aside from a temporary probe screen that this change removes, there
is no user-facing navigation yet. This change creates it.

---

## What the shell is

A single SwiftUI `TabView` mounted at the app's composition root. It becomes the app's root
view — when the app launches, it launches into this shell.

Four tabs, each a distinct home for one part of the product:

- **Home** — where the day's recommendation and the friend-voice surface will live.
- **Spotted** — where people capture and browse what others have spotted, right now.
- **Saved** — places to come back to (not yet functional; see placeholders below).
- **Profile** — your feed and your future spots.

This change builds the **frame**. The feature content of Home and Spotted is deliberately
not part of it (see Out of scope). Saved and Profile get honest placeholder screens now.

---

## Key concepts

**Per-tab navigation.** Each tab owns its own `NavigationStack`, created with the shell.
Navigation state is independent per tab: pushing a detail screen in one tab leaves the others
untouched, and switching tabs preserves each tab's place. Establishing this from the start
means a tab that is empty today can gain pushed depth later without its stack being retrofitted.

**Chrome is decided by how a screen is presented, not by a list of routes.** There are exactly
three cases, and each carries its own correct tab-bar behaviour by construction:

1. **Root-level gates** (e.g. first-open / onboarding) sit *outside* the TabView —
   `if !onboarded { OnboardingView() } else { MainTabView() }`. There is no tab bar to hide,
   because the shell is not mounted yet.
2. **Focused modal tasks** are presented with `.fullScreenCover` or `.sheet`. Being modal,
   they cover the tab bar with no explicit hiding.
3. **In-tab pushed destinations** (e.g. a beach detail) use `.toolbar(.hidden, for: .tabBar)`
   to suppress the bar while the pushed view is on screen.

Because presentation already determines chrome, there is **no central list of "hide-the-nav"
routes** to maintain. Adding a new modal or pushed screen later carries its own correct
behaviour — do not introduce such a list; it is redundant state that drifts out of sync.

For this change the root mounts `MainTabView` directly. The onboarding gate above is the
documented shape for when onboarding exists; it is not built here.

**Placeholders are honest.** Saved and Profile are not functional yet, and their screens say
so plainly and warmly — the app never fakes a capability it doesn't have. Profile's eventual
shape is your feed plus your future spots, Pinterest-style, with no separate favourites tab.

Draft placeholder copy (needs the creative's voice review before shipping):

- **Saved** — "Nothing saved yet. Soon you'll be able to keep the spots you want to come back to."
- **Profile** — "Your feed and your future spots will live here."

---

## What to build

1. A `MainTabView` carrying the four tabs above, each wrapping its own `NavigationStack`.
2. Honest placeholder views for Saved and Profile (copy above, pending review).
3. Minimal empty states for Home and Spotted — real, navigable tabs with no feature content.
4. Mount `MainTabView` as the app's root, replacing the temporary probe view (`PingView`) and
   its `@main` wiring, which this change deletes.

---

## Done

- The app launches into the four-tab shell in the simulator.
- Each tab pushes within its own `NavigationStack`.
- Saved and Profile show their placeholder screens.
- The temporary probe view and its `@main` wiring are gone; the shell is the app root.

---

## Out of scope

This change is the frame only. Deliberately not included:

- Home's recommendation and friend-voice content.
- Spotted's capture-and-feed, including the multi-step full-screen capture flow.
- Onboarding content (the shell leaves only the root-gate shape).
- Any backend deployment or live-data wiring (the shell shows no live data).
- Saved's actual save-and-recall behaviour.
