//
//  NutrientSettingTests.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class NutrientSettingTests: XCTestCase {
    var addedSugars: NutrientSetting = NutrientSetting(name: "Added Sugars", unit: "g", dailyValue: 32, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 32)
    var dietaryFiber: NutrientSetting = NutrientSetting(name: "Dietary Fiber", unit: "g", dailyValue: 25, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 25)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        addedSugars = NutrientSetting(name: "Added Sugars", unit: "g", dailyValue: 32, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 32)
        dietaryFiber = NutrientSetting(name: "Dietary Fiber", unit: "g", dailyValue: 25, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 25)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_updateValue() {
        XCTAssertEqual(32, addedSugars.dailyValue)
        addedSugars.dailyValue = 42
        XCTAssertEqual(42, addedSugars.dailyValue)
    }

    func test_dailyValuePercentage() {
        XCTAssertEqual(0, addedSugars.dailyValuePercentage(nutrientValue: 0))
        XCTAssertEqual(50, addedSugars.dailyValuePercentage(nutrientValue: 16))
        XCTAssertEqual(200, addedSugars.dailyValuePercentage(nutrientValue: 64))
        addedSugars.dailyValue = 0.09
        XCTAssertEqual(nil, addedSugars.dailyValuePercentage(nutrientValue: 5))
        addedSugars.dailyValue = 0
        XCTAssertEqual(nil, addedSugars.dailyValuePercentage(nutrientValue: 5))
        addedSugars.dailyValue = -1.555
        XCTAssertEqual(nil, addedSugars.dailyValuePercentage(nutrientValue: 5))
    }
}
