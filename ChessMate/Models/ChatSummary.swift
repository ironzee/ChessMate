//
//  ChatSummary.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
import Foundation
import FirebaseFirestoreSwift

struct ChatSummary: Identifiable, Codable {
    @DocumentID var id: String?
    let lastMessage: String
    let lastTimestamp: Date
    let participants: [String]
}
