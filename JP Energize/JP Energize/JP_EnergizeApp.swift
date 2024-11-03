//
//  JP_EnergizeApp.swift
//  JP Energize
//
//  Created by Phillip Wilke on 05.09.24.
//

import SwiftUI
import Firebase

@main
struct JP_EnergizeApp: App {
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if FirebaseAuthManager.shared.isUserSignedIn {
                ContentView()
            } else {
                AuthenticationView(viewModel: AuthViewModel())
            }
        }
    }
  
}
