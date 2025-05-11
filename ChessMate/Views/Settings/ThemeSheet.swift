//
//  ThemeSheet.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import Foundation
//
//  ThemeSheet.swift
//  ChessMate
//
//  Updated on 5/10/25 with Firestore sync
//

import SwiftUI

struct ThemeSheet: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showSavedText = false

    var body: some View {
        SheetContainer(title: "App Theme") {
            Toggle("Dark Mode", isOn: $settingsManager.settings.darkMode)

            Button("Save") {
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
