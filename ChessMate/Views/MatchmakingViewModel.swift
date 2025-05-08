//
//  MatchmakingViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/2/25.
//

import Foundation
import FirebaseFirestore



struct PlayerModel: Identifiable, Codable {
    var id: String { uid }

    let uid: String
    let name: String
    let elo: Int
    let photoURLs: [String]
    
    // Optional mock values for display (not stored in Firestore yet)
    var age: Int? = nil
    var favoriteOpening: String = "Queen's Gambit"
    var playstyle: String = "Aggressive Positional Player"
    var timeControl: String = "15|10"
    var favoriteCafe: String = "The Knight’s Corner"
    var coffeeOrder: String = "Oat Milk Cappuccino"
    var bio: String? = "Looking for challenging games and great conversations over coffee."

    // Location placeholder
    var distance: Double = Double.random(in: 1.0...10.0)
}



class MatchmakingViewModel: ObservableObject {
    @Published var players: [PlayerModel] = []
    func fetchPlayers(excludeUID: String) {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Failed to fetch players: \(error.localizedDescription)")
                return
            }

            guard let docs = snapshot?.documents else { return }

            self.players = docs.compactMap { doc in
                let data = doc.data()
                let uid = doc.documentID
                guard
                    let name = data["name"] as? String,
                    let elo = data["elo"] as? Int,
                    let photoURLs = data["photoURLs"] as? [String]
                else {
                    return nil
                }

                return PlayerModel(
                    uid: doc.documentID,
                    name: name,
                    elo: elo,
                    photoURLs: photoURLs
                )
            }
        }
    }

}
