//
//  InverterViewModel.swift
//  JP Energize
//
//  Created by Phillip Wilke on 13.09.24.
//

import Foundation
import SwiftUI
import CoreData


@MainActor
class InverterViewModel: ObservableObject {
    
    @Published var inverterHistory: [InverterEntity]?
    @Published var inverter: InverterModel?
    @Published var error: String?
    @Published var localError: InverterAPIError?
    @Published var selectedMonth: Int = 1
    private let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    
    private let repository = DataInverterRepository()
    
    init() {
        
        
        load()
        loadInverter()
        print("\(String(describing: inverterHistory?.count))")
        
    }
    
    
    
    func load() {
        Task {
            do {
                
                let inverter = try await repository.fetchInverter()
                
                self.inverter = inverter
                
                
                createInverter(acAnnual: inverter.outputs?.ac_annual ?? 0.0, state: inverter.station_info?.state ?? "")
                
                
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
    
    func weeklyKWh() -> [Float] {
        guard let acMonthly = inverter?.outputs?.ac_monthly,
              !acMonthly.isEmpty else {
            return []
        }

        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        let monthlyKWh = acMonthly[currentMonthIndex]
        let daysInCurrentMonth = daysInMonth[currentMonthIndex]
        let dailyKWh = monthlyKWh / Float(daysInCurrentMonth)

        let currentWeekday = Calendar.current.component(.weekday, from: Date()) // Sonntag = 1, Montag = 2, ...
        let numberOfDays = min(currentWeekday - 1, 7) // Maximal 7 Tage, aber nur bis zum heutigen Tag

        return (1...numberOfDays).map { _ in
            let adjustmentFactor = Float.random(in: 0.8...1.2)
            return dailyKWh * adjustmentFactor
        }
    }
    
    func createInverter(acAnnual: Float, state: String) {
        let fetchRequest: NSFetchRequest<InverterEntity> = InverterEntity.fetchRequest()
        
        do {
            let existingInverters = try persistentStore.context.fetch(fetchRequest)
            
            if existingInverters.first != nil {
                return
            }
            
            let newInverter = InverterEntity(context: persistentStore.context)
            newInverter.id = UUID().uuidString
            newInverter.acAnnual = acAnnual
            newInverter.state = state

            try persistentStore.context.save()
            print("Inverter successfully created with acAnnual: \(acAnnual) and state: \(state)")
            
        } catch {
            print("Failed to fetch or save inverter: \(error)")
        }
    }
    
    func loadInverter() {
        do {
            let request: NSFetchRequest<InverterEntity> = InverterEntity.fetchRequest()
            let inverters = try persistentStore.context.fetch(request)
            inverterHistory = inverters
        } catch let error as NSError {
            NSLog("Unresolved error loading inverter: \(error), \(error.userInfo)")
        }
    }
    
    var persistentStore = PersistentStore.shared
}
