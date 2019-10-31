//
//  LoadingOverlay.swift
//  CavEat
//
//  Created by Justin Kufro on 10/26/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct LoadingOverlay: View {
    let squareWidth: CGFloat = 120

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: squareWidth, height: squareWidth)
                .foregroundColor(Color.black)
                .opacity(0.5)
            VStack {
                Text("Please Wait")
                    .foregroundColor(.white)
                ActivityIndicator(isAnimating: true, style: .large)
            }
        }
    }
}

struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlay()
    }
}
