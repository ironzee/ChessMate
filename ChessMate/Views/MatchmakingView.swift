//
//  MatchmakingView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

//
import SwiftUI
import FirebaseFirestore

struct MatchmakingView: View {
    @Binding var path: NavigationPath
    let user: UserModel
    @StateObject private var viewModel = MatchmakingViewModel()
    @State private var currentIndex = 0

    @State private var showMatchSuccess = false
    @State private var matchedUser: PlayerModel? = nil
    private let likeService = LikeService()

    var body: some View {
        VStack {
            if currentIndex < viewModel.players.count {
                MatchProfileCard(
                    player: viewModel.players[currentIndex],
                    currentUserId: user.id,
                    path: $path,
                    onSkip: {
                        currentIndex += 1
                    },
                    onMatch: {
                        let likedUser = viewModel.players[currentIndex]
                        likeService.sendLike(from: user.id, to: likedUser.id) { isMutual in
                            if isMutual {
                                matchedUser = likedUser
                                showMatchSuccess = true
                            } else {
                                currentIndex += 1
                            }
                        }
                    }
                )
            } else {
                Text("🎉 You’ve seen all players nearby.")
                    .padding()
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.creamWhite)
        .navigationTitle("Find Players")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchPlayers(excludeUID: user.id)
        }
        .fullScreenCover(item: $matchedUser) { user in
            MatchSuccessView(
                currentUser: self.user,
                matchedUser: user,
                onStartChat: {
                    let chatId = [self.user.id, user.id].sorted().joined(separator: "_")
                    path.append(AppScreen.chat(ChatModel(
                        id: chatId,
                        userAId: self.user.id,
                        userBId: user.id,
                        lastMessage: nil,
                        timestamp: Date()
                    )))
                    matchedUser = nil
                },
                onDismiss: {
                    matchedUser = nil
                    currentIndex += 1
                }
            )
        }

    }
}

