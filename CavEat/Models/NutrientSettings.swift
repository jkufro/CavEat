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

    var nutrientDictionary: [String: NutrientSetting]

    private init() {
        // set the defaults
        // nutrients with a dailyValue of 0 do not have a default DV provided by FDA
        nutrientDictionary = [
            "Added Sugars": NutrientSetting(name: "Added Sugars", unit: "g", dailyValue: 32, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 32),
            "Cholesterol": NutrientSetting(name: "Cholesterol", unit: "mg", dailyValue: 300, minValue: 0, maxValue: 750, valueStep: 50, defaultValue: 300),
            "Dietary Fiber": NutrientSetting(name: "Dietary Fiber", unit: "g", dailyValue: 25, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 25),
            "Protein": NutrientSetting(name: "Protein", unit: "g", dailyValue: 50, minValue: 0, maxValue: 100, valueStep: 1, defaultValue: 50),
            "Saturated Fat": NutrientSetting(name: "Saturated Fat", unit: "g", dailyValue: 20, minValue: 0, maxValue: 30, valueStep: 1, defaultValue: 20),
            "Sodium": NutrientSetting(name: "Sodium", unit: "mg", dailyValue: 2300, minValue: 0, maxValue: 3000, valueStep: 100, defaultValue: 2300),
            "Total Carbohydrates": NutrientSetting(name: "Total Carbohydrates", unit: "g", dailyValue: 300, minValue: 0, maxValue: 500, valueStep: 1, defaultValue: 10),
            "Total Fat": NutrientSetting(name: "Total Fat", unit: "g", dailyValue: 65, minValue: 0, maxValue: 100, valueStep: 1, defaultValue: 65),
            "Total Sugars": NutrientSetting(name: "Total Sugars", unit: "g", dailyValue: 32, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 32),
            "Trans Fat": NutrientSetting(name: "Trans Fat", unit: "g", dailyValue: 2, minValue: 0, maxValue: 50, valueStep: 0.5, defaultValue: 5)
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
