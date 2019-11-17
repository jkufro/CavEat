//
//  SavedFoodSection.swift
//  CavEat
//
//  Created by Justin Kufro on 11/16/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct SavedFoodSection: Identifiable, Comparable {
    let id = UUID()
    let day: Date
    let foods: [Food]
    let dateFormatter = DateFormatter()

    init(day: Date, foods: [Food]) {
        self.day = day
        self.foods = foods.sorted {
            guard let thisDate = $0.createdAt, let otherDate = $1.createdAt else { return false }
            return thisDate > otherDate
        }
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }

    func dayString() -> String {
        return dateFormatter.string(from: day)
    }

    static func < (lhs: SavedFoodSection, rhs: SavedFoodSection) -> Bool {
        lhs.day < rhs.day
    }

    static func == (lhs: SavedFoodSection, rhs: SavedFoodSection) -> Bool {
        lhs.day == rhs.day
    }
}
