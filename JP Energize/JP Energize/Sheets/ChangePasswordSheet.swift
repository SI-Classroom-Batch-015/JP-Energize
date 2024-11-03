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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                PasswordField(placeholder: "Aktuelles Passwort", text: $profileViewModel.currentPassword)
                PasswordField(placeholder: "Neues Passwort", text: $profileViewModel.newPassword)
                PasswordField(placeholder: "Passwort wiederholen", text: $profileViewModel.newPasswordRepeat)

                Spacer()

                Button(action: savePassword) {
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
                        profileViewModel.resetPasswordSecureFields()
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $profileViewModel.showAlert) {
                Alert(
                    title: Text(profileViewModel.alertType == .success ? "Erfolg" : "Fehler"),
                    message: Text(profileViewModel.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if profileViewModel.alertType == .success {
                            profileViewModel.resetPasswordSecureFields()
                            dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func savePassword() {
        profileViewModel.changePassword()
    }
}

struct PasswordField: View {
    var placeholder: String
    @Binding var text: String
    @State private var isVisible: Bool = false

    var body: some View {
        ZStack(alignment: .trailing) {
            if isVisible {
                TextField(placeholder, text: $text)
                    .padding(.trailing, 40)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
            } else {
                SecureField(placeholder, text: $text)
                    .padding(.trailing, 40)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            Button(action: { isVisible.toggle() }) {
                Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChangePasswordSheet(profileViewModel: ProfileViewModel())
}
