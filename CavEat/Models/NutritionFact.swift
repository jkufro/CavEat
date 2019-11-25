//
//  Nutrient.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct NutritionFact: Codable, Identifiable, Comparable {
    var id: UUID = UUID()
    let apiId: String
    let name: String
    let description: String?
    let source: String?
    let amount: Float
    let unit: String
    let isLimiting: Bool
    var sortingOrder: Int = 500 // default to high number that would appear last in a list

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case name = "common_name"
        case description
        case source
        case amount
        case unit
        case isLimiting = "is_limiting"
    }

    func measurement() -> String {
        let roundedFloat: String = String(format: "%.1f", self.amount)
        var result: String = "\(roundedFloat)\(self.unit)"
        if let dvPercentage = NutrientSettings.shared.dailyValuePercentage(name: self.name, nutrientValue: self.amount) {
            result += " | \(dvPercentage)%"
        }
        return result
    }

    func getDescription() -> String {
        guard let desc = self.description else {
            return "No description available"
        }
        if desc.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "No description available"
        }
        return desc
    }

    func isWarning() -> Bool {
        let warningThreshold: Int = 33
        if let dvSetting = NutrientSettings.shared.nutrientDictionary[self.name] {
            if let dvPercentage = dvSetting.dailyValuePercentage(nutrientValue: self.amount) {
                return self.isLimiting && dvPercentage >= warningThreshold
            }
            return self.isLimiting && self.amount >= dvSetting.dailyValue // catches if dv is zero
        }
        return false
    }

    static func < (lhs: NutritionFact, rhs: NutritionFact) -> Bool {
        lhs.sortingOrder < rhs.sortingOrder
    }

    static func == (lhs: NutritionFact, rhs: NutritionFact) -> Bool {
        lhs.sortingOrder == rhs.sortingOrder
    }
}
