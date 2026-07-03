import SwiftUI
import UIKit
import Combine

/// Step 1 of capture — the live-camera surface. Live-camera-only, by construction:
/// on device it is the real camera; in the simulator (no camera) it is a faithful
/// camera-framed "happening now" surface. There is NO photo-library / file picker on
/// either path — that would break the principle the feature rests on.
struct LiveCaptureView: View {
    let onCapture: (Data) -> Void

    var body: some View {
        #if targetEnvironment(simulator)
        SimulatorLiveSurface(onCapture: onCapture)
        #else
        CameraPicker(onCapture: onCapture)
            .ignoresSafeArea()
        #endif
    }
}

#if targetEnvironment(simulator)
/// Faithful stand-in for the live camera in the simulator: a framed viewfinder with a "LIVE"
/// badge and the current time, and a shutter that yields a generated "now" frame as JPEG data.
/// Not a library pick — the image is produced by the live surface at the moment of capture.
private struct SimulatorLiveSurface: View {
    let onCapture: (Data) -> Void
    @State private var now = Date()
    private let tick = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LinearGradient(colors: [.teal.opacity(0.7), .blue.opacity(0.9)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            // Viewfinder framing
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.6), lineWidth: 2)
                .padding(28)

            VStack {
                HStack(spacing: 6) {
                    Circle().fill(.red).frame(width: 10, height: 10)
                    Text("LIVE").font(.caption.bold()).foregroundStyle(.white)
                    Spacer()
                    Text(now, format: .dateTime.hour().minute().second())
                        .font(.caption.monospacedDigit()).foregroundStyle(.white)
                }
                .padding(.horizontal, 40).padding(.top, 40)

                Spacer()
                Text("Live capture — happening now")
                    .font(.subheadline).foregroundStyle(.white.opacity(0.9))
                Text("Camera unavailable in the simulator; this is a faithful stand-in.")
                    .font(.caption2).foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center).padding(.horizontal, 40)

                Button {
                    onCapture(Self.makeFrame(at: now))
                } label: {
                    Circle().strokeBorder(.white, lineWidth: 4)
                        .frame(width: 72, height: 72)
                        .overlay(Circle().fill(.white).frame(width: 58, height: 58))
                }
                .padding(.bottom, 48)
                .accessibilityLabel("Take photo")
            }
        }
        .onReceive(tick) { now = $0 }
    }

    /// Render a "now" frame to JPEG — the simulator's stand-in for a live shot.
    static func makeFrame(at date: Date) -> Data {
        let size = CGSize(width: 1080, height: 1080)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let colors = [UIColor.systemTeal.cgColor, UIColor.systemBlue.cgColor] as CFArray
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: colors, locations: [0, 1])!
            ctx.cgContext.drawLinearGradient(gradient, start: .zero,
                                             end: CGPoint(x: 0, y: size.height), options: [])
            let stamp = date.formatted(date: .abbreviated, time: .standard)
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 48),
                .foregroundColor: UIColor.white,
            ]
            ("Where's Ez — " + stamp).draw(at: CGPoint(x: 60, y: size.height - 120), withAttributes: attrs)
        }
        return image.jpegData(compressionQuality: 0.8) ?? Data()
    }
}
#else
/// Device live camera. `sourceType = .camera` only — no `.photoLibrary`, by design.
private struct CameraPicker: UIViewControllerRepresentable {
    let onCapture: (Data) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ controller: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onCapture: onCapture) }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onCapture: (Data) -> Void
        init(onCapture: @escaping (Data) -> Void) { self.onCapture = onCapture }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.8) {
                onCapture(data)
            }
        }
    }
}
#endif
