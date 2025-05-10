//
//  ContentView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//
//  Created by Zulfiqur on 4/26/25.
//

//
//  ContentView.swift
//  ChessMate


import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var path = NavigationPath()
    @StateObject var authManager = AuthManager()
    @State private var isLoggedIn = false
    @StateObject private var locationManager = LocationManager()
    @State private var onboardingData = OnboardingData()

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if isLoggedIn && authManager.userProfileLoaded {
                    if let user = authManager.currentUser {
                        if user.hasCompletedOnboarding == true {
                            HomeView(path: $path, isLoggedIn: $isLoggedIn, authManager: authManager)
                        } else {
                            OnboardingView(path: $path, userId: user.id, authManager: authManager)
                        }
                    } else {
                        Text("⚠️ No user found")
                    }
                } else {
                    WelcomeView(path: $path, isLoggedIn: $isLoggedIn, authManager: authManager)
                }
            }
            .id(isLoggedIn)
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .onboarding:
                    if let user = authManager.currentUser {
                        OnboardingView(path: $path, userId: user.id, authManager: authManager)
                    } else {
                        Text("⚠️ No user found for onboarding")
                    }

                case .home:
                    HomeView(path: $path, isLoggedIn: $isLoggedIn, authManager: authManager)

                case .matchmaking:
                    if let user = authManager.currentUser {
                        MatchmakingView(path: $path, user: user)
                    } else {
                        Text("⚠️ User not loaded")
                    }

                case .chatDetail(let chat):
                    if let user = authManager.currentUser {
                        ChatDetailView(viewModel: ChatDetailViewModel(
                            chatId: chat.id ?? "unknown_chat_id",
                            currentUserId: user.id,
                            currentUserName: user.name,
                            otherUserId: chat.userAId == user.id ? chat.userBId : chat.userAId
                        ))
                    } else {
                        Text("⚠️ User not loaded")
                    }

                case .submitResult:
                    SubmitResultView(path: $path)

                case .matchRequests:
                    if let user = authManager.currentUser {
                        MatchRequestsView(currentUserId: user.id)
                    } else {
                        Text("⚠️ User not loaded")
                    }

                case .settings:
                    SettingsView(path: $path, isLoggedIn: $isLoggedIn, authManager: authManager)

                case .profile:
                    ProfileView(path: $path)

                case .leaderboard:
                    LeaderboardView(path: $path)

                case .cafeFinder:
                    CafeFinderView(path: $path, locationManager: locationManager)

                case .matchHistory:
                    MatchHistoryView(path: $path)

                case .notificationCenter:
                    NotificationCenterView(path: $path, currentUserId: authManager.currentUser?.id ?? "")

                case .tournamentDiscovery:
                    TournamentDiscoveryView(path: $path)

                case .cafeFinderWithCafe(let cafe):
                    CafeFinderView(path: $path, locationManager: locationManager, selectedCafe: cafe)

                case .chatList:
                    if let user = authManager.currentUser {
                        ChatListView(path: $path, currentUserId: user.id)
                    } else {
                        Text("⚠️ No logged-in user")
                    }

                case .ghostMode:
                    GhostModeView(path: $path)

                case .login:
                    LoginView(path: $path, isLoggedIn: $isLoggedIn, authManager: authManager)

                case .signup:
                    SignUpView(path: $path, isLoggedIn: $isLoggedIn, authManager: authManager)

                case .chat(let chat):
                    if let user = authManager.currentUser {
                        ChatDetailView(viewModel: ChatDetailViewModel(
                            chatId: chat.id ?? "unknown_chat_id",
                            currentUserId: user.id,
                            currentUserName: user.name,
                            otherUserId: chat.userAId == user.id ? chat.userBId : chat.userAId
                        ))
                    } else {
                        Text("⚠️ User not loaded")
                    }

                case .profilePhotos:
                    ProfilePhotosView(path: $path)

                case .editPhotosTemp(let tempData):
                    EditPhotosView(tempData: tempData, authManager: authManager, isLoggedIn: $isLoggedIn, path: $path)

                // ✅ Onboarding Steps
                case .onboardingPlayStyle:
                    PlayStyleView(path: $path, onboardingData: $onboardingData)

                case .onboardingOpeningMove:
                    OpeningMoveView(path: $path, onboardingData: $onboardingData)

                case .onboardingCafeStyle:
                    CafeStyleView(path: $path, onboardingData: $onboardingData)

                case .onboardingCoffeeOrder:
                    CoffeeOrderView(
                        cafeStyle: $onboardingData.cafeStyle,
                        coffeeOrder: $onboardingData.coffeeOrder,
                        onNext: {
                            path.append(AppScreen.onboardingMatchSettings)
                        })

                case .onboardingMatchSettings:
                    MatchSettingView(
                        matchSetting: $onboardingData.matchSetting,
                        bringBuddy: $onboardingData.bringBuddy,
                        onNext: {
                            path.append(AppScreen.onboardingPersona)
                        })

                case .onboardingPersona:
                    ChessPersonaView(
                        path: $path,
                        onboardingData: $onboardingData,
                        userId: authManager.currentUser?.id ?? "",
                        onComplete: submitData
                    )

                }
            }
        }
        .onReceive(authManager.$isSignedIn) { signedIn in
            if signedIn && authManager.userProfileLoaded {
                self.isLoggedIn = true
                self.path = NavigationPath()
            } else {
                self.isLoggedIn = false
                self.path = NavigationPath()
            }
        }
    }
    private func submitData() {
        guard let uid = authManager.currentUser?.id else {
            print("Missing user ID")
            return
        }

        UserManager.shared.saveOnboardingData(for: uid, data: onboardingData.toMap()) { success in
            if success {
                Firestore.firestore().collection("users").document(uid).updateData([
                    "hasCompletedOnboarding": true
                ]) { error in
                    if let error = error {
                        print("❌ Firestore update error: \(error.localizedDescription)")
                    } else {
                        path = NavigationPath()
                        path.append(AppScreen.home)
                    }
                }
            } else {
                print("❌ Failed to save onboarding data.")
            }
        }
    }

}
