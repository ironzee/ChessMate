//
//  UserModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/2/25.
//


import Foundation
import FirebaseFirestore

struct UserModel: Identifiable, Codable {
    var id: String { uid }
    let uid: String
    let name: String
    let email: String
    let location: String
    let elo: Int
    let wins: Int
    let losses: Int
    let createdAt: Date?
    let photoURLs: [String]?

    enum CodingKeys: String, CodingKey {
        case uid, name, email, location, elo, wins, losses, createdAt, photoURLs
    }

    init(
        uid: String,
        name: String,
        email: String,
        location: String,
        elo: Int = 1200,
        wins: Int = 0,
        losses: Int = 0,
        createdAt: Date? = nil,
        photoURLs: [String] = []
    ) {
        self.uid = uid
        self.name = name
        self.email = email
        self.location = location
        self.elo = elo
        self.wins = wins
        self.losses = losses
        self.createdAt = createdAt
        self.photoURLs = photoURLs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        location = try container.decode(String.self, forKey: .location)
        elo = try container.decode(Int.self, forKey: .elo)
        wins = try container.decode(Int.self, forKey: .wins)
        losses = try container.decode(Int.self, forKey: .losses)

        // Timestamp workaround
        if let timestamp = try? container.decode(Timestamp.self, forKey: .createdAt) {
            createdAt = timestamp.dateValue()
        } else {
            createdAt = nil
        }

        // photoURLs fallback
        photoURLs = (try? container.decode([String].self, forKey: .photoURLs)) ?? []

    }
}
