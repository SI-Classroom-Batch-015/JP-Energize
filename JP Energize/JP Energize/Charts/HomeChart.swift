//
//  HomeChart.swift
//  JP Energize
//
//  Created by Phillip Wilke on 19.09.24.
//

import SwiftUI
import Charts

struct HomeChart: View {
    var currentValues: [Float]
    
    
    let months = ["01", "02", "03", "04", "05", "06",
                  "07", "08", "09", "10", "11", "12"]
    
    var body: some View {
        
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        let filteredValues = Array(currentValues.prefix(currentMonthIndex + 1))
        let filteredMonths = Array(months.prefix(currentMonthIndex + 1))
        
        let maxValue = currentValues.max() ?? 0
        
        Chart {
            ForEach(Array(filteredValues.enumerated()), id: \.offset) { index, currentValue in
                BarMark(
                    x: .value("Monat", months[index]),
                    y: .value("Wert", currentValue)
                )
                .foregroundStyle(currentValue == maxValue ? Color.green : Color.blue)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}

#Preview {
    HomeChart(currentValues: [324.45, 665.98, 450.25, 600.75, 700.85, 500.32, 678.56, 456.78, 789.99, 345.67, 567.89, 489.12])
}
