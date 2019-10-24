//
//  NutrientSetting.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct NutrientSetting {
    let name: String
    let unit: String
    var dailyValue: Float?

//    mutating func updateValue(newDailyValue: Float) {
//        self.dailyValue = newDailyValue
//    }

    func dailyValuePercentage(nutrientValue: Float) -> String {
        guard let dValue = self.dailyValue else {
            return ""
        }
        guard dValue > 0.1 else { // avoid absurdly large percentages
            return ""
        }
        return "\(Int((nutrientValue / dValue) * 100))%"
    }
}
