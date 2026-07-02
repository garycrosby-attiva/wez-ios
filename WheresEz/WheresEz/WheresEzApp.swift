import SwiftUI

@main
struct WheresEzApp: App {
    private let spotted = Composition.liveSpottedEnvironment()

    var body: some Scene {
        WindowGroup { MainTabView(spotted: spotted) }
    }
}
