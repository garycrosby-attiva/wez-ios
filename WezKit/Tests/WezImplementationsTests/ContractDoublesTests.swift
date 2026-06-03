import Testing
import Foundation
import WezSpecs
import WezTestSupport

@Suite("Change 1 contract doubles")
struct ContractDoublesTests {

    @Test("InMemoryPostStorage persists and returns recent newest-first")
    func postStorageRoundTrip() async throws {
        let storage = InMemoryPostStorage()
        let older = Self.makePost(id: "p1", createdAt: Date(timeIntervalSince1970: 1000))
        let newer = Self.makePost(id: "p2", createdAt: Date(timeIntervalSince1970: 2000))
        try await storage.persist(older)
        try await storage.persist(newer)
        let recent = try await storage.recent()
        #expect(recent.map(\.id) == ["p2", "p1"])
    }

    @Test("Editorial-pair invariant rejects a half-populated post")
    func editorialPairInvariant() async {
        let bad = Self.makePost(id: "p3", summary: "Lovely spot", author: nil)
        let storage = InMemoryPostStorage()
        await #expect(throws: PostValidationError.self) {
            try await storage.persist(bad)
        }
    }

    @Test("SeededBeachResolver resolves within radius and refuses outside")
    func resolverHitAndMiss() {
        let moffat = Beach(
            id: "moffat",
            name: "Moffat Beach",
            region: "Sunshine Coast",
            coordinate: Coordinate(latitude: -26.7945, longitude: 153.141),
            tagsStatic: [],
            createdAt: Date(timeIntervalSince1970: 0)
        )
        let resolver = SeededBeachResolver(beaches: [moffat])
        #expect(resolver.resolve(Coordinate(latitude: -26.7945, longitude: 153.141)) == .resolved(moffat))
        #expect(resolver.resolve(Coordinate(latitude: 51.5074, longitude: -0.1278)) == .outOfRange)
    }

    @Test("StubBeachConditionsProvider throws on an unknown beach")
    func conditionsUnknownBeach() async {
        let provider = StubBeachConditionsProvider()
        await #expect(throws: BeachConditionsError.self) {
            _ = try await provider.conditions(for: "nope")
        }
    }

    private static func makePost(
        id: String,
        summary: String? = nil,
        author: String? = nil,
        createdAt: Date = Date()
    ) -> SpottedPost {
        SpottedPost(
            id: id,
            beachId: "moffat",
            photoUrl: "spotted/\(id).jpg",
            caption: nil,
            captureConditions: BeachConditions(
                windDirectionDegrees: 180,
                windSpeedKnots: 8,
                swellDirectionDegrees: 135,
                swellHeightMetres: 0.6,
                swellPeriodSeconds: 9,
                tide: .rising,
                cloudCoverPercent: 10,
                rainProbabilityPercent: 5,
                rainExpectedNextHours: 0,
                airTemperatureCelsius: 26,
                observedAt: createdAt
            ),
            derivedTags: [],
            summary: summary,
            author: author,
            createdAt: createdAt
        )
    }
}
