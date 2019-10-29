//
//  NutrientSettings.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

class NutrientSettings {
    static let shared = NutrientSettings()

    private var nutrientDictionary: [String: NutrientSetting]

    private init() {
        // set the defaults
        nutrientDictionary = [
            "Added Sugars": NutrientSetting(name: "Added Sugars", unit: "g", dailyValue: 32),
            "Dietary Fiber": NutrientSetting(name: "Dietary Fiber", unit: "g", dailyValue: 25)
        ]
    }

    public func getSetting(name: String) -> NutrientSetting? {
        if let nutrientSetting = nutrientDictionary[name] {
            return nutrientSetting
        }
        return nil
    }

    public func dailyValuePercentage(name: String, nutrientValue: Float) -> Int? {
        guard let nutrientSetting = getSetting(name: name) else {
            return nil
        }
        return nutrientSetting.dailyValuePercentage(nutrientValue: nutrientValue)
    }
}
