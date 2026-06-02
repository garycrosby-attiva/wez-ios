import Foundation
import WezSpecs

public struct HTTPBackendProbe: BackendProbe {
    private let baseURL: URL
    private let session: URLSession

    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func ping() async throws -> PingResponse {
        let url = baseURL.appendingPathComponent("ping")
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(PingResponse.self, from: data)
    }
}
