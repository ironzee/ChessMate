//
//  MatchesViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/11/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchesViewModel: ObservableObject {
    @Published var matches: [MatchUser] = []
    private let db = Firestore.firestore()
    
    func fetchMatches(for userId: String) {
        matches.removeAll() // 🔥 Clear before refetch

        db.collection("matches")
            .whereFilter(Filter.orFilter([
                Filter.whereField("userAId", isEqualTo: userId),
                Filter.whereField("userBId", isEqualTo: userId)
            ]))
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }

                var seenChatIds: Set<String> = []

                for doc in documents {
                    let data = doc.data()
                    guard let userA = data["userAId"] as? String,
                          let userB = data["userBId"] as? String,
                          let chatId = data["chatId"] as? String else { continue }

                    guard !seenChatIds.contains(chatId) else { continue }
                    seenChatIds.insert(chatId)

                    let otherUserId = userA == userId ? userB : userA

                    self.db.collection("users").document(otherUserId).getDocument { userSnap, err in
                        guard let userData = userSnap?.data() else { return }

                        let name = userData["name"] as? String ?? "Unknown"
                        let photoURL = (userData["photoURLs"] as? [String])?.first
                        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue()

                        let matchUser = MatchUser(
                            userId: otherUserId,
                            userAId: userA,
                            userBId: userB,
                            name: name,
                            profilePicURL: photoURL,
                            chatId: chatId,
                            createdAt: createdAt
                        )

                        DispatchQueue.main.async {
                            self.matches.append(matchUser)
                        }
                    }
                }
            }
    }


}

struct MatchUser: Identifiable {
    var id: String { userId }
    let userId: String
    let userAId: String
    let userBId: String
    let name: String
    let profilePicURL: String?
    let chatId: String
    let createdAt: Date?
}
