import SwiftUI
import WezImplementations   // the ONLY app file that knows the concrete probe

@main
struct WheresEzApp: App {
    // Local Worker: cd backend && npm run dev → http://localhost:8787
    // The simulator shares the Mac's network stack, so localhost reaches the host.
    private let probe = HTTPBackendProbe(baseURL: URL(string: "http://localhost:8787")!)

    var body: some Scene {
        WindowGroup { PingView(probe: probe) }
    }
}
