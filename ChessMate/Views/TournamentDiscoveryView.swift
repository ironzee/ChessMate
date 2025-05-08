//
//  TournamentDiscoveryView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//
import Foundation
import SwiftUI

struct TournamentDiscoveryView: View {
    @Binding var path: NavigationPath
    @State private var tournaments: [Tournament] = []
    @State private var showSignUpPopup = false
    @State private var selectedTournamentIndex: Int?
    @State private var selectedFilter = "Nearby"
    private let filters = ["Nearby", "This Week", "Beginner Friendly"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Text("Tournaments")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.creamWhite)
                    Spacer()
                 
                }
                .padding()
                .background(Color.espressoBrown)

                // Featured Card
                VStack(alignment: .leading, spacing: 8) {
                    Image("chessTournamentpic") // replace with real image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .overlay(
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 8) {
                                    Text("Featured")
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.deepForestGreen)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)

                                    Text("New")
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.goldenTan)
                                        .foregroundColor(.espressoBrown)
                                        .cornerRadius(8)
                                }

                                Text("City Chess Championship")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)

                                HStack(spacing: 10) {
                                    Label("The Coffee Bean", systemImage: "mappin.and.ellipse")
                                    Label("Dec 15 • 2:00 PM", systemImage: "calendar")
                                }
                                .font(.caption)
                                .foregroundColor(.white)

                                Button("Register Now") {
                                    // action
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.top, 8)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading),
                            alignment: .bottomLeading
                        )

                }
                .padding(.horizontal)

                // Filter Buttons
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedFilter == filter ?
                                    Color.goldenTan : Color.lightCoffeeGray.opacity(0.4)
                                )
                                .foregroundColor(.espressoBrown)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)

                // Tournament Cards
                ForEach(tournaments.indices, id: \.self) { index in
                    TournamentCardView(tournament: tournaments[index]) {
                        selectedTournamentIndex = index
                        showSignUpPopup = true
                    }
                
                }
                .padding(.horizontal)

                // Create Button
                Button(action: {
                    // navigate to create screen
                }) {
                    Text("Create Tournament")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.deepForestGreen)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
        .onAppear {
            tournaments = mockTournaments(for: selectedFilter)
        }
        .onChange(of: selectedFilter) { newValue in
            tournaments = mockTournaments(for: newValue)
        }

        .alert("Sign Up?", isPresented: $showSignUpPopup, actions: {
            Button("Sign Up", role: .none) {
                if let i = selectedTournamentIndex {
                    tournaments[i].isGoing = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Do you want to sign up for this tournament?")
        })

        .background(Color.creamWhite.ignoresSafeArea())
    }
}

// MARK: - Mock Data Models

struct Tournament: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let time: String
    let price: String
    let level: String
    let spotsLeft: Int
    let imageName: String
    var isGoing: Bool = false

}

func mockTournaments(for filter: String) -> [Tournament] {
    switch filter {
    case "Nearby":
        return [
            Tournament(title: "Weekend Blitz",
                       location: "Café Chess & Co.",
                       time: "Dec 10 • 1:00 PM",
                       price: "$5",
                       level: "Intermediate",
                       spotsLeft: 8,
                       imageName: "cafe1"),

            Tournament(title: "Pro Night Challenge",
                       location: "Coffee Culture Hub",
                       time: "Dec 14 • 7:00 PM",
                       price: "$15",
                       level: "Advanced",
                       spotsLeft: 4,
                       imageName: "cafe3"),
        ]

    case "This Week":
        return [
            Tournament(title: "City Chess Championship",
                       location: "The Coffee Bean",
                       time: "Dec 15 • 2:00 PM",
                       price: "$20",
                       level: "All Levels",
                       spotsLeft: 16,
                       imageName: "cafe1"),

            Tournament(title: "Saturday Showdown",
                       location: "Brickhouse Café",
                       time: "Dec 13 • 3:00 PM",
                       price: "$10",
                       level: "Intermediate",
                       spotsLeft: 6,
                       imageName: "cafe2"),
        ]

    case "Beginner Friendly":
        return [
            Tournament(title: "Beginners Welcome",
                       location: "The Daily Grind",
                       time: "Dec 12 • 5:30 PM",
                       price: "Free",
                       level: "Beginner",
                       spotsLeft: 12,
                       imageName: "cafe2"),

            Tournament(title: "Rookies & Lattes",
                       location: "Latte & Mate Café",
                       time: "Dec 11 • 6:00 PM",
                       price: "$3",
                       level: "Beginner",
                       spotsLeft: 10,
                       imageName: "cafe3"),
        ]

    default:
        return []
    }
}


// MARK: - Tournament Card Component

struct TournamentCardView: View {
    var tournament: Tournament
    var tapAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(tournament.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(tournament.title)
                            .font(.headline)
                            .lineLimit(1)
                        if tournament.isGoing {
                            Text("✅ Going")
                                .font(.caption)
                                .foregroundColor(.deepForestGreen)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.deepForestGreen.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }

                    Text(tournament.location)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    HStack(spacing: 8) {
                        Label(tournament.time, systemImage: "clock")
                        Text("\(tournament.spotsLeft) spots left")
                            .foregroundColor(.deepForestGreen)
                    }
                    .font(.caption)

                    Text("Entry: \(tournament.price)")
                        .font(.subheadline)
                        .foregroundColor(.espressoBrown)
                }

                Spacer()

                Text(tournament.level)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.lightCoffeeGray.opacity(0.5))
                    .cornerRadius(6)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
        .onTapGesture {
            tapAction()
        }
    }
}


#Preview {
    TournamentDiscoveryView(path: .constant(NavigationPath()))
}
