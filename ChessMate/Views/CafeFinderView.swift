//
//  CafeFinderView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

//
//  CafeFinderView.swift
//  ChessMate
//

import SwiftUI
import MapKit

// MARK: - Location + Search Managers

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }
}

class CafeFinder: ObservableObject {
    @Published var cafes: [Cafe] = []

    func searchCafes(near coordinate: CLLocationCoordinate2D) {
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
                self.cafes = items.prefix(10).compactMap { item in
                    guard let location = item.placemark.location else { return nil }
                    let distance = location.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
                    return Cafe(
                        name: item.name ?? "Café",
                        coordinate: item.placemark.coordinate,
                        distance: distance / 1609.34
                    )
                }
            }
        }
    }
}

// MARK: - Model

struct Cafe: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let distance: Double
}

// MARK: - Main View

struct CafeFinderView: View {
    @Binding var path: NavigationPath
    @State private var selectedView = "Map"
    @StateObject private var locationManager = LocationManager()
    @StateObject private var finder = CafeFinder()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selectedView) {
                Text("Map").tag("Map")
                Text("List").tag("List")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            if selectedView == "Map" {
                Map(coordinateRegion: $region, annotationItems: finder.cafes) { cafe in
                    MapMarker(coordinate: cafe.coordinate, tint: .goldenTan)
                }
                .frame(height: 400)
                .cornerRadius(12)
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(finder.cafes) { cafe in
                            CafeCard(cafe: cafe)
                                .onTapGesture {
                                    let placemark = MKPlacemark(coordinate: cafe.coordinate)
                                    let mapItem = MKMapItem(placemark: placemark)
                                    mapItem.name = cafe.name
                                    mapItem.openInMaps(launchOptions: nil)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationTitle("Find a Café")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let userLoc = locationManager.userLocation {
                region.center = userLoc
                finder.searchCafes(near: userLoc)
            }
        }
    }
}

// MARK: - Cafe Card

//struct CafeCard: View {
//    let cafe: Cafe
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.goldenTan)
//                .frame(height: 140)
//                .overlay(
//                    Text(cafe.name)
//                        .font(.headline)
//                        .foregroundColor(.espressoBrown)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                )
//
//            Text(String(format: "%.1f mi away", cafe.distance))
//                .font(.caption)
//                .foregroundColor(.espressoBrown)
//        }
//        .background(Color.lightCoffeeGray)
//        .cornerRadius(12)
//    }
//}

#Preview {
    CafeFinderView(path: .constant(NavigationPath()))
}
