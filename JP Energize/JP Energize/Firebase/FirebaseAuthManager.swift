//
//  FirebaseAuth.swift
//  JP Energize
//
//  Created by Phillip Wilke on 10.09.24.
//

import Foundation
import FirebaseAuth

@Observable
class FirebaseAuthManager {
    
    static let shared = FirebaseAuthManager()
    
    private let auth = Auth.auth()
    
    var user: User?
    
    var isUserSignedIn: Bool {
        user != nil
    }
    
    var userID: String? {
        user?.uid
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) async throws {
        let authResult = try await auth.createUser(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("User with email '\(email)' is registered with id '\(authResult.user.uid)'")
        
        FirestoreManager.shared.createFireUser(id: authResult.user.uid, email: email,firstName: firstName, lastName: lastName)
        
        try await self.signIn(email: email, password: password)
        
        
    }

    func signIn(email: String, password: String) async throws {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("User with email '\(email)' signed in with id '\(authResult.user.uid)'")
        self.user = authResult.user
    }
    
    func signOut() {
        do {
            try auth.signOut()
            user = nil
            print("Sign out succeeded.")
        } catch {
            print("Sign out failed.")
        }
    }
    
    private init() {
        checkAuth()
    }
    
    private func checkAuth() {
        guard let currentUser = auth.currentUser else {
            print("Not logged in")
            return
        }
        self.user = currentUser
    }
    
     func resetPassword(email: String, resetCompletion:@escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let error = error {
                resetCompletion(.failure(error))
            } else {
                resetCompletion(.success(true))
            }
        })
    }
    
    
    
   

}

enum AuthError: LocalizedError {
    case noEmail
    case notAuthenticated
    
    var errorDescription: String { "Auth Error" }
    
    var localizedDescription: String {
        switch self {
        case .noEmail:
            "No email was found on newly created user."
        case .notAuthenticated:
            "The user is not authenticated."
        }
    }
}

