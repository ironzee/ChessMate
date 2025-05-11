//
//  SettingsView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//

//
//  SettingsView.swift
//  ChessMate
//
//  Final version as of 5/9/25

import SwiftUI
import FirebaseAuth



struct SettingsView: View {
    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool
    @ObservedObject var authManager: AuthManager
    @EnvironmentObject var settingsManager: SettingsManager

    @State private var selectedSheet: SettingsSheetType?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Profile Header
                HStack(spacing: 16) {
                    if let photoURL = authManager.currentUser?.photoURLs?.first,
                       let url = URL(string: photoURL) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.lightCoffeeGray)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(authManager.currentUser?.name ?? "User")
                            .font(.headline)
                            .foregroundColor(.espressoBrown)

                        Text("ELO Rating: \(authManager.currentUser?.elo ?? 1850)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button("Edit Photos") {
                        path.append(AppScreen.profilePhotos)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.deepForestGreen)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 4)
                .padding(.horizontal)

                // MARK: - Chess Settings
                SettingsCard(title: "Chess Settings", items: [
                    ("chessboard", "Preferred Openings", .preferredOpenings),
                    ("clock", "Time Controls", .timeControls),
                    ("arrow.triangle.2.circlepath", "Edit My Preferences", .editPreferences)
                ], selectedSheet: $selectedSheet)

                // MARK: - Match Settings
                SettingsCard(title: "Match Settings", items: [
                    ("mappin.and.ellipse", "Search Distance", .searchDistance),
                    ("cup.and.saucer", "Café Preferences", .cafePreferences),
                    ("clock.arrow.2.circlepath", "Meeting Times", .meetingTimes)
                ], selectedSheet: $selectedSheet)

                // MARK: - Account
                SettingsCard(title: "Account", items: [
                    ("bell.fill", "Notifications", .notifications),
                    ("globe", "Language", .language),
                    ("moon.fill", "Dark Mode", .darkMode)
                ], selectedSheet: $selectedSheet)

                // MARK: - Support
                SettingsCard(title: "Support", items: [
                    ("questionmark.circle", "Help Center", .helpCenter),
                    ("lock.fill", "Privacy Policy", .privacyPolicy)
                ], selectedSheet: $selectedSheet)

                // MARK: - Premium
                VStack(spacing: 12) {
                    Text("ChessMate Premium")
                        .font(.headline)
                        .foregroundColor(.espressoBrown)
                    Text("Unlock exclusive features")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Button("Upgrade to Premium") {
                        // Action TBD
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.goldenTan)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 4)
                .padding(.horizontal)

                // MARK: - Logout + Delete
                Button("Log Out") {
                    authManager.logout()
                    isLoggedIn = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.deepForestGreen))
                .foregroundColor(.deepForestGreen)
                .cornerRadius(14)
                .shadow(radius: 4)
                .padding(.horizontal)

                Button("Delete Account") {
                    // Future deletion
                }
                .foregroundColor(.red)
                .padding(.bottom)
            }
            .padding(.top)
        }
        .onAppear {
            settingsManager.fetchSettings()
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden(false)
        .sheet(item: $selectedSheet) { sheetType in
            switch sheetType {
            case .preferredOpenings: PreferredOpeningsSheet()
            case .timeControls: TimeControlSheet()
            case .searchDistance: MatchDistanceSheet()
            case .cafePreferences: CafePreferencesSheet()
            case .meetingTimes: MeetingTimeSheet()
            case .notifications: NotificationsSheet()
            case .language: LanguageSheet()
            case .darkMode: ThemeSheet()
            case .helpCenter: HelpCenterSheet()
            case .privacyPolicy: PrivacyPolicySheet()
            case .editPreferences: EditPreferencesFlow(path: $path)
            }
        }
    }
}


// MARK: - Sheet Type Enum
enum SettingsSheetType: Identifiable {
    var id: String { UUID().uuidString }

    case preferredOpenings
    case timeControls
    case searchDistance
    case cafePreferences
    case meetingTimes
    case notifications
    case language
    case darkMode
    case helpCenter
    case privacyPolicy
    case editPreferences

}

struct SettingsCard: View {
    let title: String
    let items: [(String, String, SettingsSheetType)]
    @Binding var selectedSheet: SettingsSheetType?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.footnote.bold())
                .foregroundColor(.gray)
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    Button(action: { selectedSheet = item.2 }) {
                        HStack(spacing: 12) {
                            Image(systemName: item.0)
                                .foregroundColor(.espressoBrown)

                            Text(item.1)
                                .foregroundColor(.espressoBrown)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal)
                    }

                    if index != items.count - 1 {
                        Divider()
                            .padding(.leading, 44)
                    }
                }
            }
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 4)
        }
        .padding(.horizontal)
    }
}
