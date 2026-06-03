import SwiftUI

/// The application shell: the navigable four-tab frame the whole product lives inside.
/// Mounted at the app's composition root (`WheresEzApp`).
///
/// Per-tab navigation: each tab owns its own `NavigationStack`, so navigation state is
/// independent per tab and switching tabs preserves each tab's place.
///
/// Chrome-by-presentation: tab-bar visibility follows *how* a screen is presented, not a
/// central route list. Pushed destinations hide the bar with `.toolbar(.hidden, for: .tabBar)`
/// (see `ShellDemoDetail`); modal tasks would cover it; a root-level gate (e.g. onboarding)
/// would sit *outside* this view. There is deliberately NO central "hide-the-nav" route
/// registry — adding a screen later carries its own chrome by construction.
struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "sun.max") }

            NavigationStack { SpottedView() }
                .tabItem { Label("Spotted", systemImage: "camera") }

            NavigationStack { SavedView() }
                .tabItem { Label("Saved", systemImage: "bookmark") }

            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    MainTabView()
}
