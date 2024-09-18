//
//  Panel.swift
//  JP Energize
//
//  Created by Phillip Wilke on 11.09.24.
//

import Foundation

struct Inverter: Codable {
    let inputs: Inputs?
    let version: String?
    let station_info: StationInfo?
  
}

struct Inputs: Codable {
    let azimuth, system_capacity, tilt, array_type: String?
}

struct StationInfo: Codable {
    let city, state: String?
}

