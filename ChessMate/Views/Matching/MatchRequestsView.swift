//
//  MatchRequestsView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//
import Foundation
import SwiftUI

struct MatchRequestsView: View {
    @StateObject private var viewModel = MatchRequestViewModel()
    let currentUserId: String
    @State private var activeRequestForReschedule: MatchRequestModel?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.matchRequests.isEmpty {
                    Text("No match requests yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.matchRequests) { request in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "cup.and.saucer.fill")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(.goldenTan)
                                    .padding(.trailing, 8)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(request.cafeName)
                                        .font(.headline)
                                        .foregroundColor(.espressoBrown)

                                    Text(dateFormatted(request.suggestedTime))
                                        .font(.subheadline)
                                        .foregroundColor(.espressoBrown)


                                    Text("Status: \(request.status.capitalized)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()
                            }

                            HStack(spacing: 12) {
                                Button("Accept") {
                                    viewModel.acceptRequest(request)
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.deepForestGreen)
                                .cornerRadius(12)

                                Button("Suggest New Time") {
                                    activeRequestForReschedule = request
                                }
                                .font(.headline)
                                .foregroundColor(.espressoBrown)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.lightCoffeeGray)
                                .cornerRadius(12)
                            }
                        }
                        .sheet(item: $activeRequestForReschedule) { request in
                            SuggestMatchView(request: request) { newTime, newCafe in
                                viewModel.suggestNewTimeOrPlace(for: request, newTime: newTime, newCafeName: newCafe)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .onAppear {
            print("👂 Listening for match requests for: \(currentUserId)")
            viewModel.startListening(for: currentUserId)
        }
        .background(Color.creamWhite.ignoresSafeArea())
        .navigationTitle("Match Requests")
    }

    func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
