//
//  MatchmakingViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/2/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

class MatchmakingViewModel: ObservableObject {
    @Published var players: [PlayerModel] = []

    private let db = Firestore.firestore()

    func fetchPlayers(excludeUID: String) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Failed to fetch players: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("❌ No players found")
                return
            }

            var fetched: [PlayerModel] = []

            for doc in documents {
                if let user = try? doc.data(as: UserModel.self), user.uid != excludeUID {
                    let player = user.toPlayerModel(distance: 0) // 🔁 TODO: calculate actual distance
                    fetched.append(player)
                }
            }

            DispatchQueue.main.async {
                self.players = fetched.shuffled()
            }
        }
    }
}
