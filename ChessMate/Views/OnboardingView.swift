//
//  OnboardingView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var path: NavigationPath
    @State private var displayName = ""
    @State private var selectedSkillLevel = ""
    @State private var coffeeOrder = ""
    @State private var playstyle = ""
    @State private var selectedDays: [String] = []
    
    let skillLevels = ["Beginner", "Intermediate", "Advanced"]
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Create Your Profile")
                    .font(.title)
                    .foregroundColor(.espressoBrown)
                
                // Upload Photo
                Button(action: {
                    // Action to upload photo
                }) {
                    VStack {
                        Image(systemName: "camera.fill")
                            .font(.largeTitle)
                            .padding()
                        Text("Upload Photo")
                            .foregroundColor(.espressoBrown)
                    }
                    .frame(width: 140, height: 140)
                    .background(Color.lightCoffeeGray)
                    .clipShape(Circle())
                }
                
                // Display Name Field
                TextField("Display Name", text: $displayName)
                    .padding()
                    .background(Color.lightCoffeeGray)
                    .cornerRadius(12)
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)

                // Skill Level Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Skill Level")
                        .foregroundColor(.espressoBrown)
                    
                    Picker("Skill Level", selection: $selectedSkillLevel) {
                        ForEach(skillLevels, id: \.self) { level in
                            Text(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)

                // Coffee Order Prompt
                TextField("My go-to coffee order is...", text: $coffeeOrder)
                    .padding()
                    .background(Color.lightCoffeeGray)
                    .cornerRadius(12)
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)
                
                // Playstyle Prompt
                TextField("My playstyle is best described as...", text: $playstyle)
                    .padding()
                    .background(Color.lightCoffeeGray)
                    .cornerRadius(12)
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)

                // Availability Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("When are you usually free?")
                        .foregroundColor(.espressoBrown)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Button(action: {
                                toggleDay(day)
                            }) {
                                Text(day.prefix(3)) // Show Mon, Tue, etc.
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedDays.contains(day) ? Color.deepForestGreen : Color.lightCoffeeGray)
                                    .foregroundColor(selectedDays.contains(day) ? .creamWhite : .espressoBrown)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // NEXT Button
                Button(action: {
                    path.removeLast(path.count)
                    path = NavigationPath()      // ⬅️ clears the stack
                    path.append(AppScreen.home)                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.deepForestGreen)
                        .foregroundColor(.creamWhite)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color.creamWhite.ignoresSafeArea())
    }
    
    private func toggleDay(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.removeAll { $0 == day }
        } else {
            selectedDays.append(day)
        }
    }
}

#Preview {
    OnboardingView(path: .constant(NavigationPath()))
}
