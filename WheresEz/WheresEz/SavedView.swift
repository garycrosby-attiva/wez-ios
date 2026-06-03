import SwiftUI

/// Saved tab root. Save-and-recall is out of scope for this change (see
/// application-shell spec) — this is an honest placeholder, not a stub of a
/// real feature. The app never fakes a capability it does not have.
///
/// COPY PENDING the creative's voice review before shipping (design.md open question).
struct SavedView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Nothing saved yet", systemImage: "bookmark")
        } description: {
            Text("Soon you'll be able to keep the spots you want to come back to.")
        }
        .navigationTitle("Saved")
    }
}

#Preview {
    NavigationStack { SavedView() }
}
