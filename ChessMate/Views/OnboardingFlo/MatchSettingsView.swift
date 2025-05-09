//
//  MatchSettingsView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
//
//  MatchSettingsView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import SwiftUI

struct MatchSettingsView: View {
    @Binding var path: NavigationPath
    @Binding var onboardingData: OnboardingData

    let timeControls = [
        "Blitz (5-10 min)",
        "Rapid (15-30 min)",
        "Casual (no clock)"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("How do you like to play?")
                .font(.title)
                .foregroundColor(.espressoBrown)

            VStack(alignment: .leading, spacing: 12) {
                Text("Preferred Time Control")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)

                ForEach(timeControls, id: \.self) { setting in
                    Button(action: {
                        onboardingData.matchSetting = setting
                    }) {
                        HStack {
                            Text(setting)
                            Spacer()
                            if onboardingData.matchSetting == setting {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .padding()
                        .background(Color.lightCoffeeGray)
                        .foregroundColor(.espressoBrown)
                        .cornerRadius(12)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Would you bring a friend?")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)

                HStack {
                    Button("Yes") {
                        onboardingData.bringBuddy = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(onboardingData.bringBuddy == true ? Color.deepForestGreen : Color.lightCoffeeGray)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                    Button("No") {
                        onboardingData.bringBuddy = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(onboardingData.bringBuddy == false ? Color.espressoBrown : Color.lightCoffeeGray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }

            Spacer()

            Button("Next") {
                path.append(AppScreen.onboardingPersona)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.espressoBrown)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
        .padding()
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationTitle("Match Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
