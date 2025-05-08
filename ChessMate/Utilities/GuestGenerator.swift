//
//  GuestGenerator.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//

import Foundation
import Foundation

struct GuestGenerator {
    static let sampleNames = ["Bobby", "Nina", "Capablanca", "Fischer", "Magnus", "Hikaru", "Judit", "Mittens", "Chesster", "Rooksy"]
    static let cities = ["New York", "Chicago", "Atlanta", "San Francisco", "Austin", "Seattle", "Toronto", "London", "Berlin", "Tokyo"]
    static let guestImages = [
        "https://source.unsplash.com/random/200x200?chess",
        "https://source.unsplash.com/random/200x200?coffee",
        "https://source.unsplash.com/random/200x200?gamer",
        "https://source.unsplash.com/random/200x200?avatar",
        "https://source.unsplash.com/random/200x200?portrait"
    ]

    static func randomName() -> String {
        sampleNames.randomElement() ?? "Guest"
    }

    static func randomEmail(for name: String) -> String {
        let safeName = name.lowercased().replacingOccurrences(of: " ", with: "_")
        return "\(safeName)\(Int.random(in: 1000...9999))@guest.chessmate.app"
    }

    static func randomCity() -> String {
        cities.randomElement() ?? "Unknown"
    }

    static func randomPhotos() -> [String] {
        [guestImages.randomElement()].compactMap { $0 }
    }
}
