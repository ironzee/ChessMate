//
//  MatchmakingView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

//
//  MatchmakingView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//
import SwiftUI
import FirebaseFirestore

struct MatchmakingView: View {
    @Binding var path: NavigationPath
    let user: UserModel
    @StateObject private var viewModel = MatchmakingViewModel()
    @State private var currentIndex = 0

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
                        path.append(AppScreen.chat(ChatModel(
                            id: [user.id, viewModel.players[currentIndex].id].sorted().joined(separator: "_"),
                            userAId: user.id,
                            userBId: viewModel.players[currentIndex].id,
                            lastMessage: nil,
                            timestamp: Date()
                        )))
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
    }
}
