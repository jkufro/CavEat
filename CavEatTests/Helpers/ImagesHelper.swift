//
//  ImagesHelper.swift
//  CavEatTests
//
//  Created by Justin Kufro on 10/31/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import XCTest
@testable import CavEat

class ImagesHelper {
    static let shared: ImagesHelper = ImagesHelper()

    func loadUIImage(_ filename: String, _ fileType: String) -> UIImage? {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: filename, ofType: fileType)
        return (try? UIImage(data: Data(contentsOf: URL(fileURLWithPath: path!))))
    }
}
