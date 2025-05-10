//
//  CoffeeOrderView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
import SwiftUI
import SwiftUI

struct CoffeeOrderView: View {
    @Binding var cafeStyle: String
    @Binding var coffeeOrder: String
    var onNext: () -> Void

    let drinks = [
        "Black Coffee",
        "Latte",
        "Espresso",
        "Iced Coffee",
        "Matcha",
        "I don’t drink coffee"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Go-To Drink")
                .font(.title)
                .foregroundColor(.espressoBrown)

            VStack(spacing: 16) {
                ForEach(drinks, id: \.self) { drink in
                    Button {
                        coffeeOrder = drink
                    } label: {
                        HStack {
                            Text(drink)
                            Spacer()
                            if coffeeOrder == drink {
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

            Button("Next") {
                onNext()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.espressoBrown)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
        .padding()
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationTitle("Coffee Order")
        .navigationBarTitleDisplayMode(.inline)
    }
}
