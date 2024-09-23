//
//  InverterViewModel.swift
//  JP Energize
//
//  Created by Phillip Wilke on 13.09.24.
//

import Foundation
import SwiftUI



class InverterViewModel: ObservableObject {
    
    @Published var inverter: Inverter?
    @Published var error: String?
    @Published var localError: InverterAPIError?
    @Published var selectedMonth: Int = 1
    private let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    
    private let repository = DataInverterRepository()
    
    init() {
        
        load()
    }
    
    func load() {
        Task {
            do {
                
                self.inverter = try await repository.fetchInverter()
                
            } catch let apiError as InverterAPIError {
                self.error = apiError.description
                print("API Error: \(apiError.description)")
                switch apiError {
                case .errorResponse(code: let code, _):
                    switch code {
                    case 400...499:
                        print("Client error: \(code)")
                    case 500...599:
                        print("Server error: \(code)")
                    default:
                        print("Received error \(code)")
                    }
                }
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    func dailyKWh(for month: Int) -> Float? {
        guard month >= 1 && month <= 12,
              let acMonthly = inverter?.outputs?.ac_monthly,
              acMonthly.count >= month else {
            return nil
        }
        let monthlyKWh = acMonthly[month - 1]
        let days = daysInMonth[month - 1]
        return monthlyKWh / Float(days)
    }
    
    func getCurrentMonthKWh() -> Float? {
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        
        if let monthlyKWh = inverter?.outputs?.ac_monthly[currentMonthIndex] {
            return monthlyKWh
        } else {
            return 0
        }
    }
    
    func getAllTimeKWh() -> Float? {
        guard let acMonthly = inverter?.outputs?.ac_monthly else {
            return 0
        }

        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1

        let totalKWh = acMonthly.prefix(currentMonthIndex + 1).reduce(0, +)

        return totalKWh
    }
    
}
