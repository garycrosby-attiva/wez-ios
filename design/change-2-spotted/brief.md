# Design brief — Change 2: Spotted (capture + editorial feed)

> Shape: design brief (feature change). Vocabulary per `../glossary.md`.
> Prototype reference and capture states: see `prototype-reference.md`.
> Scope set with Producer: **capture + editorial feed only**. The live join-me alert is deferred to
> a later change.
> The spec is OpenSpec's to write; we review and approve it against this brief.

## Client & purpose

The first real feature on the foundation, and the start of the product's social loop. The client's
premise: the best signal about a beach comes from people actually there. In its full form Spotted
has two layers — a live "join me" alert to nearby friends, and a calm editorial feed the wider
community shares in. This change builds the **capture and the editorial feed**. The live join-me
alert (proximity, contacts, notifications) is a separate later change — it depends on an unresolved
proximity decision and a notifications/social-graph surface we haven't briefed, so it stays out of
this one.

## Context driving the shape

A user is physically at a beach when they capture — that's the whole value, so capture is live and
on-the-spot (live camera, not a library pick), location-bound, not composed later. A captured spot
is a moment: a photo, the conditions at that moment, the beach it's tied to, and optionally a few
words. The beach is auto-tagged from location; the user doesn't pick it. Conditions are attached
automatically as a fact of that moment — the user doesn't enter them (how we *source* conditions is
unsettled on our side; the design should depend on the fact, not the source). Once captured, the
spot posts to a calm editorial feed. V1 is curated: a single trusted editorial voice shapes the
feed, over seed beaches only — the curated circle. That's a V1 decision, not permanent, so the
design shouldn't hard-wire single-author curation into the read path.

## Capabilities in play (high level)

- **Capture** — guide the user through photographing the moment (live camera), auto-resolving
  location to a known beach, attaching conditions, an optional caption, and posting.
- **Conditions** — establish the conditions at capture time and attach them to the spot,
  automatically — not a user-entered step.
- **Persistence** — store the moment durably, photo included, as an immutable, write-once record.
- **Editorial feed** — present recent spots in the calm curated feed; for returning users,
  personalised by where they've been and what they've saved. Per spot, the reader can *sunshine* it
  (the single appreciation gesture — no likes, hearts, follower counts, comments, or following) or
  *save it to Future Spots*.
- **Place-awareness** — when the user is outside the seed beaches, the product declines gracefully
  rather than guessing.

## Where I'd head with it (direction, not prescription)

Capture as a single deliberate flow entered and left cleanly. Treat the spot as write-once — no
quiet edits after the fact; protect that immutability in the design. Keep the conditions source
abstracted: depend on the fact of conditions, not a particular provider. Build the feed read so it
can grow beyond the curated single-author case — don't hard-wire the editorial assumption into the
read path. Keep the feed's interaction surface minimal and intentional: sunshine and save, nothing
else. And leave a clean seam where the deferred join-me alert will later hook onto the same captured
moment — without building it now.

## Over to OpenSpec

Produce a spec for the full path — standing at a beach, capturing a spot, through to that spot
appearing in the editorial feed where others can sunshine or save it — satisfying the
moment-in-time, curated-V1, auto-attached-conditions, and graceful-out-of-region rules, for us to
review against this brief. The live join-me alert is out of scope for this change. I've named the
capabilities and the rules that matter; the spec owns how they're realised.
