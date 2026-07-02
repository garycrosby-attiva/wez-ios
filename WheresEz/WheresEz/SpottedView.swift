import SwiftUI
import WezSpecs

/// Spotted tab root — the area's editorial feed: posts read back from the backend,
/// newest-first (the backend caps at 50). Single-author (Ez-the-editor) in Ez's register;
/// not a generic photo grid. Capture is launched from here as a focused modal task.
struct SpottedView: View {
    let env: SpottedEnvironment

    @State private var loadState: LoadState = .loading
    @State private var capturing = false

    enum LoadState {
        case loading
        case loaded([SpottedPost])
        case failed(String)
    }

    var body: some View {
        Group {
            switch loadState {
            case .loading:
                ProgressView()
            case .loaded(let posts) where posts.isEmpty:
                ContentUnavailableView {
                    Label("Nothing spotted yet", systemImage: "camera")
                } description: {
                    Text("Be the first — capture what your beach is like right now.")
                } actions: {
                    Button("Capture") { capturing = true }
                        .buttonStyle(.borderedProminent)
                }
            case .loaded(let posts):
                List(posts) { post in
                    SpottedRow(post: post, env: env)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listStyle(.plain)
            case .failed(let message):
                ContentUnavailableView {
                    Label("Can't reach the feed", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button("Try again") { Task { await load() } }
                }
            }
        }
        .navigationTitle("Spotted")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { capturing = true } label: { Image(systemName: "camera") }
                    .accessibilityLabel("New capture")
            }
        }
        .navigationDestination(for: TryThisSpot.self) { _ in ComingSoonView() }
        .fullScreenCover(isPresented: $capturing) {
            CaptureFlowView(env: env) { Task { await load() } }
        }
        .task { await load() }
        .refreshable { await load() }
    }

    private func load() async {
        loadState = .loading
        do {
            loadState = .loaded(try await env.posts.recent())
        } catch {
            loadState = .failed(String(describing: error))
        }
    }
}

/// Navigation value for the "Try this spot" affordance.
struct TryThisSpot: Hashable { let beachId: String }

private struct SpottedRow: View {
    let post: SpottedPost
    let env: SpottedEnvironment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: env.photos.url(for: post.id)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Rectangle().fill(.quaternary)
                }
            }
            .frame(height: 220)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .clipped()

            HStack {
                Text(env.beachName(for: post.beachId)).font(.headline)
                Spacer()
                NavigationLink(value: TryThisSpot(beachId: post.beachId)) {
                    Label("Try this spot", systemImage: "arrow.turn.up.right").font(.subheadline)
                }
            }

            if let summary = post.summary {
                Text(summary).font(.body)
            }
            Text("Spotted by \(post.author ?? "Ez")")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

/// Honest "coming soon" placeholder behind "Try this spot" — there is no real beach-detail
/// screen in this change. Hides the tab bar per the shell's chrome-by-presentation rule.
private struct ComingSoonView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Beach detail coming soon", systemImage: "hourglass")
        } description: {
            Text("Soon this will open the beach so you can see if it's worth the trip.")
        }
        .navigationTitle("Try this spot")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
