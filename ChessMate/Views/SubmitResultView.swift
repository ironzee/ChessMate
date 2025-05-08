//
//  SubmitResultView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import Foundation
import SwiftUI

struct SubmitResultView: View {
    @Binding var path: NavigationPath
    @State private var selectedResult: MatchResult? = nil
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                
                // Title
                Text("How did your match go?")
                    .font(.title)
                    .foregroundColor(.espressoBrown)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                // Win / Loss / Draw Buttons
                VStack(spacing: 16) {
                    ResultButton(title: "Win", color: .deepForestGreen, isSelected: selectedResult == .win) {
                        selectedResult = .win
                    }
                    
                    ResultButton(title: "Loss", color: .goldenTan, isSelected: selectedResult == .loss) {
                        selectedResult = .loss
                    }
                    
                    ResultButton(title: "Draw", color: .lightCoffeeGray, isSelected: selectedResult == .draw) {
                        selectedResult = .draw
                    }
                }
                .padding(.horizontal)

                // Upload Board Photo (Optional)
                Button(action: {
                    // Upload board photo logic (optional future feature)
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Upload Board Photo (Optional)")
                    }
                    .foregroundColor(.espressoBrown)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.lightCoffeeGray)
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()

                // Submit Button
                Button(action: {
                    if selectedResult != nil {
                        showingConfirmation = true
                        path.append(AppScreen.submitResult)

                    }
                }) {
                    Text("Submit Result")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedResult != nil ? Color.deepForestGreen : Color.lightCoffeeGray)
                        .foregroundColor(selectedResult != nil ? .creamWhite : .espressoBrown.opacity(0.6))
                        .cornerRadius(12)
                }
                .padding()
                .disabled(selectedResult == nil)
                .alert("Result Submitted!", isPresented: $showingConfirmation) {
                    Button("OK", role: .cancel) { }
                }
            }
            .background(Color.creamWhite.ignoresSafeArea())
            .navigationTitle("Submit Result")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Result Button Component

struct ResultButton: View {
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSelected ? color : Color.lightCoffeeGray)
                .foregroundColor(isSelected ? .creamWhite : .espressoBrown)
                .cornerRadius(12)
        }
    }
}

// MARK: - Result Types

enum MatchResult {
    case win, loss, draw
}

#Preview {
    SubmitResultView(path: .constant(NavigationPath()))
}
