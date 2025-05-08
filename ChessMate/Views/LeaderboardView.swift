//
//  LeaderboardView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

struct LeaderboardView: View {
    @Binding var path: NavigationPath
    @State private var selectedScope = "Local"
    @State private var selectedTime = "Overall"

    let scopes = ["Local", "Global"]
    let times = ["Overall", "Monthly", "Weekly"]

    var body: some View {
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

                // Your Ranking Card
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Ranking")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("#42 in Seattle")
                            .font(.title2.bold())
                            .foregroundColor(.espressoBrown)
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
                    ForEach(times, id: \.self ) { time in
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
                    ForEach(top3Mock, id: \.name) { player in
                        VStack(spacing: 6) {
                            Image(player.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .overlay(
                                    player.rank == 1 ? AnyView(Image(systemName: "crown.fill")
                                        .foregroundColor(.goldenTan)
                                        .offset(y: -40)) : AnyView(EmptyView())
                                )

                            Text(player.name)
                                .font(.subheadline.bold())
                                .foregroundColor(.espressoBrown)

                            Text("\(player.elo) ELO")
                                .font(.caption)
                                .foregroundColor(.deepForestGreen)
                        }
                    }
                }
                .padding(.horizontal)

                // Full Rankings
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

                VStack(spacing: 16) {
                    ForEach(otherPlayersMock) { player in
                        HStack {
                            Text("\(player.rank)")
                                .foregroundColor(.espressoBrown)
                                .frame(width: 30)

                            Image(player.imageName)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                HStack {
                                    Text(player.name)
                                        .font(.subheadline.bold())
                                        .foregroundColor(.espressoBrown)
                                    if player.favoriteCafe {
                                        Image(systemName: "cup.and.saucer.fill")
                                            .foregroundColor(.goldenTan)
                                    }
                                }
                                Text("\(player.elo) ELO")
                                    .font(.caption)
                                    .foregroundColor(.deepForestGreen)
                            }

                            Spacer()

                            Text("\(player.matchCount) matches")
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



let top3Mock: [LeaderboardPlayer] = [
    .init(rank: 2, name: "Sarah K.", elo: 2240, imageName: "person1", matchCount: 0, favoriteCafe: true),
    .init(rank: 1, name: "Michael R.", elo: 2456, imageName: "person2", matchCount: 0, favoriteCafe: false),
    .init(rank: 3, name: "Alex M.", elo: 2198, imageName: "person3", matchCount: 0, favoriteCafe: true)
]

let otherPlayersMock: [LeaderboardPlayer] = [
    .init(rank: 4, name: "David L.", elo: 2187, imageName: "person4", matchCount: 48, favoriteCafe: true),
    .init(rank: 5, name: "Emma W.", elo: 2165, imageName: "person5", matchCount: 36, favoriteCafe: false),
    .init(rank: 6, name: "James H.", elo: 2134, imageName: "person6", matchCount: 52, favoriteCafe: true)
]
