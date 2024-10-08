//
//  UserViewModel.swift
//  JP Energize
//
//  Created by Phillip Wilke on 27.09.24.
//

import Foundation
import Observation



@Observable
class UserViewModel {
    
    func signUp(email: String, password: String, firstName: String, lastName: String) async {
        do {
            try await FirebaseAuthManager.shared.signUp(email: email, password: password, firstName: firstName, lastName: lastName)
        } catch {
            print("Error signUp!\(error.localizedDescription)")
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            try await FirebaseAuthManager.shared.signIn(email: email, password: password)
        } catch {
            print("Error signIn!\(error.localizedDescription)")
        }
    }
    
    func signOut(email: String, password: String) async {
        
        FirebaseAuthManager.shared.signOut()
        
    }
    
    
}
