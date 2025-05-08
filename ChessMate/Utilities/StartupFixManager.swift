//
//  StartupFixManager.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//


import Foundation
import FirebaseAuth

class StartupFixManager {
    static let shared = StartupFixManager()

    private init() {}

    func clearCorruptedAuthCache() {

        print("🧹 Attempting to clear corrupted Firebase Auth cache...")

        let key = "FirebaseAuth.Default.AuthUserDefaultsKey"
        UserDefaults.standard.removeObject(forKey: key)

        // Also delete Auth user data from local storage
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        if let appSupportDir = paths.first {
            let firebaseAuthPath = "\(appSupportDir)/com.google.FirebaseAuth"
            try? FileManager.default.removeItem(atPath: firebaseAuthPath)
            print("🧹 Deleted Firebase Auth storage at: \(firebaseAuthPath)")
        }
    }


//    private func signInGuest() {
//        Auth.auth().signInAnonymously { result, error in
//            if let error = error {
//                print("❌ Guest sign-in failed: \(error.localizedDescription)")
//                return
//            }
//
//            guard let user = result?.user else {
//                print("❌ Guest sign-in failed: no user object")
//                return
//            }
//
//            print("✅ Signed in anonymously as: \(user.uid)")
//
//            let guestName = GuestGenerator.randomName()
//            let guestEmail = GuestGenerator.randomEmail(for: guestName)
//            let guestLocation = GuestGenerator.randomCity()
//            let guestPhotos = GuestGenerator.randomPhotos()
//
//            UserManager.shared.createUserIfNeeded(
//                uid: user.uid,
//                name: guestName,
//                email: guestEmail,
//                location: guestLocation,
//                photoURLs: guestPhotos
//            ) {
//                print("✅ Guest user profile created")
//            }
//        }
//    }
}
