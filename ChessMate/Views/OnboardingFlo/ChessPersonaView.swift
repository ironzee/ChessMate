//
//  ChessPersonaView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
import SwiftUI

struct ChessPersonaView: View {
    @Binding var path: NavigationPath
    @Binding var onboardingData: OnboardingData
    var userId: String
    var onComplete: () -> Void

    let personas = [
        "The Gambit Lover ♛",
        "The Coffeehouse Killer ☕",
        "The Calm Strategist 🧠",
        "The Blunder Master 😂",
        "The Bookworm Tactician 📚",
        "The Social Chess Butterfly 🦋"
    ]

    @State private var reason: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Who are you as a player?")
                    .font(.title)
                    .foregroundColor(.espressoBrown)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(personas, id: \.self) { persona in
                        Button(action: {
                            onboardingData.chessPersona = persona
                        }) {
                            HStack {
                                Text(persona)
                                Spacer()
                                if onboardingData.chessPersona == persona {
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

                VStack(alignment: .leading, spacing: 8) {
                    Text("Why did you pick this?")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)

                    TextField("Tell us something fun or real...", text: $reason)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 4)
                }

                Button("Finish Onboarding") {
                    onboardingData.chessPersonaReason = reason
                    onComplete()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.deepForestGreen)
                .foregroundColor(.white)
                .cornerRadius(14)

                Spacer()
            }
            .padding()
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationTitle("Chess Persona")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            reason = onboardingData.chessPersonaReason
        }
    }
}
