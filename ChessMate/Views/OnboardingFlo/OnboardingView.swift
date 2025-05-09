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
        VStack {
            ProgressView(value: Double(step), total: Double(totalSteps))
                .accentColor(.deepForestGreen)
                .padding()

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
                        userId: userId
                    )
                default:
                    EmptyView()
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
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
            errorMessage = "Unable to find user ID"
            return
        }

        isSaving = true
        errorMessage = nil

        UserManager.shared.saveOnboardingData(for: uid, data: onboardingData.toMap()) { success in
            isSaving = false
            if success {
                Firestore.firestore().collection("users").document(uid).updateData([
                    "hasCompletedOnboarding": true
                ]) { error in
                    if let error = error {
                        errorMessage = "Error finishing onboarding: \(error.localizedDescription)"
                    } else {
                        path = NavigationPath()
                        path.append(AppScreen.home)
                    }
                }
            } else {
                errorMessage = "Failed to save onboarding data. Please try again."
            }
        }
    }
}
#Preview {
    OnboardingView(
        path: .constant(NavigationPath()),
        userId: "test_user_123",
        authManager: mockAuthManager
    )
}
private let mockAuthManager: AuthManager = {
    let manager = AuthManager()
    manager.currentUser = UserModel(
        uid: "test_user_123",
        name: "Test User",
        email: "test@example.com",
        location: "NYC",
        elo: 1200,
        wins: 0,
        losses: 0,
        createdAt: Date(),
        photoURLs: []
    )
    return manager
}()
