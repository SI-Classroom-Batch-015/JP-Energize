//
//  ChangePasswordSheet.swift
//  JP Energize
//
//  Created by Phillip Wilke on 09.10.24.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordSheet: View {
    
    @Bindable var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var message: String = ""
    @State private var showMessage: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                SecureField("Aktuelles Passwort", text: $profileViewModel.currentPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)

                SecureField("Neues Passwort", text: $profileViewModel.newPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)

                SecureField("Passwort wiederholen", text: $profileViewModel.newPasswordRepeat)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)

                if showMessage {
                    Text(message)
                        .foregroundColor(message.contains("erfolgreich") ? .green : .red)
                        .padding()
                }

                Spacer()

                Button(action: {
                    changePassword()
                }) {
                    Text("Passwort speichern")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 10)
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            .navigationTitle("Passwort ändern")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func changePassword() {
        guard let user = Auth.auth().currentUser  else { return }
        
       
        guard profileViewModel.newPassword == profileViewModel.newPasswordRepeat else {
            message = "Die neuen Passwörter stimmen nicht überein."
            showMessage = true
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: profileViewModel.currentPassword)
        
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                message = "Reauthentifizierung fehlgeschlagen: \(error.localizedDescription)"
                showMessage = true
                return
            }
            user.updatePassword(to: profileViewModel.newPassword) { error in
                if let error = error {
                    message = "Passwortänderung fehlgeschlagen: \(error.localizedDescription)"
                } else {
                    message = "Passwort erfolgreich geändert."
                    dismiss()
                }
                showMessage = true
            }
        }
    }
}

#Preview {
    ChangePasswordSheet(profileViewModel: ProfileViewModel())
}
