//
//  SignUpView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/30/25.
//

import SwiftUI

struct SignUpView: View {
    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool
    @ObservedObject var authManager: AuthManager

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var location = ""
    @State private var errorMessage = ""
    @State private var isPressed = false

    var body: some View {
        ZStack {
            // Base Background
            Color.creamWhite.ignoresSafeArea()

            // Bokeh Glow Elements (abstract background lights)
            Circle()
                .fill(Color.goldenTan.opacity(0.3))
                .blur(radius: 80)
                .offset(x: -140, y: -360)

            Circle()
                .fill(Color.deepForestGreen.opacity(0.3))
                .blur(radius: 100)
                .offset(x: 120, y: -300)

            Circle()
                .fill(Color.espressoBrown.opacity(0.2))
                .blur(radius: 90)
                .offset(x: -100, y: 280)

            // Decorative Chess Pieces
            Image("piece_queen")
                .resizable()
                .scaledToFit()
                .frame(width: 140)
                .opacity(0.06)
                .offset(x: -130, y: -320)

            Image("piece_king")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .opacity(0.05)
                .offset(x: 140, y: -280)

            Image("piece_knight")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .opacity(0.05)
                .offset(x: -100, y: 200)

            VStack(spacing: 20) {
                // Header
                HStack(spacing: 8) {
                    Image("piece_king")
                    Image( "piece_queen")
                    Image( "cpiece_king")
                }
                .font(.title2)
                .foregroundColor(.espressoBrown)

                Text("Find Your Perfect Match")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.espressoBrown)

                Text("Where Chess Lovers Connect")
                    .foregroundColor(.deepForestGreen)

                // Card Form (Glass)
                VStack(spacing: 16) {
                    glassField(icon: "person", placeholder: "Full Name", text: $name)
                    glassField(icon: "envelope", placeholder: "Email", text: $email, isEmail: true)
                    glassField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                    glassField(icon: "lock", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                    glassField(icon: "mappin.and.ellipse", placeholder: "City / Location", text: $location)

                    // Button Glow Tap Effect
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isPressed = false
                        }

                        guard password == confirmPassword else {
                            errorMessage = "Passwords do not match"
                            return
                        }

                        guard !name.isEmpty else {
                            errorMessage = "Please enter your name"
                            return
                        }

                        path.append(AppScreen.editPhotosTemp(SignUpTempData(
                            name: name,
                            email: email,
                            password: password,
                            location: location
                        )))
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                ZStack {
                                    Color.deepForestGreen
                                    if isPressed {
                                        Color.white.opacity(0.2)
                                            .blur(radius: 10)
                                            .scaleEffect(1.05)
                                    }
                                }
                            )
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(color: .deepForestGreen.opacity(0.3), radius: 10, x: 0, y: 6)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                .padding(.horizontal)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                Spacer()

                VStack(spacing: 6) {
                    Image("piece_bottom_center")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48)
                        .opacity(0.7)

                    Text("Every Queen Needs Her King")
                        .font(.footnote)
                        .foregroundColor(.goldenTan)

                    Image("checkerboard_fade")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280)
                        .opacity(0.35)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.espressoBrown)
                    Text("Back")
                        .foregroundColor(.espressoBrown)
                        .fontWeight(.medium)
                }
                .onTapGesture {
                    path.removeLast()
                }
            }
        }
        .preferredColorScheme(.light)
    }

    // Glass UI text field row
    @ViewBuilder
    func glassField(icon: String, placeholder: String, text: Binding<String>, isSecure: Bool = false, isEmail: Bool = false) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.espressoBrown)

            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
                    .keyboardType(isEmail ? .emailAddress : .default)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct SignUpTempData {
    let name: String
    let email: String
    let password: String
    let location: String
}
