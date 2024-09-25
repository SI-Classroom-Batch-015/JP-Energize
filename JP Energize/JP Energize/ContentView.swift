//
//  ContentView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 05.09.24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationStack {
            
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                PanelDetailView()
                    .tabItem {
                        Label("Panel Details", systemImage: "info.circle")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
