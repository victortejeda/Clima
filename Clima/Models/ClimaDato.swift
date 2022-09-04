//
//  ClimaDatos.swift
//  Clima
//
//  Created by Victor Tejeda on 3/9/22.
//

import Foundation


struct ClimaDatos: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
