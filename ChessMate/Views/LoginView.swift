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

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Log In to ChessMate")
                .font(.title)
                .bold()
                .foregroundColor(.espressoBrown)

            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.lightCoffeeGray)
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.lightCoffeeGray)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            if !loginError.isEmpty {
                Text(loginError)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button(action: {
                authManager.login(email: email, password: password) { success, error in
                    if success {
                        isLoggedIn = true
                        path = NavigationPath()      // ⬅️ clears the stack
                        path.append(AppScreen.home)                    } else {
                        loginError = error ?? "Login failed"
                    }
                }
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.deepForestGreen)
                    .foregroundColor(.creamWhite)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Button("Forgot Password?") {
                // Add password reset later
            }
            .foregroundColor(.espressoBrown)
            .underline()

            Spacer()
        }
        .padding()
        .background(Color.creamWhite)
        .ignoresSafeArea()
    }
}
