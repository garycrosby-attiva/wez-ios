import Foundation
import WezSpecs

/// Seeded V1 beaches (Sunshine Coast + Port Fairy). Ids, coordinates, and static tags
/// MUST match the backend `seed.sql` so the in-app resolver's beach id lines up with the
/// `Beach` rows the backend knows. The in-app `BeachResolver` works over this list.
public enum SeededData {
    public static let beaches: [Beach] = {
        let createdAt = ISO8601DateFormatter().date(from: "2026-01-01T00:00:00Z")!
        func beach(_ id: String, _ name: String, _ region: String,
                   _ lat: Double, _ lon: Double, _ tags: [String]) -> Beach {
            Beach(id: id, name: name, region: region,
                  coordinate: Coordinate(latitude: lat, longitude: lon),
                  tagsStatic: tags, createdAt: createdAt)
        }
        return [
            beach("moffat",     "Moffat Beach",     "Sunshine Coast", -26.7945, 153.1410, ["Picnic", "Shade", "Family-easy"]),
            beach("kings",      "Kings Beach",      "Sunshine Coast", -26.8014, 153.1442, ["Playground", "Family-easy", "UV friendly"]),
            beach("mooloolaba", "Mooloolaba Beach", "Sunshine Coast", -26.6819, 153.1190, ["Picnic", "Family-easy"]),
            beach("east",       "East Beach",       "Port Fairy",     -38.3833, 142.2470, ["Shade", "Picnic"]),
            beach("south",      "South Beach",      "Port Fairy",     -38.3950, 142.2300, ["UV friendly"]),
        ]
    }()
}
