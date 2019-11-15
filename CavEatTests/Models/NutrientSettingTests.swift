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
  var addedSugars: NutrientSetting = NutrientSetting(id: UUID(uuidString: "093A8D5E-AB17-4D51-9E4B-EB14A87ADBB8")!, name: "Added Sugars", unit: "g", dailyValue: 32)
  var dietaryFiber: NutrientSetting = NutrientSetting(id: UUID(uuidString: "C97F7160-4F88-452D-B834-94BDB6332480")!, name: "Dietary Fiber", unit: "g", dailyValue: 25)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      addedSugars = NutrientSetting(id: UUID(uuidString: "093A8D5E-AB17-4D51-9E4B-EB14A87ADBB8")!, name: "Added Sugars", unit: "g", dailyValue: 32)
      dietaryFiber = NutrientSetting(id: UUID(uuidString: "C97F7160-4F88-452D-B834-94BDB6332480")!, name: "Dietary Fiber", unit: "g", dailyValue: 25)
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
