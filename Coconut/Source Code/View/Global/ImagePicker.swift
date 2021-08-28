//
//  ImagePicker.swift
//  Coconut
//
//  Created by sh on 8/28/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode // allows you to dismiss the image picker overlay
    @Binding var selectedImage: UIImage // selected image binding
    @Binding var didSet: Bool // tells if the view was set or cancelled
    var sourceType = UIImagePickerController.SourceType.photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.tintColor = .clear
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let control: ImagePicker
        
        init(_ control: ImagePicker) {
            self.control = control
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                control.selectedImage = image
                control.didSet = true
            }
            control.presentationMode.wrappedValue.dismiss()
        }
    }
}
