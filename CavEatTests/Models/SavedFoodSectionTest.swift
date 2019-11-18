//
//  SavedFoodSectionTest.swift
//  CavEatTests
//
//  Created by Justin Kufro on 11/18/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class SavedFoodSectionTest: XCTestCase {
    lazy var dataManager = InMemoryDataManagerHelper.shared.getInMemoryDataManager()
    // Foods
    lazy var candy = Food(apiId: "1", upc: Int64(1), name: "Snickers", ingredients: [], nutritionFacts: [])
    lazy var chocMilk = Food(apiId: "2", upc: Int64(2), name: "TruMoo", ingredients: [], nutritionFacts: [])
    lazy var savedFoodSection = SavedFoodSection(day: Calendar.current.startOfDay(for: Date()), foods: [])

    override func setUp() {
        DataManager.shared = dataManager
        _ = dataManager.saveFood(food: candy)
        _ = dataManager.saveFood(food: chocMilk)
        candy = dataManager.loadFoods().first(where: { $0.name == candy.name })!
        chocMilk = dataManager.loadFoods().first(where: { $0.name == chocMilk.name })!
        savedFoodSection = SavedFoodSection(day: Calendar.current.startOfDay(for: Date()), foods: [candy, chocMilk])
    }

    override func tearDown() {
        InMemoryDataManagerHelper.shared.flushData(dataManager: dataManager)
    }

    func test_dayString() {
        XCTAssertEqual("Today", savedFoodSection.dayString())
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let yesterday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        let yesterdaySection = SavedFoodSection(day: Calendar.current.startOfDay(for: yesterday), foods: [])
        XCTAssertEqual(dateFormatter.string(from: yesterday), yesterdaySection.dayString())
    }

    func test_initSorting() {
        XCTAssertEqual([chocMilk, candy].map { $0.name }, savedFoodSection.foods.map { $0.name })
    }

    func test_comparable() {
        let yesterday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        let sameDaySection = SavedFoodSection(day: Calendar.current.startOfDay(for: Date()), foods: [])
        let yesterdaySection = SavedFoodSection(day: Calendar.current.startOfDay(for: yesterday), foods: [])
        XCTAssertEqual(savedFoodSection, savedFoodSection)
        XCTAssertEqual(savedFoodSection, sameDaySection)
        XCTAssertTrue(savedFoodSection < yesterdaySection)
    }
}
