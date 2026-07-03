import Testing
import Foundation
import WezSpecs
import WezImplementations

/// Live integration test — requires the local Worker running (`cd backend && npm run dev`)
/// with the D1 schema applied. Exercises the real app-to-Worker hop through the concrete
/// `HTTPPhotoStorage` and `HTTPPostStorage` adapters: upload a photo, persist a post, read the
/// feed back, and confirm the post round-trips (beach, conditions, derived tags, editorial pair)
/// newest-first.
@Test func spottedStorageRoundTripPersistsAndReadsBack() async throws {
    let baseURL = URL(string: "http://localhost:8787")!
    let posts = HTTPPostStorage(baseURL: baseURL)
    let photos = HTTPPhotoStorage(baseURL: baseURL)

    let beach = SeededData.beaches.first { $0.id == "moffat" }!
    let conditions = try await SeededBeachConditionsProvider().conditions(for: beach.id)
    let tags = DerivedTags.compute(staticTags: beach.tagsStatic, conditions: conditions)

    let id = "rt-\(UUID().uuidString)"
    let post = SpottedPost(
        id: id,
        beachId: beach.id,
        photoUrl: "spotted/\(id).jpg",
        caption: nil,
        captureConditions: conditions,
        derivedTags: tags,
        summary: "Glassy and quiet this morning.",
        author: "Ez",
        createdAt: Date()
    )

    try await photos.persist(id, photo: Data([0xFF, 0xD8, 0xFF, 0xE0, 0x00]))
    try await posts.persist(post)

    let recent = try await posts.recent()
    let mine = try #require(recent.first { $0.id == id })
    #expect(mine.beachId == "moffat")
    #expect(mine.derivedTags == tags)
    #expect(mine.captureConditions == conditions)
    #expect(mine.summary == "Glassy and quiet this morning.")
    #expect(mine.author == "Ez")

    // Feed is newest-first.
    let times = recent.map(\.createdAt)
    #expect(times == times.sorted(by: >))
}
