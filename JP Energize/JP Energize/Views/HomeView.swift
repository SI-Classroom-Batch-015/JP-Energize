//
//  HomeView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 13.09.24.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = InverterViewModel()
    
    var body: some View {
        Text(viewModel.inverter?.version ?? "Geht nicht")
    }
}

#Preview {
    HomeView()
}
