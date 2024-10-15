//
//  EditProfileSheet.swift
//  JP Energize
//
//  Created by Phillip Wilke on 09.10.24.
//

import Foundation
import SwiftUI
import Observation

struct EditProfileSheet: View {
    
    @Bindable var profileViewModel: ProfileViewModel
    
   
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("please fill all fields")
                    .foregroundStyle(profileViewModel.isValid ? .white: .red)
                
                TextField("Vorname", text: $profileViewModel.profile.firstName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                
            
                TextField("Nachname", text: $profileViewModel.profile.lastName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                
         
                TextField("E-Mail", text:
                            $profileViewModel.profile.email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                
        
                TextField("Telefonnummer", text: $profileViewModel.profile.phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)

           
                TextField("Addresse", text:
                            $profileViewModel.profile.address)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)

                Spacer()

           
                Button(action: {
                    Task {
                       await profileViewModel.updateProfile()
                    }
                    dismiss()
                }) {
                    Text("Speichern")
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
            .navigationTitle("Profil bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                    .disabled(!profileViewModel.isValid)
                }
            }
        }
    }
}

#Preview {
    EditProfileSheet(profileViewModel: ProfileViewModel())
}
