//
//  AttachmentUploadView.swift
//
//
//  Created by Abed alrahman Malkawi on 19/09/2024.
//

import SwiftUI
import PhotosUI

// Wrapper for PHPickerViewController
struct AttachmentPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var fileName: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: AttachmentPickerView

        init(_ parent: AttachmentPickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }
            
            // Load selected attachment
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                        self.parent.fileName = ""
                    }
                }
            } else {
                // Load other file types (e.g., PDFs)
                provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                    DispatchQueue.main.async {
                        if let url = urlData as? URL {
                            self.parent.selectedImage = nil
                            self.parent.fileName = url.lastPathComponent
                        }
                    }
                }
            }
        }
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images, .videos]) // Add filters as needed

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

struct AttachmentUploadView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var fileName: String = ""
    @State private var showPicker = false

    var body: some View {
        VStack (alignment: .center){
            if let image = selectedImage {
                // Display selected image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else if !fileName.isEmpty {
                // Display selected file name
                Text("Selected File: \(fileName)")
            } else {
                Text("No attachment selected")
            }

            Button(action: {
                showPicker = true
            }) {
                Text(selectedImage == nil ? "Upload Attachment" : "Change Attachment")
                    .padding(8.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showPicker) {
            AttachmentPickerView(selectedImage: $selectedImage, fileName: $fileName)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct AttachmentUploadView_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentUploadView()
    }
}
