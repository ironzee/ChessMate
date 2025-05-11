//
//  WelcomeView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//
//
//  WelcomeView.swift
//  ChessMate
//
//  Created by Zulfiqur on 4/26/25.
//

import SwiftUI
import FirebaseAuth

struct WelcomeView: View {
    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool
    @ObservedObject var authManager: AuthManager

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Image("knight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .foregroundColor(.espressoBrown)

                Text("ChessMate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.espressoBrown)

                Text("Where Chess Meets Coffee")
                    .font(.subheadline)
                    .foregroundColor(.espressoBrown.opacity(0.4))
            }

            VStack(spacing: 32) {
                Text("Welcome to ChessMate")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.espressoBrown)

                Text("Connect with chess players over coffee")
                    .foregroundColor(.espressoBrown.opacity(0.3))
            }

            VStack(spacing: 16) {
                Button(action: {
                    path.append(AppScreen.login)
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Continue with Email")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.espressoBrown)
                    .foregroundColor(.creamWhite)
                    .cornerRadius(14)
                }

//                Button(action: {
//                    // TODO: Apple sign in
//                }) {
//                    HStack {
//                        Image(systemName: "apple.logo")
//                        Text("Continue with Apple")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.deepForestGreen)
//                    .foregroundColor(.creamWhite)
//                    .cornerRadius(14)
//                }
//
//                Button(action: {
//                    // TODO: Google sign in
//                }) {
//                    HStack {
//                        Image(systemName: "g.circle.fill")
//                        Text("Continue with Google")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.deepForestGreen)
//                    .foregroundColor(.creamWhite)
//                    .cornerRadius(14)
//                }
//
//                Button(action: {
//                    // TODO: Facebook sign in
//                }) {
//                    HStack {
//                        Image(systemName: "f.circle.fill")
//                        Text("Continue with Facebook")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.deepForestGreen)
//                    .foregroundColor(.creamWhite)
//                    .cornerRadius(14)
//                }

                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.espressoBrown.opacity(0.2))
                    Text("or")
                        .foregroundColor(.espressoBrown.opacity(0.3))
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.espressoBrown.opacity(0.2))
                }

                Button(action: {
                    

                }) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Continue as Guest")
                    }
                    .foregroundColor(.goldenTan)
                }
            }
            .padding(.horizontal)

            VStack(spacing: 8) {
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.espressoBrown.opacity(0.3))
                    Button("Sign up") {
                        path.append(AppScreen.signup)
                    }
                    .foregroundColor(.goldenTan)
                }

                Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                    .font(.footnote)
                    .foregroundColor(.espressoBrown.opacity(0.3))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top, 20)
        .background(Color.creamWhite)
        .ignoresSafeArea()
    }
}
