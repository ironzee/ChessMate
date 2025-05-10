//
//  LikeService.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/9/25.
//

import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class LikeService {
    private let db = Firestore.firestore()

    /// Sends a like from one user to another
    func sendLike(from likerId: String, to likedId: String, completion: @escaping (Bool) -> Void) {
        let likeData: [String: Any] = [
            "likerId": likerId,
            "likedId": likedId,
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("likes").addDocument(data: likeData) { error in
            if let error = error {
                print("❌ Error sending like: \(error.localizedDescription)")
                completion(false)
                return
            }

            self.checkMutualLike(between: likerId, and: likedId) { isMutual in
                if isMutual {
                    self.createChatBetween(likerId, and: likedId)
                }
                completion(isMutual)
            }
        }
    }

    /// Checks if both users have liked each other
    private func checkMutualLike(between user1: String, and user2: String, completion: @escaping (Bool) -> Void) {
        db.collection("likes")
            .whereField("likerId", isEqualTo: user2)
            .whereField("likedId", isEqualTo: user1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error checking mutual like: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                let isMutual = snapshot?.documents.first != nil
                completion(isMutual)
            }
    }

    /// Creates a chat document for the matched pair
    private func createChatBetween(_ user1: String, and user2: String) {
        let sortedIds = [user1, user2].sorted()
        let chatId = sortedIds.joined(separator: "_")

        let chatData: [String: Any] = [
            "id": chatId,
            "userAId": sortedIds[0],
            "userBId": sortedIds[1],
            "timestamp": Timestamp(date: Date()),
            "lastMessage": ""
        ]

        db.collection("chats").document(chatId).setData(chatData) { error in
            if let error = error {
                print("❌ Error creating chat: \(error.localizedDescription)")
            } else {
                print("✅ Chat created for mutual match: \(chatId)")
            }
        }
    }
}
