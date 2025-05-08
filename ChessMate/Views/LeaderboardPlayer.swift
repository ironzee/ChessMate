//
//  LeaderboardPlayer.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//

import Foundation
struct LeaderboardPlayer: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let elo: Int
    let imageName: String
    let matchCount: Int
    let favoriteCafe: Bool
}
