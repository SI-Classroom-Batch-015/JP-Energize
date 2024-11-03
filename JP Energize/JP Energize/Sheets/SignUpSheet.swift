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
    @Bindable var viewModel: AuthViewModel
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

                    TextField("First Name", text: $firstName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)

                    TextField("Last Name", text: $lastName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)

                    Button("Sign Up") {
                        attemptSignUp()
                    }
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(firstName.isEmpty || lastName.isEmpty ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .disabled(firstName.isEmpty || lastName.isEmpty)

                    Spacer()
                }
                .padding(.horizontal, 30)
                .autocapitalization(.none)

                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("Info"),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK")) {
                            if viewModel.alertMessage.contains("erfolgreich") {
                                dismiss() 
                            }
                        }
                    )
                }
            }
        }

        func attemptSignUp() {
            Task {
                await viewModel.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
            }
        }
    }

#Preview {
    SignUpSheet(viewModel: AuthViewModel())
}
