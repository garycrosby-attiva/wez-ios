import SwiftUI
import WezSpecs

// DISPOSABLE SCRATCH — Lap 1 vertical slice. Proves the *running app* (not just
// `swift test` on the Mac host) reaches the local Worker. Delete when the Phase D
// navigable shell arrives. Depends on the WezSpecs.BackendProbe *contract*, never
// the concrete HTTPBackendProbe — the App composition root injects the impl.
struct PingView: View {
    let probe: any BackendProbe

    enum Phase {
        case idle, loading
        case success(PingResponse)
        case failure(String)
    }

    @State private var phase: Phase = .idle

    var body: some View {
        VStack(spacing: 16) {
            Text("Backend round-trip").font(.headline)

            switch phase {
            case .idle:
                Text("Tap to ping the Worker.").foregroundStyle(.secondary)
            case .loading:
                ProgressView()
            case .success(let r):
                VStack(spacing: 4) {
                    Text("✅ \(r.service) — \(r.status)")
                    Text(r.time)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
            case .failure(let msg):
                Text("❌ \(msg)")
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Button("Ping /ping") { Task { await runPing() } }
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .task { await runPing() }   // also fire once on appear
    }

    private func runPing() async {
        phase = .loading
        do { phase = .success(try await probe.ping()) }
        catch { phase = .failure(String(describing: error)) }
    }
}
