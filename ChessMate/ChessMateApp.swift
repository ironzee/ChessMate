//
//  ChessMateApp.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


@main
struct ChessMateApp: App {
    @UIApplicationDelegateAdaptor(ChessMateAppDelegate.self) var appDelegate
    @StateObject var authManager = AuthManager()

    init() {
        // 1. PREVENT UNARCHIVE CRASH
        NSKeyedUnarchiver.setClass(nil, forClassName: "FirebaseAuth.UserInfoImpl")

        // 2. DELETE CORRUPT FIREBASE CACHED FILES *BEFORE* CONFIGURE
        StartupFixManager.shared.clearCorruptedAuthCache()

        // 3. NOW SAFE TO CONFIGURE FIREBASE
        FirebaseApp.configure()
    }


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}

