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
}
