//
//  DataInverterRepository.swift
//  JP Energize
//
//  Created by Phillip Wilke on 13.09.24.
//

//
//  ArticlesRepository.swift
//  Daily News
//
//  Created by Phillip Wilke on 23.08.24.
//

import Foundation





class DataInverterRepository {
    

    
    func fetchInverter() async throws -> Inverter {
   // let envKey =
    guard let url = URL(string: "https://developer.nrel.gov/api/pvwatts/v8.json?api_key=tWh7ebcIAiAPnUVUBg4ISsEq1R7j0V0G4IvcIBJo&azimuth=180&system_capacity=4&losses=14&array_type=1&module_type=0&gcr=0.4&dc_ac_ratio=1.2&inv_eff=96.0&radius=0&dataset=nsrdb&tilt=10&address=boulder, co&soiling=12|4|45|23|9|99|67|12.54|54|9|0|7.6&albedo=0.3&bifaciality=0.7") else {
      throw URLError(.badURL)
    }
    var request = URLRequest(url: url)
   // request.setValue(forHTTPHeaderField: "Authorization")
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
      }
      let inverterResponse = try JSONDecoder().decode(Inverter.self, from: data)
        return inverterResponse
    } catch {
      print("Fetch articles error: \(error)")
      throw error
    }
  }
    
    
   
    
}
 

