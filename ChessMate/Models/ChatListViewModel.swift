//
//  ChatListViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatListViewModel: ObservableObject {
    @Published var chats: [ChatDisplayModel] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchChats(for userId: String) {
        listener = db.collection("chats")
            .whereFilter(Filter.orFilter([
                Filter.whereField("userAId", isEqualTo: userId),
                Filter.whereField("userBId", isEqualTo: userId)
            ]))
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }

                let chatModels = documents.compactMap { try? $0.data(as: ChatModel.self) }
                var displayModels: [ChatDisplayModel] = []

                let dispatch = DispatchGroup()

                for chat in chatModels {
                    let otherUserId = chat.userAId == userId ? chat.userBId : chat.userAId
                    dispatch.enter()

                    Firestore.firestore().collection("users").document(otherUserId).getDocument { snap, err in
                        if let data = snap?.data() {
                            let name = data["name"] as? String ?? "Unknown"
                            let elo = data["elo"] as? Int ?? 1200
                            let photoURLs = data["photoURLs"] as? [String]
                            let profilePicURL = photoURLs?.first

                            let display = ChatDisplayModel(
                                id: chat.id ?? UUID().uuidString,
                                otherUserId: otherUserId,
                                otherUserName: name,
                                otherUserElo: elo,
                                lastMessage: chat.lastMessage,
                                timestamp: chat.timestamp,
                                profilePicURL: profilePicURL
                            )

                            displayModels.append(display)
                        }
                        dispatch.leave()
                    }
                }

                dispatch.notify(queue: .main) {
                    self.chats = displayModels.sorted(by: { ($0.timestamp ?? Date.distantPast) > ($1.timestamp ?? Date.distantPast) })
                }
            }
    }

    deinit {
        listener?.remove()
    }
}

import Foundation

struct ChatDisplayModel: Identifiable {
    let id: String
    let otherUserId: String
    let otherUserName: String
    let otherUserElo: Int
    let lastMessage: String?
    let timestamp: Date?
    let profilePicURL: String? // ✅ New
}

