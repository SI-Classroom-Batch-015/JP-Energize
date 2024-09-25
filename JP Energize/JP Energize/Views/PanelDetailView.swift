//
//  PanelDetailView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 25.09.24.
//

import SwiftUI

struct PanelDetailView: View {
    
    @ObservedObject private var viewModel = InverterViewModel()
    
    var body: some View {
        
        Form {
            
      
                
                Section{
                    HStack(alignment: .center) {
                        
                        Text("Status: Active")
                            .foregroundStyle(.green)
                            .font(.caption)
                        
                        Spacer()
                        
                        Text("Solar Panel 1")
                            .font(.headline)
                    }
                    
                    VStack(alignment: .center){
                        Image("solarpanel")
                            .resizable()
                            .imageScale(.medium)
                            .frame(width: 250, height: 250)
                        
                        Text("Max Power Output: 600W")
                           
                    }
                }
            
            Section{
                    VStack(alignment: .center) {
                        
                            Text("Standort:")
                                .foregroundStyle(.gray)
                            Text(viewModel.inverter?.station_info?.state ?? "Geht nicht")
                            
                        
                        
                        Text("Version:")
                            .foregroundStyle(.gray)
                        Text(viewModel.inverter?.version ?? "Geht nicht")
                        
                        Text("Azimutwinkel:")
                            .foregroundStyle(.gray)
                        
                        Text(viewModel.inverter?.inputs?.azimuth ?? "Geht nicht")
                        Text("180 Grad = Südlich ausgerichtet")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                }
         
        }
    }
}

#Preview {
    PanelDetailView()
}

