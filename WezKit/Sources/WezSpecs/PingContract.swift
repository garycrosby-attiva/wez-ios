import Foundation

// The shape of the /ping response. Codable so it decodes straight from JSON.
public struct PingResponse: Codable, Equatable, Sendable {
    public let service: String
    public let status: String
    public let time: String

    public init(service: String, status: String, time: String) {
        self.service = service
        self.status = status
        self.time = time
    }
}

// The contract a backend client must satisfy. WezImplementations provides
// the concrete version; tests can provide a fake. Async because the network is.
public protocol BackendProbe: Sendable {
    func ping() async throws -> PingResponse
}
