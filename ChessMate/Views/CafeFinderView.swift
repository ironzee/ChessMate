//
//  CafeFinderView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//



import SwiftUI
import MapKit

struct CafeFinderView: View {
    @Binding var path: NavigationPath
    @State private var selectedView = "Map"
    @StateObject private var finder = CafeFinder()
    @State private var region = MKCoordinateRegion()
    @ObservedObject var locationManager: LocationManager

    var selectedCafe: Cafe? = nil

    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selectedView) {
                Text("Map").tag("Map")
                Text("List").tag("List")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .padding(.horizontal)

            Toggle("Only show cafés likely open", isOn: $finder.onlyShowOpenLike)
                .padding(.horizontal)
                .onChange(of: finder.onlyShowOpenLike) {
                    if let userLoc = locationManager.userLocation {
                        finder.searchCafes(near: userLoc)
                    }
                }

            if selectedView == "Map" {
                Map(coordinateRegion: $region, annotationItems: finder.cafes) { cafe in
                    MapAnnotation(coordinate: cafe.coordinate) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.title)
                            .padding(10)
                            .background(Color.goldenTan)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
                .frame(height: 500)
                .cornerRadius(20)
                .padding()
                .shadow(radius: 4)
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
        .onReceive(locationManager.$userLocation.compactMap { $0 }) { loc in
            let current = region.center
            let isNotSet = current.latitude == 0 && current.longitude == 0
            let isNewLocation = CLLocation(latitude: current.latitude, longitude: current.longitude)
                .distance(from: CLLocation(latitude: loc.latitude, longitude: loc.longitude)) > 100

            if isNotSet || isNewLocation {
                region = MKCoordinateRegion(
                    center: loc,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }

            finder.searchCafes(near: loc)
        }
    }
}

import SwiftUI

struct CafeCard: View {
    let cafe: Cafe
    var onTap: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: "cup.and.saucer.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.espressoBrown)
                )
                .shadow(radius: 3)

            VStack(alignment: .leading, spacing: 4) {
                Text(cafe.name)
                    .font(.headline)
                    .foregroundColor(.espressoBrown)

                Text(String(format: "%.1f miles away", cafe.distance))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .shadow(radius: 4)
        .onTapGesture {
            onTap?()
        }
    }
}
