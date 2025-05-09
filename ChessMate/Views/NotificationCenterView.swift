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
    var currentUserId: String

    @State private var selectedFilter = "All"
    private let filters = ["All", "Matches", "Reminders", "Updates"]

    @StateObject private var viewModel = MatchRequestViewModel()

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
                                    selectedFilter == filter ? Color.goldenTan : Color.lightCoffeeGray.opacity(0.4)
                                )
                                .foregroundColor(.espressoBrown)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)

                Text("Today")
                    .font(.headline)
                    .foregroundColor(.espressoBrown)
                    .padding(.horizontal)

                Group {
                    switch selectedFilter {
                    case "All": allNotificationsView
                    case "Matches": matchNotificationsView
                    case "Reminders": reminderNotificationsView
                    case "Updates": updateNotificationsView
                    default: allNotificationsView
                    }
                }

                Spacer(minLength: 40)

                if selectedFilter == "All" || selectedFilter == "Matches" {
                    Text("Yesterday")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)
                        .padding(.horizontal)

                    matchHistoryView
                }
            }
        }
        .onAppear {
            guard !currentUserId.isEmpty else {
                print("❌ currentUserId is empty. Skipping listener setup.")
                return
            }
            print("👤 currentUserId loaded in NotificationCenterView: \(currentUserId)")
            viewModel.startListening(for: currentUserId)
        }
        .background(Color.creamWhite.ignoresSafeArea())
    }

    var allNotificationsView: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.matchRequests.prefix(3)) { request in
                challengeCard(for: request)
            }
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

    // MARK: - Cards

    func challengeCard(for request: MatchRequestModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Image("profile_sample")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(request.name ?? "Someone") wants to play chess!")
                            .fontWeight(.semibold)
                            .onAppear {
                                print("📄 Rendering match request from: \(request.name), receiver: \(request.receiverId)")
                            }

                        Spacer()
                        if let createdAt = request.createdAt {
                            Text(relativeTime(createdAt))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "cup.and.saucer")
                        Text("Suggested: \(request.cafeName), \(formattedDate(request.suggestedTime))")
                    }
                    .font(.subheadline)
                    .foregroundColor(.espressoBrown)
                }
            }

            HStack {
                Button("Accept") {
                    viewModel.acceptRequest(request)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.deepForestGreen)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Decline") {
                    // Placeholder for decline
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

    // MARK: - Utilities

    func relativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
}
