import SwiftUI

/// Profile tab root. The eventual shape is the user's own feed plus their future
/// spots (Pinterest-style, no separate favourites tab) — but none of that exists
/// yet, so this is an honest placeholder. The app never fakes a capability it does
/// not have.
///
/// COPY PENDING the creative's voice review before shipping (design.md open question).
struct ProfileView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Your profile", systemImage: "person.crop.circle")
        } description: {
            Text("Your feed and your future spots will live here.")
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack { ProfileView() }
}
