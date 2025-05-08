//
//  SettingsView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool // ✅ Add this
    @ObservedObject var authManager: AuthManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    HStack {
                        Button(action: {
                            path.removeLast() // Go back
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.espressoBrown)
                        }
                        Spacer()
                        Text("Settings")
                            .font(.title2.bold())
                            .foregroundColor(.espressoBrown)
                        Spacer()
                        Spacer()
                    }

                    HStack(spacing: 16) {
                        if let photoURL = authManager.currentUser?.photoURLs?.first,
                           let url = URL(string: photoURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.lightCoffeeGray)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(authManager.currentUser?.name ?? "Michael Chen")
                                .font(.headline)
                                .foregroundColor(.espressoBrown)

                            HStack {
                                Text("ELO 1850")
                                    .font(.subheadline)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.lightCoffeeGray)
                                    .cornerRadius(10)

                                Text("Master")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }

                        Spacer()

                        Button("Edit Photos") {
                            path.append(AppScreen.profilePhotos)
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.deepForestGreen)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.creamWhite)

                SettingsSection(title: "ACCOUNT SETTINGS", items: [
                    ("person.fill", "Profile Information"),
                    ("chessboard", "Chess Preferences"),
                    ("clock.arrow.circlepath", "Match History"),
                    ("trophy.fill", "Achievements & Badges"),
                    ("cup.and.saucer.fill", "Favorite Cafés")
                ])

                SettingsSection(title: "PRIVACY & SECURITY", items: [
                    ("lock.fill", "Privacy Settings"),
                    ("bell.fill", "Notification Preferences"),
                    ("location", "Location Services"),
                    ("key.fill", "Account Security")
                ])

                SettingsSection(title: "APP SETTINGS", items: [
                    ("globe", "Language"),
                    ("moon.fill", "Dark Mode"),
                    ("speaker.wave.2.fill", "Sound Effects"),
                    ("info.circle.fill", "App Version")
                ])

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("ChessMate Premium")
                            .font(.headline)
                            .foregroundColor(.espressoBrown)
                        Text("Unlock exclusive features")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)

                    Button("Upgrade to Premium") {
                        // Premium action
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.goldenTan)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .padding()
                .background(Color.creamWhite)
                .cornerRadius(12)
                .padding(.horizontal)

                Button("Log Out") {
                    
                    authManager.logout()
                    isLoggedIn = false

                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.deepForestGreen)
                .foregroundColor(.white)
                .cornerRadius(16)
                .padding(.horizontal)

                Button("Delete Account") {
                    // Future delete action
                }
                .foregroundColor(.red)
                .padding(.bottom)
            }
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)

    }
}

struct SettingsSection: View {
    var title: String
    var items: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.footnote.bold())
                .foregroundColor(.gray)
                .padding(.horizontal)

            ForEach(0..<items.count, id: \.self) { index in
                let item = items[index]
                HStack {
                    Image(systemName: item.0)
                        .foregroundColor(.espressoBrown)
                    Text(item.1)
                        .foregroundColor(.espressoBrown)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                Divider()
            }

        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
