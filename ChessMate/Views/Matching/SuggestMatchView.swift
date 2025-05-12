//
//  SuggestMatchView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import Foundation
import SwiftUI

struct SuggestMatchView: View {
    let request: MatchRequestModel
    var onSubmit: (Date, String) -> Void

    @Environment(\.dismiss) var dismiss

    @State private var newTime: Date = Date().addingTimeInterval(3600)
    @State private var newCafeName: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Suggest New Time & Café")
                    .font(.title2.bold())
                    .foregroundColor(.espressoBrown)

                VStack(alignment: .leading, spacing: 16) {
                    DatePicker("New Time", selection: $newTime, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .accentColor(.espressoBrown)

                    TextField("New Café Name", text: $newCafeName)
                        .padding()
                        .background(Color.lightCoffeeGray)
                        .cornerRadius(8)
                        .foregroundColor(.espressoBrown)
                }

                Spacer()

                Button("Submit Suggestion") {
                    guard !newCafeName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    onSubmit(newTime, newCafeName)
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.deepForestGreen)
                .foregroundColor(.white)
                .cornerRadius(12)

                Button("Cancel") {
                    dismiss()
                }
                .padding(.top, 4)
                .foregroundColor(.espressoBrown)

            }
            .padding()
            .background(Color.creamWhite.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SuggestMatchView(request: MatchRequestModel(
        senderId: "abc123",
        receiverId: "xyz456",
        cafeName: "Café Latte",
        suggestedTime: Date(),
        status: "pending", name: "Name"
    )) { newTime, newCafe in
        print("New suggestion: \(newTime), \(newCafe)")
    }
}
