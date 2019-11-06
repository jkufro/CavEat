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
  var resultVM = ResultViewModel(food: Food)

    override func setUp() {
        resultVM = ResultViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_renameFood_success() {
        XCTAssertNil(scanVM.upc)
        scanVM.scanCompletionHandler("1234567890")
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("1234567890", self.scanVM.upc)
        XCTAssertTrue(self.scanVM.showFood)
        XCTAssertEqual("SuccessfulAPIClientMock Food", self.scanVM.food.name)
        XCTAssertFalse(self.scanVM.waiting)
    }

    func test_renameFood_failure() {
        scanVM.apiClient = FailedAPIClientMock()
        XCTAssertNil(scanVM.upc)
        scanVM.scanCompletionHandler("1234567890")
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("1234567890", self.scanVM.upc)
        XCTAssertTrue(self.scanVM.promptForManualDecision)
        XCTAssertTrue(self.scanVM.anyAlerts)
        XCTAssertFalse(self.scanVM.waiting)
    }

   
}

