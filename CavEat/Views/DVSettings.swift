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
    let nutrientSettings = NutrientSettings.shared.nutrientDictionary.map {$0.value}

    var body: some View {
        NavigationView {
            VStack {
                List(nutrientSettings) { nutrientSetting in
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
                        Text("Daily Value Settings")
                            .font(.title)
                            .padding(.bottom)
                        VStack(alignment: .leading) {
                            Text("You are able to personalize the desired daily value intake of all the nutrients listed on this page. Any changes you make here will be reflected in scan results through different percentage daily values (%DV).")
                                .padding(.bottom)
                            Text("You are always able to reset your changes back to the app default value by pressing the “Reset to Default” button.")
                                .padding(.bottom)
                            Text("All values default to the average adult consumption guidelines.")
                                .padding(.bottom)
                        }
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
