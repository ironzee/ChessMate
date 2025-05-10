//
//  Player.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
import Foundation

struct Player: Identifiable {
    var id: String { uid }
    let uid: String
    let name: String
    let skillLevel: Int
    let distance: Double
}

import Foundation

struct PlayerModel: Identifiable {
    var id: String { uid }
    let uid: String
    let name: String
    let elo: Int
    let distance: Double
    let favoriteOpening: String
    let playstyle: String
    let timeControl: String
    let favoriteCafe: String
    let coffeeOrder: String
    let photoURLs: [String]
    let bio: String?
}
