//
//  MatchRequestModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//

import Foundation
import FirebaseFirestore

struct MatchRequestModel: Identifiable, Codable {
    @DocumentID var id: String?
    var senderId: String
    var receiverId: String
    var cafeName: String
    var suggestedTime: Date
    var status: String // "pending", "accepted", "declined"
    var name: String? // sender's display name

    var newTime: Date?
    var newCafeName: String?
    var chatId: String?
    var createdAt: Date?

    var participants: [String]? // ✅ NEW: used for querying both sender & receiver
}
