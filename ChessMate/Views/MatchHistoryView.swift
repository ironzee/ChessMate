//
//  MatchHistoryView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import Foundation
import SwiftUI

struct MatchHistoryView: View {
    @Binding var path: NavigationPath // <-- Add this here too

    var body: some View {
      //  NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(mockMatchHistory, id: \.id) { match in
                        MatchHistoryRow(match: match)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .background(Color.creamWhite.ignoresSafeArea())
            .navigationTitle("Match History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
//}

struct MatchHistoryRow: View {
    let match: MatchRecord
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.goldenTan)
            
            VStack(alignment: .leading) {
                Text(match.opponentName)
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                Text(match.cafeName)
                    .font(.caption)
                    .foregroundColor(.espressoBrown)
                Text(match.datePlayed, style: .date)
                    .font(.caption2)
                    .foregroundColor(.espressoBrown)
            }
            
            Spacer()
            
            Text(match.result.rawValue)
                .font(.subheadline.bold())
                .padding(8)
                .background(resultColor(match.result))
                .cornerRadius(8)
                .foregroundColor(.creamWhite)
        }
        .padding()
        .background(Color.lightCoffeeGray)
        .cornerRadius(12)
    }
    
    func resultColor(_ result: MatchResultType) -> Color {
        switch result {
        case .win:
            return .deepForestGreen
        case .loss:
            return .goldenTan
        case .draw:
            return .lightCoffeeGray
        }
    }
}

// MARK: - Mock Data for Match History

struct MatchRecord: Identifiable {
    let id = UUID()
    let opponentName: String
    let cafeName: String
    let datePlayed: Date
    let result: MatchResultType
}

enum MatchResultType: String {
    case win = "Win"
    case loss = "Loss"
    case draw = "Draw"
}

let mockMatchHistory = [
    MatchRecord(opponentName: "Olivia", cafeName: "Cozy Brews", datePlayed: Date().addingTimeInterval(-86400), result: .win),
    MatchRecord(opponentName: "Ethan", cafeName: "Pawn House", datePlayed: Date().addingTimeInterval(-172800), result: .loss),
    MatchRecord(opponentName: "Sophia", cafeName: "Queen's Café", datePlayed: Date().addingTimeInterval(-259200), result: .draw),
    MatchRecord(opponentName: "Olivia", cafeName: "Cozy Brews", datePlayed: Date().addingTimeInterval(-86400), result: .win),
    MatchRecord(opponentName: "Ethan", cafeName: "Pawn House", datePlayed: Date().addingTimeInterval(-172800), result: .loss),
    MatchRecord(opponentName: "Sophia", cafeName: "Queen's Café", datePlayed: Date().addingTimeInterval(-259200), result: .draw),
    MatchRecord(opponentName: "Olivia", cafeName: "Cozy Brews", datePlayed: Date().addingTimeInterval(-86400), result: .win),
    MatchRecord(opponentName: "Ethan", cafeName: "Pawn House", datePlayed: Date().addingTimeInterval(-172800), result: .loss),
    MatchRecord(opponentName: "Sophia", cafeName: "Queen's Café", datePlayed: Date().addingTimeInterval(-259200), result: .draw),
    MatchRecord(opponentName: "Olivia", cafeName: "Cozy Brews", datePlayed: Date().addingTimeInterval(-86400), result: .win),
    MatchRecord(opponentName: "Ethan", cafeName: "Pawn House", datePlayed: Date().addingTimeInterval(-172800), result: .loss),
    MatchRecord(opponentName: "Sophia", cafeName: "Queen's Café", datePlayed: Date().addingTimeInterval(-259200), result: .draw)
]

#Preview {
    MatchHistoryView(path: .constant(NavigationPath()))
}
