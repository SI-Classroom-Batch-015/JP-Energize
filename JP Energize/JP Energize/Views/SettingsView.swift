//
//  SettingsView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 27.09.24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Button("Logout") {
                FirebaseAuthManager.shared.signOut()
            }
            .frame(maxWidth: 250, maxHeight: 44)
            .background(.red)
            .cornerRadius(10)
            .padding()
            .foregroundStyle(.white)
            .bold()
           
        }
    }
}

#Preview {
    SettingsView()
}
