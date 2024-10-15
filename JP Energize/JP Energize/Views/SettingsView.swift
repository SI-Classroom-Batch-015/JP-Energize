//
//  SettingsView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 27.09.24.
//

import SwiftUI

struct SettingsView: View {
    var viewModel = InverterViewModel()
    @State var profileViewModel = ProfileViewModel()
    
    @State private var showStatistics = false
    @State private var selectedLanguage: String = Locale.current.language.languageCode?.identifier ?? "de"
    
    @State private var showEditProfile = false
    @State private var showChangePassword = false
    @State private var deleteAccount = false
    @State private var isPickerShowing = false
    @State private var selectedImage: UIImage?
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Allgemein").font(.headline).padding(.top)) {
                    Button("Statistics") {
                        showStatistics.toggle()
                    }
                    .sheet(isPresented: $showStatistics) {
                        StatisticSettingsSheetView(viewModel: viewModel)
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
                            
                            isPickerShowing = true
                            
                        } label: {
                            
                            Text("Foto auswählen/ändern")
                        }
                        .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                        }
                        
                        Button("Account löschen 😢") {
                            
                        }
                        .sheet(isPresented: $deleteAccount) {
                            
                        }
                        .foregroundStyle(.red)
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
                    .onChange(of: selectedLanguage) {
                    
                    }
                    
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
                    
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Einstellungen")
        }
       
    }
}


#Preview {
    SettingsView()
}
