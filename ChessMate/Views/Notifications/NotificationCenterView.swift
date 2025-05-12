//
//  NotificationCenterView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import SwiftUI
import Foundation

struct NotificationCenterView: View {
    @Binding var path: NavigationPath
    var currentUserId: String

    @State private var selectedFilter = "All"
    private let filters = ["All", "Matches", "Reminders", "Updates"]

    @StateObject private var viewModel = MatchRequestViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Top Bar
                HStack {
                    Button(action: {
                        path.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.espressoBrown)
                    }

                    Text("Notifications")
                        .font(.title.bold())
                        .foregroundColor(.espressoBrown)
                        .padding(.leading, 8)

                    Spacer()
                }
                .padding(.horizontal)

                // Filter Tabs
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter)
                                .padding(.vertical, 20)
                                .background(
                                    selectedFilter == filter ? Color.goldenTan : Color.lightCoffeeGray.opacity(0.4)
                                )
                                .foregroundColor(.espressoBrown)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)

                // New Profile Matches (Static UI for now)
                VStack(alignment: .leading, spacing: 12) {
                    Text("New Profile Matches")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(["Alex", "Sam", "Jordan", "Taylor", "Casey"], id: \.self) { name in
                                VStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 56, height: 56)
                                        .overlay(Text(String(name.prefix(1))).fontWeight(.bold).foregroundColor(.white))
                                    Text(name)
                                        .font(.caption)
                                        .foregroundColor(.espressoBrown)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                // New Messages Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("New Messages")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)
                        .padding(.horizontal)

                    ForEach(mockNewMessages, id: \.id) { message in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(message.senderName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(message.timeAgo)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Text(message.preview)
                                .font(.subheadline)
                                .foregroundColor(.espressoBrown)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(18)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }

                // Dynamic Section
                switch selectedFilter {
                case "All": allNotificationsView
                case "Matches": matchNotificationsView
                case "Reminders": reminderNotificationsView
                case "Updates": updateNotificationsView
                default: allNotificationsView
                }

                if selectedFilter == "All" || selectedFilter == "Matches" {
                    Text("Yesterday")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)
                        .padding(.horizontal)

                    matchHistoryView
                }

                Spacer(minLength: 40)
            }
            .padding(.top)
        }
        .onAppear {
            guard !currentUserId.isEmpty else {
                print("❌ currentUserId is empty. Skipping listener setup.")
                return
            }
            viewModel.startListening(for: currentUserId)
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)

    }

    // MARK: - Filtered Sections

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

    // MARK: - Card Components

    func challengeCard(for request: MatchRequestModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .overlay(Text(String(request.name?.prefix(1) ?? "?")).foregroundColor(.white))

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(request.name ?? "Someone") wants to play chess!")
                            .fontWeight(.semibold)
                        Spacer()
                        if let createdAt = request.createdAt {
                            Text(relativeTime(createdAt))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    HStack(spacing: 6) {
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
                .cornerRadius(12)

                Button("Decline") {
                    // Future: handle decline
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.lightCoffeeGray)
                .foregroundColor(.espressoBrown)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 2)
        .padding(.horizontal)
    }

    var upcomingMatchCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Upcoming match with Marcus")
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

            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 120)
                .overlay(Text("🗺 Map Preview").foregroundColor(.gray))

            Text("1 hour until match")
                .font(.footnote)
                .foregroundColor(.deepForestGreen)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 2)
        .padding(.horizontal)
    }

    var matchResultCard: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                .foregroundColor(.espressoBrown)

            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.deepForestGreen)
                Text("Match logged successfully")
            }
            .font(.footnote)
            .foregroundColor(.deepForestGreen)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 2)
    }

    var reminderCard: some View {
        VStack(alignment: .leading, spacing: 12) {
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
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 2)
        .padding(.horizontal)
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
struct NewMessagePreview: Identifiable {
    let id = UUID()
    let senderName: String
    let preview: String
    let timeAgo: String
}

let mockNewMessages: [NewMessagePreview] = [
    NewMessagePreview(senderName: "Morgan", preview: "Hey, are you free this evening?", timeAgo: "10m ago"),
    NewMessagePreview(senderName: "Riley", preview: "Thanks for the coffee recommendation!", timeAgo: "25m ago")
]
