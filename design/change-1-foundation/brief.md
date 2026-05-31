# Substrate brief — Change 1: foundation

> Shape: substrate brief (foundation change). Vocabulary per `../glossary.md`.
> The spec is OpenSpec's to write; we review and approve it against this brief.

## Client & purpose

Where's Ez is a beach-discovery app for a creative client (Desert Rose Studios). The product helps
people find a beach that suits the conditions they want — calm water, sun, low wind — and share
spots they've found. We're building it native iOS, SwiftUI end-to-end, after an earlier web
prototype was retired to reference. This change is foundation only: stand up the app and prove the
architecture holds end to end before any feature lands on it.

## Context driving the shape

It's a mobile-first, location-aware social product. Users capture moments at a physical beach, so we
need on-device location resolved against a known set of beaches, photo capture and storage, and a
feed. V1 runs on seed regions (Sunshine Coast, Port Fairy), hand-curated. The backend is
Cloudflare-shaped (Workers, D1, R2) — though the native pivot means that's now a client-to-edge
relationship over HTTP, not a single-vendor web stack, so proving that seam is the point of this
change.

## Where I'd head with it (direction, not prescription)

A thin app layer over modular packages, with a hard separation between the product's promised
capabilities and the adapters that satisfy them — so the backend can move without disturbing the
app. The capability seams I'd expect: photo storage, post persistence and feed read,
beach-conditions lookup, and location-to-beach resolution. A tab-based shell that accretes feature
by feature, with honest placeholders where features haven't arrived. Foundation success is
structural: builds, runs, the layers are wired, and a trivial round-trip proves the app actually
talks to its backend.

## Over to OpenSpec

Produce a spec that refines this into the foundation's build — the module boundaries, the seam
contracts, the schema, the round-trip proof — for us to review against this brief. I've named the
seams and the direction; the spec owns their shape.
