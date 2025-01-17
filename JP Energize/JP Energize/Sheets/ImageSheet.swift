//
//  ImageSheet.swift
//  JP Energize
//
//  Created by Phillip Wilke on 10.10.24.
//
import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct ImageSheet: View {
    
    @Binding var selectedImage: UIImage?
    @Binding var sheetShowing: Bool
    @State var showImagePicker: Bool = false
    @Environment(\.dismiss) var dismiss  // Dismiss-Umgebung für das Schließen der Ansicht

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }

            Button {
                showImagePicker = true
            } label: {
                Text("Wähle ein Foto aus")
                    .foregroundStyle(.black)
            }

            if let selectedImage = selectedImage {
                Button {
                    FirebaseStorageManager.shared.uploadImageToFirebase(image: selectedImage)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        dismiss()  // Sheet nach dem Hochladen schließen
                    }
                } label: {
                    Text("Foto hochladen")
                }
            }

            Divider()
            
            // Abbrechen-Button
            Button {
                dismiss()  // Sheet ohne Auswahl schließen
            } label: {
                Text("Abbrechen")
                    .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $showImagePicker)
        }
    }
}

#Preview {
    ImageSheet(selectedImage: .constant(.thor), sheetShowing: .constant(false))
}

