import Foundation
import WezSpecs

/// Concrete `PhotoStorage` over the local dev Worker (AD-WEZ-photo-storage v2, R2).
/// `persist` uploads the bytes to `/photos/{postId}` (the Worker proxies to R2 at
/// `spotted/{postId}.jpg`); `url(for:)` returns the Worker GET URL that serves them — native
/// loads images by URL (e.g. `AsyncImage`), so a URL-shaped read is the right seam here.
public struct HTTPPhotoStorage: PhotoStorage {
    private let baseURL: URL
    private let session: URLSession

    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func persist(_ postId: String, photo: Data) async throws {
        var request = URLRequest(url: url(for: postId))
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "content-type")
        request.httpBody = photo
        let (_, response) = try await session.data(for: request)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw HTTPStorageError.unexpectedStatus(http.statusCode)
        }
    }

    public func url(for postId: String) -> URL {
        baseURL.appendingPathComponent("photos").appendingPathComponent(postId)
    }
}
