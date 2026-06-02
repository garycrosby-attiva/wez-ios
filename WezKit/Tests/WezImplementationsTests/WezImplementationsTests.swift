import Testing
@testable import WezImplementations
import WezTestSupport

@Test func implementationsBuildsOnSpecs() {
    #expect(WezImplementations.dependsOn == "WezSpecs")
}
