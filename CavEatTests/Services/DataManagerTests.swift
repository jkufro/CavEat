//
//  DataManager.swift
//  CavEatTests
//
//  Created by Darien Weems on 11/14/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import CoreData
import XCTest
@testable import CavEat

class DataManagerTests: XCTestCase {
    lazy var dataManager = InMemoryDataManagerHelper.shared.getInMemoryDataManager()

    // Ingredients
    var milk = Ingredient(apiId: "1", name: "Milk", composition: nil, description: "From a cow.", source: nil, isWarning: false)
    var cocoa = Ingredient(apiId: "2", name: "Cocoa", composition: nil, description: "From a cocoa bean.", source: nil, isWarning: false)

    // Nutrition Facts
    var dietaryFiberNF: NutritionFact = NutritionFact(apiId: "2", name: "Dietary Fiber", description: "dietary fiber desc", source: "https://medlineplus.gov/dietaryfiber.html", amount: 25, unit: "g", isLimiting: false)
    var energy: NutritionFact = NutritionFact(apiId: "3", name: "Energy", description: nil, source: nil, amount: 200, unit: "kcal", isLimiting: false)

    // Nutrient Settings
    var addedSugars: NutrientSetting = NutrientSetting(id: UUID(uuidString: "093A8D5E-AB17-4D51-9E4B-EB14A87ADBB8")!, name: "Added Sugars", unit: "g", dailyValue: 32, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 32, sortingOrder: 10)
    var dietaryFiberNS: NutrientSetting = NutrientSetting(id: UUID(uuidString: "C97F7160-4F88-452D-B834-94BDB6332480")!, name: "Dietary Fiber", unit: "g", dailyValue: 25, minValue: 0, maxValue: 50, valueStep: 1, defaultValue: 25, sortingOrder: 20)
    // Foods
    lazy var candy = Food(apiId: "1", upc: Int64(1), name: "Snickers", ingredients: [cocoa], nutritionFacts: [energy, dietaryFiberNF])
    lazy var chocMilk = Food(apiId: "2", upc: Int64(2), name: "TruMoo", ingredients: [cocoa, milk], nutritionFacts: [energy, dietaryFiberNF])

    // MARK: - Data Setup and Teardown
    override func setUp() {
        DataManager.shared = dataManager
    }

    override func tearDown() {
        InMemoryDataManagerHelper.shared.flushData(dataManager: dataManager)
    }

    // MARK: - Actual Tests
    func test_saveFood() {
        XCTAssertTrue(DataManager.shared.saveFood(food: candy))
        var foods = DataManager.shared.loadFoods()
        XCTAssertEqual(1, foods.count)
        XCTAssertEqual(foods[0].name, "Snickers")
        XCTAssertNotNil(foods[0].createdAt)
        // test that re-saving a food does not create a duplicate
        XCTAssertTrue(DataManager.shared.saveFood(food: foods[0]))
        foods = DataManager.shared.loadFoods()
        XCTAssertEqual(1, foods.count)
        XCTAssertEqual(foods[0].name, "Snickers")
        // test that renaming a food works
        foods[0].name = "Hazelnut Snickers"
        XCTAssertTrue(DataManager.shared.saveFood(food: foods[0]))
        foods = DataManager.shared.loadFoods()
        XCTAssertEqual(1, foods.count)
        XCTAssertEqual(foods[0].name, "Hazelnut Snickers")
        // test saving a second food
        XCTAssertTrue(DataManager.shared.saveFood(food: chocMilk))
        foods = DataManager.shared.loadFoods()
        XCTAssertEqual(2, foods.count)
    }

    func test_loadFoods() {
        XCTAssertTrue(DataManager.shared.saveFood(food: chocMilk))
        XCTAssertTrue(DataManager.shared.saveFood(food: candy))
        let foods = DataManager.shared.loadFoods()
        XCTAssertEqual(2, foods.count)
        XCTAssertNotNil(foods[0].createdAt)
        XCTAssertEqual(foods[0].name, "Snickers")
        XCTAssertEqual(foods[0].nutritionFacts.count, 2)
        XCTAssertEqual(foods[0].ingredients.count, 1)
        XCTAssertNotNil(foods[1].createdAt)
        XCTAssertEqual(foods[1].name, "TruMoo")
        XCTAssertEqual(foods[1].nutritionFacts.count, 2)
        XCTAssertEqual(foods[1].ingredients.count, 2)
    }

    func test_deleteFood() {
        XCTAssertTrue(DataManager.shared.saveFood(food: candy))
        XCTAssertTrue(DataManager.shared.saveFood(food: chocMilk))
        var foods = DataManager.shared.loadFoods() // candy and chocMilk dont get uuids until they are saved
        XCTAssertEqual(2, foods.count)
        let deleteTarget = foods[0]
        let remainingTarget = foods[1]
        XCTAssertTrue(DataManager.shared.deleteFood(food: deleteTarget))
        foods = DataManager.shared.loadFoods()
        XCTAssertEqual(1, foods.count)
        XCTAssertEqual(foods[0].id, remainingTarget.id)
    }

    func test_saveSettings() {
        XCTAssertTrue(DataManager.shared.saveSetting(setting: addedSugars))
        var settings = DataManager.shared.loadSettings()
        XCTAssertEqual(1, settings.count)
        // test that re-saving a setting does not create a duplicate
        XCTAssertTrue(DataManager.shared.saveSetting(setting: addedSugars))
        XCTAssertEqual(1, settings.count)
        // test that updating the dv of an existing food works
        XCTAssertEqual(32, settings[0].dailyValue)
        settings[0].dailyValue = 5
        XCTAssertTrue(DataManager.shared.saveSetting(setting: settings[0]))
        settings = DataManager.shared.loadSettings()
        XCTAssertEqual(1, settings.count)
        XCTAssertEqual(5, settings[0].dailyValue)
        // test saving a second setting
        XCTAssertTrue(DataManager.shared.saveSetting(setting: dietaryFiberNS))
        settings = DataManager.shared.loadSettings()
        XCTAssertEqual(2, settings.count)
    }

    func test_loadSettings() {
        XCTAssertTrue(DataManager.shared.saveSetting(setting: addedSugars))
        XCTAssertTrue(DataManager.shared.saveSetting(setting: dietaryFiberNS))
        let settings = DataManager.shared.loadSettings()
        XCTAssertEqual(2, settings.count)
        XCTAssertEqual(settings[0].name, "Dietary Fiber")
        XCTAssertEqual(settings[1].name, "Added Sugars")
    }
}
