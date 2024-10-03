//
//  Panel.swift
//  JP Energize
//
//  Created by Phillip Wilke on 11.09.24.
//

import Foundation

struct InverterModel: Codable {
    let inputs: Inputs?
    let version: String?
    let station_info: StationInfo?
    let outputs: Outputs?
}

struct Inputs: Codable {
    let azimuth, system_capacity, tilt, array_type, losses: String?
    let dc_ac_ratio: String?
}

struct StationInfo: Codable {
    let city, state,weather_data_source: String?
}

struct Outputs: Codable {
    let ac_monthly: [Float]
    let solrad_monthly: [Float]
    let ac_annual: Float
}
