//
//  DVSettingRowViewModelTest.swift
//  CavEatTests
//
//  Created by Justin Kufro on 11/18/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class DVSettingRowViewModelTest: XCTestCase {
    lazy var dataManager = InMemoryDataManagerHelper.shared.getInMemoryDataManager()
    var viewModel = DVSettingRowViewModel(nutrientSetting: NutrientSetting(id: UUID(uuidString: "55DADEE5-95BD-4105-82F3-1F0B20C67DA6")!, name: "Trans Fat", unit: "g", dailyValue: 2, minValue: 0, maxValue: 10, valueStep: 0.5, defaultValue: 2, sortingOrder: 30))

    override func setUp() {
        DataManager.shared = dataManager
        NutrientSettings.shared.seedSettings()
        viewModel = DVSettingRowViewModel(nutrientSetting: NutrientSetting(id: UUID(uuidString: "55DADEE5-95BD-4105-82F3-1F0B20C67DA6")!, name: "Trans Fat", unit: "g", dailyValue: 2, minValue: 0, maxValue: 10, valueStep: 0.5, defaultValue: 2, sortingOrder: 30))
    }

    override func tearDown() {
        InMemoryDataManagerHelper.shared.flushData(dataManager: dataManager)
    }

    func test_savePressed() {
        XCTAssertEqual(2.0, viewModel.nutrientSetting.dailyValue)
        viewModel.selection = 7
        viewModel.savePressed()
        XCTAssertEqual(3.5, viewModel.nutrientSetting.dailyValue)
    }

    func test_resetToDefaultPressed() {
        viewModel.selection = 7
        viewModel.resetToDefaultPressed()
        XCTAssertEqual(4, viewModel.selection)
    }

    func test_getSelectionOptions() {
        let expectedOptions: [Float] = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0]
        XCTAssertEqual(expectedOptions, viewModel.selectionOptions)
    }

    func test_getDefaultSelectionIndex() {
        XCTAssertEqual(4, viewModel.defaultSelectionIndex)
    }
}
