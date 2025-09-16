//
//  apiNetwork.swift
//  Converter
//
//  Created by Miguel Angel Bohorquez on 16/09/25.
//

import Foundation

class APINetwork {
    struct Envoltorio:Codable{
        let conversion_rates: [String: Double]
    }
    
    struct Monedas:Codable{
        let value: Double
    }
    
    func getMoney() async throws -> Envoltorio{
        let apiURL = URL(string: "https://v6.exchangerate-api.com/v6/72dee02a361efc531d17810f/latest/COP")!
        
        
        let (data, _) = try await URLSession.shared.data(from: apiURL)
        
        let envoltorio = try JSONDecoder().decode(Envoltorio.self, from: data)
        return envoltorio
    }
    
    
}
