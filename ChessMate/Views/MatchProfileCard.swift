//
//  MatchProfileCard.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//
import SwiftUI
import Foundation
struct MatchProfileCard: View {
    let player: PlayerModel
    let currentUserId: String
    @Binding var path: NavigationPath
    let onSkip: () -> Void
    let onMatch: () -> Void

    @State private var photoIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            // Profile photos
            TabView(selection: $photoIndex) {
                ForEach(Array(player.photoURLs.enumerated()), id: \.offset) { index, url in
                    AsyncImage(url: URL(string: url)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.2))
                    }
                    .frame(height: 340)
                    .clipped()
                    .cornerRadius(20)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 340)

            profileDetails
            actionButtons

            Divider().padding(.horizontal)

            Button(action: {
                print("View full profile tapped")
            }) {
                Text("View Full Profile")
                    .font(.subheadline)
                    .foregroundColor(.deepForestGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding(.vertical)
    }

    private var profileDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(player.name), \(player.elo) ELO")
                    .font(.title2.bold())
                Spacer()
                Text(String(format: "%.1f", player.distance) + " miles away")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Label("Opening: \(player.favoriteOpening)", systemImage: "chessboard")
            Label("Style: \(player.playstyle)", systemImage: "wand.and.stars")
            Label("Time Control: \(player.timeControl)", systemImage: "clock")
            Label("Café: \(player.favoriteCafe)", systemImage: "cup.and.saucer")
            Label("Order: \(player.coffeeOrder)", systemImage: "takeoutbag.and.cup.and.straw")

            if let bio = player.bio, !bio.isEmpty {
                Text("“\(bio)”")
                    .font(.footnote)
                    .padding(.top, 4)
            }

            // Optional: badge or flair
            Text("🔥 Hot Match Nearby")
                .font(.caption)
                .foregroundColor(.red)
                .padding(6)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                .padding(.top, 4)
        }
        .foregroundColor(.espressoBrown)
        .padding()
    }

    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button(action: {
                photoIndex = 0
                onSkip()
            }) {
                Label("Skip", systemImage: "xmark")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.deepForestGreen)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button(action: {
                onMatch()
            }) {
                Label("Match", systemImage: "heart.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.espressoBrown)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
