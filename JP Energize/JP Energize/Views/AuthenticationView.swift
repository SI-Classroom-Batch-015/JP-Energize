//
//  AuthenticationView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 27.09.24.
//

import SwiftUI
import FirebaseAuth


struct AuthenticationView: View {
    @State var email = ""
    @State var password = ""
    @State var viewModel: AuthViewModel
    @State var isPresenting = false
    @Environment(\.dismiss) private var dismiss
    
    // Alert Properties
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // State variablen für Zurücksetzen des Passworts

    @State private var showResetAlert: Bool = false
    @State private var resetEmilAddress: String = ""
    @State private var reEnterPassword: String = ""
    @State private var isLoading = false
    
    
    
    
    var body: some View {
        
        VStack(spacing: 20) {

            Image("jpenergize")
                .resizable()
                .scaledToFill()
                .frame(height: 450)
                .clipped()
                .ignoresSafeArea(edges: .top)
        }
        .padding(.bottom)
        
        
        VStack(spacing: 5) {
            Text("Let's start it!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Enter your E-Mail")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 10)
        
        VStack {
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 30)
            
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 30)
            
            VStack(alignment: .trailing, spacing: 12, content: {
                Button("Forgot Password?") {
                    showResetAlert = true
                }
                .font(.caption)
                .tint(Color.accentColor)
            })
            .alert(alertMessage, isPresented: $showAlert) { }
            .alert("Passwort zurücksetzen", isPresented: $showResetAlert, actions: {
                TextField("E-Mail Addresse", text: $resetEmilAddress)
                
                Button("Sende Link zum Zurücksetzen", role: .destructive, action: sendResetLink)
                
                Button("Abbrechen", role: .cancel) {
                    resetEmilAddress = ""
                }
            }, message:  {
                    Text("Gib deine Email Adresse ein")
                
            })
            
            Button(action: {
                attemptSignIn()
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
        }
        .padding(.horizontal, 30)
        .autocapitalization(.none)
        
        
        HStack{
            Text("don't you have an account ?")
                .foregroundStyle(.gray)
            
            Button("SignUp") {
                isPresenting.toggle()
            }
        }
        .sheet(isPresented: $isPresenting) {
            SignUpSheet(email: email, password: password, viewModel: viewModel)
        }
        .padding(.bottom, 40)
    }
        
    
    func sendResetLink() {
        Task {
            do {
                if resetEmilAddress.isEmpty {
                    await presentAlert("Bitte gib eine E-Mail ein")
                    return
                }
                isLoading = true
                try await Auth.auth().sendPasswordReset(withEmail: resetEmilAddress)
                await presentAlert("Bitte prüfe dein E-Mail Postfach und folge den Schritten um dein Passwort zurückzusetzen")
                
                resetEmilAddress = ""
                isLoading = false
            } catch {
                await presentAlert(error.localizedDescription)
            }
        }
    }
    
    func presentAlert(_ message: String) async {
        await MainActor.run {
            alertMessage = message
            showAlert = true
            isLoading = false
            resetEmilAddress = ""
            
            
        }
    }

    
    func attemptSignIn() {
        Task {
            await viewModel.signIn(email: email, password: password)
        }
    }
}

#Preview {
    AuthenticationView(viewModel: AuthViewModel())
}
