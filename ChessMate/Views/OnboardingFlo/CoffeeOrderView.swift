//
//  CoffeeOrderView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
import SwiftUI

struct CoffeeOrderView: View {
    @Binding var cafeStyle: String
    @Binding var coffeeOrder: String
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Café Style")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.espressoBrown)

            VStack(spacing: 16) {
                cafeStyleOption("Quiet Focus", subtitle: "Minimal distractions")
                cafeStyleOption("Chill Music", subtitle: "Background ambiance")
                cafeStyleOption("Social Atmosphere", subtitle: "Open to conversation")
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Coffee Order")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)

                TextField("What's your go-to drink?", text: $coffeeOrder)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button("Next") {
                onNext()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.deepForestGreen)
            .foregroundColor(.white)
            .cornerRadius(16)

            Spacer()
        }
        .padding()
    }

    func cafeStyleOption(_ title: String, subtitle: String) -> some View {
        Button {
            cafeStyle = title
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(cafeStyle == title ? Color.deepForestGreen : Color.lightCoffeeGray, lineWidth: 2)
            )
        }
    }
}
