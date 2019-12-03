//
//  Ingredient.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct Ingredient: Codable, Identifiable, Comparable {
    var id: UUID = UUID()
    let apiId: String
    let name: String
    let composition: String?
    let description: String?
    let source: String?
    let isWarning: Bool
    var sortingOrder: Int = 500 // default to high number that would appear last in a list

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case name
        case composition
        case description
        case source
        case isWarning = "is_warning"
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

    static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.sortingOrder < rhs.sortingOrder
    }

    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.sortingOrder == rhs.sortingOrder
    }
}
