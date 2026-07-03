## Why

Where's Ez has two halves: the friend who tells you where to go, and the friend who shares
where they are. The shell exists but the Spotted tab is still an empty state. This change
builds the second half — capture what a beach is like *right now* and read it back in the
area's editorial feed — proving the whole loop end-to-end against the local backend.

## What Changes

- Add a four-step **capture flow** presented as a focused task over the Spotted tab:
  live-camera capture → GPS auto-tag (resolve + confirm nearest seeded beach) → join-me
  alert (visually complete but **quietly does not send**) → post submit.
- Capture is **live-camera-only**. On device that's the real camera; in the simulator,
  present a faithful "happening now" capture surface. **No library-picker fallback** —
  that would break the principle the feature rests on.
- Add the Spotted **editorial feed**: posts newest-first, capped at the most recent 50,
  authored as Ez-the-editor (no multi-user identity), in Ez's register. A **"Try this
  spot"** affordance links to a coming-soon placeholder (no real beach detail yet).
- Wire the existing `PostStorage` and `PhotoStorage` seams to the **local dev backend**
  (Worker + local D1 post metadata + local R2 photo blobs) via new concrete HTTP adapters;
  add the Worker endpoints they call. GPS-to-beach uses the in-app `BeachResolver` over the
  seeded beach list.
- Populate `SpottedPost.captureConditions` from a **seeded `BeachConditionsProvider` stub**
  for the seeded beaches (no live weather source is in scope); compute `derivedTags` from
  the beach's static tags ∪ condition-derived tags. These stub values are **never surfaced
  as live conditions** in the feed UI.

## Capabilities

### New Capabilities
- `spotted-capture`: the four-step live-capture flow that produces a persisted post —
  capture, GPS auto-tag/confirm, non-sending join-me alert, and submit.
- `spotted-feed`: the editorial Spotted feed — newest-first, 50-capped, Ez-authored, with
  the coming-soon "Try this spot" affordance.

### Modified Capabilities
- `application-shell`: the "Home and Spotted are navigable empty states" requirement
  narrows to **Home only** — Spotted now hosts real feature content (capture + feed).

## Impact

- **App target (`WheresEz`)**: `SpottedView` replaced by the feed; capture flow views
  presented modally (`.fullScreenCover`) over the tab. Composition root injects the
  concrete storage/resolver/conditions adapters.
- **WezKit**:
  - `WezImplementations` — new HTTP adapters `HTTPPostStorage` (`PostStorage`) and
    `HTTPPhotoStorage` (`PhotoStorage`); a seeded conditions provider for capture; the
    seeded beach list for the in-app resolver.
  - No new `WezSpecs` contracts expected — `PostStorage`, `PhotoStorage`, `BeachResolver`,
    `BeachConditionsProvider`, `SpottedPost` already exist. (Confirmed in design.)
- **Backend (`backend/`)**: new local Worker endpoints for post create, photo upload/serve,
  and feed list, backed by local D1 and R2. Deployed/hosted backend is **out of scope**.
- **Out of scope**: hosted backend, actually sending the join-me nudge, captions, user
  identity / multi-author feeds, offline capture/sync, a real beach-detail screen, Home
  recommendation content, and any correction/live-signal surface.
