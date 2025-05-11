//
//  MatchDistanceSheet.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import Foundation
//
//  MatchDistanceSheet.swift
//  ChessMate
//
//  Updated on 5/10/25 with Firestore sync
//

import SwiftUI

struct MatchDistanceSheet: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var distance: Double = 5
    @State private var showSavedText = false

    var body: some View {
        SheetContainer(title: "Search Distance") {
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "map")
                    Text("Maximum Travel Distance")
                    Spacer()
                    Text("\(Int(distance)) mi")
                        .foregroundColor(.gray)
                }

                Slider(value: $distance, in: 1...50, step: 1)

                Button("Save") {
                    settingsManager.settings.maxDistance = Int(distance)
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
        .onAppear {
            distance = Double(settingsManager.settings.maxDistance)
        }
    }
}
