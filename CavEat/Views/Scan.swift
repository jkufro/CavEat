//
//  Scan.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct Scan: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                .frame(height: 100)
                .foregroundColor(Color.black)
                .opacity(0.75)
                HStack(alignment: .center) {
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
            Spacer()
            Text("Scan Page")
        }.edgesIgnoringSafeArea(.top)
        
    }
}

struct Scan_Previews: PreviewProvider {
    static var previews: some View {
        Scan()
    }
}
