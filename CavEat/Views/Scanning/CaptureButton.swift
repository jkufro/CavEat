//
//  CaptureButton.swift
//  CavEat
//
//  Created by Justin Kufro on 10/26/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct CaptureButton: View {
    let cameraButtonSize: CGFloat = 75
    let pressHandler: () -> Void

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .frame(width: cameraButtonSize, height: cameraButtonSize)
                    .foregroundColor(.secondary)
                Button(action: pressHandler) {
                    Image(systemName: "camera.circle")
                        .font(.system(size: cameraButtonSize))
                        .frame(width: cameraButtonSize, height: cameraButtonSize)
                        .foregroundColor(Color.white)
                }
            }.padding()
        }
    }
}

struct CaptureButton_Previews: PreviewProvider {
    static var previews: some View {
        CaptureButton(pressHandler: {})
    }
}
