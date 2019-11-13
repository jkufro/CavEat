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
          "Added Sugars": NutrientSetting(id: UUID(uuidString: "093A8D5E-AB17-4D51-9E4B-EB14A87ADBB8")!, name: "Added Sugars", unit: "g", dailyValue: 32),
          "Cholesterol": NutrientSetting(id: UUID(uuidString: "C97F7160-4F88-452D-B834-94BDB6332480")!, name: "Cholesterol", unit: "mg", dailyValue: 300),
          "Dietary Fiber": NutrientSetting(id: UUID(uuidString: "C738265A-3E0A-4DD0-9FA1-B84C51B2908B")!, name: "Dietary Fiber", unit: "g", dailyValue: 25),
          "Protein": NutrientSetting(id: UUID(uuidString: "1DC27A39-E7B1-41FC-B05F-71DF89FA8EB5")!, name: "Protein", unit: "g", dailyValue: 50),
          "Saturated Fat": NutrientSetting(id: UUID(uuidString: "BAC6522A-5F72-4B32-9B66-6C202F504385")!, name: "Saturated Fat", unit: "g", dailyValue: 20),
          "Sodium": NutrientSetting(id: UUID(uuidString: "F402C9AB-8EAA-48F2-AC71-5C11D55A0ACD")!, name: "Sodium", unit: "mg", dailyValue: 2300),
          "Total Carbohydrates": NutrientSetting(id: UUID(uuidString: "2A0825B4-BC1F-40F7-AECB-EDCAB7367B69")!, name: "Total Carbohydrates", unit: "g", dailyValue: 300),
          "Total Fat": NutrientSetting(id: UUID(uuidString: "5B39AA3C-B7C9-47FD-8E80-0A917F0F3617")!, name: "Total Fat", unit: "g", dailyValue: 65),
          "Total Sugars": NutrientSetting(id: UUID(uuidString: "F450DF27-CA40-46A9-B2CB-AB8399555F06")!, name: "Total Sugars", unit: "g", dailyValue: 0),
          "Trans Fat": NutrientSetting(id: UUID(uuidString: "55DADEE5-95BD-4105-82F3-1F0B20C67DA6")!, name: "Trans Fat", unit: "g", dailyValue: 2)
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
