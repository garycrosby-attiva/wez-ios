import Foundation
import WezSpecs

/// Dependencies the Spotted feature needs, expressed purely in `WezSpecs` contracts.
/// The app composition root (`WheresEzApp`) builds this from concrete `WezImplementations`
/// adapters; the views below never see a concrete type.
struct SpottedEnvironment {
    let posts: any PostStorage
    let photos: any PhotoStorage
    let resolver: any BeachResolver
    let conditions: any BeachConditionsProvider
    /// Seeded beaches, for resolving a `beachId` to a display name in the feed/flow.
    let beaches: [Beach]
    /// Derives a post's tags (static ∪ condition-derived). Injected from `WezImplementations`
    /// so views stay off concrete types.
    let deriveTags: @Sendable ([String], BeachConditions) -> [String]

    func beachName(for id: String) -> String {
        beaches.first { $0.id == id }?.name ?? id
    }
}
