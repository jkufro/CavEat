//
//  SavedFoodSection.swift
//  CavEat
//
//  Created by Justin Kufro on 11/16/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct SavedFoodSection: Identifiable {
    let id = UUID()
    let day: String
    let foods: [Food]

    init(day: String, foods: [Food]) {
        self.day = day
        self.foods = foods.sorted {
            guard let thisDate = $0.createdAt, let otherDate = $1.createdAt else { return false }
            return thisDate > otherDate
        }
    }
}
