//
//  UserModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/2/25.
//


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
    let hasCompletedOnboarding: Bool
    let onboardingData: OnboardingData?

    enum CodingKeys: String, CodingKey {
        case uid, name, email, location, elo, wins, losses, createdAt, photoURLs, hasCompletedOnboarding, onboardingData
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
        photoURLs: [String] = [],
        hasCompletedOnboarding: Bool = false,
        onboardingData: OnboardingData? = nil
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
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.onboardingData = onboardingData
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
        hasCompletedOnboarding = (try? container.decode(Bool.self, forKey: .hasCompletedOnboarding)) ?? false

        if let timestamp = try? container.decode(Timestamp.self, forKey: .createdAt) {
            createdAt = timestamp.dateValue()
        } else {
            createdAt = nil
        }

        photoURLs = (try? container.decode([String].self, forKey: .photoURLs)) ?? []
        onboardingData = try? container.decode(OnboardingData.self, forKey: .onboardingData)
    }
}

// MARK: - Convert to PlayerModel
extension UserModel {
    func toPlayerModel(distance: Double) -> PlayerModel {
        PlayerModel(
            uid: uid,
            name: name,
            elo: elo,
            distance: distance,
            favoriteOpening: onboardingData?.openingMove ?? "",
            playstyle: onboardingData?.playStyle ?? "",
            timeControl: onboardingData?.matchSetting ?? "",
            favoriteCafe: onboardingData?.cafeStyle ?? "",
            coffeeOrder: onboardingData?.coffeeOrder ?? "",
            photoURLs: photoURLs ?? [],
            bio: onboardingData?.chessPersonaReason
        )
    }
}

// MARK: - Onboarding Data Struct

struct OnboardingData: Codable {
    var playStyle: String = ""
    var openingMove: String = ""
    var cafeStyle: String = ""
    var coffeeOrder: String = ""
    var matchSetting: String = ""
    var bringBuddy: Bool = false
    var chessPersona: String = ""
    var chessPersonaReason: String = ""

    func toMap() -> [String: Any] {
        return [
            "playStyle": playStyle,
            "openingMove": openingMove,
            "cafeStyle": cafeStyle,
            "coffeeOrder": coffeeOrder,
            "matchSetting": matchSetting,
            "bringBuddy": bringBuddy,
            "chessPersona": chessPersona,
            "chessPersonaReason": chessPersonaReason
        ]
    }
}

