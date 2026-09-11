//
//  HomeLeaderboardViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/29/25.
//

import Foundation
import Foundation
import FirebaseFirestore
import CoreLocation

class HomeLeaderboardViewModel: ObservableObject {
    @Published var topThree: [UserModel] = []

    private let db = Firestore.firestore()

    func fetchLocalTopPlayers(location: String) {
        db.collection("users")
            .whereField("location", isEqualTo: location.capitalized)
            .order(by: "elo", descending: true)
            .limit(to: 3)
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                let users = docs.compactMap { try? $0.data(as: UserModel.self) }

                DispatchQueue.main.async {
                    self.topThree = users
                }
            }
    }
}
