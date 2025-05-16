//
//  ChatManager.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
import FirebaseFirestore

class ChatManager: ObservableObject {
    private let db = Firestore.firestore()

    @Published var chats: [ChatModel] = []

    func fetchChats(for userId: String) {
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .order(by: "lastTimestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching chats: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.chats = documents.compactMap { doc in
                    try? doc.data(as: ChatModel.self)
                }
            }
    }
}
