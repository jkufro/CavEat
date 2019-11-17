//
//  Food.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct Food: Codable, Identifiable {
    var id: UUID = UUID()
    let apiId: String
    let upc: Int64
    var name: String
    let ingredients: [Ingredient]
    let nutritionFacts: [NutritionFact]
    var createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case upc
        case name
        case ingredients
        case nutritionFacts = "nutrition_facts"
    }

//    static func == (lhs: Food, rhs: Food) -> Bool {
//        lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        if let uuid = id {
//            hasher.combine(uuid)
//        } else {
//            hasher.combine(1)
//        }
//    }
}
