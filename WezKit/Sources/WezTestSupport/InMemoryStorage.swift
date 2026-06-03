import Foundation
import WezSpecs

/// In-memory `PostStorage` double. An actor so mutable state is `Sendable`-safe under Swift 6
/// strict concurrency. Enforces the same `validate()` invariant a real adapter would on persist.
public actor InMemoryPostStorage: PostStorage {
    private var posts: [SpottedPost] = []

    public init() {}

    public func persist(_ post: SpottedPost) async throws {
        try post.validate()
        posts.append(post)
    }

    public func recent() async throws -> [SpottedPost] {
        posts.sorted { $0.createdAt > $1.createdAt }
    }
}

/// In-memory `PhotoStorage` double. Stores bytes by post id; `url(for:)` returns a stub URL.
public actor InMemoryPhotoStorage: PhotoStorage {
    private var blobs: [String: Data] = [:]

    public init() {}

    public func persist(_ postId: String, photo: Data) async throws {
        blobs[postId] = photo
    }

    /// `nonisolated` to satisfy the synchronous protocol requirement — constructs a URL purely
    /// from `postId`, touching no actor-isolated state.
    public nonisolated func url(for postId: String) -> URL {
        URL(string: "memory://photos/spotted/\(postId).jpg")!
    }

    /// Test helper (not part of the `PhotoStorage` contract): read persisted bytes back.
    public func bytes(for postId: String) -> Data? {
        blobs[postId]
    }
}
