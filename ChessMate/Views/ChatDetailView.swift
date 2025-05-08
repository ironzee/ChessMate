//
//  ChatDetailView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatDetailView: View {
    @StateObject var viewModel: ChatDetailViewModel
    let requestSender = MatchRequestSender()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("person1")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.otherUserName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(viewModel.otherUserELO) ELO • \(viewModel.otherUserResponseTime)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }


                Spacer()

                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.espressoBrown)

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, currentUserId: viewModel.currentUserId)
                                .padding(.horizontal)
                                .id(message.id)
                        }
                    }
                    .padding(.top, 16)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(last, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // Input Bar
            HStack(spacing: 12) {
                TextField("Type a message...", text: $viewModel.newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    requestSender.sendRequest(
                        from: viewModel.currentUserId,
                        to: viewModel.otherUserId,
                        chatId: viewModel.chatId,
                        cafeName: "The Chess & Bean Café",
                        suggestedTime: Date().addingTimeInterval(3600) // 1 hour from now
                    ) { success in
                        if success {
                            print("✅ Request sent from chat!")
                        }
                    }
                }) {
                    Text("Challenge to a Match")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.goldenTan)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
                .padding(.top, 8)

                Button(action: {
                    // Optionally allow image sending later
                }) {
                    Image(systemName: "camera")
                        .font(.title2)
                        .foregroundColor(.deepForestGreen)
                }

                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.deepForestGreen)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .onAppear {
            print("🔁 Loading chat with ID: \(viewModel.chatId)")
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let currentUserId: String

    var isCurrentUser: Bool {
        message.senderId == currentUserId
    }

    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading) {
            if !isCurrentUser {
                Text(message.senderName)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Text(message.text)
                .padding()
                .background(isCurrentUser ? Color.goldenTan : Color.lightCoffeeGray)
                .foregroundColor(.black)
                .cornerRadius(16)

            Text(timeFormatted(message.timestamp))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
        .padding(.horizontal)
    }

    func timeFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
