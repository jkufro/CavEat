//
//  NutrientSettings.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

class NutrientSettings: ObservableObject {
    static let shared = NutrientSettings()
    private static var defaultSettings: [String: NutrientSetting] = [
        "Total Fat": NutrientSetting(id: UUID(uuidString: "5B39AA3C-B7C9-47FD-8E80-0A917F0F3617")!, name: "Total Fat", unit: "g", dailyValue: 65, minValue: 0, maxValue: 100, valueStep: 1, defaultValue: 65, sortingOrder: 10),
        "Saturated Fat": NutrientSetting(id: UUID(uuidString: "BAC6522A-5F72-4B32-9B66-6C202F504385")!, name: "Saturated Fat", unit: "g", dailyValue: 20, minValue: 0, maxValue: 30, valueStep: 1, defaultValue: 20, sortingOrder: 20),
        "Trans Fat": NutrientSetting(id: UUID(uuidString: "55DADEE5-95BD-4105-82F3-1F0B20C67DA6")!, name: "Trans Fat", unit: "g", dailyValue: 2, minValue: 0, maxValue: 50, valueStep: 0.5, defaultValue: 5, sortingOrder: 30),
        "Cholesterol": NutrientSetting(id: UUID(uuidString: "C97F7160-4F88-452D-B834-94BDB6332480")!, name: "Cholesterol", unit: "mg", dailyValue: 300, minValue: 0, maxValue: 750, valueStep: 50, defaultValue: 300, sortingOrder: 40),
        "Sodium": NutrientSetting(id: UUID(uuidString: "F402C9AB-8EAA-48F2-AC71-5C11D55A0ACD")!, name: "Sodium", unit: "mg", dailyValue: 2300, minValue: 0, maxValue: 3000, valueStep: 100, defaultValue: 2300, sortingOrder: 50),
        "Total Carbohydrates": NutrientSetting(id: UUID(uuidString: "2A0825B4-BC1F-40F7-AECB-EDCAB7367B69")!, name: "Total Carbohydrates", unit: "g", dailyValue: 300, minValue: 0, maxValue: 500, valueStep: 1, defaultValue: 300, sortingOrder: 60),
        "Total Sugars": NutrientSetting(id: UUID(uuidString: "F450DF27-CA40-46A9-B2CB-AB8399555F06")!, name: "Total Sugars", unit: "g", dailyValue: 32, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 32, sortingOrder: 70),
        "Added Sugars": NutrientSetting(id: UUID(uuidString: "093A8D5E-AB17-4D51-9E4B-EB14A87ADBB8")!, name: "Added Sugars", unit: "g", dailyValue: 32, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 32, sortingOrder: 80),
        "Dietary Fiber": NutrientSetting(id: UUID(uuidString: "C738265A-3E0A-4DD0-9FA1-B84C51B2908B")!, name: "Dietary Fiber", unit: "g", dailyValue: 25, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 25, sortingOrder: 90),
        "Protein": NutrientSetting(id: UUID(uuidString: "1DC27A39-E7B1-41FC-B05F-71DF89FA8EB5")!, name: "Protein", unit: "g", dailyValue: 50, minValue: 0, maxValue: 100, valueStep: 1, defaultValue: 50, sortingOrder: 100)
    ]

    @Published var nutrientDictionary: [String: NutrientSetting]

    private init() {
        nutrientDictionary = [String: NutrientSetting]()
        seedSettings()
    }

    func dailyValuePercentage(name: String, nutrientValue: Float) -> Int? {
        guard let nutrientSetting = nutrientDictionary[name] else {
            return nil
        }
        return nutrientSetting.dailyValuePercentage(nutrientValue: nutrientValue)
    }

    func updateDailyValue(name: String, newValue: Float) {
        guard var nutrientSetting = nutrientDictionary[name] else {
            return
        }
        nutrientSetting.dailyValue = newValue
        _ = DataManager.shared.saveSetting(setting: nutrientSetting)
        nutrientDictionary.updateValue(nutrientSetting, forKey: name)
    }

    func seedSettings() {
        let existingSettings = DataManager.shared.loadSettings()
        for (_, setting) in NutrientSettings.defaultSettings {
            if existingSettings.contains(where: { $0.id == setting.id }) { continue }
            _ = DataManager.shared.saveSetting(setting: setting)
        }
        for setting in DataManager.shared.loadSettings() {
            nutrientDictionary.updateValue(setting, forKey: setting.name)
        }
    }
}
