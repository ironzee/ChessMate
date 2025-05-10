//
//  OnboardingView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import SwiftUI
import FirebaseFirestore

struct OnboardingView: View {
    @Binding var path: NavigationPath
    var userId: String
    var authManager: AuthManager

    @State private var onboardingData = OnboardingData()
    @State private var step = 0
    @State private var isSaving = false
    @State private var errorMessage: String?

    private let totalSteps = 6

    var body: some View {
        VStack(spacing: 16) {
            ProgressView(value: Double(step), total: Double(totalSteps))
                .accentColor(.deepForestGreen)
                .padding(.horizontal)

            Group {
                switch step {
                case 0:
                    PlayStyleView(path: $path, onboardingData: $onboardingData)
                case 1:
                    OpeningMoveView(path: $path, onboardingData: $onboardingData)
                case 2:
                    CafeStyleView(path: $path, onboardingData: $onboardingData)
                case 3:
                    CoffeeOrderView(
                        cafeStyle: $onboardingData.cafeStyle,
                        coffeeOrder: $onboardingData.coffeeOrder
                    ) {
                        step += 1
                    }
                case 4:
                    MatchSettingView(
                        matchSetting: $onboardingData.matchSetting,
                        bringBuddy: $onboardingData.bringBuddy
                    ) {
                        step += 1
                    }
                case 5:
                    ChessPersonaView(
                        path: $path,
                        onboardingData: $onboardingData,
                        userId: userId,
                        onComplete: submitData
                    )
                default:
                    EmptyView()
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            if isSaving {
                ProgressView("Saving your preferences...")
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.creamWhite.ignoresSafeArea())
    }

    private func submitData() {
        guard let uid = authManager.currentUser?.id else {
            return
        }

        UserManager.shared.saveOnboardingData(for: uid, data: onboardingData.toMap()) { success in
            if success {
                Firestore.firestore().collection("users").document(uid).updateData([
                    "hasCompletedOnboarding": true
                ])
                self.path = NavigationPath()
                self.path.append(AppScreen.home)
            } else {
                print("❌ Failed to save onboarding data.")
            }
        }
    }

}
