//
//  OpeningMoveView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import SwiftUI
import Foundation
struct OpeningMoveView: View {
    @Binding var path: NavigationPath
    @Binding var onboardingData: OnboardingData

    let openings = [
        "Queen’s Gambit ♛",
        "Sicilian Defense",
        "King’s Indian Defense",
        "London System",
        "Ruy Lopez",
        "Scandinavian Defense",
        "I like to improvise!"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("Favorite Opening?")
                .font(.title)
                .foregroundColor(.espressoBrown)

            VStack(spacing: 16) {
                ForEach(openings, id: \.self) { move in
                    Button(action: {
                        onboardingData.openingMove = move
                        path.append(AppScreen.onboardingCafeStyle)
                    }) {
                        HStack {
                            Text(move)
                            Spacer()
                            if onboardingData.openingMove == move {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.deepForestGreen)
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
        .navigationTitle("Opening Move")
        .navigationBarTitleDisplayMode(.inline)
    }
}
