//
//  FireStoreProfile.swift
//  JP Energize
//
//  Created by Phillip Wilke on 08.10.24.
//

import Foundation
import FirebaseFirestore


struct FireUser: Codable {
    var id: String
    var email: String
    var registeredAt: Date
}


class FireStoreManager {
    var db = Firestore.firestore()
    
    private func createFireUser(withId id: String, email: String) {
        let profile = FireUser(id: id, email: email, registeredAt: Date())
        
        do {
            try db.collection("users").document(id).setData(from: profile)
        } catch {
            print("Saving user failed: \(error)")
        }
    }
}
