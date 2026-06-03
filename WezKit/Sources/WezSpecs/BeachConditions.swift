import Foundation

public enum TideState: String, Codable, Equatable, Sendable {
    case low = "LOW"
    case rising = "RISING"
    case high = "HIGH"
    case falling = "FALLING"
}

/// Point-in-time conditions for a beach (SIG-01 AuthoritativeWeatherIngestion).
/// Re-authored from the web substrate's `BeachConditions` shape (readable-not-runnable reference).
public struct BeachConditions: Codable, Equatable, Sendable {
    public let windDirectionDegrees: Double
    public let windSpeedKnots: Double
    public let swellDirectionDegrees: Double
    public let swellHeightMetres: Double
    public let swellPeriodSeconds: Double
    public let tide: TideState
    public let cloudCoverPercent: Double
    public let rainProbabilityPercent: Double
    public let rainExpectedNextHours: Double
    public let airTemperatureCelsius: Double
    public let observedAt: Date

    public init(
        windDirectionDegrees: Double,
        windSpeedKnots: Double,
        swellDirectionDegrees: Double,
        swellHeightMetres: Double,
        swellPeriodSeconds: Double,
        tide: TideState,
        cloudCoverPercent: Double,
        rainProbabilityPercent: Double,
        rainExpectedNextHours: Double,
        airTemperatureCelsius: Double,
        observedAt: Date
    ) {
        self.windDirectionDegrees = windDirectionDegrees
        self.windSpeedKnots = windSpeedKnots
        self.swellDirectionDegrees = swellDirectionDegrees
        self.swellHeightMetres = swellHeightMetres
        self.swellPeriodSeconds = swellPeriodSeconds
        self.tide = tide
        self.cloudCoverPercent = cloudCoverPercent
        self.rainProbabilityPercent = rainProbabilityPercent
        self.rainExpectedNextHours = rainExpectedNextHours
        self.airTemperatureCelsius = airTemperatureCelsius
        self.observedAt = observedAt
    }
}

public enum BeachConditionsError: Error, Equatable, Sendable {
    /// No conditions are known for the given beach id.
    case unknownBeach(String)
}

/// Supplies conditions for a beach (SIG-01).
///
/// Async + throwing — a deliberate structural divergence from the web substrate's synchronous,
/// optional-returning `conditionsFor`. The seam must accommodate a real *authoritative* provider
/// that ingests over the network; throwing `.unknownBeach` models the miss more honestly than `nil`.
/// The wider `wind-data-source` open thread resolves *behind* this interface, not in it.
public protocol BeachConditionsProvider: Sendable {
    func conditions(for beachId: String) async throws -> BeachConditions
}
