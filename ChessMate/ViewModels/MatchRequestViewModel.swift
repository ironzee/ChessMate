//
//  MatchRequestViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestore

class MatchRequestViewModel: ObservableObject {
    @Published var matchRequests: [MatchRequestModel] = []
    @Published var userCache: [String: UserModel] = [:]

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    var confirmedMatches: [MatchRequestModel] {
        matchRequests.filter {
            $0.status.lowercased() == "accepted" || $0.status.lowercased() == "confirmed"
        }
    }

    // Load all requests where user is the receiver
    func fetchRequests(for userId: String) {
        listener = db.collection("matchRequests")
            .whereField("receiverId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Failed to fetch match requests: \(error.localizedDescription)")
                    return
                }

                self.matchRequests = snapshot?.documents.compactMap {
                    try? $0.data(as: MatchRequestModel.self)
                } ?? []
                self.preloadOpponentUsers(for: self.matchRequests, currentUserId: userId)

            }
    }
    func getOpponent(from request: MatchRequestModel, currentUserId: String) -> UserModel? {
        if request.senderId == currentUserId {
            return userCache[request.receiverId]
        } else {
            return userCache[request.senderId]
        }
    }
    func preloadOpponentUsers(for requests: [MatchRequestModel], currentUserId: String) {
        let opponentIds = Set(
            requests.map {
                $0.senderId == currentUserId ? $0.receiverId : $0.senderId
            }
        )

        for uid in opponentIds {
            if userCache[uid] == nil {
                db.collection("users").document(uid).getDocument { snapshot, error in
                    guard let data = snapshot?.data(),
                          let user = try? snapshot?.data(as: UserModel.self) else {
                        print("❌ Failed to load user \(uid)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.userCache[uid] = user
                    }
                }
            }
        }
    }

    func startListening(for userId: String) {
        listener?.remove()

        listener = db.collection("matchRequests")
            .whereField("participants", arrayContains: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching match requests: \(error.localizedDescription)")
                    return
                }

                self.matchRequests = snapshot?.documents.compactMap {
                    try? $0.data(as: MatchRequestModel.self)
                } ?? []
            }
    }

   
 
    func acceptRequest(_ request: MatchRequestModel) {
        guard let id = request.id else { return }

        db.collection("matchRequests").document(id).updateData([
            "status": "accepted"
        ]) { error in
            if let error = error {
                print("❌ Failed to accept request: \(error.localizedDescription)")
            } else {
                print("✅ Match request accepted")
            }
        }
    }

    func suggestNewTimeOrPlace(for request: MatchRequestModel, newTime: Date?, newCafeName: String?) {
        guard let id = request.id else { return }

        db.collection("matchRequests").document(id).updateData([
            "status": "suggested",
            "newTime": newTime as Any,
            "newCafeName": newCafeName as Any
        ]) { error in
            if let error = error {
                print("❌ Failed to suggest new time/place: \(error.localizedDescription)")
            } else {
                print("📅 Suggestion sent")
            }
        }
    }

    deinit {
        listener?.remove()
    }
}
