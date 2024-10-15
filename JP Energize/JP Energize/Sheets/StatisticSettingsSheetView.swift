//
//  StatisticSettingsSheetView.swift
//  JP Energize
//
//  Created by Phillip Wilke on 07.10.24.
//

import SwiftUI

struct StatisticSettingsSheetView: View {
    @ObservedObject var viewModel = InverterViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
                   Image("energieSettings")
                       .resizable()
                       .scaledToFill()
                       .ignoresSafeArea() 

                   VStack {
                       HStack {
                           Button(action: {
                               dismiss()
                           }) {
                               Image(systemName: "xmark")
                                   .foregroundColor(.white)
                                   .padding()
                           }
                           Spacer()
                       }
                       .padding([.top, .leading])
                       
                       Spacer()

                       VStack {
                           Text("Jahreswert: \(viewModel.inverter?.outputs?.ac_annual ?? 0, specifier: "%.2f") kWh")
                           Text("Ort: \(viewModel.inverter?.station_info?.state ?? "Unknown")")
                       }
                       .padding()
                       .background(Color(UIColor.systemGray6))
                       .cornerRadius(10)
                       .padding()
                       
                       Spacer()
                   }
                   .padding(.top, 20)
               }
           }
       }


#Preview {
    StatisticSettingsSheetView()
}
