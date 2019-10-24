//
//  Nutrient.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct NutritionFact: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let source: String?
    let amount:Float
    let unit:String
  
    enum CodingKeys : String, CodingKey {
        case id
        case name = "common_name"
        case description
        case source
        case amount
        case unit
    }
    
    func measurement() -> String {
        return "\(self.amount)\(self.unit)"
    }
    
    func getDescription() -> String {
        return self.description ?? "No description available"
    }
    
    func isWarning() -> Bool {
        return true
    }
}
