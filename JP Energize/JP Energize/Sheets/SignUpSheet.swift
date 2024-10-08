//
//  SignUpSheet.swift
//  JP Energize
//
//  Created by Phillip Wilke on 30.09.24.
//

import SwiftUI

struct SignUpSheet: View {
    @State var email = ""
    @State var password = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var userViewModel = UserViewModel()
    @State var isPresenting = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
                
              
            }
            
            Image("startpanel")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .clipped()
                .ignoresSafeArea(edges: .top)
            
            Spacer()
            
            Text("Registration")
                .font(.title)
             
                .foregroundStyle(.gray)
            
            VStack {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                TextField("firstName", text: $firstName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                TextField("lastName", text: $lastName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                
                
                Button("SignUp") {
                    attemptSignUp()
                    dismiss()
                }
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
    
    func attemptSignUp() {
        Task {
            await userViewModel.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
        }
    }
}

#Preview {
    SignUpSheet()
}
