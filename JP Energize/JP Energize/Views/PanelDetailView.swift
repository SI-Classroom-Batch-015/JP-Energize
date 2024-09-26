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
                VStack(alignment: .leading) {
                    
                    HStack{
                        Text("Standort:")
                            .foregroundStyle(.gray)
                        Text(viewModel.inverter?.station_info?.state ?? "Geht nicht")
                        
                    }
                    .padding(.bottom)
                    
                    
                    HStack{
                        Text("Version:")
                            .foregroundStyle(.gray)
                        Text(viewModel.inverter?.version ?? "Geht nicht")
                    }
                    .padding(.bottom)
                    
                    HStack{
                        Text("Azimutwinkel:")
                            .foregroundStyle(.gray)
                        
                        Text(viewModel.inverter?.inputs?.azimuth ?? "Geht nicht")
                        Text("Südlich ausgerichtet")
                            .foregroundStyle(.gray)
                    }
                    .padding(.bottom)
                    
                    HStack{
                        Text("Neigungswinkel:")
                            .foregroundStyle(.gray)
                        Text("\(String(viewModel.inverter?.inputs?.tilt ?? "0")) Grad")
                    }
                    .padding(.bottom)
                    
                    let arrayTypeDescriptions: [String: String] = [
                        "0": "Fest - Offenes Rack",
                        "1": "Fest - Dachmontage",
                        "2": "1-Achse",
                        "3": "1-Achse mit Rückverfolgung",
                        "4": "2-Achsen"
                    ]
                    HStack{
                            Text("Monatge:")
                            .foregroundStyle(.gray)
                        
                        if let arrayType = viewModel.inverter?.inputs?.array_type {
                            let description = arrayTypeDescriptions[arrayType] ?? "Unbekannter Typ"
                            Text(description)
                                
                                
                        } else {
                            Text("Keine Daten verfügbar")
                                .font(.headline)
                        }
                        }
                }
                
            }
            
        }
    }
}

#Preview {
    PanelDetailView()
}

