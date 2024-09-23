//
//  HomeView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 13.09.24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var viewModel = InverterViewModel()
    @State private var selectedOption: HomePicker = .month
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    var body: some View {
        NavigationStack{
            Form{
                Section {
                    
                    VStack {
                        HStack{
                            
                            VStack(alignment: .leading){
                                Text("Solar Panel")
                                    .font(.headline)
                                Text("Total generation")
                                    .foregroundStyle(.gray)
                                
                                HStack{
                                    Image(systemName: "battery.0percent")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 20)
                                        .padding(.top)
                                    
                                    Text("Battery")
                                        .foregroundStyle(.gray)
                                        .padding(.top)

                                }
                            }
                            .padding(.bottom)
                            
                            Spacer()
                            
                            Image("solarpanel")
                                .resizable()
                                .imageScale(.medium)
                                .frame(width: 150, height: 150)
                            
                        }
                        
                    }
                    VStack(alignment: .leading, spacing: 10){
                        
                        HStack {
                            VStack {
                                if let dailyKWh = viewModel.dailyKWh(for: selectedMonth) {
                                    Text("\(dailyKWh, specifier: "%.0f") KWh")
                                } else {
                                    Text("Keine Daten verfügbar")
                                }
                                Text("Today")
                                    .foregroundStyle(.gray)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            VStack {
                                if let monthlyKWh = viewModel.getCurrentMonthKWh() {
                                    Text("\(Int(monthlyKWh)) KWh")
                                        .font(.headline)
                                } else {
                                    Text("Keine Daten verfügbar")
                                        .font(.headline)
                                }

                                Text("This month")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            VStack {
                                if let allTimeKWh = viewModel.getAllTimeKWh() {
                                    Text("\(Int(allTimeKWh)) KWh")
                                        .font(.headline)
                                } else {
                                    Text("Keine Daten verfügbar")
                                        .font(.headline)
                                }

                                Text("All Time")
                                    .foregroundStyle(.gray)
                                    .font(.caption)
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    
                    
                }
                Section {
                    
                    HStack {
                        Image("flash")
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        VStack {
                            if let max = viewModel.inverter?.outputs?.ac_monthly.max() {
                                Text("\(Int(max)) KWh")
                                    .font(.headline)
                            }
                            
                            Text("Most Electricity earned")
                                .foregroundStyle(.gray)
                                .font(.caption)
                            
                            
                        }
                        
                        
                        
                        Picker("", selection: $selectedOption) {
                            
                            ForEach(HomePicker.allCases) { option in
                                
                                Text(String(describing: option))
                                
                            }
                        }
                        .pickerStyle(.automatic)
                        
                        
                    }
                    
                    HomeChart(currentValues: viewModel.inverter?.outputs?.ac_monthly ?? [])
                    
                }
                
                VStack{
                    
                    Text("Standort:")
                        .foregroundStyle(.gray)
                    Text(viewModel.inverter?.station_info?.state ?? "Geht nicht")
                    
                    Text("Version")
                        .foregroundStyle(.gray)
                    Text(viewModel.inverter?.version ?? "Geht nicht")
                    
                    
                    Text("Azimutwinkel")
                        .foregroundStyle(.gray)

                    Text(viewModel.inverter?.inputs?.azimuth ?? "Geht nicht")
                    Text("180 Grad = Südlich ausgerichtet")
                        .foregroundStyle(.gray)

                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Welcome back,")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                        Text("Thor Odinson")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        
                        Image("glocke")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                        
                        
                        
                        Image("thor")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 65, height: 65)
                            .clipShape(Circle())
                    }
                    
                }
            }
        }
    }
    
}


#Preview {
    HomeView()
}
