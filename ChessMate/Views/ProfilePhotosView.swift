//
//  ProfilePhotosView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//
//
//  ProfilePhotosView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//


import SwiftUI
import PhotosUI

struct ProfilePhotosView: View {
    @StateObject private var viewModel = ProfilePhotosViewModel()
    @Binding var path: NavigationPath
    @State private var photoSlotIndex: Int?
    @State private var showDeleteIcons = false


    var body: some View {
        VStack(spacing: 16) {
            Text("Profile Photos")
                .font(.title2.bold())
                .foregroundColor(.espressoBrown)

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                ForEach(0..<6) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(height: 100)

                        if let urlString = viewModel.photos[index],
                           let url = URL(string: urlString) {
                            ZStack(alignment: .topTrailing) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                         .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 100)
                                .clipped()
                                .cornerRadius(8)
                                .onLongPressGesture {
                                    withAnimation {
                                        showDeleteIcons = true
                                    }
                                }

                                if showDeleteIcons {
                                    Button(action: {
                                        withAnimation {
                                            viewModel.removePhoto(at: index)
                                            showDeleteIcons = false
                                            
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white.clipShape(Circle()))
                                    }
                                    .padding(6)
                                }
                            }
                        }
 else {
                            Button {
                                photoSlotIndex = index
                                viewModel.pickNewPhoto()
                            } label: {
                                VStack {
                                    Image(systemName: "plus")
                                    Text("Add Photo")
                                        .font(.footnote)
                                }
                                .foregroundColor(.goldenTan)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)

            Text("Drag to rearrange your photos")
                .font(.subheadline)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 4) {
                Label("Photo Guidelines", systemImage: "info.circle")
                    .font(.subheadline.bold())
                    .foregroundColor(.deepForestGreen)

                Text("• Clear, well-lit photos\n• No inappropriate content\n• No chess game screenshots\n• You must be in the photo")
                    .font(.footnote)
                    .foregroundColor(.espressoBrown)
            }
            .padding()
            .background(Color.lightCoffeeGray)
            .cornerRadius(12)
            .padding(.horizontal)

            HStack {
                Button("Save Photos") {
                    viewModel.saveChanges()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.espressoBrown)
                .foregroundColor(.white)
                .cornerRadius(12)

                Button("Edit") {
                    viewModel.pickNewPhoto()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.lightCoffeeGray)
                .foregroundColor(.espressoBrown)
                .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color.creamWhite.ignoresSafeArea())
        .sheet(isPresented: $viewModel.showingPicker) {
            PhotoPickerView { image in
                viewModel.handlePickedImage(image)
            }
        }
        .onAppear {
            viewModel.loadUserPhotos()
        }
    }
}
