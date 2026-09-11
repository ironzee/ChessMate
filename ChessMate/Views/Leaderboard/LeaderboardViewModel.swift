//
//  LeaderboardViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/29/25.
//

import Foundation
import FirebaseFirestore

class LeaderboardViewModel: ObservableObject {
    @Published var topThree: [UserModel] = []
    @Published var otherRankings: [UserModel] = []
    @Published var currentUserRank: Int?
    @Published var currentCity: String = ""

    private let db = Firestore.firestore()

    // 🔁 Cache to avoid refetching
    private var cachedRankings: [String: [UserModel]] = [:]
    private var cachedTopThree: [String: [UserModel]] = [:]

    func fetchLeaderboard(scope: String = "Local", currentUserId: String) {
        if let cached = cachedRankings[scope], !cached.isEmpty {
            self.topThree = cachedTopThree[scope] ?? []
            self.otherRankings = Array(cached.dropFirst(3))
            self.updateCurrentUserRank(users: cached, currentUserId: currentUserId)
            return
        }

        var query: Query = db.collection("users")

        if scope == "Local" {
            query = query.whereField("location", isEqualTo: currentCity.capitalized)
        }

        query.order(by: "elo", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let users = documents.compactMap { try? $0.data(as: UserModel.self) }

            DispatchQueue.main.async {
                let top = Array(users.prefix(3))
                let rest = Array(users.dropFirst(3))

                self.topThree = top
                self.otherRankings = rest

                // Cache full list
                self.cachedRankings[scope] = users
                self.cachedTopThree[scope] = top

                self.updateCurrentUserRank(users: users, currentUserId: currentUserId)
            }
        }
    }

    private func updateCurrentUserRank(users: [UserModel], currentUserId: String) {
        if let rank = users.firstIndex(where: { $0.uid == currentUserId }) {
            self.currentUserRank = rank + 1
        }
    }
}
