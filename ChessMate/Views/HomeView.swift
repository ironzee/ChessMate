//
//  HomeView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//
//  HomeView.swift
//  ChessMate
//

import SwiftUI
//import FirebaseFirestore
import MapKit

struct HomeView: View {
    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool
    var authManager: AuthManager

    @StateObject private var locationManager = LocationManager()
    @StateObject private var cafeFinder = CafeFinder()

    var body: some View {
        ScrollView {
            Spacer()
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Label("ChessMate", systemImage: "crown.fill")
                        .font(.title2.bold())
                        .foregroundColor(.espressoBrown)

                    Spacer()
                    
                    Button(action: {
                        path.append(AppScreen.matchRequests)
                                   }) {
                                       Image(systemName: "bell.fill")
                                           .foregroundColor(.espressoBrown)
                                           .padding(10)
                                           .background(Color.goldenTan.opacity(0.3))
                                           .clipShape(Circle())
                                   }
                    Button(action: {
                        path.append(AppScreen.notificationCenter)
                                   }) {
                                       Image(systemName: "bell.fill")
                                           .foregroundColor(.espressoBrown)
                                           .padding(10)
                                           .background(Color.goldenTan.opacity(0.3))
                                           .clipShape(Circle())
                                   }
                               
                    Button(action: {
                               path.append(AppScreen.chatList)
                           }) {
                               Image(systemName: "bubble.left.and.bubble.right.fill")
                                   .font(.title2)
                                   .foregroundColor(.espressoBrown)
                           }
                    
                       
                    Button(action: {
                        path.append(AppScreen.settings)
                    }) {
                        if let urlString = authManager.currentUser?.photoURLs?.first,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.gray)
                        }

                    }


                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Ready to play?")
                        .font(.title2.bold())
                        .foregroundColor(.espressoBrown)

                    Text("Find chess partners at nearby cafés")
                        .foregroundColor(.espressoBrown.opacity(0.4))

                    Button(action: {
                        path.append(AppScreen.matchmaking)
                    }) {
                        Text("Find a Match")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.espressoBrown)
                            .foregroundColor(.creamWhite)
                            .cornerRadius(14)
                    }
                }
                .padding()
                .background(Color.goldenTan.opacity(0.4))
                .cornerRadius(20)
                .padding(.horizontal)

                Text("Active Matches")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        MatchCard(opponent: "The Chess House", time: "Today, 3:00 PM", status: "Confirmed")
                        MatchCard(opponent: "Coffee & Tomes", time: "Tomorrow, 1:00 PM", status: "Pending")
                    }
                    .padding(.horizontal)
                }

                Text("Chess-Friendly Cafés")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(cafeFinder.cafes) { cafe in
                        CafeCard(cafe: cafe)
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Button(action: {
                        path.append(AppScreen.leaderboard)
                    }) {
                        Text("Local Leaderboard")
                            .font(.headline)
                            .foregroundColor(.espressoBrown)
                    }

                    VStack(spacing: 12) {
                        LeaderboardRow(rank: 1, name: "Sarah K.", elo: 1850)
                        LeaderboardRow(rank: 2, name: "Michael R.", elo: 1780)
                        LeaderboardRow(rank: 3, name: "David L.", elo: 1720)
                    }
                    .padding()
                    .background(Color.lightCoffeeGray)
                    .cornerRadius(12)
                }

                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 70)
        .background(Color.creamWhite)
        .ignoresSafeArea()
        .onAppear {
            authManager.refreshCurrentUser()
            
            if let location = locationManager.userLocation {
                cafeFinder.searchCafes(near: location)
            }
        }

        .onReceive(locationManager.$userLocation) { newLocation in
            guard let location = newLocation else { return }
            cafeFinder.searchCafes(near: location)
        }
    }
}

struct MatchCard: View {
    var opponent: String
    var time: String
    var status: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                Text("vs")
                Image(systemName: "person.crop.circle")
            }
            .font(.title2)

            Label(opponent, systemImage: "mappin.and.ellipse")
            Label(time, systemImage: "clock")

            Text(status)
                .font(.caption)
                .padding(6)
                .background(status == "Confirmed" ? Color.deepForestGreen : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .frame(width: 200)
        .background(Color.creamWhite)
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

struct CafeCard: View {
    let cafe: Cafe       // ✅ NEW
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color.goldenTan)
                .frame(height: 100)
                .cornerRadius(10)
                .overlay(
                    Text(cafe.name)
                        .font(.subheadline.bold())
                        .padding(8)
                        .foregroundColor(.espressoBrown), alignment: .bottomLeading
                )

            Text(" players")
                .font(.caption)
                .foregroundColor(.espressoBrown)

            Text("\(String(format: "%.1f", cafe.distance)) mi")
                .font(.caption2)
                .foregroundColor(.espressoBrown.opacity(0.6))
        }
        .onTapGesture {
            let placemark = MKPlacemark(coordinate: cafe.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = cafe.name
            mapItem.openInMaps(launchOptions: nil)
        }
    }
}



struct LeaderboardRow: View {
    var rank: Int
    var name: String
    var elo: Int

    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(rank == 1 ? Color.green : (rank == 2 ? Color.gray : Color.brown))
                .frame(width: 28, height: 28)
                .overlay(
                    Text("\(rank)")
                        .foregroundColor(.white)
                        .font(.caption)
                        .bold()
                )

            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.espressoBrown)

            Spacer()

            Text("\(elo) ELO")
                .font(.subheadline)
                .foregroundColor(.espressoBrown)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.lightCoffeeGray.opacity(0.4))
        .cornerRadius(12)
    }
}
