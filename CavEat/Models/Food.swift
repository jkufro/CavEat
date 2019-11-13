//
//  Food.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct Food: Codable {
    let id = UUID()
    let api_id: String
    let upc: Int64
    var name: String
    let ingredients: [Ingredient]
    let nutritionFacts: [NutritionFact]

    enum CodingKeys: String, CodingKey {
        case id
        case api_id
        case upc
        case name
        case ingredients
        case nutritionFacts = "nutrition_facts"
    }
}
