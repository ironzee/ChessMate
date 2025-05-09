//
//  OnboardingViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
import Foundation
import FirebaseFirestore
import FirebaseAuth

class OnboardingViewModel: ObservableObject {
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid ?? ""

    @Published var playStyle: String = ""
    @Published var openingMove: String = ""
    @Published var cafeStyle: String = ""
    @Published var coffeeOrder: String = ""
    @Published var matchSetting: String = ""
    @Published var bringBuddy: Bool = false
    @Published var chessPersona: String = ""
    @Published var personaReason: String = ""

    func saveOnboardingData(completion: @escaping (Bool) -> Void) {
        guard !userId.isEmpty else {
            completion(false)
            return
        }

        let data: [String: Any] = [
            "playStyle": playStyle,
            "openingMove": openingMove,
            "cafeStyle": cafeStyle,
            "coffeeOrder": coffeeOrder,
            "matchSetting": matchSetting,
            "bringBuddy": bringBuddy,
            "chessPersona": [
                "piece": chessPersona,
                "reason": personaReason
            ]
        ]

        db.collection("users").document(userId).updateData([
            "onboardingData": data
        ]) { error in
            if let error = error {
                print("❌ Failed to save onboarding data: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Onboarding data saved successfully.")
                completion(true)
            }
        }
    }
}
