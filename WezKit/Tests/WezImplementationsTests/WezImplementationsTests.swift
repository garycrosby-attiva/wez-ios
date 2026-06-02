import Testing
import Foundation
@testable import WezImplementations
import WezSpecs

@Test func pingRoundTripReturnsOk() async throws {
    let probe = HTTPBackendProbe(baseURL: URL(string: "http://localhost:8787")!)
    let response = try await probe.ping()
    #expect(response.service == "wez-backend")
    #expect(response.status == "ok")
    #expect(!response.time.isEmpty)
}
