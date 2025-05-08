//
//  MessageModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
import Foundation
import FirebaseFirestoreSwift


struct MessageModel: Identifiable, Codable {
    let id: String
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: Date
}
