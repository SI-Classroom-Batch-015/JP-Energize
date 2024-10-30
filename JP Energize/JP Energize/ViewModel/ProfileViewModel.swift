//
//  ProfileViewModel.swift
//  JP Energize
//
//  Created by Phillip Wilke on 09.10.24.
//

import Foundation
import Observation

@Observable
class ProfileViewModel {
    
    var profile: Profile = .sample
    var currentPassword: String = ""
    var newPassword: String = ""
    var newPasswordRepeat: String = ""
    var isValid: Bool {
        !profile.firstName.isEmpty && !profile.lastName.isEmpty && !profile.email.isEmpty && !profile.phoneNumber.isEmpty
        
    }
    
    init() {
        Task {
            await fetchProfile()
        }
    }
    
    func updateProfile() async {
        
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        do {
            try await FirestoreManager.shared.updateFireUser(withId: userId, newFirstName: profile.firstName, newLastName: profile.lastName, newEmail: profile.email, newPhoneNumber: profile.phoneNumber, address: profile.address,
                newProfileImageURL: profile.profileImageUrl ?? "")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchProfile() async {
        
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        do {
            profile = try await FirestoreManager.shared.fetchFireUser(withId: userId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}


