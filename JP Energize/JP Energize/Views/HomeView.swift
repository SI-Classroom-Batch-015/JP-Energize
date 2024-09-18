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
        NavigationStack{
            Form{
                Section("") {
                    
                    VStack {
                        HStack{
                        
                            VStack{
                                Text("Solar Panel")
                                    .font(.headline)
                                Text("Total generation")
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            Image("solarpanel")
                                .resizable()
                                .imageScale(.medium)
                                .frame(width: 150, height: 150)
                        }
 
                       
                        Text(viewModel.inverter?.version ?? "Geht nicht")
                        Text(viewModel.inverter?.inputs?.azimuth ?? "Geht nicht")
                        
                    }
                    
                    
                }
                Section("") {
                    Text(viewModel.inverter?.station_info?.state ?? "Geht nicht")
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    VStack(alignment: .leading) {
                        Text("Welcome back")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Name Placeholder")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                }
            }
            .overlay(alignment: .topLeading) {
                
            }
        }
        
    }
}

#Preview {
    HomeView()
}
