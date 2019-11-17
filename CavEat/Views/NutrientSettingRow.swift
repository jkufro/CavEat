//
//  NutrientSettingRow.swift
//  CavEat
//
//  Created by Justin Kufro on 11/4/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct NutrientSettingRow: View {
    @State private var showDetail = false
    @ObservedObject var settingRowVM: DVSettingRowViewModel

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: HorizontalAlignment.leading) {
                Button(
                    action: {
                        withAnimation {
                            self.showDetail.toggle()
                        }
                    },
                    label: {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(self.settingRowVM.nutrientSetting.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                            }
                            Spacer()
                            if !showDetail {
                                Text(String(format: "%.1f\(self.settingRowVM.nutrientSetting.unit)", self.settingRowVM.nutrientSetting.dailyValue))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Image(systemName: "chevron.right")
                                .imageScale(.large)
                                .rotationEffect(.degrees(showDetail ? 90 : 0))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding([.leading, .trailing], 5.0)
                        }
                    }
                )

                if showDetail {
                    HStack {
                        Spacer()
                        Picker(
                            selection: $settingRowVM.selection,
                            label: Text("Pick something")
                        ) {
                            ForEach(0 ..< settingRowVM.selectionOptions.count) { index in
                                Text(String(format: "%.1f\(self.settingRowVM.nutrientSetting.unit)", self.settingRowVM.selectionOptions[index])).tag(index)
                            }
                        }.labelsHidden()
                        Spacer()
                    }
                    HStack {
                        Text("Reset to Default")
                            .foregroundColor(.blue)
                            .gesture(
                                TapGesture().onEnded { _ in
                                    self.settingRowVM.resetToDefaultPressed()
                                }
                            )
                        Spacer()
                        Text("Save")
                        .foregroundColor(.blue)
                        .padding(.trailing)
                        .gesture(
                            TapGesture().onEnded { _ in
                                self.showDetail.toggle()
                                self.settingRowVM.savePressed()
                            }
                        )
                    }
                }
            }.padding(.leading).animation(.spring())
        }
    }
}

struct NutrientSettingRow_Previews: PreviewProvider {
    static var previews: some View {
        NutrientSettingRow(
            settingRowVM: DVSettingRowViewModel(
                nutrientSetting: NutrientSetting(
                    id: UUID(uuidString: "093A8D5E-AB17-4D51-9E4B-EB14A87ADBB8")!,
                    name: "Added Sugars",
                    unit: "g",
                    dailyValue: 32,
                    minValue: 0,
                    maxValue: 50,
                    valueStep: 1,
                    defaultValue: 32,
                    sortingOrder: 10
                )
            )
        )
    }
}
