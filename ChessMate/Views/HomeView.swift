//
//  HomeView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//
//  HomeView.swift
//  ChessMate
//

//
//  HomeView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool
    var authManager: AuthManager

    @StateObject private var locationManager = LocationManager()
    @StateObject private var cafeFinder = CafeFinder()
    @StateObject private var matchRequestVM = MatchRequestViewModel() // ✅ Inject match request VM

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
                        ForEach(matchRequestVM.confirmedMatches) { request in
                            MatchCardView(request: request)
                        }
                    }
                    .padding(.horizontal)
                }

                Text("Chess-Friendly Cafés")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(cafeFinder.cafes) { cafe in
                        CafeCardView(cafe: cafe) {
                            path.append(AppScreen.cafeFinderWithCafe(cafe))
                        }
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
            if let userId = authManager.currentUser?.uid {
                matchRequestVM.startListening(for: userId)
            }
            if let location = locationManager.userLocation {
                cafeFinder.searchCafes(near: location)
            }
        }
        .onReceive(locationManager.$userLocation) { newLocation in
            guard let location = newLocation else { return }
            cafeFinder.searchCafes(near: location)
        }
    }

    // ✅ Format time from timestamp
    func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
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

struct CafeCardView: View {
    let cafe: Cafe
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("cafe_placeholder") // Replace with real image if you have café images
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(10)

            Text(cafe.name)
                .font(.headline)
                .foregroundColor(.espressoBrown)

            Text("\(Int.random(in: 6...20)) players") // Mock player count
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(String(format: "%.1f mi", cafe.distance))
                .font(.caption)
                .foregroundColor(.espressoBrown.opacity(0.6))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .onTapGesture {
            onTap()
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
