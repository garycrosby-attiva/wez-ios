import Foundation
import CoreLocation
import WezSpecs

/// One-shot current-coordinate read via CoreLocation. Uses the classic
/// `requestLocation()` + delegate path, which reliably delivers the simulator's
/// `simctl location set` coordinate. Prompts for when-in-use authorization on first use.
/// A timeout surfaces an honest error rather than hanging if no location is available.
@MainActor
final class LocationProvider: NSObject, CLLocationManagerDelegate {
    enum LocationError: Error, Equatable { case denied, unavailable, timedOut }

    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<Coordinate, Error>?

    override init() {
        super.init()
        manager.delegate = self
    }

    func current(timeout: Duration = .seconds(10)) async throws -> Coordinate {
        switch manager.authorizationStatus {
        case .denied, .restricted: throw LocationError.denied
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: break
        }

        return try await withThrowingTaskGroup(of: Coordinate.self) { group in
            group.addTask { @MainActor in
                try await withCheckedThrowingContinuation { cont in
                    self.continuation = cont
                    switch self.manager.authorizationStatus {
                    case .authorizedWhenInUse, .authorizedAlways:
                        self.manager.requestLocation()
                    default:
                        break   // wait for locationManagerDidChangeAuthorization to request
                    }
                }
            }
            group.addTask {
                try await Task.sleep(for: timeout)
                throw LocationError.timedOut
            }
            let result = try await group.next()!
            group.cancelAll()
            return result
        }
    }

    private func resume(_ result: Result<Coordinate, Error>) {
        guard let cont = continuation else { return }
        continuation = nil
        cont.resume(with: result)
    }

    // MARK: CLLocationManagerDelegate

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        let coordinate = Coordinate(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        Task { @MainActor in self.resume(.success(coordinate)) }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in self.resume(.failure(LocationError.unavailable)) }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            switch status {
            case .authorizedWhenInUse, .authorizedAlways: self.manager.requestLocation()
            case .denied, .restricted: self.resume(.failure(LocationError.denied))
            default: break
            }
        }
    }
}
