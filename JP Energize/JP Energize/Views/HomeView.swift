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
    
    
    var body: some View {
        
        
        
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome back,")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Text(profileViewModel.profile.firstName)
                        .fontWeight(.medium)
                        .font(.subheadline)
                }
                .padding(.leading)
                .padding(.top, 10)
                
                Spacer()
                
                HStack(spacing: 15) {
                    Image("glocke")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                    
                    if let profileImageUrl = profileViewModel.profile.profileImageUrl {
                        if let imageUrl = URL(string: profileImageUrl) {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    
                }
                .padding(.trailing)
                .padding(.top, 10)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            
            Form {
                
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
                            if selectedOption == .week {
                                if let weeklyMax = viewModel.weeklyKWh().max() {
                                    Text("\(Int(weeklyMax)) KWh")
                                        .font(.headline)
                                }
                            } else if let monthlyMax = viewModel.inverter?.outputs?.ac_monthly.max() {
                                Text("\(Int(monthlyMax)) KWh")
                                    .font(.headline)
                            }
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
                    
                    HomeChart(viewModel: viewModel, selectedOption: $selectedOption, selectedMonth: selectedMonth)
                }
            }
            .onAppear {
                Task {
                    await profileViewModel.fetchProfile()
                }
            }
        }
    }
}


#Preview {
    HomeView()
}
