## 1. Local backend (Worker + D1 + R2)

- [ ] 1.1 Add D1 binding and an R2 bucket binding to `backend/wrangler.toml`; keep `name = "wez-backend"`
- [ ] 1.2 Add a D1 schema (migration/SQL) for `Beach` and `SpottedPost` per the canonical AD-WEZ-post-metadata-store v2 shape
- [ ] 1.3 Seed `Beach` rows for the Sunshine Coast and Port Fairy seed regions (id, name, region, coordinate, static tags)
- [ ] 1.4 Add `POST` create-post endpoint: validate the editorial pair, insert into D1
- [ ] 1.5 Add photo upload endpoint: store bytes in R2 at `spotted/{id}.jpg`
- [ ] 1.6 Add photo serve endpoint: stream `spotted/{id}.jpg` from R2 by id
- [ ] 1.7 Add feed list endpoint: return posts `ORDER BY createdAt DESC LIMIT 50`
- [ ] 1.8 Verify endpoints locally (`npm run dev`) with curl: create → upload → list → fetch photo round-trips

## 2. WezKit adapters (WezImplementations + tests)

- [ ] 2.1 Add a seeded beach list (Sunshine Coast / Port Fairy) in `WezImplementations` for the in-app `SeededBeachResolver`
- [ ] 2.2 Add a seeded `BeachConditionsProvider` (plausible per-seeded-beach values) for capture-time `captureConditions`
- [ ] 2.3 Add `HTTPPostStorage: PostStorage` — `persist` POSTs post JSON; `recent()` GETs the feed (newest-first, 50)
- [ ] 2.4 Add `HTTPPhotoStorage: PhotoStorage` — `persist(postId:photo:)` uploads bytes; `url(for:)` returns the serve URL for `spotted/{postId}.jpg`
- [ ] 2.5 Add a derived-tags helper: union of the beach's static tags and condition-derived tags
- [ ] 2.6 Add a live round-trip test (mirroring the probe test) exercising `HTTPPostStorage`/`HTTPPhotoStorage` against the local Worker

## 3. Capture flow (app)

- [ ] 3.1 Build the capture-flow container presented as `.fullScreenCover` over the Spotted tab, stepping capture → auto-tag → join-me → post
- [ ] 3.2 Build the live-capture surface: real camera on device; a faithful "happening now" camera-framed surface in the simulator; NO library picker
- [ ] 3.3 Build the auto-tag step: read GPS, resolve via in-app `BeachResolver`, present the beach for confirmation; honest out-of-range state (no arbitrary beach)
- [ ] 3.4 Build the join-me alert step: visually complete and interactive, but wired to send nothing
- [ ] 3.5 Build submit: generate `postId`, upload photo, build the Ez-authored `SpottedPost` (editorial pair, seeded conditions, derived tags), persist, dismiss to the feed

## 4. Feed (app)

- [ ] 4.1 Replace the Spotted empty state with the editorial feed: load via `PostStorage.recent()`, newest-first, render photos via `PhotoStorage.url(for:)` (`AsyncImage`)
- [ ] 4.2 Render posts in Ez's editorial register (single-author), never presenting stored conditions as live
- [ ] 4.3 Add the "Try this spot" affordance linking to an honest coming-soon placeholder
- [ ] 4.4 Add an honest empty state when no posts exist; surface backend-unreachable errors truthfully (no faked success)
- [ ] 4.5 Add an entry point to start capture from the Spotted tab

## 5. Composition + shell update

- [ ] 5.1 Inject the concrete `HTTPPostStorage` / `HTTPPhotoStorage` / seeded resolver / seeded conditions provider at the app composition root
- [ ] 5.2 Update the application-shell expectation: Home stays an empty state; Spotted now hosts the feed (reflects the spec RENAME/MODIFY)

## 6. Verify

- [ ] 6.1 Build the `WheresEz` target clean (Swift 6 strict concurrency, no new warnings)
- [ ] 6.2 With the local backend running and the simulator location set near a seeded beach: complete a capture and confirm the post lands top of the feed
- [ ] 6.3 Confirm GPS resolves to the correct seeded beach; confirm a far location shows the honest out-of-range state
- [ ] 6.4 Confirm the join-me step sends nothing; confirm "Try this spot" shows the coming-soon placeholder
- [ ] 6.5 Confirm the feed shows newest-first (cap 50) and that no stub conditions are presented as live
- [ ] 6.6 Confirm capture offers no library picker in either device or simulator builds
