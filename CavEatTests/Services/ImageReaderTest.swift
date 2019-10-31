//
//  ImageReaderTest.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/29/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import XCTest
@testable import CavEat

class ImageReaderTest: XCTestCase {
    let imageReader = ImageReader()

    func test_imageToText() {
        if let image = ImagesHelper.shared.loadUIImage("caveat_image", "jpg") {
            let success = imageReader.imageToText(image: image) { result in
                let modifiedResult = result.replacingOccurrences(of: "\n", with: " ").lowercased()
                XCTAssert(modifiedResult.contains("total fat"))
                XCTAssert(modifiedResult.contains("saturated fat"))
                XCTAssert(modifiedResult.contains("trans fat"))
                XCTAssert(modifiedResult.contains("cholesterol"))
                XCTAssert(modifiedResult.contains("sodium"))
                XCTAssert(modifiedResult.contains("total carbohydrate"))
                XCTAssert(modifiedResult.contains("dietary fiber"))
                XCTAssert(modifiedResult.contains("total sugars"))
                XCTAssert(modifiedResult.contains("protein"))
                XCTAssert(modifiedResult.contains("vitamin d"))
                XCTAssert(modifiedResult.contains("calcium"))
                XCTAssert(modifiedResult.contains("iron"))
                XCTAssert(modifiedResult.contains("potassium"))
                XCTAssert(modifiedResult.contains("0g"))
                XCTAssert(modifiedResult.contains("1g"))
                XCTAssert(modifiedResult.contains("4g"))
                XCTAssert(modifiedResult.contains("22g"))
                XCTAssert(modifiedResult.contains("0mcg"))
                XCTAssert(modifiedResult.contains("0.6mg"))
                XCTAssert(modifiedResult.contains("40mg"))
            }
            XCTAssert(success)
        } else {
            XCTAssertEqual(0, 1)
        }

        if let image = ImagesHelper.shared.loadUIImage("no_text_image", "jpg") {
            let success = imageReader.imageToText(image: image) { result in
                XCTAssertEqual("", result)
            }
            XCTAssert(success)
        } else {
            XCTAssertEqual(0, 1)
        }
    }
}
