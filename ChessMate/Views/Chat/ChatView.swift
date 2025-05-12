////
////  ChatView.swift
////  ChessMate
////
////  Created by Zulfiqur on 4/26/25.
////
////
////  
//import SwiftUI
//import FirebaseAuth
//struct ChatView: View {
//    @Binding var path: NavigationPath
//    let chat: ChatModel 
//    @State private var messageText = ""
//    @State private var messages: [Message] = []
//    let currentUserId = Auth.auth().currentUser?.uid ?? ""
//    @StateObject private var viewModel: ChatDetailViewModel
//
//    init(path: Binding<NavigationPath>, chat: ChatModel) {
//        self._path = path
//        self.chat = chat
//
//        // Now it's safe to access chat.id
//        _viewModel = StateObject(wrappedValue: ChatDetailViewModel(
//            chatId: chat.id ?? "unknown_chat_id",
//            currentUserId: Auth.auth().currentUser?.uid ?? "",
//            currentUserName: Auth.auth().currentUser?.displayName ?? "Anonymous"
//        ))
//    }
//    var body: some View {
//        VStack(spacing: 0) {
//            ScrollView {
//                VStack(spacing: 12) {
//                    ForEach(messages) { message in
//                        ChatBubble(message: message, currentUserId: currentUserId)
//                    }
//                }
//                .padding()
//            }
//            
//            Divider()
//                .background(Color.lightCoffeeGray)
//            
//            // Message Bar
//            HStack {
//                TextField("Type a message...", text: $messageText)
//                    .padding(12)
//                    .background(Color.lightCoffeeGray)
//                    .cornerRadius(20)
//                
//                Button(action: {
//                    viewModel.sendMessage()
//                })  {
//                    Image(systemName: "paperplane.fill")
//                        .foregroundColor(.espressoBrown)
//                        .padding(8)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 8)
//            
//            // Action Buttons
//            VStack(spacing: 12) {
//                Button(action: {
//                    path.append(AppScreen.cafeFinder)
//                }) {
//                    Text("Suggest a Café")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.goldenTan)
//                        .foregroundColor(.espressoBrown)
//                        .cornerRadius(12)
//                }
//                
//                Button(action: {
//                    path.append(AppScreen.submitResult)
//                }) {
//                    Text("Confirm Match")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.deepForestGreen)
//                        .foregroundColor(.creamWhite)
//                        .cornerRadius(12)
//                }
//            }
//            .padding(.horizontal)
//            .padding(.bottom)
//        }
//        .background(Color.creamWhite.ignoresSafeArea())
//        .navigationTitle("Emma")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//struct ChatBubble: View {
//    let message: Message
//    let currentUserId: String
//
//    var isSentByCurrentUser: Bool {
//        message.senderId == currentUserId
//    }
//
//    var body: some View {
//        HStack {
//            if isSentByCurrentUser { Spacer() }
//
//            Text(message.text)
//                .padding(10)
//                .background(isSentByCurrentUser ? Color.deepForestGreen : Color.lightCoffeeGray)
//                .foregroundColor(isSentByCurrentUser ? .creamWhite : .espressoBrown)
//                .cornerRadius(12)
//                .frame(maxWidth: 250, alignment: isSentByCurrentUser ? .trailing : .leading)
//
//            if !isSentByCurrentUser { Spacer() }
//        }
//        .padding(isSentByCurrentUser ? .leading : .trailing, 60)
//        .padding(.horizontal, 8)
//    }
//}
