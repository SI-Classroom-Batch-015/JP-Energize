//
//  InverterAPIError.swift
//  JP Energize
//
//  Created by Phillip Wilke on 13.09.24.
//

import Foundation


enum InverterAPIError: LocalizedError {
  case errorResponse(code: Int, message: String)
  var description: String {
    switch self {
    case .errorResponse(let code, let message):
      return "Error \(code): \(message)"
    }
  }
}
