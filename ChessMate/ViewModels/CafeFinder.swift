//
//  CafeFinder.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
//
//  CafeFinder.swift
//  ChessMate
//

import Foundation
import MapKit

class CafeFinder: ObservableObject {
    @Published var cafes: [Cafe] = []
    @Published var onlyShowOpenLike = false

    private var searchDebounceTimer: Timer?
    private var lastSearchLocation: CLLocationCoordinate2D?

    func searchCafes(near coordinate: CLLocationCoordinate2D) {
        // 👣 Skip search if user hasn't moved much
        if let last = lastSearchLocation {
            let moved = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                .distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
            if moved < 100 { return } // ⛔ Ignore small movement (<100m)
        }

        lastSearchLocation = coordinate
        searchDebounceTimer?.invalidate()

        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { [weak self] _ in
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "Cafe"
            request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)

            MKLocalSearch(request: request).start { response, error in
                if let error = error {
                    print("❌ MKLocalSearch error: \(error.localizedDescription)")
                    return
                }

                guard let items = response?.mapItems else {
                    print("⚠️ No map items found.")
                    return
                }

                DispatchQueue.main.async {
                    var results = items.compactMap { item -> Cafe? in
                        guard let location = item.placemark.location else { return nil }
                        let distance = location.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        let hasMetadata = item.phoneNumber != nil || item.url != nil
                        return Cafe(
                            name: item.name ?? "Café",
                            coordinate: item.placemark.coordinate,
                            distance: distance / 1609.34,
                            hasMetadata: hasMetadata
                        )
                    }

                    if self?.onlyShowOpenLike == true {
                        results = results.filter { $0.hasMetadata }
                    }

                    self?.cafes = results.sorted { $0.distance < $1.distance }.prefix(10).map { $0 }
                }
            }
        }
    }
}

struct Cafe: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let distance: Double
    let hasMetadata: Bool
}
