# Brief — Spotted

Where's Ez has two halves: the friend who tells you where to go, and the friend who
shares where they are. This change builds the second half — **Spotted**: you're at a
beach, you capture what it's like right now, and it lands in the area's editorial feed
for others to see. It lives in the Spotted tab of the existing shell.

This is a prototype-and-demonstrate build: enough to capture a post and read the feed
back, end to end, running locally. Its concepts come from the product's design.

---

## The core principle: live, right now

Every Spotted post is something happening *now*. Capture is the **live camera only** —
never a photo pulled from the library. This is non-negotiable; it is what lets the feed
be trusted as "what the beach is actually like at this moment."

On a device that is the real camera. In the simulator there is no camera, so present the
live-capture surface as faithfully as the simulator allows — a camera-framed, "happening
now" capture screen — so the experience reads true for demonstration. Do **not** substitute
a library picker to work around the missing camera; that breaks the principle the whole
feature rests on.

---

## What to build — the capture flow

A four-step flow, presented as a focused task over the Spotted tab. The sequence below is
the prototype's working shape — treat it as real but not final; it is open to refinement
once the flow is walked with the creative.

1. **Capture** — the live-capture surface (above). The user takes the shot.
2. **Auto-tag** — the app reads GPS and resolves it to the nearest known beach; the user
   confirms the beach.
3. **Join-me alert** — a proximity "come join me" nudge. Its UI ships visually complete and
   functional, but it **quietly does not send** in this version; the delivery mechanism is a
   later change. Present it honestly as part of the flow — just don't wire it to send.
4. **Post** — the post lands in the area's editorial feed.

---

## What to build — the feed

The Spotted tab shows the **editorial feed** for the area: the posts people have spotted,
newest first, capped at the most recent 50. The voice and framing are Ez's register — this
is "the friend who shares," not a generic photo grid. For this prototype every post is
authored as Ez-the-editor; there is no multi-user identity yet.

Where a post surfaces a beach, a **"Try this spot"** affordance points at it — but for now
it links to a "coming soon" placeholder, not a real beach-detail screen.

---

## Persistence

A captured post and its photo persist behind the app's **existing storage seams** — the
post-metadata and photo protocols already defined in the shared package — so the storage
backend is swappable without touching the flow. GPS-to-beach uses the app's in-app
nearest-beach resolver over the seeded beach list.

For this change, wire those seams to the **local development backend**: the local dev
worker with local post-metadata storage and local photo storage. The **deployed, hosted
backend is explicitly out of scope** — this change proves the loop locally; making it real
for remote users comes later.

---

## Done

- The app opens to a working Spotted tab.
- A live capture (alluded-to in the simulator) produces a post.
- The post resolves to a seeded beach by GPS.
- It persists to the local backend and reads back.
- The editorial feed shows posts newest-first (most recent 50), in Ez's register.
- The join-me alert is present in the flow and does not send.
- "Try this spot" links to a coming-soon placeholder.

---

## Out of scope

- The deployed / hosted backend (this change is local only).
- Actually sending the join-me nudge (a later change wires delivery).
- Captions on posts (a later change).
- User identity / accounts and multi-author feeds.
- Offline capture and sync.
- A real beach-detail screen behind "Try this spot."
- The Home tab's recommendation content (a separate change).
- Any correction-feed or live-signal surface.
