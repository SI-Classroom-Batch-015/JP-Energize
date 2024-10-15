//
//  HomeView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 13.09.24.
//

import SwiftUI


struct HomeView: View {
    
    @State private var profileViewModel = ProfileViewModel()

    @ObservedObject private var viewModel = InverterViewModel()
    @State private var selectedOption: HomePicker = .month
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State var selectedImage: UIImage?
    
    
    var body: some View {
        Form{
            
            Section {
                
                VStack {
                    HStack{
                        
                        VStack(alignment: .leading){
                            Text("Solar Panel")
                                .font(.headline)
                            Text("Total generation")
                                .foregroundStyle(.gray)
                            
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
                            
                            Text(option.rawValue).tag(option)
                            
                        }
                    }
                    .pickerStyle(.automatic)
                    
                }
                
                HomeChart(viewModel: viewModel, selectedOption: $selectedOption, selectedMonth: selectedMonth)
                
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                VStack(alignment: .leading) {
                    Text("Welcome back,")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Text(profileViewModel.profile.firstName)
                        .fontWeight(.medium)
                        .font(.subheadline)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 15) {
                    Image("glocke")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                    
                   
                    
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    
                       
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 20)  
                .padding(.trailing, 10)
            }
        }
        .onAppear {
            Task {
                await profileViewModel.fetchProfile()
            }
        }
    }
    
}


#Preview {
    HomeView()
}
