//
//  APIClient.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import Alamofire
import Japx

class APIClient {
    private static let baseURL: String = "http://caveat.cmuis.org"

    func findByUpc(upc: String, _ completion: @escaping (Food?) -> Void) {
        let url = APIClient.baseURL + "/api/v1/upc"
        let parameters = ["upc": upc]

        APIRequest(url: url, parameters: parameters) { food in
            completion(food)
        }
    }

    func findByStrings(upc: String, nutritionFacts: String, ingredients: String, _ completion: @escaping (Food?) -> Void) {
        let url = APIClient.baseURL + "/api/v1/strings"
        let parameters = ["upc": upc, "nutrition_facts": nutritionFacts, "ingredients": ingredients]

        APIRequest(url: url, parameters: parameters) { food in
            completion(food)
        }
    }

    internal func APIRequest(url: String, parameters: [String: String], _ completion: @escaping (Food?) -> Void) {
        Alamofire.request(url,
                   method: .post,
                   parameters: parameters)
            .validate(statusCode: 200...200)
            .responseCodableJSONAPI(keyPath: "data", completionHandler: { (response: DataResponse<Food>) in
            switch response.result {
            case .success(let food):
                completion(food)
            case .failure:
                completion(nil)
            }
        })
    }
}
