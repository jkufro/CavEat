//
//  SavedScansViewModelTest.swift
//  CavEatTests
//
//  Created by Justin Kufro on 11/18/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class SavedScansViewModelTest: XCTestCase {
    lazy var dataManager = InMemoryDataManagerHelper.shared.getInMemoryDataManager()
    // Foods
    lazy var candy = Food(apiId: "1", upc: Int64(1), name: "Snickers", ingredients: [], nutritionFacts: [])
    lazy var chocMilk = Food(apiId: "2", upc: Int64(2), name: "TruMoo", ingredients: [], nutritionFacts: [])
    var viewModel = SavedScansViewModel()

    override func setUp() {
        DataManager.shared = dataManager
        _ = dataManager.saveFood(food: candy)
        _ = dataManager.saveFood(food: chocMilk)
        viewModel = SavedScansViewModel()
    }

    override func tearDown() {
        InMemoryDataManagerHelper.shared.flushData(dataManager: dataManager)
    }

    func test_getFilteredFoods() {
        XCTAssertEqual(2, viewModel.getFilteredFoods().count)
        viewModel.searchTerm = "ers"
        XCTAssertEqual(1, viewModel.getFilteredFoods().count)
        XCTAssertEqual("Snickers", viewModel.getFilteredFoods()[0].name)
    }

    func test_getSectionedFoods() {
        var expected = [
            SavedFoodSection(day: Calendar.current.startOfDay(for: Date()), foods: dataManager.loadFoods())
        ]
        XCTAssertEqual(expected, viewModel.getSectionedFoods())
        XCTAssertEqual(2, viewModel.getSectionedFoods()[0].foods.count)
        let yesterday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        let yesterdayFood = Food(id: viewModel.allSavedFoods[0].id, apiId: viewModel.allSavedFoods[0].apiId, upc: viewModel.allSavedFoods[0].upc, name: viewModel.allSavedFoods[0].name, ingredients: viewModel.allSavedFoods[0].ingredients, nutritionFacts: viewModel.allSavedFoods[0].nutritionFacts, createdAt: yesterday)
        viewModel.allSavedFoods[0] = yesterdayFood
        expected = [
            SavedFoodSection(day: Calendar.current.startOfDay(for: Date()), foods: [viewModel.allSavedFoods[1]]),
            SavedFoodSection(day: Calendar.current.startOfDay(for: yesterday), foods: [viewModel.allSavedFoods[0]])
        ]
        XCTAssertEqual(expected, viewModel.getSectionedFoods())
    }

    func test_isFilteredFoodsEmpty() {
        XCTAssertFalse(viewModel.isFilteredFoodsEmpty())
        viewModel.searchTerm = "no food contains this text"
        XCTAssertTrue(viewModel.isFilteredFoodsEmpty())
    }

    func test_dismissCallback() {
        XCTAssertEqual(2, viewModel.allSavedFoods.count)
        let pasta = Food(apiId: "2", upc: Int64(2), name: "Pasta", ingredients: [], nutritionFacts: [])
        _ = dataManager.saveFood(food: pasta)
        XCTAssertEqual(2, viewModel.allSavedFoods.count)
        viewModel.dismissCallback()
        XCTAssertEqual(3, viewModel.allSavedFoods.count)
    }

    func test_deleteFood() {
        // setup more foods
        let yesterday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        let twoDaysAgo = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
        var pasta = Food(apiId: "2", upc: Int64(2), name: "Pasta", ingredients: [], nutritionFacts: [])
        var cheerios = Food(apiId: "2", upc: Int64(2), name: "Cheerios", ingredients: [], nutritionFacts: [])
        var sourCream = Food(apiId: "2", upc: Int64(2), name: "Sour Cream", ingredients: [], nutritionFacts: [])
        _ = dataManager.saveFood(food: pasta)
        _ = dataManager.saveFood(food: cheerios)
        _ = dataManager.saveFood(food: sourCream)
        viewModel.allSavedFoods = dataManager.loadFoods()
        let pastaIndex = viewModel.allSavedFoods.firstIndex(where: { $0.name == pasta.name })!
        let cheeriosIndex = viewModel.allSavedFoods.firstIndex(where: { $0.name == cheerios.name })!
        let sourCreamIndex = viewModel.allSavedFoods.firstIndex(where: { $0.name == sourCream.name })!
        pasta = viewModel.allSavedFoods[pastaIndex]
        cheerios = viewModel.allSavedFoods[cheeriosIndex]
        sourCream = viewModel.allSavedFoods[sourCreamIndex]
        // modify dates on some foods
        let pastaYesterday = Food(id: pasta.id, apiId: pasta.apiId, upc: pasta.upc, name: pasta.name, ingredients: pasta.ingredients, nutritionFacts: pasta.nutritionFacts, createdAt: yesterday)
        let cheeriosYesterday = Food(id: cheerios.id, apiId: cheerios.apiId, upc: cheerios.upc, name: cheerios.name, ingredients: cheerios.ingredients, nutritionFacts: cheerios.nutritionFacts, createdAt: yesterday)
        let sourCreamTwoDaysAgo = Food(id: sourCream.id, apiId: sourCream.apiId, upc: sourCream.upc, name: sourCream.name, ingredients: sourCream.ingredients, nutritionFacts: sourCream.nutritionFacts, createdAt: twoDaysAgo)
        viewModel.allSavedFoods[pastaIndex] = pastaYesterday
        viewModel.allSavedFoods[cheeriosIndex] = cheeriosYesterday
        viewModel.allSavedFoods[sourCreamIndex] = sourCreamTwoDaysAgo
        // test the function
        XCTAssertEqual(5, viewModel.allSavedFoods.count)
        viewModel.deleteFood(at: IndexSet(integer: 1), day: yesterday) // should delete pastaYesterday
        XCTAssertEqual(4, viewModel.allSavedFoods.count)
        XCTAssertFalse(viewModel.allSavedFoods.contains(where: { pastaYesterday.name == $0.name }))
    }
}
