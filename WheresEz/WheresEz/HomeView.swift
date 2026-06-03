import SwiftUI

/// Home tab root. The day's recommendation and the friend-voice surface will live
/// here — but that feature content is out of scope for this change (application-shell
/// spec). For now this is a real, navigable empty state inside its own NavigationStack,
/// showing no live data.
struct HomeView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Home", systemImage: "sun.max")
        } description: {
            Text("Today's beach pick will show up here.")
        } actions: {
            // DISPOSABLE SCRATCH — demonstrates the chrome-by-presentation push (see
            // ShellDemoDetail). Remove with ShellDemoDetail when Home gets real content.
            NavigationLink("See a pushed detail") { ShellDemoDetail() }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack { HomeView() }
}
