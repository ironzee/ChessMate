//
//  StartupFixManager.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/3/25.
//




import Foundation
import FirebaseAuth
import Security

// 🧼 Dummy stub class to intercept corrupted Firebase Auth archive data
final class DummyUserInfoImpl: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    func encode(with coder: NSCoder) {}

    required init?(coder: NSCoder) {}

    override init() {
        super.init()
    }
}

class StartupFixManager {
    static let shared = StartupFixManager()

    private init() {}

    func clearCorruptedAuthCache() {
        print("🧹 Attempting to clear corrupted Firebase Auth cache...")

        // 🔧 Fix for NSKeyedUnarchiver crash on FirebaseAuth.UserInfoImpl
        NSKeyedUnarchiver.setClass(DummyUserInfoImpl.self, forClassName: "FirebaseAuth.UserInfoImpl")

        // 🔨 Clear cached Firebase Auth UserDefaults
        let key = "FirebaseAuth.Default.AuthUserDefaultsKey"
        UserDefaults.standard.removeObject(forKey: key)

        // 🔨 Clear Firebase local file cache
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        if let appSupportDir = paths.first {
            let firebaseAuthPath = "\(appSupportDir)/com.google.FirebaseAuth"
            try? FileManager.default.removeItem(atPath: firebaseAuthPath)
            print("🧹 Deleted Firebase Auth storage at: \(firebaseAuthPath)")
        }

        // 🔐 Optional: Clear Keychain entries that may be linked to Firebase
        clearKeychainFirebaseTokens()
    }

    private func clearKeychainFirebaseTokens() {
        let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        for itemClass in secItemClasses {
            let query: [String: Any] = [kSecClass as String: itemClass]
            let status = SecItemDelete(query as CFDictionary)
            if status == errSecSuccess {
                print("🗑️ Cleared keychain items for class: \(itemClass)")
            }
        }
    }
}
