//
//  MatchRequestModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//

import Foundation
import Foundation
import FirebaseFirestoreSwift


struct MatchRequestModel: Identifiable, Codable {
    @DocumentID var id: String?
    var senderId: String
    var receiverId: String
    var cafeName: String
    var suggestedTime: Date
    var status: String // "pending", "accepted", "declined"
    
    var newTime: Date?
    var newCafeName: String?
    var chatId: String? // optional, if linked to a chat

    var createdAt: Date? // ✅ make this optional to prevent crash
}
