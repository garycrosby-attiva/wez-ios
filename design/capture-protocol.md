# Capture protocol — walking a prototype with the creative

How we turn the creative's functional prototype into labelled, traceable reference for the
implementation tool. Authored once; each journey's `ez-walkthrough-guide.md` follows it.

The ordering matters: we get the creative's *actual* path before our blueprint can bias it, then
reconcile, then capture. Walking in step-by-step from our blueprint would lead the witness.

## Pass 0 — Confirm the bounded context

Before anything else, name the scope out loud and agree it: "today, the Spotted flow — it starts at
X, it ends at Y." This bounds the *scope*, not the *steps*. The goalposts can move if the walk shows
the real boundary sits elsewhere — but moving them is then a deliberate, visible decision, not a
silent drift.

## Pass 1 — Discovery (unguided, recorded)

Ask the creative to walk the whole journey without stopping and without our prompting: "just talk me
through it, don't wait for me." No capturing, no naming, no interrupting. Record it (voice or screen
recording) — the unguided narration is itself a creative-intent artefact, the rawest version of
their voice and sense of the flow, and notes would lose the texture.

## Pass 2 — Calibration (ours, then theirs)

Reconcile the recorded walk against the blueprint for this journey. Divergences split three ways,
and each is signal:

- a step they do that we never modelled → our blueprint has a gap (add it);
- a step we modelled that they don't actually want → we over-specified (drop it);
- the same step seen differently → a vocabulary mismatch the glossary should settle.

Authority over the reconciliation sits on our side. Produce the agreed step list, then take it back
to the creative — "here's what we heard, does this land?" — and only proceed on their yes. For
journeys whose blueprint has no event walks modelled yet, this pass *is* the event-storming: the
steps are made explicit from observed behaviour rather than invented at a desk.

## Pass 3 — Capture (guided)

Only now, go screen by screen against the confirmed list. The filenames are pre-assigned in the
journey guide, so the creative makes no naming decisions — they save what they're told. Capture
**states, not just screens**: the empty case, the populated case, the out-of-region refusal,
mid-flow steps. Trigger the states deliberately (post something so the feed isn't empty; go
out-of-region for the refusal) — a happy-path walk misses them. Each step also captures the
creative's words for that moment ("in your words"), which lands in the manifest.

## Where things go

Recordings and raw screenshots → a shared folder the creative can reach (Drive/Dropbox), not the
repo. We rename to the scheme and move the curated set into `screens/<journey>/` at the laptop.
One capture device, for consistent resolution.
