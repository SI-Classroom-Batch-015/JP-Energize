//
//  FireStoreProfile.swift
//  JP Energize
//
//  Created by Phillip Wilke on 08.10.24.
//

import Foundation
import FirebaseFirestore


struct Profile: Codable {
    var id: String
    var email: String
    var registeredAt: Date
    var firstName: String
    var lastName: String
    var phoneNumber: String = ""
    var updatedAt: Date? = nil
    var address: String = ""
}

extension Profile {
    static var sample = Profile(id: "1234567890", email: "test@test.com", registeredAt: Date(), firstName: "Test", lastName: "User")
}


class FirestoreManager {
    
    let db = Firestore.firestore()
    
    static var shared = FirestoreManager()
    
    func createFireUser(id: String, email: String, firstName: String, lastName: String) {
        let profile = Profile(id: id, email: email, registeredAt: Date(), firstName: firstName, lastName: lastName)
        
        do {
            try db.collection("users").document(id).setData(from: profile)
        } catch {
            print("Saving user failed: \(error)")
        }
    }
    
    func fetchFireUser(withId id: String) async throws -> Profile {
        let document = try await FirestoreManager.shared.db.collection("users").document(id).getDocument()

        guard document.data() != nil else {
            print("Document with id: \(id) not found")
            return .sample
        }

        do {
            let fireUser = try document.data(as: Profile.self)
            return fireUser
        } catch {
            print("Decoding user failed: \(error)")
            throw error
        }
    }
    
    func updateFireUser(withId id: String, newFirstName: String, newLastName: String, newEmail: String, newPhoneNumber: String, address: String) async throws {
        let userRef = FirestoreManager.shared.db.collection("users").document(id)
        
        do {
            try await userRef.updateData([
                "firstName": newFirstName,
                "lastName": newLastName,
                "email": newEmail,
                "phoneNumber": newPhoneNumber,
                "updatedAt": Timestamp(date: Date()),
                "address": address
            ])
            print("User updated successfully")
        } catch {
            print("Failed to update user: \(error)")
            throw error
        }
    }
}
