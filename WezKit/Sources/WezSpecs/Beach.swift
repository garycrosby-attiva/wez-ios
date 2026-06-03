import Foundation

/// A geographic coordinate in decimal degrees.
public struct Coordinate: Codable, Equatable, Sendable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

/// A known beach in the seeded set. Mirrors the canonical D1 `Beach` row
/// (AD-WEZ-post-metadata-store v2): id, name, region, coordinate, static tags, createdAt.
public struct Beach: Codable, Equatable, Sendable, Identifiable {
    public let id: String
    public let name: String
    public let region: String
    public let coordinate: Coordinate
    /// Static, beach-intrinsic tags (e.g. Playground, Shade, Picnic, "UV friendly", "Family-easy").
    public let tagsStatic: [String]
    public let createdAt: Date

    public init(
        id: String,
        name: String,
        region: String,
        coordinate: Coordinate,
        tagsStatic: [String],
        createdAt: Date
    ) {
        self.id = id
        self.name = name
        self.region = region
        self.coordinate = coordinate
        self.tagsStatic = tagsStatic
        self.createdAt = createdAt
    }
}

/// The outcome of resolving a device coordinate to a known beach.
/// `.outOfRange` carries the AD-WEZ-gps-to-beach-resolver graceful-refusal intent
/// (nearest beach is beyond the resolution radius, or there are no candidates).
///
/// Diverges deliberately from the web substrate's `string | null` return: the Swift
/// enum-with-associated-value models the refusal as a first-class case rather than a
/// null, which the AD's "capture refuses gracefully" behaviour reads onto more cleanly.
public enum BeachResolution: Equatable, Sendable {
    case resolved(Beach)
    case outOfRange
}

/// Resolves a device coordinate to a known beach by nearest-by-haversine within a
/// resolution radius (AD-WEZ-gps-to-beach-resolver: ~2km working assumption, tie -> alphabetical by id).
///
/// Synchronous: a pure spatial lookup over a seeded set, no I/O.
///
/// NOTE (carried from EnvironmentState v17 correctionNote): AD-WEZ-gps-to-beach-resolver is
/// internally inconsistent on *where* the resolver runs (optionChosen "in-app" vs consequences
/// "Worker layer"). That contradiction does not touch this contract — coordinate in, beach out,
/// identical either way — but it must be resolved before the concrete adapter lands in Change 2.
public protocol BeachResolver: Sendable {
    func resolve(_ coordinate: Coordinate) -> BeachResolution
}
