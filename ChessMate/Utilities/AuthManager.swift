//
//  AuthManager.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/30/25.
//
// 🔐 AuthManager.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var userID: String?
    @Published var userProfileLoaded = false
    @Published var currentUser: UserModel?

    private let db = Firestore.firestore()

    func signUp(name: String, email: String, password: String, location: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            guard let user = result?.user else {
                completion(false, "User creation failed.")
                return
            }
            self.userID = user.uid
            self.isSignedIn = true
            completion(true, nil)
        }
    }

    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            guard let user = result?.user else {
                completion(false, "User not found")
                return
            }
            self.userID = user.uid
            self.loadUserProfile(uid: user.uid) { success in
                completion(success, success ? nil : "Failed to load user")
            }
        }
    }

    func loadUserProfile(uid: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("u274c Failed to fetch user profile: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let snapshot = snapshot else {
                print("u26a0ufe0f No snapshot returned")
                completion(false)
                return
            }
            do {
                let user = try snapshot.data(as: UserModel.self)
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.userProfileLoaded = true
                    print("u2705 Loaded user profile: \(user.name)")
                    completion(true)
                }
            } catch {
                print("u274c Failed to decode user: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    func refreshCurrentUser(completion: @escaping () -> Void = {}) {
        guard let uid = currentUser?.id else {
            print("u274c No UID in currentUser")
            return
        }
        loadUserProfile(uid: uid) { _ in completion() }
    }

    func logout() {
        try? Auth.auth().signOut()
        self.userID = nil
        self.isSignedIn = false
        self.userProfileLoaded = false
        self.currentUser = nil
    }
}

