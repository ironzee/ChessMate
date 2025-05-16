//
//  ChatListViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
import FirebaseFirestore

class ChatListViewModel: ObservableObject {
    @Published var chats: [ChatDisplayModel] = []

    private let db = Firestore.firestore()
    private var chatListener: ListenerRegistration?
    private var matchListener: ListenerRegistration?

    func fetchChats(for userId: String) {
        var displayModels: [ChatDisplayModel] = []
        let dispatch = DispatchGroup()

        // Clear current chats
        self.chats.removeAll()

        // 🔹 Step 1: Listen to active chats
        chatListener = db.collection("chats")
            .whereFilter(Filter.orFilter([
                Filter.whereField("userAId", isEqualTo: userId),
                Filter.whereField("userBId", isEqualTo: userId)
            ]))
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }

                let chatModels = documents.compactMap { try? $0.data(as: ChatModel.self) }

                for chat in chatModels {
                    let otherUserId = chat.userAId == userId ? chat.userBId : chat.userAId
                    dispatch.enter()
                    self.fetchUserProfile(userId: otherUserId) { name, elo, photoURL in
                        let display = ChatDisplayModel(
                            id: chat.id ?? UUID().uuidString,
                            otherUserId: otherUserId,
                            otherUserName: name,
                            otherUserElo: elo,
                            profilePicURL: photoURL,
                            lastMessage: chat.lastMessage,
                            timestamp: chat.timestamp
                        )
                        displayModels.append(display)
                        dispatch.leave()
                    }
                }

                dispatch.notify(queue: .main) {
                    self.chats = displayModels
                        .uniqued(by: \.id) // ✅ Remove any duplicates by ID
                        .sorted(by: { ($0.timestamp ?? .distantPast) > ($1.timestamp ?? .distantPast) })
                }
            }

        // 🔹 Step 2: Listen to matches without started chats
        matchListener = db.collection("matches")
            .whereFilter(Filter.orFilter([
                Filter.whereField("userAId", isEqualTo: userId),
                Filter.whereField("userBId", isEqualTo: userId)
            ]))
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }

                for doc in documents {
                    guard let match = try? doc.data(as: MatchModel.self) else { continue }
                    let otherUserId = match.userAId == userId ? match.userBId : match.userAId
                    let chatId = match.chatId

                    // Skip if already exists in displayModels
                    if displayModels.contains(where: { $0.id == chatId }) { continue }

                    dispatch.enter()
                    self.fetchUserProfile(userId: otherUserId) { name, elo, photoURL in
                        let display = ChatDisplayModel(
                            id: chatId,
                            otherUserId: otherUserId,
                            otherUserName: name,
                            otherUserElo: elo,
                            profilePicURL: photoURL,
                            lastMessage: "You matched! Start chatting.",
                            timestamp: match.createdAt
                        )
                        displayModels.append(display)
                        dispatch.leave()
                    }
                }

                dispatch.notify(queue: .main) {
                    self.chats = displayModels
                        .uniqued(by: \.id) // ✅ Remove any duplicates by ID
                        .sorted(by: { ($0.timestamp ?? .distantPast) > ($1.timestamp ?? .distantPast) })
                }
            }
    }


    private func fetchUserProfile(userId: String, completion: @escaping (String, Int, String?) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                let name = data["name"] as? String ?? "Unknown"
                let elo = data["elo"] as? Int ?? 1200
                let photoURL = (data["photoURLs"] as? [String])?.first
                completion(name, elo, photoURL)
            } else {
                completion("Unknown", 1200, nil)
            }
        }
    }

    deinit {
        chatListener?.remove()
        matchListener?.remove()
    }
}

struct ChatDisplayModel: Identifiable {
    let id: String
    let otherUserId: String
    let otherUserName: String
    let otherUserElo: Int
    let profilePicURL: String?
    let lastMessage: String?
    let timestamp: Date?
}
extension Array {
    func uniqued<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
