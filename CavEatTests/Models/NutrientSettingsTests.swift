//
//  NutrientSettingsTests.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class NutrientSettingsTests: XCTestCase {
    lazy var dataManager = InMemoryDataManagerHelper.shared.getInMemoryDataManager()
    
    override func setUp() {
        DataManager.shared = dataManager
    }

    override func tearDown() {
        InMemoryDataManagerHelper.shared.flushData(dataManager: dataManager)
    }

    func test_getSetting() {
        XCTAssertEqual("Added Sugars", NutrientSettings.shared.getSetting(name: "Added Sugars")!.name)
        XCTAssertEqual("Dietary Fiber", NutrientSettings.shared.getSetting(name: "Dietary Fiber")!.name)
    }

    func test_dailyValuePercentage() {
        XCTAssertEqual(0, NutrientSettings.shared.dailyValuePercentage(name: "Added Sugars", nutrientValue: 0)!)
        XCTAssertEqual(50, NutrientSettings.shared.dailyValuePercentage(name: "Added Sugars", nutrientValue: 16)!)
        XCTAssertEqual(200, NutrientSettings.shared.dailyValuePercentage(name: "Added Sugars", nutrientValue: 64)!)
        XCTAssertEqual(nil, NutrientSettings.shared.dailyValuePercentage(name: "Doesn't Exist", nutrientValue: 5))
    }

    func test_seedSettings() {
        NutrientSettings.shared.seedSettings()
        XCTAssertEqual(10, DataManager.shared.loadSettings().count)
        NutrientSettings.shared.seedSettings()
        NutrientSettings.shared.seedSettings()
        XCTAssertEqual(10, DataManager.shared.loadSettings().count)
    }
}
