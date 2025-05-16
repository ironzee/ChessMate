//
//  MatchModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/11/25.
//

import Foundation
import Foundation
import FirebaseFirestore

struct MatchModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userAId: String
    var userBId: String
    var chatId: String
    var createdAt: Date
    var initiatedBy: String
}
