//
//  CafeStyleView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
//
import SwiftUI

struct CafeStyleView: View {
    @Binding var path: NavigationPath
    @Binding var onboardingData: OnboardingData

    let cafeStyles = [
        "Trendy & Social",
        "Quiet & Artsy",
        "Classic Local Spot",
        "Outdoors Café",
        "Anywhere with WiFi ☕📶"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Café Vibe")
                .font(.title)
                .foregroundColor(.espressoBrown)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(cafeStyles, id: \.self) { style in
                    Button(action: {
                        onboardingData.cafeStyle = style
                        path.append(AppScreen.onboardingCoffeeOrder)
                    }) {
                        HStack {
                            Text(style)
                            Spacer()
                            if onboardingData.cafeStyle == style {
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
        .navigationTitle("Café Style")
        .navigationBarTitleDisplayMode(.inline)
    }
}
