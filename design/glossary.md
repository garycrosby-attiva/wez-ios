# Glossary — Where's Ez ubiquitous language

This is the shared vocabulary that must survive intact from brief to spec to implementation. It pins
**meaning**, not shape — no types, fields, or signatures. If the same word means the same thing in
the brief, the spec, the code, and the screens, the glossary is doing its job.

---

**The friend** — the product's voice and posture: a knowledgeable mate who knows where the calm is
and where the wind isn't. It is a tone and a positioning, not a screen or a character. Copy
throughout should sound like this friend, not like an app announcing itself.

**Beach** — a known, named place the product covers. In V1 these are hand-curated within the seed
regions. A beach has a location and some lasting qualities (shade, playground, and the like).

**Seed regions / seed beaches** — the curated set the product covers in V1 (Sunshine Coast and Port
Fairy). Coverage grows later; V1 is deliberately narrow and hand-curated.

**Conditions** — what it was like at a beach at a particular moment (sunny, calm, and so on).
Conditions attached to a spot are a **fact of that moment**, captured then — not a live reading and
not something that updates afterward.

**Spot** — a shared moment at a beach: a photo, the conditions of that moment, the beach it is tied
to, and a few words. A spot is the core unit the product is built around.

**Moment (write-once)** — a spot is a moment in time. Once shared it does not quietly change. This
immutability is a product rule, not an implementation convenience.

**Capture** — the act of creating a spot while physically at the beach: photographing the moment,
establishing where you are, attaching the conditions, and adding words. Capture is on-the-spot and
location-bound; it is not composing a post later from elsewhere.

**Out-of-region** — being somewhere outside the seed beaches. The product says so warmly and
declines to guess, rather than forcing a wrong beach. A graceful refusal, in the friend's voice.

**Feed** — recent spots, newest first. In V1 the feed is curated.

**The curated circle** — the V1 social shape: a single trusted editorial voice shapes what appears,
over seed beaches only. This is a V1 decision, not a permanent constraint — the design should not
assume curation is forever.

**Spotted** — the feature (and journey set) covering capture and feed together: sharing where the
calm is, and seeing where others found it. The first real feature on the foundation.

**Place-awareness / beach resolution** — knowing which known beach you are standing at, from your
location, and stepping back kindly (out-of-region) when it is somewhere not yet covered.

**Sunshine** — the editorial feed's single appreciation gesture: you can *sunshine* a spot. It
deliberately replaces likes, hearts, and follower counts — there are none of those. A quiet, warm
acknowledgement, not a popularity metric.

**Future Spots** — spots a user has saved from the feed to return to later. Saving from the feed is
the bridge into a user's Future Spots.

**Join-me alert** — the live, proximity-gated friend alert: from a captured spot, a user alerts
nearby friends in a friend-text-style message to come join them. In the full product this is the
primary purpose of Spotted, but it is **deferred beyond Change 2** — it depends on the social graph,
proximity gating, and notifications. Change 2 covers capture and the editorial feed only.
