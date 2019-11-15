//
//  Food.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct Food: Codable {
    var id: UUID?
    let api_id: String
    let upc: Int64
    var name: String
    let ingredients: [Ingredient]
    let nutritionFacts: [NutritionFact]
    var createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case api_id = "id"
        case upc
        case name
        case ingredients
        case nutritionFacts = "nutrition_facts"
    }
}
