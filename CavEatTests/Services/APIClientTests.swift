//
//  APIClientTests.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class SuccessfulAPIClientMock: APIClient {
    override internal func APIRequest(url: String, parameters: [String: String], _ completion: @escaping (Food?) -> Void) {
        completion(Food(id: "1", upc: 1234567890, name: "My Food", ingredients: [], nutritionFacts: []))
    }
}

class FailedAPIClientMock: APIClient {
    override internal func APIRequest(url: String, parameters: [String: String], _ completion: @escaping (Food?) -> Void) {
        completion(nil)
    }
}

class APIClientTests: XCTestCase {
    let successfulClient: SuccessfulAPIClientMock = SuccessfulAPIClientMock()
    let failedClient: FailedAPIClientMock = FailedAPIClientMock()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_successfulfindByUpc() {
        successfulClient.findByUpc(upc: "this does not matter") { food in
            XCTAssertEqual("1", food!.id)
        }
    }

    func test_successfulfindByStrings() {
        successfulClient.findByStrings(upc: "this does not matter", nutritionFacts: "", ingredients: "") { food in
            XCTAssertEqual("1", food!.id)
        }
    }

    func test_failedfindByUpc() {
        failedClient.findByUpc(upc: "this does not matter") { food in
            XCTAssertNil(food)
        }
    }

    func test_failedfindByStrings() {
        failedClient.findByStrings(upc: "this does not matter", nutritionFacts: "", ingredients: "") { food in
            XCTAssertNil(food)
        }
    }
}
