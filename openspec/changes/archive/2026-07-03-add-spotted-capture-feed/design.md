## Context

The shell exists; the Spotted tab is an empty state. The shared `WezSpecs` package already
defines every contract this change needs — `PostStorage`, `PhotoStorage`, `BeachResolver`,
`BeachConditionsProvider`, and the `SpottedPost` / `Beach` / `BeachConditions` domain types.
Today only in-memory doubles (`WezTestSupport`) and the `HTTPBackendProbe` exist; the local
Worker serves a single `/ping`. This change wires the storage seams to the local dev backend
with new concrete HTTP adapters, adds the Worker endpoints, and builds the capture flow and
feed in the app. Local-only — the hosted backend is out of scope.

Constraints: SwiftUI, Swift 6 strict concurrency; spec/impl/test separation (new behaviour
behind existing contracts, concretes in `WezImplementations`); honest-about-state; the
simulator shares the Mac's network stack so the app reaches `http://localhost:8787`.

## Goals / Non-Goals

**Goals:**
- A four-step capture flow (capture → auto-tag → join-me → post), modal over the Spotted tab.
- Live-camera-only capture; a faithful "happening now" surface in the simulator; no library fallback.
- GPS → seeded beach via the in-app `BeachResolver`, with user confirmation and honest out-of-range.
- Persist post + photo through `PostStorage` / `PhotoStorage` wired to the local Worker (D1 + R2).
- Editorial feed: newest-first, capped 50, Ez-authored, "Try this spot" → coming-soon placeholder.
- Prove the whole loop locally, end-to-end.

**Non-Goals:**
- Hosted/deployed backend; sending the join-me nudge; captions; user identity / multi-author;
  offline capture/sync; a real beach-detail screen; Home recommendation content.

## Decisions

**1. No new `WezSpecs` contracts.** Capture and feed compose the existing seams. New code is
concrete adapters in `WezImplementations` + app views. *Why:* the seams were designed for
exactly this; adding contracts would be speculative.

**2. `BeachResolver` runs in-app.** The brief states GPS-to-beach uses "the app's in-app
nearest-beach resolver", resolving the AD-WEZ-gps-to-beach-resolver in-app-vs-Worker
contradiction flagged in `Beach.swift` **in favour of in-app**. The existing
`SeededBeachResolver` (real haversine, ~2km radius, tie → alphabetical id) is used directly,
seeded from a beach list shipped in `WezImplementations`.

**3. `captureConditions` from a seeded stub, never surfaced as live.** No authoritative
weather source is in scope (SIG-01, backend not deployed). Capture populates
`captureConditions` from a seeded `BeachConditionsProvider` for the seeded beaches (the
`StubBeachConditionsProvider` shape, seeded with plausible per-beach values), and
`derivedTags` = beach static tags ∪ condition-derived tags. The feed renders photo + beach +
Ez's framing and **never** presents these numbers as current conditions. This resolves the
`SpottedPost.swift` open thread toward "persist the full snapshot (from a stub), don't display
it as live". *Alternative considered:* make `captureConditions` optional — rejected to keep the
shared contract and its double/tests stable for a prototype.

**4. New HTTP adapters in `WezImplementations`.**
- `HTTPPostStorage: PostStorage` — `persist` POSTs post JSON to the Worker; `recent()` GETs the
  feed (newest-first, server-applied `LIMIT 50`).
- `HTTPPhotoStorage: PhotoStorage` — `persist(postId:photo:)` uploads bytes to the Worker
  (proxied to R2); `url(for:)` returns the Worker GET URL serving `spotted/{postId}.jpg`.
- *Photo upload via Worker proxy, not R2 presigned-direct-upload.* The contract is storage-shaped
  and the AD leaves mechanics to the adapter; proxying through the Worker is the simplest correct
  path for a local prototype. Presigned direct upload is a later optimisation.

**5. Post identity and ordering.** The app generates a `postId` (UUID) before upload so photo and
metadata share it; `photoUrl` is stored as the canonical object key `spotted/{postId}.jpg` (per
AD-WEZ-photo-storage), and the feed derives a loadable URL via `PhotoStorage.url(for:)` for
`AsyncImage`. `createdAt` is stamped at submit and stored; the feed orders by `createdAt DESC`.

**6. Ez-the-editor authoring.** Every prototype post sets `summary` and `author` together
(satisfying `SpottedPost.validate()`'s editorial-pair invariant) as Ez-the-editor. No author
selection UI.

**7. Capture presented modally (`.fullScreenCover`).** Per the shell's chrome-by-presentation
rule, a focused modal task covers the tab bar with no explicit hiding. The flow is internal
step state (capture → auto-tag → join-me → post), not pushed routes.

**8. Backend: new local Worker endpoints over D1 + R2.** Extend `backend/src/index.ts` (keeping
`/ping`): create-post, upload-photo, serve-photo, list-feed. Add a D1 `Beach`/`SpottedPost`
schema (canonical AD-WEZ-post-metadata-store v2 shape) and an R2 bucket binding in
`wrangler.toml`; seed the beach rows for Sunshine Coast / Port Fairy. Endpoint shapes are
finalised during implementation against the adapters.

## Risks / Trade-offs

- **Simulator has no camera** → present a faithful camera-framed capture surface; do NOT add a
  library picker (would break the core principle). The captured image in-sim is a stand-in asset
  delivered through the live-surface, not a user library pick.
- **GPS in the simulator is synthetic** → demo by setting the simulator location near a seeded
  beach (Sunshine Coast / Port Fairy); document the demo coordinate. Out-of-range path is still
  exercised by choosing a far location.
- **Local backend must be running** (`cd backend && npm run dev`) and local D1/R2 initialised →
  document the run steps; the feed/capture honestly surface backend-unreachable errors rather
  than faking success.
- **Seeded stub conditions could leak into the UI as if live** → explicit spec requirement that
  they are never presented as current conditions; enforce in review and feed rendering.
- **Capture flow shape is "real but not final"** (brief) → keep step views loosely coupled so the
  sequence can be re-walked with the creative without reworking persistence.

## Migration Plan

Additive; no data migration (no prior posts). Steps: extend the Worker (endpoints + D1 schema +
R2 binding, seed beaches) → add `HTTPPostStorage` / `HTTPPhotoStorage` + seeded resolver/conditions
in `WezImplementations` → build capture flow + feed views → inject concretes at the app root →
run locally and verify the loop. Rollback: revert the commit; local backend state is disposable.

## Open Questions

- **Capture flow sequence** is open to refinement once walked with the creative (brief). The
  four-step order is the working shape.
- **Exact D1 column set and endpoint payloads** are settled during implementation against the
  adapters (the canonical schema is the reference).
- **Simulator capture stand-in asset** — which image the faithful live surface yields for a
  simulator demo (a bundled "now" placeholder vs a generated frame); cosmetic, settle in build.
