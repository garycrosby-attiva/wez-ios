import SwiftUI

/// Spotted tab root. Capture-and-feed (live-camera-only) is out of scope for this
/// change (application-shell spec). For now this is a real, navigable empty state
/// inside its own NavigationStack, showing no live data.
struct SpottedView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Spotted", systemImage: "camera")
        } description: {
            Text("What people are spotting right now will show up here.")
        }
        .navigationTitle("Spotted")
    }
}

#Preview {
    NavigationStack { SpottedView() }
}
