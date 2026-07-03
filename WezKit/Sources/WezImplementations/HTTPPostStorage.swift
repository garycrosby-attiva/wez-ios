import Foundation
import WezSpecs

public enum HTTPStorageError: Error, Equatable, Sendable {
    /// The backend returned a non-2xx status for an operation.
    case unexpectedStatus(Int)
}

/// Concrete `PostStorage` over the local dev Worker (AD-WEZ-post-metadata-store v2, D1).
/// `persist` POSTs the post JSON to `/posts`; `recent()` GETs `/feed` (server-applied
/// newest-first `LIMIT 50`). Dates are ISO8601 on the wire, matching the Worker.
public struct HTTPPostStorage: PostStorage {
    private let baseURL: URL
    private let session: URLSession

    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    private static func makeEncoder() -> JSONEncoder {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }

    private static func makeDecoder() -> JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    public func persist(_ post: SpottedPost) async throws {
        try post.validate()
        var request = URLRequest(url: baseURL.appendingPathComponent("posts"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = try Self.makeEncoder().encode(post)
        let (_, response) = try await session.data(for: request)
        try Self.check(response)
    }

    public func recent() async throws -> [SpottedPost] {
        let (data, response) = try await session.data(from: baseURL.appendingPathComponent("feed"))
        try Self.check(response)
        return try Self.makeDecoder().decode([SpottedPost].self, from: data)
    }

    private static func check(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200..<300).contains(http.statusCode) else {
            throw HTTPStorageError.unexpectedStatus(http.statusCode)
        }
    }
}
