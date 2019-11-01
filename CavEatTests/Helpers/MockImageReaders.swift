//
//  MockImageReaders.swift
//  CavEatTests
//
//  Created by Justin Kufro on 11/1/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import XCTest
@testable import CavEat

// will cycle through a sequence of strings and booleans as imageToText is called
class MockImageReader: ImageReader {
    private var strSequence: [String] = ["This is the string result"]
    private var boolSequence: [Bool] = [true]
    private var index = -1

    init(strSequence: [String], boolSequence: [Bool]) {
        self.strSequence = strSequence
        self.boolSequence = boolSequence
    }

    override func imageToText(image: UIImage, _ completion: @escaping (String) -> Void) -> Bool {
        index += 1
        let returnBool = boolSequence[index % boolSequence.count]

        if returnBool {
            completion(strSequence[index % strSequence.count])
        }
        return returnBool
    }
}
