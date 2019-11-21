//
//  UPCScan.swift
//  CavEat
//
//  Created by Justin Kufro on 10/26/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct UPCScan: View {
    let hasNotch = UIDevice.current.hasNotch

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: hasNotch ? 85 : 70)
                    .foregroundColor(Color.black)
                    .opacity(0.75)
                VStack {
                    Spacer()
                        .frame(height: hasNotch ? 15 : 5)
                    HStack {
                        Image(systemName: "barcode")
                            .imageScale(.large)
                            .foregroundColor(Color.white)
                        Text("Point camera at bar code")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                }
            }
            Spacer()
        }
    }
}

struct UPCScan_Previews: PreviewProvider {
    static var previews: some View {
        UPCScan()
    }
}
