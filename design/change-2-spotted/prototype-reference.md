# Prototype reference — Change 2: Spotted (capture + editorial feed)

This is **our** manifest (a brief-companion), not an OpenSpec artefact. It binds each captured screen
to the blueprint step it shows and the brief capability it serves, and carries the creative's intent
for each moment. The blueprint is the checklist; this is the ledger.

## Authority (read first)

> The brief is authoritative; conflicts resolve on our side, not by the agent. The prototype —
> screens here plus the cloned repo at `../../wez-lovable-reference/` — is authoritative over
> **experience and behaviour** and **reference-only over structure**: re-realise it natively, do
> not carry the React/Tailwind shape across. Exact visual tokens (palette, type scale, spacing) and
> precise behaviour live in the cloned repo; the screens here are authoritative for composition and
> state. Fonts: the actual font files must travel into the app bundle and the embedding licence be
> confirmed — a web-font reference is not enough.

## Coverage

Scope: capture + editorial feed. The live join-me alert is out of this change. Rows below are the
**target capture set drawn from the Spotted blueprints**; Ez's unguided walk (Pass 1) and
calibration (Pass 2) confirm or adjust the screen-level granularity before capture. The "intent"
column is filled from Ez's words during the walk. A blueprint step with no screen row is a gap.

## Ledger

| Screen file | Journey (blueprint) | Step / state (blueprint event) | Serves (brief capability) | Static-frame note | Intent (creative, verbatim) |
|---|---|---|---|---|---|
| `screens/spotted-capture/01-camera.png` | Capture | UserOpenedSpottedCamera (live camera only) | Capture | transition into capture not visible | _(Pass 1/3)_ |
| `screens/spotted-capture/02-photo.png` | Capture | UserCapturedSpotted (SOC-01) | Capture | retake gesture not visible | _(Pass 1/3)_ |
| `screens/spotted-capture/03-beach.png` | Capture | beach auto-tagged from GPS | Place-awareness | — | _(Pass 1/3)_ |
| `screens/spotted-capture/04-caption.png` | Capture | optional caption | Capture | — | _(Pass 1/3)_ |
| `screens/spotted-capture/05-posted.png` | Capture | SpottedPostedToEditorialFeed (SOC-02) | Persistence / Editorial feed | post→feed transition not visible | _(Pass 1/3)_ |
| `screens/spotted-capture/out-of-region.png` | Capture | out-of-region branch | Place-awareness | static; tone is the point | _(Pass 1/3)_ |
| `screens/spotted-feed/feed-empty.png` | Editorial feed | empty state | Editorial feed | — | _(Pass 1/3)_ |
| `screens/spotted-feed/feed-populated.png` | Editorial feed | SpottedFeedOpenedByUser → personalised (PER-01) | Editorial feed | scroll/refresh not visible | _(Pass 1/3)_ |
| `screens/spotted-feed/item-view.png` | Editorial feed | SpottedItemViewed | Editorial feed | — | _(Pass 1/3)_ |
| `screens/spotted-feed/item-sunshined.png` | Editorial feed | SpottedItemSunshined (SOC-02, replaces like) | Editorial feed | the gesture/animation not visible | _(Pass 1/3)_ |
| `screens/spotted-feed/item-saved.png` | Editorial feed | SpottedItemSavedAsFutureSpot (SOC-03 → PER-01) | Editorial feed | — | _(Pass 1/3)_ |

Note: conditions are attached automatically at capture (not a user step), so there is no
conditions-entry screen to capture. Substrate chrome seen in passing → `screens/_substrate/`.
