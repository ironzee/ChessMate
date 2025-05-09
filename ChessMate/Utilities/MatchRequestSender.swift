//
//  MatchRequestSender.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//

import Foundation
import Foundation
import FirebaseFirestore



class MatchRequestSender {
    private let db = Firestore.firestore()

    func sendRequest(
        from senderId: String,
        senderName: String,
        to receiverId: String,
        chatId: String? = nil,
        cafeName: String,
        suggestedTime: Date,
        completion: @escaping (Bool) -> Void
    ) {
        let participants = [senderId, receiverId] // ✅ New field for querying

        let newRequest: [String: Any] = [
            "senderId": senderId,
            "receiverId": receiverId,
            "cafeName": cafeName,
            "suggestedTime": Timestamp(date: suggestedTime), // ✅ stored as Timestamp
            "status": "pending",
            "chatId": chatId ?? "",
            "createdAt": FieldValue.serverTimestamp(), // ✅ stored with server timestamp
            "name": senderName,
            "participants": participants // ✅ Add both sender and receiver here
        ]

        db.collection("matchRequests").addDocument(data: newRequest) { error in
            if let error = error {
                print("❌ Failed to send match request: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Match request sent")
                completion(true)
            }
        }
    }
}
