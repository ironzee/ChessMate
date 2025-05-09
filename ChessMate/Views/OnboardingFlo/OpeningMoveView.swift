//
//  OpeningMoveView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
//
//  OpeningMoveView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import SwiftUI

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
            Text("What’s your favorite opening?")
                .font(.title)
                .foregroundColor(.espressoBrown)

            VStack(spacing: 16) {
                ForEach(openings, id: \.self) { move in
                    Button(action: {
                        onboardingData.openingMove = move
                        path.append(AppScreen.onboardingCafeStyle) // ✅ Go to next
                    }) {
                        HStack {
                            Text(move)
                            Spacer()
                            if onboardingData.openingMove == move {
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
        .navigationTitle("Opening Move")
        .navigationBarTitleDisplayMode(.inline)
    }
}
