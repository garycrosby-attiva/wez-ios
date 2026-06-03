import SwiftUI

/// DISPOSABLE SCRATCH — establishes and demonstrates the chrome-by-presentation rule
/// (application-shell spec): an in-tab pushed destination hides the tab bar with
/// `.toolbar(.hidden, for: .tabBar)` and the bar reappears on pop. It exists so the
/// behaviour is verifiable now, before any tab has real pushed content. Delete this view
/// and its `NavigationLink` in `HomeView` when the first real detail destination lands;
/// copy the `.toolbar(.hidden, for: .tabBar)` line onto that real destination.
struct ShellDemoDetail: View {
    var body: some View {
        ContentUnavailableView {
            Label("Pushed detail", systemImage: "arrow.up.forward.square")
        } description: {
            Text("The tab bar is hidden while this pushed screen is on top, and comes back when you go back.")
        }
        .navigationTitle("Detail")
        .toolbar(.hidden, for: .tabBar)   // chrome-by-presentation: pushed → hide the bar
    }
}

#Preview {
    NavigationStack { ShellDemoDetail() }
}
