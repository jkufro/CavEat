//
//  UPCScan.swift
//  CavEat
//
//  Created by Justin Kufro on 10/26/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct UPCScan: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(height: 85)
                    .foregroundColor(Color.black)
                    .opacity(0.75)
                VStack {
                    Spacer()
                    .frame(height: 15)
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
        }.edgesIgnoringSafeArea(.top)
    }
}

struct UPCScan_Previews: PreviewProvider {
    static var previews: some View {
        UPCScan()
    }
}
