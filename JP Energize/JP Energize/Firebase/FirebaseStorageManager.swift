//
//  FirebaseStorageManager.swift
//  JP Energize
//
//  Created by Phillip Wilke on 24.10.24.
//

import Foundation
import UIKit
import FirebaseStorage


class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    let storageRef = Storage.storage().reference()
    
    func uploadImageToFirebase(image: UIImage) {
        
        let imageData = image.jpegData(compressionQuality: 0.8)
        let fileName = UUID().uuidString // Eindeutiger Dateiname
        
        let imageRef = storageRef.child("profileImages/\(fileName).jpg")
        
        if let imageData = imageData {
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Fehler beim Hochladen: \(error.localizedDescription)")
                    return
                }
                
                // URL des Bildes erhalten
                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Fehler beim Abrufen der Bild-URL: \(error.localizedDescription)")
                    } else if let url = url {
                        let imageUrl = url.absoluteString
                        self.saveImageUrlToFirestore(imageUrl: imageUrl)
                    }
                }
            }
        }
    }
    
    func saveImageUrlToFirestore(imageUrl: String) {
        let db = FirestoreManager.shared.db
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        db.collection("users").document(userId).setData(["profileImageUrl": imageUrl], merge: true) { error in
            if let error = error {
                print("Fehler beim Speichern der URL in Firestore: \(error.localizedDescription)")
            } else {
                print("Profilbild-URL erfolgreich in Firestore gespeichert.")
            }
        }
    }
    
}
