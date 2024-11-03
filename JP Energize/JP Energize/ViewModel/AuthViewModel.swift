//
//  AuthViewModel.swift
//  JP Energize
//
//  Created by Phillip Wilke on 27.09.24.
//

import Foundation
import Observation

@Observable
class AuthViewModel {
    var alertMessage: String = ""
    var showAlert: Bool = false

    private let passwordMinLength = 8

    func signUp(email: String, password: String, firstName: String, lastName: String) async {
        guard validateEmail(email) else {
            await presentAlert("Bitte geben Sie eine gültige E-Mail-Adresse ein.")
            return
        }

        guard validatePassword(password) else {
            await presentAlert("Das Passwort muss mindestens \(passwordMinLength) Zeichen lang sein.")
            return
        }

        do {
            try await FirebaseAuthManager.shared.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
            await presentAlert("Registrierung erfolgreich! Willkommen, \(firstName)!")
        } catch {
            await presentAlert("Fehler bei der Registrierung: \(error.localizedDescription)")
        }
    }

    func signIn(email: String, password: String) async {
        guard validateEmail(email) else {
            await presentAlert("Bitte geben Sie eine gültige E-Mail-Adresse ein.")
            return
        }

        guard validatePassword(password) else {
            await presentAlert("Das Passwort muss mindestens \(passwordMinLength) Zeichen lang sein.")
            return
        }

        do {
            try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            await presentAlert("Anmeldung erfolgreich!")
        } catch {
            await presentAlert("Fehler bei der Anmeldung: \(error.localizedDescription)")
        }
    }

    func signOut() async {
        FirebaseAuthManager.shared.signOut()
        Task {
            await presentAlert("Erfolgreich abgemeldet!")
        }
    }

    private func presentAlert(_ message: String) async {
        await MainActor.run {
            alertMessage = message
            showAlert = true
        }
    }

    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func validatePassword(_ password: String) -> Bool {
        return password.count >= passwordMinLength
    }
}
