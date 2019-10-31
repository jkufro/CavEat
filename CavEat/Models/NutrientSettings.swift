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
        // nutrients with a dailyValue of 0 do not have a default DV provided by FDA
        nutrientDictionary = [
            "Added Sugars": NutrientSetting(name: "Added Sugars", unit: "g", dailyValue: 32),
            "Cholesterol": NutrientSetting(name: "Cholesterol", unit: "mg", dailyValue: 300),
            "Dietary Fiber": NutrientSetting(name: "Dietary Fiber", unit: "g", dailyValue: 25),
            "Protein": NutrientSetting(name: "Protein", unit: "g", dailyValue: 50),
            "Saturated Fat": NutrientSetting(name: "Saturated Fat", unit: "g", dailyValue: 20),
            "Sodium": NutrientSetting(name: "Sodium", unit: "mg", dailyValue: 2300),
            "Total Carbohydrates": NutrientSetting(name: "Total Carbohydrates", unit: "g", dailyValue: 300),
            "Total Fat": NutrientSetting(name: "Total Fat", unit: "g", dailyValue: 65),
            "Total Sugars": NutrientSetting(name: "Total Sugars", unit: "g", dailyValue: 0),
            "Trans Fat": NutrientSetting(name: "Trans Fat", unit: "g", dailyValue: 2)
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
