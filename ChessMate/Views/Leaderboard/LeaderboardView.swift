//
//  LeaderboardView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//
import SwiftUI
import Foundation
import SwiftUI

struct LeaderboardView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = LeaderboardViewModel()
    @EnvironmentObject var authManager: AuthManager

    @State private var selectedScope = "Local"
    @State private var selectedTime = "Overall"
    @State private var isLoading = true

    let scopes = ["Local", "Global"]
    let times = ["Overall", "Monthly", "Weekly"]

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading Leaderboard...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.espressoBrown)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Leaderboard")
                            .font(.largeTitle.bold())
                            .foregroundColor(.espressoBrown)
                            .padding(.horizontal)

                        // Scope Tabs
                        HStack(spacing: 0) {
                            ForEach(scopes, id: \.self) { scope in
                                Button(action: {
                                    selectedScope = scope
                                    fetchData()
                                }) {
                                    Text(scope)
                                        .fontWeight(.semibold)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity)
                                        .background(selectedScope == scope ? Color.espressoBrown : Color.clear)
                                        .foregroundColor(selectedScope == scope ? .creamWhite : .espressoBrown)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.espressoBrown.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)

                        // Your Ranking
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Your Ranking")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                if let rank = viewModel.currentUserRank {
                                    Text("#\(rank) in \(viewModel.currentCity)")
                                        .font(.title2.bold())
                                        .foregroundColor(.espressoBrown)
                                } else {
                                    Text("Loading...")
                                        .font(.title2.bold())
                                        .foregroundColor(.espressoBrown)
                                }
                            }
                            Spacer()
                            Image(systemName: "horse.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.goldenTan)
                        }
                        .padding()
                        .background(Color.creamWhite)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)

                        // Time Tabs
                        HStack {
                            ForEach(times, id: \.self) { time in
                                Button(action: {
                                    selectedTime = time
                                }) {
                                    Text(time)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                        .background(selectedTime == time ? Color.espressoBrown : Color.clear)
                                        .foregroundColor(selectedTime == time ? .creamWhite : .espressoBrown)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Top 3 Podium
                        HStack(spacing: 24) {
                            ForEach(Array(viewModel.topThree.enumerated()), id: \.1.uid) { index, player in
                                VStack(spacing: 6) {
                                    profileImage(urlString: player.photoURLs?.first, size: 70)
                                    Text(shortName(player.name))
                                        .font(.subheadline.bold())
                                        .foregroundColor(.espressoBrown)
                                    Text("\(player.elo) ELO")
                                        .font(.caption)
                                        .foregroundColor(.deepForestGreen)
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Rankings Title
                        HStack {
                            Text("Rankings")
                                .font(.headline)
                                .foregroundColor(.espressoBrown)
                            Spacer()
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.deepForestGreen)
                                .font(.subheadline)
                        }
                        .padding(.horizontal)

                        // Other Ranked Players
                        VStack(spacing: 16) {
                            ForEach(viewModel.otherRankings.indices, id: \.self) { i in
                                let player = viewModel.otherRankings[i]
                                HStack {
                                    Text("\(i + 4)")
                                        .foregroundColor(.espressoBrown)
                                        .frame(width: 30)

                                    profileImage(urlString: player.photoURLs?.first, size: 40)

                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(shortName(player.name))
                                                .font(.subheadline.bold())
                                                .foregroundColor(.espressoBrown)
                                            if player.onboardingData?.cafeStyle != "" {
                                                Image(systemName: "cup.and.saucer.fill")
                                                    .foregroundColor(.goldenTan)
                                            }
                                        }
                                        Text("\(player.elo) ELO")
                                            .font(.caption)
                                            .foregroundColor(.deepForestGreen)
                                    }

                                    Spacer()

                                    Text("\(player.wins + player.losses) matches")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 32)
                    }
                }
                .background(Color.creamWhite.ignoresSafeArea())
            }
        }
        .onAppear {
            viewModel.currentCity = authManager.currentUser?.location ?? "Your City"
            fetchData()
        }
    }

    private func fetchData() {
        isLoading = true
        viewModel.fetchLeaderboard(scope: selectedScope, currentUserId: authManager.currentUser?.uid ?? "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isLoading = false
        }
    }

    private func shortName(_ name: String) -> String {
        let comps = name.split(separator: " ")
        if comps.count >= 2 {
            return "\(comps[0]) \(comps[1].prefix(1))."
        }
        return name
    }

    private func profileImage(urlString: String?, size: CGFloat) -> some View {
        Group {
            if let urlString = urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { img in
                    img.resizable()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.2))
                }
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .background(Circle().fill(Color.lightCoffeeGray))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
