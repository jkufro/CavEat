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
    let foreground = Color(UIColor(named: "Foregrounds")!)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: squareWidth, height: squareWidth)
                .foregroundColor(foreground)
                .opacity(0.75)
            VStack {
                Text("Please Wait")
                    .foregroundColor(.primary)
                ActivityIndicator(isAnimating: true, style: .large)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlay()
    }
}
