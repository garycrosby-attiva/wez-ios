import Foundation
import WezSpecs

/// Seeded `BeachConditionsProvider` for the local prototype. No authoritative weather source
/// is in scope (SIG-01, backend not deployed), so capture sources `captureConditions` from
/// these plausible per-beach values.
///
/// IMPORTANT: these are seeded placeholders, NOT live observations. They satisfy the
/// non-optional `SpottedPost.captureConditions` field and feed `derivedTags`; they MUST NOT
/// be presented anywhere in the UI as the beach's live or current conditions.
public struct SeededBeachConditionsProvider: BeachConditionsProvider {
    private let byBeachId: [String: BeachConditions]

    public init(byBeachId: [String: BeachConditions] = SeededBeachConditionsProvider.defaults) {
        self.byBeachId = byBeachId
    }

    public func conditions(for beachId: String) async throws -> BeachConditions {
        guard let c = byBeachId[beachId] else { throw BeachConditionsError.unknownBeach(beachId) }
        return c
    }

    /// Plausible seeded snapshot per seeded beach. `observedAt` is fixed seed time, underscoring
    /// these are not live.
    public static let defaults: [String: BeachConditions] = {
        let observedAt = ISO8601DateFormatter().date(from: "2026-01-01T00:00:00Z")!
        func c(wind: Double, cloud: Double, temp: Double, tide: TideState) -> BeachConditions {
            BeachConditions(
                windDirectionDegrees: 180, windSpeedKnots: wind,
                swellDirectionDegrees: 135, swellHeightMetres: 0.6, swellPeriodSeconds: 9,
                tide: tide, cloudCoverPercent: cloud,
                rainProbabilityPercent: 5, rainExpectedNextHours: 0,
                airTemperatureCelsius: temp, observedAt: observedAt
            )
        }
        return [
            "moffat":     c(wind: 7,  cloud: 15, temp: 26, tide: .rising),
            "kings":      c(wind: 9,  cloud: 20, temp: 25, tide: .high),
            "mooloolaba": c(wind: 12, cloud: 40, temp: 27, tide: .falling),
            "east":       c(wind: 14, cloud: 55, temp: 18, tide: .low),
            "south":      c(wind: 16, cloud: 60, temp: 17, tide: .rising),
        ]
    }()
}
