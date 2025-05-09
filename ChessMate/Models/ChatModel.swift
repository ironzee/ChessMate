//
//  ChatModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatModel: Identifiable, Codable, Hashable {
    var id: String
    var userAId: String
    var userBId: String
    var lastMessage: String?
    var timestamp: Date?
    
    // Add this if you’re using a mock initializer
    static let mock = ChatModel(id: "mock123", userAId: "1", userBId: "2", lastMessage: "Hi", timestamp: Date())
}
