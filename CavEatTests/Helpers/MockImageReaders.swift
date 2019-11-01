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

// will cycle through a sequence of strings as imageToText is called
class SuccessfulMockImageReader: ImageReader {
    private var sequence: [String] = ["This is the string result"]
    private var index = 0

    init(sequence: [String]) {
        self.sequence = sequence
    }

    override func imageToText(image: UIImage, _ completion: @escaping (String) -> Void) -> Bool {
        completion(sequence[index % sequence.count])
        index += 1
        return true
    }
}

class FailedMockImageReader: ImageReader {
    override func imageToText(image: UIImage, _ completion: @escaping (String) -> Void) -> Bool {
        return false
    }
}
