//
//  ContentView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 05.09.24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {

        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            PanelDetailView()
                .tabItem {
                    Label("Panel Details", systemImage: "light.panel")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        
    }
}

#Preview {
    ContentView()
}
