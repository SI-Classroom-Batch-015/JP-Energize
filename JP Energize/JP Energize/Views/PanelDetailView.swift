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
                
                VStack {
                    Image("solarpanel")
                        .resizable()
                        .imageScale(.medium)
                        .frame(width: 250, height: 250)
                    
                    Text("Max Power Output: 600W")
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Section{
                VStack(alignment: .leading) {
                    
                    HStack{
                        Text("Standort:")
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        Text(viewModel.inverter?.station_info?.state ?? "Keine Daten verfügbar")
                        
                    }
                    .padding(.bottom)
                    
                    
                    HStack{
                        Text("Version:")
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        Text(viewModel.inverter?.version ?? "Keine Daten verfügbar")
                    }
                    .padding(.bottom)
                    
                    let azimutDescription: [String: String] = [
                        "0": " 0 = Nördlich ausgerichtet",
                        "90": "90 = Östlich ausgerichtet ",
                        "180": "180 = Südlich ausgerichtet",
                        "270": "270 = Westlich ausgerichtet",
                        
                    ]
                    HStack{
                        Text("Azimutwinkel:")
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        if let azimuth = viewModel.inverter?.inputs?.azimuth {
                            let descriptionAzimut = azimutDescription[azimuth] ?? "Unbekannter Typ"
                            Text(descriptionAzimut)
                            
                            
                        } else {
                            Text("Keine Daten verfügbar")
                            
                        }
                    }
                    .padding(.bottom)
                    
                    HStack{
                        Text("Neigungswinkel:")
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
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
                        Text("Montage:")
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        if let arrayType = viewModel.inverter?.inputs?.array_type {
                            let description = arrayTypeDescriptions[arrayType] ?? "Unbekannter Typ"
                            Text(description)
                            
                            
                        } else {
                            Text("Keine Daten verfügbar")
                                .foregroundColor(.red)
                            
                            
                        }
                    }
                    .padding(.bottom)
                    
                    if let losses = viewModel.inverter?.inputs?.losses {
                        HStack() {
                            Text("Betriebsverluste in %:")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(String(losses))
                                .foregroundColor(.black)
                            
                        }
                        .padding(.bottom)
                    } else {
                        Text("Keine Daten zu den Betriebsverlusten verfügbar.")
                            .foregroundColor(.red)
                        
                    }
                    
                    
                    if let solradMonthly = viewModel.inverter?.outputs?.solrad_monthly {
                        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
                        if currentMonthIndex < solradMonthly.count {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading){
                                    Text("Monatl. Sonnenstrahlung")
                                        .foregroundColor(.gray)
                                    Text("für \(currentMonthIndex + 1). Monat")
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text(String(format: "%.2f kWh/m²", solradMonthly[currentMonthIndex]))
                                    .foregroundColor(.black)
                            }
                            .padding(.bottom)
                        } else {
                            Text("Keine Daten für den aktuellen Monat verfügbar.")
                                .foregroundColor(.red)
                            
                        }
                    } else {
                        Text("Keine Daten verfügbar.")
                            .foregroundColor(.red)
                        
                    }
                    
                    if let acAnnual = viewModel.inverter?.outputs?.ac_annual {
                        HStack {
                            Text("Jährliche AC-Leistung")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(String(format: "%.2f kWh", acAnnual))
                                .foregroundColor(.black)
                        }
                        .padding(.bottom)
                    } else {
                        Text("Keine Daten zur jährlichen AC-Leistung verfügbar.")
                            .foregroundColor(.red)
                    }
                    
                    
                    if let weatherDataSource =
                        viewModel.inverter?.station_info?.weather_data_source {
                        HStack(alignment: .top) {
                            Text("Wetterdaten")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            VStack(alignment: .leading){
                                Text(String(weatherDataSource))
                            }
                            
                        }
                        .padding(.bottom)
                        
                    } else {
                        Text("Keine Daten verfügbar.")
                    }
                    
                    if let dcAcRatioStrings =
                        viewModel.inverter?.inputs?.dc_ac_ratio {
                        HStack(alignment: .top) {
                            Text("Verhältnis DC AC")
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            Text(dcAcRatioStrings)
                            
                            
                            
                        }
                        .padding(.bottom)
                        
                    } else {
                        Text("Keine Daten verfügbar.")
                    }
                    
                    
                }
                
            }
            
        }
    }
}


#Preview {
    PanelDetailView()
}
