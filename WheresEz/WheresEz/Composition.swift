import Foundation
import WezImplementations   // composition root: the one place that knows the concretes

/// Builds the live `SpottedEnvironment` from concrete `WezImplementations` adapters wired to the
/// local dev backend. Local Worker: `cd backend && npm run dev` → http://localhost:8787 (the
/// simulator shares the Mac's network stack, so localhost reaches the host).
enum Composition {
    static func liveSpottedEnvironment(
        baseURL: URL = URL(string: "http://localhost:8787")!
    ) -> SpottedEnvironment {
        SpottedEnvironment(
            posts: HTTPPostStorage(baseURL: baseURL),
            photos: HTTPPhotoStorage(baseURL: baseURL),
            resolver: SeededBeachResolver(),
            conditions: SeededBeachConditionsProvider(),
            beaches: SeededData.beaches,
            deriveTags: { DerivedTags.compute(staticTags: $0, conditions: $1) }
        )
    }
}
