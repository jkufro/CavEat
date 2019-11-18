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

    override func setUp() {
        DataManager.shared = dataManager
    }

    override func tearDown() {
        InMemoryDataManagerHelper.shared.flushData(dataManager: dataManager)
    }

    func test_getFilteredFoods() {

    }

    func test_getSectionedFoods() {

    }

    func test_isFilteredFoodsEmpty() {

    }

    func test_dismissCallback() {

    }

    func test_deleteFood() {

    }
}
