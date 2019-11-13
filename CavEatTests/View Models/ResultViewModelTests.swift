//
//  ResultViewModelTests.swift
//  CavEatTests
//
//  Created by John Kim on 11/5/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class ResultViewModelTests: XCTestCase {
    var resultVM = ResultViewModel(
        food: Food(
          api_id: "1",
            upc: 1234567890,
            name: "My Food",
            ingredients: [
        Ingredient(
            id: "123",
            name: "Milk",
            composition: nil,
            description: nil,
            source: nil,
            isWarning: false)
        ],
        nutritionFacts: [
            NutritionFact(
                id: "1",
                name: "Cholesterol",
                description: "Needed for the body in moderate amounts. Excess consumption is known to lead to plaque buildup in arteries. This may lead to coronary artery disease, heart attack, or stroke.",
                source: "https://medlineplus.gov/cholesterol.html",
                amount: 5.2,
                unit: "mg",
                isLimiting: true),
            NutritionFact(
                id: "2",
                name: "Dietary Fiber",
                description: "Helps digestions and prevent constipation, and helps control your weight by making you feel full faster. You should get enough fiber, but adding too much too quickly can lead to gas, bloating, and cramps.",
                source: "https://medlineplus.gov/dietaryfiber.html",
                amount: 3,
                unit: "g",
                isLimiting: false),
            NutritionFact(
                id: "3",
                name: "Energy",
                description: nil,
                source: nil,
                amount: 0,
                unit: "kcal",
                isLimiting: false)
            ]
        )
    )

    override func setUp() {
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
