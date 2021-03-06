//
//  NutritionFactTests.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class NutritionFactTests: XCTestCase {
    var dietaryFiber: NutritionFact = NutritionFact(apiId: "2", name: "Dietary Fiber", description: "dietary fiber desc", source: "https://medlineplus.gov/dietaryfiber.html", amount: 25, unit: "g", isLimiting: false)
    var energy: NutritionFact = NutritionFact(apiId: "3", name: "Energy", description: nil, source: nil, amount: 0, unit: "kcal", isLimiting: false)

    override func setUp() {
        dietaryFiber = NutritionFact(apiId: "2", name: "Dietary Fiber", description: "dietary fiber desc", source: "https://medlineplus.gov/dietaryfiber.html", amount: 25, unit: "g", isLimiting: false)
        energy = NutritionFact(apiId: "3", name: "Energy", description: nil, source: nil, amount: 0, unit: "kcal", isLimiting: false)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_measurement() {
        XCTAssertEqual("25.0g | 100%", dietaryFiber.measurement())
        XCTAssertEqual("0.0kcal", energy.measurement())

    }

    func test_getDescription() {
        XCTAssertEqual("dietary fiber desc", dietaryFiber.getDescription())
        XCTAssertEqual("No description available", energy.getDescription())
        energy = NutritionFact(apiId: "3", name: "Energy", description: " ", source: nil, amount: 0, unit: "kcal", isLimiting: false)
        XCTAssertEqual("No description available", energy.getDescription())
    }

    func test_isWarning() {
        XCTAssertFalse(dietaryFiber.isWarning())
        dietaryFiber = NutritionFact(apiId: "2", name: "Dietary Fiber", description: "dietary fiber desc", source: "https://medlineplus.gov/dietaryfiber.html", amount: 32, unit: "g", isLimiting: true)
        XCTAssertTrue(dietaryFiber.isWarning())
        NutrientSettings.shared.updateDailyValue(name: "Dietary Fiber", newValue: 0.0)
        XCTAssertTrue(dietaryFiber.isWarning())
        NutrientSettings.shared.updateDailyValue(name: "Dietary Fiber", newValue: 25.0)
        let nonexistentFact = NutritionFact(apiId: "2", name: "I dont exist", description: "", source: nil, amount: 32, unit: "g", isLimiting: true)
        XCTAssertFalse(nonexistentFact.isWarning())
    }

    func test_comparable() {
        XCTAssertEqual(dietaryFiber, dietaryFiber)
        XCTAssertEqual(dietaryFiber, energy)
        dietaryFiber.sortingOrder = 1
        XCTAssertTrue(dietaryFiber < energy)
    }
}
