import Foundation
import WezSpecs

/// Stub `BeachConditionsProvider` double. Seeded with a fixed map; throws `.unknownBeach`
/// for ids not in the seed.
public struct StubBeachConditionsProvider: BeachConditionsProvider {
    private let conditionsByBeachId: [String: BeachConditions]

    public init(conditionsByBeachId: [String: BeachConditions] = [:]) {
        self.conditionsByBeachId = conditionsByBeachId
    }

    public func conditions(for beachId: String) async throws -> BeachConditions {
        guard let conditions = conditionsByBeachId[beachId] else {
            throw BeachConditionsError.unknownBeach(beachId)
        }
        return conditions
    }
}

/// Seeded `BeachResolver` double doing the *real* nearest-by-haversine lookup over a beach set
/// (AD-WEZ-gps-to-beach-resolver: radius working assumption ~2km, tie -> alphabetical by id).
/// Behaviour mirrors the web substrate's `resolveBeachId`; structure is the native enum result.
public struct SeededBeachResolver: BeachResolver {
    private let beaches: [Beach]
    private let radiusKm: Double

    public init(beaches: [Beach], radiusKm: Double = 2) {
        self.beaches = beaches
        self.radiusKm = radiusKm
    }

    public func resolve(_ coordinate: Coordinate) -> BeachResolution {
        let ranked = beaches
            .map { (beach: $0, distance: Self.haversineKm(coordinate, $0.coordinate)) }
            .sorted { lhs, rhs in
                lhs.distance != rhs.distance ? lhs.distance < rhs.distance : lhs.beach.id < rhs.beach.id
            }
        guard let nearest = ranked.first, nearest.distance <= radiusKm else {
            return .outOfRange
        }
        return .resolved(nearest.beach)
    }

    private static func haversineKm(_ a: Coordinate, _ b: Coordinate) -> Double {
        let earthRadiusKm = 6371.0
        let dLat = (b.latitude - a.latitude) * .pi / 180
        let dLon = (b.longitude - a.longitude) * .pi / 180
        let lat1 = a.latitude * .pi / 180
        let lat2 = b.latitude * .pi / 180
        let h = sin(dLat / 2) * sin(dLat / 2)
              + sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2)
        return earthRadiusKm * 2 * atan2(sqrt(h), sqrt(1 - h))
    }
}
