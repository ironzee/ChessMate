//
//  PhotoPickerView.swift
//  ChessMate
//
//  Created by Zulfiqur on 5/4/25.
//

import Foundation
import SwiftUI
import PhotosUI


struct PhotoPickerView: UIViewControllerRepresentable {
    var completion: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var completion: (UIImage?) -> Void

        init(completion: @escaping (UIImage?) -> Void) {
            self.completion = completion
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let result = results.first else {
                completion(nil)
                return
            }

            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, _ in
                DispatchQueue.main.async {
                    self.completion(reading as? UIImage)
                }
            }
        }
    }
}
