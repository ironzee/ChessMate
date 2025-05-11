//
//  SettingsManager.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import Foundation
import Foundation
import FirebaseFirestore
import FirebaseAuth

class SettingsManager: ObservableObject {
    @Published var settings = SettingsModel(
        maxDistance: 10,
        preferredTimes: ["Evening"],
        notificationsEnabled: true,
        darkMode: false
    )

    private let db = Firestore.firestore()

    var userId: String? {
        Auth.auth().currentUser?.uid
    }

    func fetchSettings() {
        guard let uid = userId else { return }

        db.collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let settingsData = data["settings"] as? [String: Any],
                  let json = try? JSONSerialization.data(withJSONObject: settingsData),
                  let decoded = try? JSONDecoder().decode(SettingsModel.self, from: json)
            else { return }

            DispatchQueue.main.async {
                self.settings = decoded
            }
        }
    }

    func saveSettings() {
        guard let uid = userId else { return }
        do {
            let encoded = try Firestore.Encoder().encode(settings)
            db.collection("users").document(uid).setData(["settings": encoded], merge: true)
        } catch {
            print("❌ Error saving settings: \(error.localizedDescription)")
        }
    }
}
