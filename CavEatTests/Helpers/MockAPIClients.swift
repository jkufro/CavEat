//
//  MockAPIClients.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/31/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
@testable import CavEat

class SuccessfulAPIClientMock: APIClient {
    override internal func APIRequest(url: String, parameters: [String: String], _ completion: @escaping (Food?) -> Void) {
      completion(Food(apiId: "1", upc: 1234567890, name: "SuccessfulAPIClientMock Food", ingredients: [], nutritionFacts: []))
    }
}

class FailedAPIClientMock: APIClient {
    override internal func APIRequest(url: String, parameters: [String: String], _ completion: @escaping (Food?) -> Void) {
        completion(nil)
    }
}
