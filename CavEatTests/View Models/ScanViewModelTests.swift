//
//  ScanViewModelTests.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/31/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class ScanViewModelTests: XCTestCase {
    let image: UIImage = ImagesHelper.shared.loadUIImage("no_text_image", "jpg")!
    var scanVM = ScanViewModel()

    override func setUp() {
        scanVM = ScanViewModel()
        scanVM.apiClient = SuccessfulAPIClientMock()
        scanVM.imageReader = MockImageReader(strSequence: ["Some Text"], boolSequence: [true])
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_scanCompletionHandler_success() {
        XCTAssertNil(scanVM.upc)
        scanVM.scanCompletionHandler("1234567890")
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("1234567890", self.scanVM.upc)
        XCTAssertTrue(self.scanVM.showFood)
        XCTAssertEqual("SuccessfulAPIClientMock Food", self.scanVM.food.name)
        XCTAssertFalse(self.scanVM.waiting)
    }

    func test_scanCompletionHandler_failure() {
        scanVM.apiClient = FailedAPIClientMock()
        XCTAssertNil(scanVM.upc)
        scanVM.scanCompletionHandler("1234567890")
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("1234567890", self.scanVM.upc)
        XCTAssertTrue(self.scanVM.promptForManualDecision)
        XCTAssertTrue(self.scanVM.anyAlerts)
        XCTAssertFalse(self.scanVM.waiting)
    }

    func test_captureCompletionHandler_success() {
        scanVM.upc = "1234567890"
        scanVM.state = .nutritionFactScanning
        scanVM.captureCompletionHandler(image, nil)
        XCTAssertEqual(.ingredientScanning, scanVM.state)
        XCTAssertEqual(image, scanVM.nutritionFactsImage)
        scanVM.captureCompletionHandler(image, nil)
        XCTAssertEqual(.ingredientScanning, scanVM.state)
        XCTAssertEqual(image, scanVM.ingredientsImage)
    }

    func test_completeManualScan_success() {
        // fail to read ingredients image
        scanVM.upc = "1234567890"
        scanVM.nutritionFactsImage = image
        scanVM.state = .ingredientScanning
        scanVM.captureCompletionHandler(image, nil)
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual(.upcScanning, self.scanVM.state)
        XCTAssertTrue(self.scanVM.showFood)
    }

    func test_completeManualScan_failure_guardUPC() {
        // fail on upc guard
        scanVM.state = .ingredientScanning
        scanVM.captureCompletionHandler(image, nil)
        XCTAssertEqual(.upcScanning, scanVM.state)
        XCTAssertNil(scanVM.ingredientsImage)
    }

    func test_completeManualScan_failure_guardNutritionFacts() {
        // fail on nutritionFactsImage guard
        scanVM.upc = "1234567890"
        scanVM.state = .ingredientScanning
        scanVM.captureCompletionHandler(image, nil)
        XCTAssertEqual(.nutritionFactScanning, scanVM.state)
        XCTAssertNil(scanVM.ingredientsImage)
    }

    func test_completeManualScan_failure_readNutritionFacts() {
        scanVM.imageReader = MockImageReader(strSequence: [""], boolSequence: [true])
        // fail to read nutritionFacts image
        scanVM.upc = "1234567890"
        scanVM.nutritionFactsImage = image
        scanVM.state = .ingredientScanning
        scanVM.captureCompletionHandler(image, nil)
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("Could not read the nutrition facts image for text.", self.scanVM.errorMessage)
    }

    func test_completeManualScan_failure_readIngredients() {
        scanVM.imageReader = MockImageReader(strSequence: ["Some Text", ""], boolSequence: [true, true])
        // fail to read ingredients image
        scanVM.upc = "1234567890"
        scanVM.nutritionFactsImage = image
        scanVM.state = .ingredientScanning
        scanVM.captureCompletionHandler(image, nil)
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("Could not read the ingredients image for text.", self.scanVM.errorMessage)
    }

    func test_completeManualScan_failure_nutritionFactRequest() {
        scanVM.imageReader = MockImageReader(strSequence: [""], boolSequence: [false])
        // fail to read ingredients image
        scanVM.upc = "1234567890"
        scanVM.nutritionFactsImage = image
        scanVM.state = .ingredientScanning
        scanVM.captureCompletionHandler(image, nil)
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("Request failed to read the nutrition facts image for text.", self.scanVM.errorMessage)
    }

    func test_completeManualScan_failure_ingredientRequest() {
        scanVM.imageReader = MockImageReader(strSequence: ["Some Text", ""], boolSequence: [true, false])
        // fail to read ingredients image
        scanVM.upc = "1234567890"
        scanVM.nutritionFactsImage = image
        scanVM.state = .ingredientScanning
        scanVM.captureCompletionHandler(image, nil)
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("Request failed to read the ingredients image for text.", self.scanVM.errorMessage)
    }

    func test_completeManualScan_failure_foodFromAPI() {
        // fail to get food from api
        scanVM.apiClient = FailedAPIClientMock()
        scanVM.upc = "1234567890"
        scanVM.nutritionFactsImage = image
        scanVM.state = .ingredientScanning
        scanVM.captureCompletionHandler(image, nil)
        Thread.sleep(forTimeInterval: 0.25)
        XCTAssertEqual("Did not get result back from server.", self.scanVM.errorMessage)
    }

    func test_captureCompletionHandler_failure() {
        scanVM.captureCompletionHandler(nil, nil)
        XCTAssertTrue(scanVM.errorNeedsAttention)
        XCTAssertTrue(scanVM.anyAlerts)
        XCTAssertEqual("Picture could not be taken", self.scanVM.errorMessage)
    }

    func test_goToUpcScan() {
        scanVM.nutritionFactsImage = image
        scanVM.ingredientsImage = image
        scanVM.state = .nutritionFactScanning
        XCTAssertEqual(.nutritionFactScanning, scanVM.state)
        scanVM.goToUpcScan()
        XCTAssertEqual(.upcScanning, scanVM.state)
        XCTAssertNil(scanVM.upc)
        XCTAssertNil(scanVM.nutritionFactsImage)
        XCTAssertNil(scanVM.ingredientsImage)
    }

    func test_goToFactsScan() {
        scanVM.nutritionFactsImage = image
        scanVM.ingredientsImage = image
        XCTAssertEqual(.upcScanning, scanVM.state)
        scanVM.goToFactsScan()
        XCTAssertEqual(.nutritionFactScanning, scanVM.state)
        XCTAssertNil(scanVM.nutritionFactsImage)
        XCTAssertNil(scanVM.ingredientsImage)
    }

    func test_goToIngredientsScan() {
        scanVM.ingredientsImage = image
        XCTAssertEqual(.upcScanning, scanVM.state)
        scanVM.goToIngredientsScan()
        XCTAssertEqual(.ingredientScanning, scanVM.state)
        XCTAssertNil(scanVM.ingredientsImage)
    }

    func test_acceptUpcAlert() {
        scanVM.promptForManualDecision = true
        XCTAssertEqual(.upcScanning, scanVM.state)
        scanVM.acceptUpcAlert()
        XCTAssertFalse(scanVM.promptForManualDecision)
        XCTAssertEqual(.nutritionFactScanning, scanVM.state)
    }

    func test_dismissUpcAlert() {
        XCTAssertFalse(scanVM.errorNeedsAttention)
        XCTAssertFalse(scanVM.promptForManualDecision)
        XCTAssertFalse(scanVM.anyAlerts)
        scanVM.errorNeedsAttention = true
        scanVM.promptForManualDecision = true
        scanVM.anyAlerts = true
        scanVM.dismissUpcAlert()
        XCTAssertTrue(scanVM.errorNeedsAttention)
        XCTAssertFalse(scanVM.promptForManualDecision)
        XCTAssertTrue(scanVM.anyAlerts)
    }

    func test_dismissErrorAlert() {
        XCTAssertFalse(scanVM.errorNeedsAttention)
        XCTAssertFalse(scanVM.promptForManualDecision)
        XCTAssertFalse(scanVM.anyAlerts)
        scanVM.errorNeedsAttention = true
        scanVM.promptForManualDecision = true
        scanVM.anyAlerts = true
        scanVM.dismissErrorAlert()
        XCTAssertFalse(scanVM.errorNeedsAttention)
        XCTAssertTrue(scanVM.promptForManualDecision)
        XCTAssertTrue(scanVM.anyAlerts)
    }

    func test_handleFoodResult() {
        XCTAssertFalse(scanVM.showFood)
        XCTAssertEqual("Blank Food", scanVM.food.name)
      let result: Food = Food(api_id: "", upc: 0, name: "New Food", ingredients: [], nutritionFacts: [])
        scanVM.handleFoodResult(result)
        XCTAssertTrue(scanVM.showFood)
        XCTAssertEqual("New Food", scanVM.food.name)
    }
}
