//
//  ChangePasswordSheet.swift
//  JP Energize
//
//  Created by Phillip Wilke on 09.10.24.
//

import SwiftUI

struct ChangePasswordSheet: View {
    
    @Bindable var profileViewModel: ProfileViewModel
   
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
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

                Spacer()

                Button(action: {
                    
                    dismiss()
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
}

#Preview {
    ChangePasswordSheet(profileViewModel: ProfileViewModel())
}
