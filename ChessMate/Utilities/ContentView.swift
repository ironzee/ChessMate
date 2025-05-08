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
//
//  Created by Zulfiqur on 4/26/25.
//
import Foundation
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var path = NavigationPath()
    @StateObject var authManager = AuthManager()
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if isLoggedIn && authManager.userProfileLoaded {
                    HomeView(path: $path, isLoggedIn: $isLoggedIn, authManager: authManager)
                } else {
                    WelcomeView(path: $path, isLoggedIn: $isLoggedIn, authManager: authManager)
                }
            }
            .id(isLoggedIn) // 🔁 force re-evaluation when auth state changes
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .onboarding:
                    OnboardingView(path: $path)

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
                            currentUserName: user.name ?? "Anonymous",
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
                    CafeFinderView(path: $path)

                case .matchHistory:
                    MatchHistoryView(path: $path)

                case .notificationCenter:
                    NotificationCenterView(path: $path)

                case .tournamentDiscovery:
                    TournamentDiscoveryView(path: $path)

                case .cafeDetails:
                    CafeDetailsView(path: $path)

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
                            currentUserName: user.name ?? "Anonymous",
                            otherUserId: chat.userAId == user.id ? chat.userBId : chat.userAId
                        ))
                    } else {
                        Text("⚠️ User not loaded")
                    }

                case .profilePhotos:
                    ProfilePhotosView(path: $path)

                case .editPhotosTemp(let tempData):
                    EditPhotosView(tempData: tempData, authManager: authManager, isLoggedIn: $isLoggedIn, path: $path)


                }
            }
        }
        .onReceive(authManager.$isSignedIn) { signedIn in
            if signedIn && authManager.userProfileLoaded {
                self.isLoggedIn = true
                self.path = NavigationPath() // ✅ Reset on login
            } else {
                self.isLoggedIn = false
                self.path = NavigationPath() // ✅ Reset on logout too
            }
        }
    }
}
