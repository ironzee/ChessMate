//
//  MatchCardView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/9/25.
//

import Foundation
import SwiftUI

struct MatchCardView: View {
    let request: MatchRequestModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.fill")
                Text("vs")
                Image(systemName: "person.fill")
            }
            .font(.subheadline)
            .foregroundColor(.black)

            Text(request.cafeName)
                .font(.headline)
                .foregroundColor(.espressoBrown)

            Text(formatDate(request.suggestedTime))
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Confirmed")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.deepForestGreen)
                .cornerRadius(12)
        }
        .padding()
        .frame(width: 220)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
