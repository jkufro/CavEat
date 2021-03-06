//
//  ManualScan.swift
//  CavEat
//
//  Created by Justin Kufro on 10/26/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct ManualScanHeader: View {
    let state: ScanVMState
    let inactiveColor: Color = Color.secondary //Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.4))
    let pressHandler: () -> Void
    let hasNotch = UIDevice.current.hasNotch
    let foreground = Color(UIColor(named: "Foregrounds")!)

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Rectangle()
                    .frame(height: hasNotch ? 120 : 105)
                    .foregroundColor(foreground)
                    .opacity(0.75)
                VStack {
                    Spacer()
                        .frame(height: hasNotch ? 35: 25)
                    HStack {
                        if state == .nutritionFactScanning {
                            Button(action: pressHandler) {
                                Image(systemName: "x.circle")
                                    .imageScale(.large)
                                    .foregroundColor(Color.primary)
                            }
                        } else if state == .ingredientScanning {
                            Button(action: pressHandler) {
                                Image(systemName: "arrow.uturn.left.circle")
                                    .imageScale(.large)
                                    .foregroundColor(Color.primary)
                            }

                        }

                        Text("1. Capture nutrition facts")
                            .font(.title)
                            .foregroundColor(state == .nutritionFactScanning ? Color.primary : inactiveColor)
                            .multilineTextAlignment(.center)
                    }
                    HStack {
                        Text("2. Capture ingredients")
                            .font(.title)
                            .foregroundColor(state == .ingredientScanning ? Color.primary : inactiveColor)
                            .multilineTextAlignment(.center)
                    }
                }

            }
            Spacer()
        }
    }
}

struct ManualScanHeader_Previews: PreviewProvider {
    static var previews: some View {
        ManualScanHeader(state: .nutritionFactScanning, pressHandler: {})
    }
}
