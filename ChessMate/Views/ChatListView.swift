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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Messages")
                    .font(.largeTitle.bold())
                    .foregroundColor(.espressoBrown)

                Spacer()

                Button(action: {
                    // Optional: Compose new message
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.espressoBrown)
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            .padding(.top)

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
                            HStack(spacing: 16) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(.goldenTan)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(chat.otherUserName)
                                        .font(.subheadline.bold())
                                        .foregroundColor(.espressoBrown)

                                    Text(chat.lastMessage ?? "No messages yet")
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
                            .background(Color.lightCoffeeGray)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .onAppear {
            viewModel.fetchChats(for: currentUserId)
        }
    }

    func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
