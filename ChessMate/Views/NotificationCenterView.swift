//
//  NotificationCenterView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import Foundation
import SwiftUI


struct NotificationCenterView: View {
    @Binding var path: NavigationPath
    @State private var selectedFilter = "All"
    private let filters = ["All", "Matches", "Reminders", "Updates"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Notifications")
                    .font(.title)
                    .bold()
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)

                // Filter Tabs
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
                                        Color.goldenTan :
                                        Color.lightCoffeeGray.opacity(0.4)
                                )
                                .foregroundColor(.espressoBrown)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)

                // Today Section Title
                Text("Today")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)

                // Dynamic section based on filter
                Group {
                    switch selectedFilter {
                    case "All":
                        allNotificationsView
                    case "Matches":
                        matchNotificationsView
                    case "Reminders":
                        reminderNotificationsView
                    case "Updates":
                        updateNotificationsView
                    default:
                        allNotificationsView
                    }
                }

                Spacer(minLength: 40)

                // Yesterday Section (common for all filters)
                if selectedFilter == "All" || selectedFilter == "Matches" {
                    Text("Yesterday")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)
                        .padding(.horizontal)

                    matchHistoryView
                }
            }
        }
        .background(Color.creamWhite.ignoresSafeArea())
    }

    // MARK: - Sections for each filter

    var allNotificationsView: some View {
        VStack(spacing: 16) {
            challengeCard
            upcomingMatchCard
        }
    }

    var matchNotificationsView: some View {
        VStack(spacing: 16) {
            upcomingMatchCard
        }
    }

    var reminderNotificationsView: some View {
        VStack(spacing: 16) {
            reminderCard
        }
    }

    var updateNotificationsView: some View {
        VStack(spacing: 16) {
            Text("No new updates.")
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
    }

    var matchHistoryView: some View {
        VStack(spacing: 16) {
            matchResultCard
            reminderCard
        }
        .padding(.horizontal)
    }

    // MARK: - Reusable Notification Cards

    var challengeCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Image("profile_sample")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Alexandra (1850 ELO) wants to play chess!")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("15m ago")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "cup.and.saucer")
                        Text("Suggested: The Coffee Bean, 2pm today")
                    }
                    .font(.subheadline)
                    .foregroundColor(.espressoBrown)
                }
            }

            HStack {
                Button("Accept") {
                    // action
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.deepForestGreen)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Decline") {
                    // action
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.lightCoffeeGray)
                .foregroundColor(.espressoBrown)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 2))
        .padding(.horizontal)
    }

    var upcomingMatchCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Upcoming match with Marcus", systemImage: "chessboard")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                Spacer()
                Text("1h ago")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text("Today at 4:30 PM - Central Perk Café")
                .font(.subheadline)
                .foregroundColor(.espressoBrown)

            Image("map_sample")
                .resizable()
                .frame(height: 120)
                .cornerRadius(10)

            Text("1 hour until match")
                .font(.footnote)
                .foregroundColor(.deepForestGreen)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 1)
        .padding(.horizontal)
    }

    var matchResultCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Match Result: Victory!", systemImage: "crown.fill")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                Spacer()
                Text("Yesterday")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text("You won against David at The Chess Café")
                .font(.subheadline)

            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.deepForestGreen)
                Text("Match logged successfully")
            }
            .font(.footnote)
            .foregroundColor(.deepForestGreen)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 1)
    }

    var reminderCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Reminder: Rate your last match", systemImage: "clock")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                Spacer()
                Text("Yesterday")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text("Don't forget to rate your match with Sarah from yesterday")
                .font(.subheadline)
                .foregroundColor(.espressoBrown)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 1)
    }
}

#Preview {
    NotificationCenterView(path: .constant(NavigationPath()))
}
