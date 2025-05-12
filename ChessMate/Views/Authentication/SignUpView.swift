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

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Create Account")
                .font(.title)
                .bold()
                .foregroundColor(.espressoBrown)

            Group {
                TextField("Full Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)
                SecureField("Confirm Password", text: $confirmPassword)
                TextField("City / Location", text: $location)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button("Sign Up") {
                guard password == confirmPassword else {
                    errorMessage = "Passwords do not match"
                    return
                }

                guard !name.isEmpty else {
                    errorMessage = "Please enter your name"
                    return
                }

                // Go to EditPhotosView and pass info forward
                DispatchQueue.main.async {
                    path.append(AppScreen.editPhotosTemp(SignUpTempData(
                        name: name,
                        email: email,
                        password: password,
                        location: location
                    )))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.deepForestGreen)
            .foregroundColor(.creamWhite)
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color.creamWhite)
        .ignoresSafeArea()
    }
}

struct SignUpTempData {
    let name: String
    let email: String
    let password: String
    let location: String
}
