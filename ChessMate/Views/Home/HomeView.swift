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
    @StateObject private var matchRequestVM = MatchRequestViewModel()
    @StateObject private var matchmakingVM = MatchmakingViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack(spacing: 16) {
                    Label("ChessMate", systemImage: "crown.fill")
                        .font(.title2.bold())
                        .foregroundColor(.espressoBrown)

                    Spacer()

                    Button(action: {
                        path.append(AppScreen.notificationCenter)
                    }) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.espressoBrown)
                            .padding(10)
                            .background(.ultraThinMaterial)
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
                                    .scaledToFit()
                            }
                            .frame(width: 40, height: 40)
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

                // Hero Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Checkmate or Soulmate?")
                        .font(.title2.bold())
                        .foregroundColor(.espressoBrown)

                    Text("Coffee, conversation, and clever moves awaits…")
                        .foregroundColor(.espressoBrown.opacity(0.4))

                    Button(action: {
                        path.append(AppScreen.matchmaking)
                    }) {
                        Text("Start Matching ❤️")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.espressoBrown)
                            .foregroundColor(.creamWhite)
                            .cornerRadius(18)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(24)
                .shadow(radius: 6)
                .padding(.horizontal)

                // MARK: - Match Now Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Match Now!")
                        .font(.title3.bold())
                        .foregroundColor(.espressoBrown)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(matchmakingVM.players) { player in
                                ZStack(alignment: .topTrailing) {
                                    VStack(spacing: 10) {
                                        AsyncImage(url: URL(string: player.photoURLs.first ?? "")) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Color.gray.opacity(0.2)
                                        }
                                        .frame(width: 130, height: 140)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .shadow(radius: 6)

                                        VStack(spacing: 4) {
                                            Text(player.name)
                                                .font(.headline)
                                                .foregroundColor(.espressoBrown)

                                            Text("\(player.elo) ELO")
                                                .font(.caption)
                                                .foregroundColor(.gray)

                                            Button(action: {
                                                // Trigger match logic
                                            }) {
                                                Text("Match")
                                                    .font(.subheadline.bold())
                                                    .padding(.vertical, 6)
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color.deepForestGreen.opacity(0.8))
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.top, 4)
                                        .padding(.horizontal)
                                    }
                                    .padding(.top)
                                    .frame(width: 160)
                                    .background(.ultraThinMaterial).opacity(0.9)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)

                                    // Small glass badge circle (like status dot)
                                    Circle()
                                        .fill(Color.goldenTan.opacity(0.9))
                                        .frame(width: 12, height: 12)
                                        .padding(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }                
                .shadow(radius: 6)


                // Matches
                Button(action: {
                    path.append(AppScreen.matchRequests)
                }, label: {
                    Text("Active Matches")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)
                        .padding(.horizontal)                })
               

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(matchRequestVM.confirmedMatches) { request in
                            MatchCard(request: request)
                        }
                    }
                    .padding(.horizontal)
                }

                // Cafés
                Button(action: {
                    path.append(AppScreen.cafeFinder)
                }) {
                    Text("Chess-Friendly Cafés")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)
                        .padding(.horizontal)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(cafeFinder.cafes) { cafe in
                            CafeCardView(cafe: cafe) {
                                path.append(AppScreen.cafeFinderWithCafe(cafe))
                            }
                            .frame(width: 240)
                        }
                    }
                    .padding(.horizontal)
                }

                // Leaderboard
                VStack(alignment: .leading, spacing: 12) {
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
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear {
            authManager.refreshCurrentUser()
            matchmakingVM.fetchPlayers(excludeUID: authManager.currentUser?.uid ?? "")
            // ...
        }
        .padding(.top, 70)
        .background(
            LinearGradient(colors: [Color.creamWhite, Color.goldenTan.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
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
}

// MARK: - MatchCard
struct MatchCard: View {
    var request: MatchRequestModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.fill")
                Text("vs")
                Image(systemName: "person.fill")
            }
            .font(.headline)

            Text(request.cafeName)
                .font(.subheadline)
                .foregroundColor(.espressoBrown)

            Text(formatDate(from: request.suggestedTime))
                .font(.caption)
                .foregroundColor(.espressoBrown.opacity(0.6))

            Text(request.status.capitalized)
                .font(.caption2)
                .padding(6)
                .background(request.status.lowercased() == "confirmed" ? Color.deepForestGreen : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .frame(width: 220)
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .shadow(radius: 4)
    }

    func formatDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

}

// MARK: - CafeCardView
struct CafeCardView: View {
    let cafe: Cafe
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("cafe1") // Replace if dynamic
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)

            Text(cafe.name)
                .font(.headline)
                .foregroundColor(.espressoBrown)

            Text("\(Int.random(in: 6...20)) players")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(String(format: "%.1f mi", cafe.distance))
                .font(.caption)
                .foregroundColor(.espressoBrown.opacity(0.6))
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .shadow(radius: 4)
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - LeaderboardRow
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
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
