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
    @StateObject private var leaderboardVM = HomeLeaderboardViewModel()
    
    var body: some View {
        let currentUser = authManager.currentUser

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                            .font(.title3)
                            .foregroundColor(.espressoBrown)
                            .padding(2)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())

                    Button(action: {
                        path.append(AppScreen.chatList)
                    }) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.title3)
                            .foregroundColor(.espressoBrown)
                            .padding(2)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .frame(width: 36, height: 36)
                    .contentShape(Rectangle())

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
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Circle())
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
                    Button(action: {
                        path.append(AppScreen.botGame)
                    }) {
                        Text("Play vs Bot 🤖")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.deepForestGreen)
                            .foregroundColor(.creamWhite)
                            .cornerRadius(18)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
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
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(12)
                                .frame(width: 160)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)


                // Active Matches Header
                HStack {
                    Text("Active Matches")
                        .font(.title3.bold())
                        .foregroundColor(.espressoBrown)
                    Spacer()
                    Button {
                        path.append(AppScreen.matchRequests)
                    } label: {
                        HStack(spacing: 4) {
                            Text("See All")
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .padding(.horizontal)

                if matchRequestVM.confirmedMatches.isEmpty {
                    Text("No active matches yet")
                        .foregroundColor(.espressoBrown.opacity(0.5))
                        .padding(.horizontal)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(matchRequestVM.confirmedMatches.enumerated().map { ($0.offset, $0.element) }, id: \.0) { _, request in
                            if let currentUser = authManager.currentUser,
                               let opponent = matchRequestVM.getOpponent(from: request, currentUserId: currentUser.uid) {
                                MatchCard(request: request, currentUser: currentUser, opponent: opponent) { gameId in
                                    path.append(AppScreen.game(gameId))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Cafés Header
                HStack {
                    Text("Chess-Friendly Cafés")
                        .font(.title3.bold())
                        .foregroundColor(.espressoBrown)
                    Spacer()
                    Button {
                        path.append(AppScreen.cafeFinder)
                    } label: {
                        HStack(spacing: 4) {
                            Text("See All")
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .padding(.horizontal)

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
                            .font(.title3.bold())
                            .foregroundColor(.espressoBrown)
                            .padding(.horizontal)
                    }

                    VStack(spacing: 12) {
                        ForEach(Array(leaderboardVM.topThree.enumerated()), id: \.1.uid) { index, player in
                            LeaderboardRow(rank: index + 1, name: player.name, elo: player.elo)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .scrollIndicators(.hidden)
        .padding(.top, 70)
        .background(
            LinearGradient(colors: [Color.creamWhite, Color.goldenTan.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            authManager.refreshCurrentUser()
            matchmakingVM.fetchPlayers(excludeUID: authManager.currentUser?.uid ?? "")
            if let userId = authManager.currentUser?.uid {
                matchRequestVM.startListening(for: userId)
            }
            if let location = authManager.currentUser?.location {
                leaderboardVM.fetchLocalTopPlayers(location: location)
            }
            if let loc = locationManager.userLocation {
                cafeFinder.searchCafes(near: loc)
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
    var currentUser: UserModel
    var opponent: UserModel
    var onResumeGame: (String) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Player VS Layout
            HStack(spacing: 12) {
                profileImage(from: currentUser.photoURLs?.first)

                Text("vs")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)

                profileImage(from: opponent.photoURLs?.first)
            }
            .font(.headline)

            // Café Name
            Text(request.cafeName)
                .font(.subheadline)
                .foregroundColor(.espressoBrown)

            // Suggested Match Time
            Text(formatDate(from: request.suggestedTime))
                .font(.caption)
                .foregroundColor(.espressoBrown.opacity(0.6))

            // Status
            Text(request.status.capitalized)
                .font(.caption2)
                .padding(6)
                .background(request.status.lowercased() == "confirmed" ? Color.deepForestGreen : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)

            if let gameId = request.gameId, !gameId.isEmpty {
                Button("Resume Game") {
                    onResumeGame(gameId)
                }
                .font(.caption.bold())
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(Color.deepForestGreen)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .frame(width: 220)
        .background(.ultraThinMaterial)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    // MARK: - Helper
    @ViewBuilder
    func profileImage(from urlString: String?) -> some View {
        if let urlString = urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                Circle().fill(Color.gray.opacity(0.2))
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.lightCoffeeGray))
                .clipShape(Circle())
        }
    }

    // MARK: - Format Date
    func formatDate(from timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d • h:mm a"
        return formatter.string(from: timestamp)
    }
}

// MARK: - CafeCardView
struct CafeCardView: View {
    let cafe: Cafe
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("cafe1")
                .resizable()
                .scaledToFill()
                .frame(width: 240, height: 140)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(cafe.name)
                .font(.headline)
                .foregroundColor(.espressoBrown)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .truncationMode(.tail)
                .frame(height: 42, alignment: .topLeading)

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
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        .onTapGesture {
            onTap()
        }
        .frame(width: 240)
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

