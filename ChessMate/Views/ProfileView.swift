//
//  ProfileView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @State private var isEditingProfile = false
    @Binding var path: NavigationPath // <-- Add this here too

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Picture
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.goldenTan)
                    
                    // Display Name + Bio
                    VStack(spacing: 4) {
                        Text("Samantha")
                            .font(.title)
                            .foregroundColor(.espressoBrown)
                        
                        Text("I love aggressive playstyles & iced lattes ☕♟️")
                            .font(.subheadline)
                            .foregroundColor(.espressoBrown)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Skill Level Badge
                    Text("Advanced")
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.goldenTan)
                        .cornerRadius(20)
                        .foregroundColor(.espressoBrown)
                    
                    Divider()
                        .background(Color.lightCoffeeGray)
                        .padding(.horizontal)
                    
                    // Stats
                    HStack(spacing: 24) {
                        VStack {
                            Text("24")
                                .font(.title.bold())
                                .foregroundColor(.espressoBrown)
                            Text("Wins")
                                .font(.caption)
                                .foregroundColor(.espressoBrown)
                        }
                        
                        VStack {
                            Text("10")
                                .font(.title.bold())
                                .foregroundColor(.espressoBrown)
                            Text("Losses")
                                .font(.caption)
                                .foregroundColor(.espressoBrown)
                        }
                        
                        VStack {
                            Text("5")
                                .font(.title.bold())
                                .foregroundColor(.espressoBrown)
                            Text("Draws")
                                .font(.caption)
                                .foregroundColor(.espressoBrown)
                        }
                    }
                    
                    Divider()
                        .background(Color.lightCoffeeGray)
                        .padding(.horizontal)

                    // Favorite Opening
                    VStack(spacing: 8) {
                        Text("Favorite Opening")
                            .font(.headline)
                            .foregroundColor(.espressoBrown)
                        
                        Text("Queen's Gambit ♛")
                            .font(.subheadline)
                            .foregroundColor(.espressoBrown)
                    }
                    
                    Divider()
                        .background(Color.lightCoffeeGray)
                        .padding(.horizontal)
                    
                    // Badges
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Badges")
                            .font(.headline)
                            .foregroundColor(.espressoBrown)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                            ForEach(mockBadges, id: \.self) { badge in
                                VStack {
                                    Image(systemName: badge.icon)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.goldenTan)
                                    Text(badge.title)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.espressoBrown)
                                }
                                .padding()
                                .background(Color.lightCoffeeGray)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .background(Color.creamWhite)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Mock Data

struct Badge: Hashable {
    let title: String
    let icon: String
}

let mockBadges = [
    Badge(title: "5 Games", icon: "star.fill"),
    Badge(title: "First Win", icon: "trophy.fill"),
    Badge(title: "100 Points", icon: "crown.fill"),
    Badge(title: "5 Cafés", icon: "mappin.and.ellipse"),
]

#Preview {
    ProfileView(path: .constant(NavigationPath()))
}
