//
//  NutrientSetting.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

struct NutrientSetting: Identifiable {
    let id: UUID = UUID()
    let name: String
    let unit: String
    var dailyValue: Float
    let minValue: Float
    let maxValue: Float
    let valueStep: Float
    let defaultValue: Float
    
    func dailyValuePercentage(nutrientValue: Float) -> Int? {
        guard dailyValue > 0.1 else { // avoid absurdly large percentages
            return nil
        }
        return Int((nutrientValue / dailyValue) * 100)
    }
}
