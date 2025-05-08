//
//  GhostModeView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import Foundation
import SwiftUI

struct GhostModeView: View {
    @Binding var path: NavigationPath // <-- Add this here too
    var body: some View {
        VStack {
            
            Text("Ghost Mode Activated")
                .font(.largeTitle)
                .foregroundColor(.espressoBrown)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.creamWhite)
        .ignoresSafeArea()
    }
}

#Preview {
    GhostModeView(path: .constant(NavigationPath()))
}
