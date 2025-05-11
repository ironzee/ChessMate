//
//  SettingsModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import Foundation
import Foundation

struct SettingsModel: Codable {
    var maxDistance: Int
    var preferredTimes: [String]
    var notificationsEnabled: Bool
    var darkMode: Bool
}
