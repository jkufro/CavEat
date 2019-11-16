//
//  DVSettingRowViewModel.swift
//  CavEat
//
//  Created by Justin Kufro on 11/4/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import SwiftUI

class DVSettingRowViewModel: ObservableObject {
    @Published var nutrientSetting:NutrientSetting
    @Published var selection:Int
    var selectionOptions:[Float]
    var defaultSelectionIndex:Int

    init(nutrientSetting:NutrientSetting) {
        self.nutrientSetting = nutrientSetting
        let selectionOptions = DVSettingRowViewModel.getSelectionOptions(nutrientSetting: nutrientSetting)
        self.selectionOptions = selectionOptions
        self.defaultSelectionIndex = DVSettingRowViewModel.getDefaultSelectionIndex(selectionOptions: selectionOptions, nutrientSetting: nutrientSetting)
        self.selection = selectionOptions.firstIndex{$0 == nutrientSetting.dailyValue} ?? 0
    }

    func savePressed() {
        nutrientSetting.dailyValue = selectionOptions[selection]
        NutrientSettings.shared.updateDailyValue(name: nutrientSetting.name, newValue: selectionOptions[selection])
    }

    func resetToDefaultPressed() {
        selection = defaultSelectionIndex
    }

    private static func getSelectionOptions(nutrientSetting: NutrientSetting) -> [Float] {
        var result = [Float]()
        for value in stride(from: nutrientSetting.minValue, through: nutrientSetting.maxValue, by: nutrientSetting.valueStep) {
            result.append(value)
        }
        return result
    }

    private static func getDefaultSelectionIndex(selectionOptions: [Float], nutrientSetting: NutrientSetting) -> Int {
        return selectionOptions.firstIndex{$0 == nutrientSetting.defaultValue} ?? 0
    }
}
