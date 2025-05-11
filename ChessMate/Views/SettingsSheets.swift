//
//  SettingsSheets.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/9/25.
//

import Foundation
import SwiftUI

struct SettingsSheets: View {
    var body: some View {
        Text("Use each individual sheet below as needed.")
    }
}

// MARK: - Edit Profile Sheet
struct EditProfileSheet: View {
    @State private var name = ""
    @State private var bio = ""

    var body: some View {
        SheetContainer(title: "Edit Profile") {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Bio", text: $bio)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Save") {}
        }
    }
}

// MARK: - Chess Preferences Sheet
struct ChessPreferencesSheet: View {
    @State private var playStyle = ""
    @State private var openingMove = ""
    @State private var bringBuddy = false

    var body: some View {
        SheetContainer(title: "Chess Preferences") {
            TextField("Play Style", text: $playStyle)
            TextField("Favorite Opening", text: $openingMove)
            Toggle("Bring a Buddy", isOn: $bringBuddy)

            Button("Save") {}
        }
    }
}

// MARK: - Match History Sheet
struct MatchHistorySheet: View {
    var body: some View {
        SheetContainer(title: "Match History") {
            List {
                Text("May 5 – Chess & Bean – Win")
                Text("May 2 – Coffee & Knights – Draw")
                Text("Apr 28 – The Chess House – Loss")
            }
        }
    }
}

// MARK: - Achievements Sheet
struct BadgesSheet: View {
    var body: some View {
        SheetContainer(title: "Achievements") {
            HStack {
                Image(systemName: "star.fill")
                Text("Opening Master")
                Spacer()
                Text("Unlocked")
            }
            .padding()
            .background(Color.goldenTan.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

// MARK: - Favorite Cafés Sheet
struct FavoriteCafesSheet: View {
    var body: some View {
        SheetContainer(title: "Favorite Cafés") {
            List {
                Text("Café Central")
                Text("The Chess House")
            }
        }
    }
}

// MARK: - Notification Preferences Sheet


// MARK: - Privacy Sheet
struct PrivacySheet: View {
    @State private var locationEnabled = true
    @State private var showElo = true

    var body: some View {
        SheetContainer(title: "Privacy Settings") {
            Toggle("Enable Location", isOn: $locationEnabled)
            Toggle("Show ELO on Profile", isOn: $showElo)
        }
    }
}

// MARK: - Theme Sheet


// MARK: - Sheet UI Wrapper
struct SheetContainer<Content: View>: View {
    var title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2.bold())
                .foregroundColor(.espressoBrown)

            content

            Spacer()
        }
        .padding()
        .background(Color.creamWhite)
        .cornerRadius(30)
        .presentationDetents([.medium, .large])
    }
}
// MARK: - Preferred Openings Sheet
struct PreferredOpeningsSheet: View {
    @State private var opening = ""

    var body: some View {
        SheetContainer(title: "Preferred Openings") {
            TextField("e.g. Queen’s Gambit", text: $opening)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Save") {}
        }
    }
}

// MARK: - Time Control Sheet
struct TimeControlSheet: View {
    @State private var selected = "Blitz"
    let options = ["Blitz", "Rapid", "Classical"]

    var body: some View {
        SheetContainer(title: "Time Controls") {
            Picker("Choose format", selection: $selected) {
                ForEach(options, id: \.self) { Text($0) }
            }
            .pickerStyle(SegmentedPickerStyle())
            Button("Save") {}
        }
    }
}

// MARK: - Match Distance Sheet


// MARK: - Café Preferences Sheet
struct CafePreferencesSheet: View {
    @State private var favorite = ""

    var body: some View {
        SheetContainer(title: "Café Preferences") {
            TextField("e.g. Cozy, outdoor seating", text: $favorite)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Save") {}
        }
    }
}

// MARK: - Meeting Time Sheet


// MARK: - Help Center Sheet
struct HelpCenterSheet: View {
    var body: some View {
        SheetContainer(title: "Help Center") {
            Text("Need help? Contact support@chessmate.app")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

// MARK: - Privacy Policy Sheet
struct PrivacyPolicySheet: View {
    var body: some View {
        SheetContainer(title: "Privacy Policy") {
            ScrollView {
                Text("Your data is safe with us. We don't share your information with anyone.")
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
    }
}
