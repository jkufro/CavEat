//
//  Navigation.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State var selectedView = 1

    var body: some View {
        TabView(selection: $selectedView) {
            SavedScans()
                .tabItem {
                    Image(systemName: "rectangle.stack").imageScale(.large)
                    Text("Saved Scans")
                }.tag(0)
            Scan()
                .tabItem {
                    Image(systemName: "barcode.viewfinder").imageScale(.large)
                    Text("Scan")
                }.tag(1)
            DVSettings()
                .tabItem {
                    Image(systemName: "gear").imageScale(.large)
                    Text("DV Settings")
                }.tag(2)
        }.edgesIgnoringSafeArea(.top)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
