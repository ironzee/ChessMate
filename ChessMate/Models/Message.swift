    //
    //  Message.swift
    //  ChessMate
    //
    //  Created by Zulfiqur on 5/3/25.
    //

    import Foundation
    import FirebaseFirestoreSwift

    struct Message: Identifiable, Codable {
        @DocumentID var id: String? = nil
        let text: String
        let senderId: String
        let senderName: String
        let timestamp: Date

        init(id: String? = nil, text: String, senderId: String, senderName: String, timestamp: Date = Date()) {
            self.id = id
            self.text = text
            self.senderId = senderId
            self.senderName = senderName
            self.timestamp = timestamp
        }
    }
