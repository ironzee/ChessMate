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
            // Top Bar
            HStack(spacing: 12) {
                if let urlString = viewModel.otherUserProfilePic,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Circle().fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(viewModel.otherUserName.prefix(1))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        )
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(viewModel.otherUserELO) ELO")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Usually responds in \(viewModel.otherUserResponseTime)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
            }
            .padding()
            .background(.ultraThinMaterial)
            .background(BlurView(style: .systemUltraThinMaterialDark))
            .shadow(radius: 1)

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, currentUserId: viewModel.currentUserId)
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

            // Input + Match Button
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $viewModel.newMessage)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    Button(action: {
                        // Optional: image sending
                    }) {
                        Image(systemName: "camera")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.deepForestGreen)
                            .clipShape(Circle())
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

                Button(action: {
                    requestSender.sendRequest(
                        from: viewModel.currentUserId,
                        senderName: viewModel.currentUserName,
                        to: viewModel.otherUserId,
                        chatId: viewModel.chatId,
                        cafeName: "The Chess & Bean Café",
                        suggestedTime: Date().addingTimeInterval(3600)
                    ) { success in
                        if success {
                            print("✅ Match request sent from chat!")
                        }
                    }
                }) {
                    Text("Challenge to a Match")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.goldenTan)
                        .cornerRadius(16)
                }
            }
            .padding()
            .background(Color.creamWhite.opacity(0.5))
        }
        .background(
            LinearGradient(colors: [Color.espressoBrown, Color.black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .onAppear {
            print("🔁 Loading chat with ID: \(viewModel.chatId)")
        }
    }
}

// MARK: - Message Bubble

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

// MARK: - BlurView Helper

import UIKit

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
