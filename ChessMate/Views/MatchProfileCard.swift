//
//  MatchProfileCard.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//

import Foundation
import SwiftUI

struct MatchProfileCard: View {
    let player: PlayerModel
    let currentUserId: String
    @Binding var path: NavigationPath
    let onSkip: () -> Void
    let onMatch: () -> Void

    @State private var photoIndex = 0

    var body: some View {
        VStack(spacing: 0) {
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

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(player.name), \(player.age ?? 0)")
                        .font(.title2.bold())
                    Spacer()
                    Text(String(format: "%.1f", player.distance) + " miles away")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Label("\(player.elo) ELO", systemImage: "crown.fill")
                Label("Favorite Opening: \(player.favoriteOpening)", systemImage: "crown")
                Label("Style: \(player.playstyle)", systemImage: "wand.and.stars")
                Label("Time Control: \(player.timeControl)", systemImage: "clock")
                Label("Café: \(player.favoriteCafe)", systemImage: "cup.and.saucer")
                Label("Order: \(player.coffeeOrder)", systemImage: "takeoutbag.and.cup.and.straw")

                if let bio = player.bio {
                    Text("“\(bio)”")
                        .font(.footnote)
                        .padding(.top, 4)
                }
            }
            .foregroundColor(.espressoBrown)
            .padding()

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
            .padding(.top)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding(.vertical)
    }
}
