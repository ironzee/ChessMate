//
//  UserManager.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/30/25.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class UserManager {
    static let shared = UserManager()
    private let db = Firestore.firestore()

    func saveUser(user: UserModel, completion: ((Error?) -> Void)? = nil) {
        do {
            let data = try Firestore.Encoder().encode(user)
            db.collection("users").document(user.uid).setData(data) { error in
                if let error = error {
                    print("❌ Error saving user: \(error.localizedDescription)")
                } else {
                    print("✅ User saved successfully")
                }
                completion?(error)
            }
        } catch {
            print("❌ Encoding error: \(error.localizedDescription)")
            completion?(error)
        }
    }

    func updateUserPhotoURLs(uid: String, photoURLs: [String], completion: @escaping (Bool) -> Void) {
        db.collection("users").document(uid).updateData(["photoURLs": photoURLs]) { error in
            if let error = error {
                print("❌ Failed to update photoURLs: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ photoURLs updated")
                completion(true)
            }
        }
    }
}
