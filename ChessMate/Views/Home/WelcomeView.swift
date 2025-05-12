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
        ZStack {
            // MARK: - Background Chess Pieces
            Group {
                Image("piece_top_left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .position(x: 40, y: 50)

                Image("piece_top_right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .position(x: UIScreen.main.bounds.width - 40, y: 50)

                Image("piece_bottom_left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .position(x: 40, y: UIScreen.main.bounds.height - 80)

                Image("piece_bottom_right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .position(x: UIScreen.main.bounds.width - 40, y: UIScreen.main.bounds.height - 80)
                    .opacity(0.5)

                Image("piece_bottom_center")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 40)
            }

            VStack(spacing: 24) {
                Spacer()

                // MARK: - Logo & Tagline
                VStack(spacing: 12) {
                    Image("crown_heart") // placeholder for crown+heart icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)

                    Text("ChessMate")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.espressoBrown)

                    Text("Where Strategy Meets Romance")
                        .font(.subheadline)
                        .foregroundColor(.goldenTan)
                }

                // MARK: - Headline + Subtext
                VStack(spacing: 8) {
                    Text("Checkmate Your Loneliness")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.espressoBrown)

                    Text("Are you tired of dating looks? Date intelligence!")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.espressoBrown.opacity(0.7))
                        .padding(.horizontal, 32)
                }

                // MARK: - Email Button
                Button(action: {
                    path.append(AppScreen.login)
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Continue with Email")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.espressoBrown)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 4)
                }
                .padding(.horizontal, 32)

                // MARK: - Divider
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
                .padding(.horizontal, 40)

                // MARK: - Signup CTA
                VStack(spacing: 6) {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.espressoBrown.opacity(0.4))
                        Button("Sign up") {
                            path.append(AppScreen.signup)
                        }
                        .foregroundColor(.goldenTan)
                    }

                    Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.espressoBrown.opacity(0.3))
                        .padding(.horizontal, 24)
                }
                // MARK: - Bottom Row Pieces
                VStack {
                    Spacer()
                    HStack(spacing: 32) {
                        Image("piece_king")     // leftmost
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                            .opacity(0.15)

                        Image("piece_queen")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                            .opacity(0.15)

                        Image("piece_bishop")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                            .opacity(0.15)

                        Image("piece_knight")   // rightmost
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                            .opacity(0.15)
                    }
                    .padding(.bottom, 24)
                }


                Spacer()
            }
            .padding(.top, 40)
        }
        .background(Color.creamWhite.ignoresSafeArea())
    }
}
