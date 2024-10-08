//
//  AuthenticationView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 27.09.24.
//

import SwiftUI


struct AuthenticationView: View {
    @State var email = ""
    @State var password = ""
    @State var userViewModel = UserViewModel()
    @State var isPresenting = false
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        VStack(spacing: 20) {
            
          

            Image("jpenergize")
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipped()
                .ignoresSafeArea(edges: .top)
            
        }
        
        
        VStack(spacing: 5) {
            Text("Let's start it!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Enter your E-Mail")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 20)
        
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
        
        
        HStack{
            Text("Dont have an Account ?")
                .foregroundStyle(.gray)
            
            Button("SignUp") {
                isPresenting.toggle()
            }
        }
        .sheet(isPresented: $isPresenting) {
            SignUpSheet(email: email, password: password)
        }
    }
    
    func attemptSignIn() {
        Task {
            await userViewModel.signIn(email: email, password: password)
        }
    }
}

#Preview {
    AuthenticationView()
}
