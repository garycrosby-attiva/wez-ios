import Foundation

/// Persists Spotted posts and reads the recent feed (AD-WEZ-post-metadata-store v2, D1).
///
/// `recent()` returns newest-first; the feed query is `ORDER BY createdAt DESC` with a hard
/// `LIMIT` applied by the concrete adapter (working assumption 50, sized at implementation).
/// The two-method shape transfers directly from the web substrate's `PostStorage`.
public protocol PostStorage: Sendable {
    func persist(_ post: SpottedPost) async throws
    func recent() async throws -> [SpottedPost]
}

/// Stores and serves Spotted photos (AD-WEZ-photo-storage v2, Cloudflare R2).
///
/// The R2 presigned-direct-upload mechanics are the concrete adapter's concern; the contract
/// stays storage-shaped. Reads serve over HTTP by URL — a deliberate divergence from the web
/// substrate's byte-returning `bytesFor`, because native loads images by URL (e.g. `AsyncImage`).
public protocol PhotoStorage: Sendable {
    func persist(_ postId: String, photo: Data) async throws
    func url(for postId: String) -> URL
}
