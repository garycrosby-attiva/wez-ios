# Where's Ez — walking through Spotted with you

> For the creative (Ez). Producer-facing notes are in blockquotes — don't read those out.
> Follows the three passes in `../capture-protocol.md`. Scope: capture + the editorial feed.
> The steps below are grounded in our blueprints, but the *exact screens* are confirmed by Ez's
> unguided walk (Pass 1) and calibration (Pass 2) — add or drop steps there before capturing.
> Filenames are pre-assigned so Ez never names anything.

We're building the app for real now, natively, and I want it to look and feel exactly like your
prototype. The easiest way is to walk through it together and grab a picture of each screen as we
go. I'll tell you what to tap and what to call each picture — you just save them. The "in your
words" bits are the important part: that's where you tell me what each moment should feel like.

---

## First — what we're looking at today

> Pass 0 — confirm the bounded context before anything else.

Today we're walking **Spotted: sharing a spot, and the feed where it lives.** It starts when you go
to add a spot, and it ends when your spot is in the feed and someone can sunshine it or save it.
We're *not* doing the "join my friends nearby" part today — that's a later piece.

## Then — just show me, don't stop

> Pass 1 — discovery, unguided, recorded. No capturing yet.

Before we capture anything, just walk me through it start to finish, the way you'd really use it —
add a spot, then go look at the feed. Don't wait for me, don't explain for my benefit. I'm recording.

## Then — let me check I heard you right

> Pass 2 — calibration against the blueprint; agree the step list; bring it back to Ez for a yes.
> Only then capture. Trigger states deliberately (post a spot so the feed isn't empty; go
> out-of-region for the refusal).

## Then — let's capture it, screen by screen

> Pass 3 — guided capture against the confirmed list.

### Journey A — Sharing a spot (the capture)

**Step 1 — Opening the camera**
- Where you are: you've tapped to add a spot; the camera's open on the beach.
- What to do: frame the beach as you would for real, then screenshot.
- Save as: `spotted-capture/01-camera.png`
- In your words: quick and instinctive, or a considered moment?

**Step 2 — The photo you took**
- Where you are: you've taken the shot and you're looking at it.
- What to do: screenshot.
- Save as: `spotted-capture/02-photo.png`
- In your words: can you retake? What matters here before you carry on?

**Step 3 — Which beach (it knows where you are)**
- Where you are: the app has worked out which beach you're at and shows it.
- What to do: screenshot.
- Save as: `spotted-capture/03-beach.png`
- In your words: how should it feel that it already knows the beach?

**Step 4 — A few words (if you want)**
- Where you are: adding an optional caption.
- What to do: screenshot.
- Save as: `spotted-capture/04-caption.png`
- In your words: how much do words matter here — central, or a light touch?

**Step 5 — Shared**
- Where you are: you've posted; the spot's gone to the feed.
- What to do: screenshot.
- Save as: `spotted-capture/05-posted.png`
- In your words: what's the feeling right after you share?

**Branch — When you're not at a known beach**
- Where you are: you tried to spot somewhere we don't cover yet, and the app gently says so.
- What to do: screenshot the message.
- Save as: `spotted-capture/out-of-region.png`
- In your words: how should this let-down feel? It should still sound like you.

### Journey B — The feed

**Empty, then full**
- Empty: before anything's posted. Save as `spotted-feed/feed-empty.png`.
- Full: after a spot is posted. Save as `spotted-feed/feed-populated.png`.
- In your words: the feeling of opening this and seeing real moments from people who know people?

**Looking at one spot**
- Where you are: you've tapped into a single spot in the feed.
- What to do: screenshot.
- Save as: `spotted-feed/item-view.png`
- In your words: what's this moment for — lingering, or a glance?

**Sunshine it**
- Where you are: you've sunshined the spot (our version of appreciating it — no likes, no hearts).
- What to do: screenshot.
- Save as: `spotted-feed/item-sunshined.png`
- In your words: what should sunshining feel like, versus a "like" anywhere else?

**Save it for later**
- Where you are: you've saved the spot to your Future Spots.
- What to do: screenshot.
- Save as: `spotted-feed/item-saved.png`
- In your words: what makes a spot worth saving for another day?

---

> Where files go: a shared folder (Drive/Dropbox), in order — not the repo. Producer renames if
> needed and moves the curated set into `screens/<journey>/`, and fills Ez's verbatim words into
> `prototype-reference.md`. Substrate chrome Ez passes through (tab bar, menus) goes in
> `screens/_substrate/`.
