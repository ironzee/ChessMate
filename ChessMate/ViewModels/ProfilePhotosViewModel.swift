//
//  ProfilePhotosViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//

//
//  ProfilePhotosViewModel.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/7/25.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class ProfilePhotosViewModel: ObservableObject {
    @Published var photos: [String?] = Array(repeating: nil, count: 6)
    @Published var showingPicker = false

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    // MARK: - Load Photos
    func loadUserPhotos() {
        guard let uid = currentUserId else { return }
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let urls = data["photoURLs"] as? [String] {
                DispatchQueue.main.async {
                    for i in 0..<min(self.photos.count, urls.count) {
                        self.photos[i] = urls[i]
                    }
                }
            }
        }
    }

    // MARK: - Add Photo
    func pickNewPhoto() {
        showingPicker = true
    }

    func handlePickedImage(_ image: UIImage?) {
        guard let image = image,
              let uid = currentUserId,
              let data = image.jpegData(compressionQuality: 0.8)
        else { return }

        let index = photos.firstIndex(where: { $0 == nil }) ?? photos.count
        guard index < photos.count else { return }

        let ref = storage.reference().child("profile_photos/\(uid)/photo_\(index).jpg")

        ref.putData(data, metadata: nil) { _, error in
            if error == nil {
                ref.downloadURL { url, _ in
                    DispatchQueue.main.async {
                        self.photos[index] = url?.absoluteString
                        self.saveChanges()
                    }
                }
            }
        }
    }

    // MARK: - Remove Photo
    func removePhoto(at index: Int) {
        guard index < photos.count, let uid = currentUserId else { return }

        // Remove from storage
        let ref = storage.reference().child("profile_photos/\(uid)/photo_\(index).jpg")
        ref.delete { error in
            if let error = error {
                print("❌ Failed to delete photo from storage: \(error.localizedDescription)")
            } else {
                print("🗑️ Photo deleted from storage")
            }
        }

        // Clear the slot and sync Firestore
        photos[index] = nil
        saveChanges()
    }

    // MARK: - Sync to Firestore
    func saveChanges() {
        guard let uid = currentUserId else { return }
        let validURLs = photos.compactMap { $0 }
        db.collection("users").document(uid).updateData(["photoURLs": validURLs]) { error in
            if let error = error {
                print("❌ Error saving changes: \(error.localizedDescription)")
            } else {
                print("✅ Photo changes saved")
            }
        }
    }
}
