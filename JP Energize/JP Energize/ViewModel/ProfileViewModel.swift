//
//  ProfileViewModel.swift
//  JP Energize
//
//  Created by Phillip Wilke on 09.10.24.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
class ProfileViewModel {
    
    var profile: Profile = .sample
    var currentPassword: String = ""
    var newPassword: String = ""
    var newPasswordRepeat: String = ""
    var isValid: Bool {
        !profile.firstName.isEmpty && !profile.lastName.isEmpty && !profile.email.isEmpty && !profile.phoneNumber.isEmpty
    }
    
    var showAlert = false
    
    enum AlertType {
        case success, error
    }
    var alertMessage = ""
    var alertType: AlertType = .error
    
    private let passwordMinLength = 8
    
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
            showSuccess("Profil erfolgreich aktualisiert.")
            
        } catch {
            print(error.localizedDescription)
            showError("Fehler beim Aktualisieren des Profils: \(error.localizedDescription)")
        }
        
    }
    
    func fetchProfile() async {
        
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        do {
            profile = try await FirestoreManager.shared.fetchFireUser(withId: userId)
        } catch {
            print(error.localizedDescription)
            showError("Fehler beim Laden des Profils: \(error.localizedDescription)")
            
        }
    }
    
    func validatePasswords() -> Bool {
        guard !newPassword.isEmpty && !newPasswordRepeat.isEmpty else {
            showError("Das Passwort darf nicht leer sein.")
            return false
        }
        
        guard newPassword.count >= passwordMinLength else {
            showError("Das Passwort muss mindestens \(passwordMinLength) Zeichen lang sein.")
            return false
        }
        
        guard newPassword == newPasswordRepeat else {
            showError("Die neuen Passwörter stimmen nicht überein.")
            return false
        }
        
        return true
    }
    
    func changePassword() {
        guard let user = Auth.auth().currentUser else {
            showError("Benutzer nicht gefunden.")
            return
        }
        
        guard validatePasswords() else {
            showError("Das Passwort darf nicht leer sein.")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
        
        user.reauthenticate(with: credential) { [weak self] result, error in
            if let error = error {
                self?.showError("Reauthentifizierung fehlgeschlagen: \(error.localizedDescription)")
                return
            }
            
            user.updatePassword(to: self?.newPassword ?? "") { error in
                if let error = error {
                    self?.showError("Passwortänderung fehlgeschlagen: \(error.localizedDescription)")
                } else {
                    self?.showSuccess("Passwort erfolgreich geändert.")
                }
            }
        }
    }
    
    func deleteAccount() async {
        guard let userId = FirebaseAuthManager.shared.userID else { return }
        
        do {
            try await FirestoreManager.shared.deleteFireUser(withId: userId)
            
            try await Auth.auth().currentUser?.delete()
            
            print("Konto erfolgreich gelöscht.")
            showSuccess("Konto erfolgreich gelöscht.")
        } catch {
            print("Failed to delete account: \(error)")
            showError("Konto konnte nicht gelöscht werden: \(error.localizedDescription)")
        }
    }
    
    func resetPasswordSecureFields() {
        currentPassword = ""
        newPassword = ""
        newPasswordRepeat = ""
    }
    
    private func showError(_ message: String) {
        alertMessage = message
        alertType = .error
        showAlert = true
    }
    
    private func showSuccess(_ message: String) {
        alertMessage = message
        alertType = .success
        showAlert = true
    }
}
