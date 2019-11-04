//
//  DVSettings.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct DVSettings: View {
    @State private var showInfo = false

    var body: some View {
        NavigationView {
            VStack {
                List(NutrientSettings.shared.nutrientDictionary.map {$0.value}) { nutrientSetting in
                    NutrientSettingRow(
                        settingRowVM: DVSettingRowViewModel(
                            nutrientSetting: nutrientSetting
                        )
                    )
                }
            }
            .navigationBarTitle("Daily Value Settings")
            .navigationBarItems(trailing:
                Button(
                    action: { self.showInfo = true },
                    label: {
                        Image(systemName: "info.circle").imageScale(.large)
                    }
                )
            )
            .sheet(
                isPresented: $showInfo,
                onDismiss: { self.showInfo = false },
                content: {
                    VStack {
                        HStack {
                            Button("Close") {
                                self.showInfo = false
                            }
                            Spacer()
                        }
                        Text("Hello")
                        Spacer()
                    }.padding()
                }
            )
        }

    }
}

struct DVSettings_Previews: PreviewProvider {
    static var previews: some View {
        DVSettings()
    }
}
