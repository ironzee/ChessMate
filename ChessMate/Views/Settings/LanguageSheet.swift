//
//  LanguageSheet.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/10/25.
//

import Foundation
//
//  LanguageSheet.swift
//  ChessMate
//

import SwiftUI

struct LanguageSheet: View {
    @State private var selectedLang = "English"
    let languages = ["English", "Spanish", "French"]
    @State private var showSavedText = false

    var body: some View {
        SheetContainer(title: "Language") {
            Picker("Select Language", selection: $selectedLang) {
                ForEach(languages, id: \.self) { lang in
                    Text(lang)
                }
            }
            .pickerStyle(WheelPickerStyle())

            Button("Save") {
                // Save to local settings or future i18n config
                showSavedText = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showSavedText = false
                }
            }

            if showSavedText {
                Text("Saved ✅")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}
