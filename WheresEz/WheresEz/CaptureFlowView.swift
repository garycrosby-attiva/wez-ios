import SwiftUI
import WezSpecs

/// The four-step capture flow, presented as a focused full-screen task over the Spotted tab:
/// capture → auto-tag (GPS → seeded beach, confirm) → join-me (inert) → post.
struct CaptureFlowView: View {
    let env: SpottedEnvironment
    /// Called after a successful post so the feed can refresh; the sheet is dismissed either way.
    let onPosted: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var step: Step = .capture
    @State private var photo: Data?
    @State private var lastBeach: Beach?

    enum Step {
        case capture
        case autoTagging
        case confirm(Beach)
        case outOfRange
        case joinMe(Beach)
        case submitting
        case failed(String)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
        }
    }

    private var title: String {
        switch step {
        case .capture: "Capture"
        case .autoTagging, .confirm, .outOfRange: "Tag the beach"
        case .joinMe: "Come join me"
        case .submitting, .failed: "Post"
        }
    }

    @ViewBuilder
    private var content: some View {
        switch step {
        case .capture:
            LiveCaptureView { data in
                photo = data
                step = .autoTagging
            }

        case .autoTagging:
            ProgressView("Finding the nearest beach…")
                .task { await resolveBeach() }

        case .confirm(let beach):
            VStack(spacing: 16) {
                Image(systemName: "mappin.and.ellipse").font(.largeTitle).foregroundStyle(.tint)
                Text("Looks like you're at").foregroundStyle(.secondary)
                Text(beach.name).font(.title2.bold())
                Text(beach.region).foregroundStyle(.secondary)
                Button("That's the spot") { step = .joinMe(beach) }
                    .buttonStyle(.borderedProminent)
            }
            .padding()

        case .outOfRange:
            ContentUnavailableView {
                Label("No known beach nearby", systemImage: "location.slash")
            } description: {
                Text("We can only tag spots at beaches we know yet. Nothing was posted.")
            } actions: {
                Button("Close") { dismiss() }
            }

        case .joinMe(let beach):
            JoinMeStep(beachName: beach.name) { step = .submitting; Task { await submit(beach: beach) } }

        case .submitting:
            ProgressView("Posting…")

        case .failed(let message):
            ContentUnavailableView {
                Label("Couldn't post", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") { step = .submitting; if let b = lastBeach { Task { await submit(beach: b) } } }
                    .disabled(lastBeach == nil)
                Button("Close") { dismiss() }
            }
        }
    }

    @MainActor
    private func resolveBeach() async {
        do {
            let coordinate = try await LocationProvider().current()
            switch env.resolver.resolve(coordinate) {
            case .resolved(let beach): step = .confirm(beach)
            case .outOfRange: step = .outOfRange
            }
        } catch {
            step = .failed("Couldn't read your location. \(String(describing: error))")
        }
    }

    @MainActor
    private func submit(beach: Beach) async {
        lastBeach = beach
        guard let photo else { step = .failed("No photo captured."); return }
        do {
            let id = UUID().uuidString
            let conditions = try await env.conditions.conditions(for: beach.id)
            let tags = env.deriveTags(beach.tagsStatic, conditions)
            let post = SpottedPost(
                id: id,
                beachId: beach.id,
                photoUrl: "spotted/\(id).jpg",
                caption: nil,
                captureConditions: conditions,
                derivedTags: tags,
                // Editorial pair (Ez-the-editor). COPY PENDING the creative's voice review.
                summary: "Spotted just now.",
                author: "Ez",
                createdAt: Date()
            )
            try await env.photos.persist(id, photo: photo)
            try await env.posts.persist(post)
            onPosted()
            dismiss()
        } catch {
            step = .failed(String(describing: error))
        }
    }
}

/// Step 3 — the "come join me" proximity alert. Visually complete and interactive, but it
/// **quietly does not send**: the delivery mechanism is a later change. Presented honestly.
private struct JoinMeStep: View {
    let beachName: String
    let onPost: () -> Void
    @State private var invite = true

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.badge").font(.largeTitle).foregroundStyle(.tint)
            Toggle("Nudge people nearby to come join you at \(beachName)", isOn: $invite)
                .padding(.horizontal)
            Text("Delivery is coming in a later update — this won't send a notification yet.")
                .font(.footnote).foregroundStyle(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal)
            Button("Post to the feed", action: onPost)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
