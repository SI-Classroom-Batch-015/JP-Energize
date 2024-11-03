//
//  SettingsView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 27.09.24.
//

import SwiftUI

struct SettingsView: View {
    @State private var profileViewModel = ProfileViewModel()
    @ObservedObject private var viewModel = InverterViewModel()
    
    @State private var showStatistics = false
    @State private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "de"
    
    @State private var showEditProfile = false
    @State private var showChangePassword = false
    @State private var deleteAccountAlert = false
    @State private var sheetShowing = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Allgemein").font(.headline).padding(.top)) {
                    Button("Statistiken") {
                        showStatistics.toggle()
                    }
                    .sheet(isPresented: $showStatistics) {
                        StatisticSettingsSheetView(viewModel: viewModel) // viewModel hier übergeben
                    }
                    .foregroundStyle(.black)
                    .padding(.vertical, 4)

                    DisclosureGroup("Profil-Einstellungen") {
                        Button("Profil bearbeiten") {
                            showEditProfile.toggle()
                        }
                        .sheet(isPresented: $showEditProfile) {
                            EditProfileSheet(profileViewModel: profileViewModel)
                                .interactiveDismissDisabled(!profileViewModel.isValid)
                        }
                        
                        Button("Passwort ändern") {
                            showChangePassword.toggle()
                        }
                        .sheet(isPresented: $showChangePassword) {
                            ChangePasswordSheet(profileViewModel: profileViewModel)
                        }

                        Button {
                            sheetShowing = true
                        } label: {
                            Text("Foto auswählen/ändern")
                        }
                        .sheet(isPresented: $sheetShowing) {
                            ImageSheet(selectedImage: $selectedImage, sheetShowing: $sheetShowing)
                        }
                        
                        Button("Account löschen 😢") {
                            deleteAccountAlert = true
                        }
                        .foregroundStyle(.red)
                        .alert(isPresented: $deleteAccountAlert) {
                            Alert(
                                title: Text("Konto löschen"),
                                message: Text("Möchten Sie Ihr Konto wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden."),
                                primaryButton: .destructive(Text("Löschen")) {
                                    Task {
                                        await profileViewModel.deleteAccount()
                                    }
                                },
                                secondaryButton: .cancel(Text("Abbrechen"))
                            )
                        }
                    }
                    .foregroundStyle(.black)
                }
                .padding(.vertical)
                
                DisclosureGroup("Sprache/Region") {
                    Picker("Sprache ändern", selection: $selectedLanguage) {
                        Text("Deutsch").tag("de")
                        Text("Englisch").tag("en")
                        Text("Französisch").tag("fr")
                    }
                    .pickerStyle(.menu)
                    .tint(.black)
                }
                .foregroundStyle(.black)
                .padding(.vertical)

                Section {
                    Button("Logout") {
                        FirebaseAuthManager.shared.signOut()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .bold()
                    .padding(.vertical)
                }
                
                // Badge für Profilvervollständigung
                if profileViewModel.needsProfileCompletion {
                    HStack {
                        Text("Bitte vervollständigen Sie Ihr Profil!")
                            .foregroundColor(.red)
                        Spacer()
                        Image(systemName: "exclamationmark.bubble.fill")
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Einstellungen")
            .alert(isPresented: $profileViewModel.showAlert) {
                Alert(
                    title: Text(profileViewModel.alertType == .success ? "Erfolg" : "Fehler"),
                    message: Text(profileViewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            Task {
                await profileViewModel.fetchProfile() // Profil beim Auftauchen abrufen
            }
        }
    }
}

#Preview {
    SettingsView()
}
