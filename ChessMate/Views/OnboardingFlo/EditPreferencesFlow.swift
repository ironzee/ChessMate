//
//  EditPreferencesFlow.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import Foundation
//
//  EditPreferencesFlow.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import SwiftUI

struct EditPreferencesFlow: View {
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @State private var onboardingData = OnboardingData()
    @EnvironmentObject var authManager: AuthManager
    @State private var hasLoaded = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("Update Your Preferences")
                    .font(.title2.bold())
                    .padding(.top)
                
                NavigationLink("Play Style", destination:
                    PlayStyleView(path: $path, onboardingData: $onboardingData)
                )
                .buttonStyle(PrimaryButtonStyle())

                NavigationLink("Favorite Opening", destination:
                    OpeningMoveView(path: $path, onboardingData: $onboardingData)
                )
                .buttonStyle(PrimaryButtonStyle())

                NavigationLink("Café Style", destination:
                    CafeStyleView(path: $path, onboardingData: $onboardingData)
                )
                .buttonStyle(PrimaryButtonStyle())

                NavigationLink("Coffee Order", destination:
                    CoffeeOrderView(
                        cafeStyle: $onboardingData.cafeStyle,
                        coffeeOrder: $onboardingData.coffeeOrder,
                        onNext: {
                            path.append(AppScreen.onboardingMatchSettings)
                        }
                    )
                )
                .buttonStyle(PrimaryButtonStyle())

                NavigationLink("Match Settings", destination:
                    MatchSettingView(
                        matchSetting: $onboardingData.matchSetting,
                        bringBuddy: $onboardingData.bringBuddy,
                        onNext: {
                            path.append(AppScreen.onboardingPersona)
                        }
                    )
                )
                .buttonStyle(PrimaryButtonStyle())

                NavigationLink("Chess Persona", destination:
                    ChessPersonaView(
                        path: $path,
                        onboardingData: $onboardingData,
                        userId: authManager.currentUser?.id ?? "",
                        onComplete: {
                            submitUpdatedPreferences()
                        }
                    )
                )
                .buttonStyle(PrimaryButtonStyle())

                Spacer()

                Button("Done") {
                    submitUpdatedPreferences()
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.deepForestGreen)
                .foregroundColor(.white)
                .cornerRadius(14)
                .padding()
            }
            .padding()
            .background(Color.creamWhite)
        }
        .onAppear {
            if !hasLoaded, let user = authManager.currentUser {
                if let existingData = user.onboardingData {
                    onboardingData = existingData
                }
                hasLoaded = true
            }
        }
    }

    private func submitUpdatedPreferences() {
        guard let uid = authManager.currentUser?.id else {
            print("Missing user ID")
            return
        }

        UserManager.shared.saveOnboardingData(for: uid, data: onboardingData.toMap()) { success in
            if success {
                print("✅ Preferences updated")
            } else {
                print("❌ Failed to update preferences")
            }
        }
    }
}
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.goldenTan)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}
