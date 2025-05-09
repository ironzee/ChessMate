//
//  ChatDetailViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatDetailViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessage: String = ""
    @Published var otherUserName: String = ""
    @Published var otherUserELO: Int = 0
    @Published var otherUserResponseTime: String = "Usually responds in 5 min" // mock for now

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    let chatId: String
    let currentUserId: String
    let currentUserName: String
    let otherUserId: String

    init(chatId: String, currentUserId: String, currentUserName: String, otherUserId: String) {
        self.chatId = chatId
        self.currentUserId = currentUserId
        self.currentUserName = currentUserName
        self.otherUserId = otherUserId
        listenForMessages()
        fetchOtherUserProfile()

    }

    deinit {
        listener?.remove()
    }

    func listenForMessages() {
        listener = db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("❌ Failed to fetch messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.messages = documents.compactMap { try? $0.data(as: Message.self) }
            }
    }
    func fetchOtherUserProfile() {
        let ref = Firestore.firestore().collection("users").document(otherUserId)
        ref.getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.otherUserName = data["name"] as? String ?? "Unknown"
                self.otherUserELO = data["elo"] as? Int ?? 0
                // Optional: if you want to support dynamic response time
                self.otherUserResponseTime = data["responseTime"] as? String ?? "Usually responds in 5 min"
            }
        }
    }
    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let message = Message(
            text: newMessage,
            senderId: currentUserId,
            senderName: currentUserName
        )

        let chatRef = db.collection("chats").document(chatId)

        // Save or update parent chat document
        chatRef.setData([
            "id": chatId,
            "userAId": currentUserId,
            "userBId": otherUserId,
            "lastMessage": message.text,
            "timestamp": message.timestamp
        ], merge: true)

        // Save message in subcollection
        do {
            try chatRef.collection("messages").addDocument(from: message)
            newMessage = ""
        } catch {
            print("❌ Error sending message: \(error.localizedDescription)")
        }
    }
}
