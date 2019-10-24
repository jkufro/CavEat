//
//  Navigation.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct Navigation: View {
    @State var selectedView = 1
    
    var body: some View {
        TabView(selection: $selectedView) {
            SavedScans()
                .tabItem {
                    Image(systemName: "rectangle.stack")
                    Text("Saved Scans")
                }.tag(0)
            Scan()
                .tabItem {
                    Image(systemName: "barcode.viewfinder")
                    Text("Scan")
                }.tag(1)
            DVSettings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("DV Settings")
                }.tag(2)
        }
    }
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}
