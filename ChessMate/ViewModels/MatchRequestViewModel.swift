//
//  MatchRequestViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchRequestViewModel: ObservableObject {
    @Published var matchRequests: [MatchRequestModel] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

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
            }
    }

    func startListening(for userId: String) {
            listener?.remove() // remove previous listener if any

            listener = db.collection("matchRequests")
                .whereField("receiverId", isEqualTo: userId)
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
