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
