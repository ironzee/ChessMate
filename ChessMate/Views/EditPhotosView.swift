//
//  EditPhotosView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//

//
//  EditPhotosView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//

//
//  EditPhotosView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//
import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct EditPhotosView: View {
    var tempData: SignUpTempData
    var authManager: AuthManager
    @Binding var isLoggedIn: Bool
    @Binding var path: NavigationPath

    @State private var photos: [UIImage?] = Array(repeating: nil, count: 6)
    @State private var photoSlotIndex: Int? = nil
    @State private var showingPhotoPicker = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var isUploading = false
    @State private var uploadStatus: String?

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Profile Photos")
                    .font(.title2.bold())
                    .foregroundColor(.espressoBrown)

                Spacer()

                Button("Save") {
                    uploadAllPhotos()
                }
                .foregroundColor(.deepForestGreen)
            }
            .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                ForEach(0..<6) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(height: 100)

                        if let image = photos[index] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 100)
                                .clipped()
                                .cornerRadius(8)
                        } else {
                            Button {
                                photoSlotIndex = index
                                showingPhotoPicker = true
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

            Spacer()

            if isUploading {
                ProgressView("Uploading...")
                    .padding(.bottom)
            }

            if let uploadStatus = uploadStatus {
                Text(uploadStatus)
                    .font(.caption)
                    .foregroundColor(.deepForestGreen)
                    .padding(.bottom)
            }

            Button("Upload Photos") {
                uploadAllPhotos()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.deepForestGreen)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .padding(.top)
        .background(Color.creamWhite.ignoresSafeArea())
        .photosPicker(isPresented: $showingPhotoPicker, selection: $photoPickerItem, matching: .images)
        .onChange(of: photoPickerItem) { _ in loadPhoto() }
    }

    func loadPhoto() {
        guard let item = photoPickerItem, let index = photoSlotIndex else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data?):
                    if let uiImage = UIImage(data: data) {
                        photos[index] = uiImage
                    }
                case .success(nil):
                    print("❌ No data")
                case .failure(let error):
                    print("❌ Error loading photo: \(error)")
                }
            }
        }
    }

    func uploadAllPhotos() {
        isUploading = true
        uploadStatus = nil

        let nonNilPhotos = photos.compactMap { $0 }
        guard !nonNilPhotos.isEmpty else {
            uploadStatus = "Please select at least one photo."
            isUploading = false
            return
        }

        Auth.auth().createUser(withEmail: tempData.email, password: tempData.password) { result, error in
            if let error = error {
                print("❌ Auth error: \(error.localizedDescription)")
                uploadStatus = "❌ Failed to create user."
                isUploading = false
                return
            }

            guard let user = result?.user else {
                print("❌ Missing user after sign up")
                uploadStatus = "❌ Failed to create user."
                isUploading = false
                return
            }

            let uid = user.uid
            let dispatchGroup = DispatchGroup()
            var uploadedURLs: [URL] = []

            for (index, image) in nonNilPhotos.enumerated() {
                guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
                dispatchGroup.enter()

                let storageRef = Storage.storage().reference()
                    .child("profile_photos/\(uid)/photo_\(index).jpg")

                storageRef.putData(data, metadata: nil) { _, error in
                    if let error = error {
                        print("❌ Upload error: \(error.localizedDescription)")
                        dispatchGroup.leave()
                        return
                    }

                    storageRef.downloadURL { url, _ in
                        if let url = url {
                            uploadedURLs.append(url)
                        }
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                let newUser = UserModel(
                    uid: uid,
                    name: tempData.name,
                    email: tempData.email,
                    location: tempData.location,
                    elo: 1200,
                    wins: 0,
                    losses: 0,
                    createdAt: Date(),
                    photoURLs: uploadedURLs.map { $0.absoluteString }
                )

                UserManager.shared.saveUser(user: newUser) { error in
                    if let error = error {
                        print("❌ Failed to save user: \(error.localizedDescription)")
                        return
                    }

                    authManager.loadUserProfile(uid: uid) { success in
                        isUploading = false
                        if success {
                            isLoggedIn = true
                            path = NavigationPath()

                            if authManager.currentUser?.hasCompletedOnboarding == true {
                                path.append(AppScreen.home)
                            } else {
                                path.append(AppScreen.onboarding)
                            }

                            uploadStatus = "✅ Account created and photos uploaded!"
                        } else {
                            uploadStatus = "Failed to load user profile."
                        }
                    }
                }
            }
        }
    }
}
