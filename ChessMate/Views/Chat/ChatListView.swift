//
//  ChatListView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//
//
//  ChatListView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import SwiftUI

struct ChatListView: View {
    @Binding var path: NavigationPath
    let currentUserId: String

    @StateObject private var viewModel = ChatListViewModel()
    @StateObject private var matchViewModel = MatchesViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    path.removeLast()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.espressoBrown)
                }

                Spacer()

                Text("Messages")
                    .font(.title.bold())
                    .foregroundColor(.espressoBrown)

                Spacer()

                Button(action: {
                    // Optional: compose
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.espressoBrown)
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)

            // 🔁 Dynamic Recent Matches
            if !matchViewModel.matches.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(matchViewModel.matches) { match in
                            VStack(spacing: 4) {
                                if let url = match.profilePicURL, let imageURL = URL(string: url) {
                                    AsyncImage(url: imageURL) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Circle().fill(Color.gray.opacity(0.2))
                                    }
                                    .frame(width: 56, height: 56)
                                    .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 56, height: 56)
                                        .overlay(Text(match.name.prefix(1)).foregroundColor(.white))
                                }

                                Text(match.name)
                                    .font(.caption)
                                    .foregroundColor(.espressoBrown)
                            }
                            .onTapGesture {
                                // open chat
                                path.append(AppScreen.chat(ChatModel(
                                    id: match.chatId,
                                    userAId: currentUserId,
                                    userBId: match.userId,
                                    lastMessage: nil,
                                    timestamp: nil
                                )))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                }
            }

            // 🔥 Chat List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.chats) { chat in
                        Button {
                            path.append(AppScreen.chat(ChatModel(
                                id: chat.id,
                                userAId: currentUserId,
                                userBId: chat.otherUserId,
                                lastMessage: chat.lastMessage,
                                timestamp: chat.timestamp
                            )))
                        } label: {
                            HStack(spacing: 12) {
                                if let url = chat.profilePicURL, let imageURL = URL(string: url) {
                                    AsyncImage(url: imageURL) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Circle().fill(Color.gray.opacity(0.2))
                                    }
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 48, height: 48)
                                        .overlay(Text(chat.otherUserName.prefix(1)).foregroundColor(.white))
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(chat.otherUserName)
                                        .font(.subheadline.bold())
                                        .foregroundColor(.espressoBrown)

                                    Text(chat.lastMessage ?? "You matched! Start chatting.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }

                                Spacer()

                                if let timestamp = chat.timestamp {
                                    Text(timeAgoString(from: timestamp))
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .onAppear {
            viewModel.fetchChats(for: currentUserId)
            matchViewModel.fetchMatches(for: currentUserId)
        }
        .navigationBarBackButtonHidden(true)
    }

    func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
