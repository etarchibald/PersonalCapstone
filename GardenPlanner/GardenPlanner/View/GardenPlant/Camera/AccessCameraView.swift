//
//  AccessCameraView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/26/24.
//

import Foundation
import SwiftUI

struct AccessCameraView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedImages: [Data]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: AccessCameraView
    
    init(picker: AccessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? Data else { return }
        self.picker.selectedImages.append(selectedImage)
        self.picker.dismiss()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss()
    }
}
