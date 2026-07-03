import Foundation
import WezSpecs

/// Production in-app `BeachResolver` (AD-WEZ-gps-to-beach-resolver, resolved in-app per the
/// Spotted brief). Nearest-by-haversine over a seeded beach set within a resolution radius;
/// ties broken alphabetically by id; out-of-range when the nearest is beyond the radius.
///
/// NOTE: `WezTestSupport.SeededBeachResolver` is a parallel double with the same algorithm used
/// by package tests; this is the concrete the shipping app injects.
public struct SeededBeachResolver: BeachResolver {
    private let beaches: [Beach]
    private let radiusKm: Double

    public init(beaches: [Beach] = SeededData.beaches, radiusKm: Double = 2) {
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
