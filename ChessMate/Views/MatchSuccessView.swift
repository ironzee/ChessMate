//
//  MatchSuccessView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/9/25.
//


import SwiftUI

struct MatchSuccessView: View {
    let currentUser: UserModel
    let matchedUser: PlayerModel
    let onStartChat: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Background hero image
            if let urlString = matchedUser.photoURLs.first,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .overlay(Color.black.opacity(0.25)) // slight dark overlay
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .ignoresSafeArea()
            } else {
                Color.creamWhite.ignoresSafeArea()
            }

            VStack(spacing: 24) {
                Spacer()

                // Overlapping profile bubbles
                HStack(spacing: -20) {
                    if let currentURL = currentUser.photoURLs?.first {
                        ProfileBubble(imageURL: currentURL)
                    }
                    if let matchURL = matchedUser.photoURLs.first {
                        ProfileBubble(imageURL: matchURL)
                    }
                }

                // Match message
                VStack(spacing: 6) {
                    Text("It's a Match!")
                        .font(.largeTitle.bold())
                        .foregroundColor(.goldenTan)

                    Text("You and \(matchedUser.name) share a passion for chess!")
                        .font(.subheadline)
                        .foregroundColor(.creamWhite)
                }

                // Buttons
                VStack(spacing: 12) {
                    Button(action: onStartChat) {
                        Text("Start Chat")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.espressoBrown)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }

                    Button(action: onDismiss) {
                        Text("Keep Browsing")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.deepForestGreen)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}

struct ProfileBubble: View {
    var imageURL: String?

    var body: some View {
        ZStack {
            if let url = URL(string: imageURL ?? "") {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.2))
                }
            } else {
                Circle().fill(Color.gray.opacity(0.2))
            }

            // Optional chess icon overlay
            Image("FRAME03")
                .foregroundColor(.goldenTan)
                .padding(1)
                .clipShape(Circle())
                .offset(x: 20, y: 20)
                .frame(width: 10, height: 10)
             
        }
        .frame(width: 100, height: 100)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.creamWhite, lineWidth: 4)
        )
    }
}
