//
//  HomeChart.swift
//  JP Energize
//
//  Created by Phillip Wilke on 19.09.24.
//

import SwiftUI
import Charts

struct HomeChart: View {
    var viewModel: InverterViewModel
    @Binding var selectedOption: HomePicker
    var selectedMonth: Int
    
    let months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    let weeks = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    
    var body: some View {
        
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        let monthlyValues = viewModel.inverter?.outputs?.ac_monthly ?? []
        let valuesToShow = Array(monthlyValues.prefix(currentMonthIndex + 1))
        
        let weeklyValues = viewModel.weeklyKWh()
        let weeklyMaxValue = weeklyValues.max() ?? 0
        
        let maxValue: Float = selectedOption == .week ? weeklyMaxValue : (monthlyValues.prefix(currentMonthIndex + 1).max() ?? 0)
        
        switch selectedOption {
        case .month:
            Chart {
                ForEach(0..<valuesToShow.count, id: \.self) { index in
                    BarMark(
                        x: .value("Monat", months[index]),
                        y: .value("Wert", monthlyValues[index])
                    )
                    .foregroundStyle(monthlyValues[index] == maxValue ? Color.green : Color.blue)
                }
            }
            .chartYScale(domain: 0...600)
            .chartYAxis {
                AxisMarks(values: Array(stride(from: 0, through: 600, by: 50)))
            }
            .aspectRatio(1, contentMode: .fill)
            .padding()
            
        case .week:
            Chart {
                ForEach(0..<weeklyValues.count, id: \.self) { index in
                    BarMark(
                        x: .value("Woche", weeks[index]),
                        y: .value("Wert", weeklyValues[index])
                    )
                    .foregroundStyle(weeklyValues[index] == weeklyMaxValue ? Color.green : Color.blue)
                }
            }
            .chartYScale(domain: 0...16)
            .chartYAxis {
                AxisMarks(values: Array(stride(from: 0, through: 16, by: 2)))
            }
            .aspectRatio(1, contentMode: .fill)
            .padding()
        }
    }
}

#Preview {
    HomeChart(viewModel: InverterViewModel(), selectedOption: .constant(.month), selectedMonth: Calendar.current.component(.month, from: Date()))
}
