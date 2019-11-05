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
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_dailyValuePercentage() {
        XCTAssertEqual(0, NutrientSettings.shared.dailyValuePercentage(name: "Added Sugars", nutrientValue: 0)!)
        XCTAssertEqual(50, NutrientSettings.shared.dailyValuePercentage(name: "Added Sugars", nutrientValue: 16)!)
        XCTAssertEqual(200, NutrientSettings.shared.dailyValuePercentage(name: "Added Sugars", nutrientValue: 64)!)
        XCTAssertEqual(nil, NutrientSettings.shared.dailyValuePercentage(name: "Doesn't Exist", nutrientValue: 5))
    }
}
