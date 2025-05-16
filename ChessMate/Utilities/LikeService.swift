//
//  LikeService.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/9/25.
//

import Foundation
import FirebaseFirestore

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
                    self.createChatAndMatchBetween(likerId, and: likedId)
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

    /// Creates both a chat and a match entry for mutual likes
    private func createChatAndMatchBetween(_ user1: String, and user2: String) {
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

        let matchData: [String: Any] = [
            "userAId": sortedIds[0],
            "userBId": sortedIds[1],
            "chatId": chatId,
            "createdAt": Timestamp(date: Date()),
            "initiatedBy": user1
        ]

        db.collection("matches")
            .whereField("userAId", isEqualTo: sortedIds[0])
            .whereField("userBId", isEqualTo: sortedIds[1])
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error checking existing match: \(error.localizedDescription)")
                    return
                }

                if snapshot?.documents.isEmpty == true {
                    self.db.collection("matches").addDocument(data: matchData) { error in
                        if let error = error {
                            print("❌ Error saving match: \(error.localizedDescription)")
                        } else {
                            print("✅ Match saved for users: \(sortedIds)")
                        }
                    }
                } else {
                    print("ℹ️ Match already exists between users: \(sortedIds)")
                }
            }
    }
}
