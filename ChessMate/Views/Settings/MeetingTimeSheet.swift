//
//  MeetingTimeSheet.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import Foundation
//
//  MeetingTimeSheet.swift
//  ChessMate
//
//  Updated on 5/10/25 with Firestore sync
//

import SwiftUI

struct MeetingTimeSheet: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedTimes: Set<String> = []
    @State private var showSavedText = false

    let allTimes = ["Morning", "Afternoon", "Evening", "Late Night"]

    var body: some View {
        SheetContainer(title: "Preferred Times") {
            VStack(spacing: 16) {
                ForEach(allTimes, id: \.self) { time in
                    Button {
                        if selectedTimes.contains(time) {
                            selectedTimes.remove(time)
                        } else {
                            selectedTimes.insert(time)
                        }
                    } label: {
                        Text(time)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedTimes.contains(time) ? Color.deepForestGreen : Color.white)
                            .foregroundColor(selectedTimes.contains(time) ? .white : .espressoBrown)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.deepForestGreen)
                            )
                    }
                }

                Button("Save") {
                    settingsManager.settings.preferredTimes = Array(selectedTimes)
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
            selectedTimes = Set(settingsManager.settings.preferredTimes)
        }
    }
}
