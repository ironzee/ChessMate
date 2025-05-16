//
//  MatchmakingViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/2/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestore
import CoreLocation

class MatchmakingViewModel: ObservableObject {
    @Published var players: [PlayerModel] = []

    private let db = Firestore.firestore()

    func fetchPlayers(excludeUID: String) {
        // Step 1: Fetch matched userIds first
        fetchMatchedUserIds(for: excludeUID) { matchedIds in
            self.db.collection("users").getDocuments { snapshot, error in
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
                    if let user = try? doc.data(as: UserModel.self),
                       user.uid != excludeUID,
                       !matchedIds.contains(user.uid) {
                        let player = user.toPlayerModel(distance: 0) // 🔁 TODO: Add distance logic if needed
                        fetched.append(player)
                    }
                }

                DispatchQueue.main.async {
                    self.players = fetched.shuffled()
                }
            }
        }
    }

    private func fetchMatchedUserIds(for userId: String, completion: @escaping ([String]) -> Void) {
        db.collection("matches")
            .whereFilter(Filter.orFilter([
                Filter.whereField("userAId", isEqualTo: userId),
                Filter.whereField("userBId", isEqualTo: userId)
            ]))
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching matches: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let matches = snapshot?.documents.compactMap { try? $0.data(as: MatchModel.self) } ?? []

                let matchedUserIds = matches.map { match in
                    return match.userAId == userId ? match.userBId : match.userAId
                }

                completion(matchedUserIds)
            }
    }
}
