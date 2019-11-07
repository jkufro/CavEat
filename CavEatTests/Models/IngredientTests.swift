//
//  IngredientTest.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class IngredientTests: XCTestCase {
    var milk = Ingredient(id: "1", name: "Milk", composition: nil, description: "From a cow.", source: nil, isWarning: false)

    override func setUp() {
        milk = Ingredient(id: "1", name: "Milk", composition: nil, description: "From a cow.", source: nil, isWarning: false)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getDescription() {
        XCTAssertEqual("From a cow.", milk.getDescription())
        milk = Ingredient(id: "1", name: "Milk", composition: nil, description: nil, source: nil, isWarning: false)
        XCTAssertEqual("No description available", milk.getDescription())
        milk = Ingredient(id: "1", name: "Milk", composition: nil, description: " ", source: nil, isWarning: false)
        XCTAssertEqual("No description available", milk.getDescription())
    }
}
