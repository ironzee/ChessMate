//
//  MatchSettingView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/8/25.
//

import SwiftUI

struct MatchSettingView: View {
    @Binding var matchSetting: String
    @Binding var bringBuddy: Bool
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Match Settings")
                .font(.title2.bold())
                .foregroundColor(.espressoBrown)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                matchOption("Blitz", subtitle: "5 min")
                matchOption("Casual", subtitle: "30–60 min")
                matchOption("Marathon", subtitle: "1hr+")
            }

            Toggle(isOn: $bringBuddy) {
                Text("Bring a Buddy")
                    .foregroundColor(.espressoBrown)
            }
            .toggleStyle(SwitchToggleStyle(tint: .espressoBrown))
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.goldenTan, lineWidth: 1))

            Button(action: onNext) {
                Text("Next")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.espressoBrown)
                    .cornerRadius(30)
            }

            Spacer()
        }
        .padding()
        .background(Color.creamWhite.ignoresSafeArea())
    }

    func matchOption(_ title: String, subtitle: String) -> some View {
        Button {
            matchSetting = title
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.espressoBrown)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.goldenTan, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(matchSetting == title ? Color.goldenTan.opacity(0.15) : Color.clear)
                    )
            )
        }
    }
}
