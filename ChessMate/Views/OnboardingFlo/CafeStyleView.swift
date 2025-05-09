//
//  CafeStyleView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
//
//  CafeStyleView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
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

    let coffeeOrders = [
        "Black Coffee",
        "Latte",
        "Espresso Shot",
        "Iced Coffee",
        "Matcha Latte",
        "I don’t drink coffee"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your Café Preferences")
                    .font(.title)
                    .foregroundColor(.espressoBrown)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Preferred Café Vibe")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)

                    ForEach(cafeStyles, id: \.self) { style in
                        Button(action: {
                            onboardingData.cafeStyle = style
                        }) {
                            HStack {
                                Text(style)
                                Spacer()
                                if onboardingData.cafeStyle == style {
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
                    Text("Go-to Coffee Order")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)

                    ForEach(coffeeOrders, id: \.self) { order in
                        Button(action: {
                            onboardingData.coffeeOrder = order
                        }) {
                            HStack {
                                Text(order)
                                Spacer()
                                if onboardingData.coffeeOrder == order {
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

                Button("Next") {
                    path.append(AppScreen.onboardingMatchSettings)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.espressoBrown)
                .foregroundColor(.white)
                .cornerRadius(14)
                .padding(.top)

                Spacer()
            }
            .padding()
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationTitle("Café Style")
        .navigationBarTitleDisplayMode(.inline)
    }
}
