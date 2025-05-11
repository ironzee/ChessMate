//
//  NotificationsSheet.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import Foundation
//
//  NotificationsSheet.swift
//  ChessMate
//
//  Updated on 5/10/25 with Firestore sync
//

import SwiftUI

struct NotificationsSheet: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showSavedText = false

    var body: some View {
        SheetContainer(title: "Notifications") {
            VStack(spacing: 20) {
                Toggle("Chat Messages", isOn: $settingsManager.settings.notificationsEnabled)
                Toggle("Match Invites", isOn: $settingsManager.settings.notificationsEnabled)
                Toggle("Promotional Alerts", isOn: $settingsManager.settings.notificationsEnabled)

                Button("Save Preferences") {
                    settingsManager.saveSettings()
                    showSavedText = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showSavedText = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.deepForestGreen)
                .foregroundColor(.white)
                .cornerRadius(14)

                if showSavedText {
                    Text("Saved ✅")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
