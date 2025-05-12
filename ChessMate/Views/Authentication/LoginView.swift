//
//  LoginView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/30/25.
//


import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool
    @ObservedObject var authManager: AuthManager

    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.creamWhite.ignoresSafeArea()

            VStack(spacing: 24) {
                // Top Crown Icons
                HStack(spacing: 8) {
                    Image("piece_king")
                    Image("piece_queen")
                    Image("piece_bishop")
                    Image("piece_knight")

                }
                .font(.title2)
                .foregroundColor(.espressoBrown)

                // Title Texts
                Text("Where Chess Meets Romance")
                    .font(.title2.bold())
                    .foregroundColor(.espressoBrown)

                Text("Your Perfect Match Awaits")
                    .foregroundColor(.deepForestGreen)

                // Glass Container
                VStack(spacing: 16) {
                    HStack {
                        Image( "bishop.fill")
                            .foregroundColor(.espressoBrown)
                        TextField("Your Move (Email)", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .foregroundColor(.espressoBrown)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)

                    HStack {
                        Image( "rook.fill")
                            .foregroundColor(.espressoBrown)
                        SecureField("Secret Strategy (Password)", text: $password)
                            .foregroundColor(.espressoBrown)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)

                    Button(action: {
                        authManager.login(email: email, password: password) { success, error in
                            if success {
                                isLoggedIn = true
                                path = NavigationPath()
                                path.append(AppScreen.home)
                            } else {
                                loginError = error ?? "Login failed"
                            }
                        }
                    }) {
                        Text("Make Your Move")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.deepForestGreen)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 6)
                .padding(.horizontal)

                // Error message
                if !loginError.isEmpty {
                    Text(loginError)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                // Forgot Password
                Button("Forgot Password?") {
                    // TBD
                }
                .foregroundColor(.espressoBrown)

                Spacer()

                // Bottom Quote + Background
                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Image("piece_bottom_center") // example image
                            .opacity(1.0)
                    }

                    Text("Every Queen Needs Her King")
                        .font(.footnote)
                        .foregroundColor(.goldenTan)

                    Image("checkerboard_fade")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .opacity(0.4)
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
        .preferredColorScheme(.light) // 👈 Force Light Mode
    }
       
}
