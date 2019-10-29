//
//  Ingredient.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct Ingredient: Codable, Identifiable {
    let id: String
    let name: String
    let composition: String?
    let description: String?
    let source: String?
    let isWarning: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case composition
        case description
        case source
        case isWarning = "is_warning"
    }

  func getDescription() -> String {
      return self.description ?? "No description available"
  }
}
