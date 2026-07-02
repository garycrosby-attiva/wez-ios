import Foundation
import WezSpecs

/// Computes a post's `derivedTags` at capture submit: the union of the beach's static tags and
/// a small set of condition-derived tags. Order-stable and de-duplicated; static tags first.
///
/// These are tags for filtering/framing, not a weather readout — see `SeededBeachConditionsProvider`.
public enum DerivedTags {
    public static func compute(staticTags: [String], conditions: BeachConditions) -> [String] {
        var conditionTags: [String] = []
        if conditions.windSpeedKnots < 10 { conditionTags.append("Sheltered") }
        if conditions.cloudCoverPercent < 30 { conditionTags.append("Sunny") }
        if conditions.rainProbabilityPercent < 20 { conditionTags.append("Dry") }

        var seen = Set<String>()
        return (staticTags + conditionTags).filter { seen.insert($0).inserted }
    }
}
