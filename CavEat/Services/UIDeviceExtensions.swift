//
//  UIDeviceExtensions.swift
//  CavEat
//
//  Created by Justin Kufro on 11/21/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import SwiftUI

// source: https://medium.com/@cafielo/how-to-detect-notch-screen-in-swift-56271827625d
extension UIDevice {
    var hasNotch: Bool {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
    }
}
