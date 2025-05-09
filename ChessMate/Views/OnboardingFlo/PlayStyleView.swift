//
//  PlayStyleView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation


import SwiftUI

struct PlayStyleView: View {
    @Binding var path: NavigationPath
    @Binding var onboardingData: OnboardingData

    let styles = [
        "Aggressive & Tactical",
        "Solid & Positional",
        "Creative & Unpredictable",
        "Fast-Paced Blitz Master",
        "Calm Endgame Grinder"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("What’s your play style?")
                .font(.title)
                .foregroundColor(.espressoBrown)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(styles, id: \.self) { style in
                    Button(action: {
                        onboardingData.playStyle = style
                        path.append(AppScreen.onboardingOpeningMove) // 👈 Go to next screen
                    }) {
                        HStack {
                            Text(style)
                            Spacer()
                            if onboardingData.playStyle == style {
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

            Spacer()
        }
        .padding()
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationTitle("Your Style")
        .navigationBarTitleDisplayMode(.inline)
    }
}
