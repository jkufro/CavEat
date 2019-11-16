//
//  SavedScans.swift
//  CavEat
//
//  Created by Justin Kufro on 10/24/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import SwiftUI

struct SavedScans: View {
    @ObservedObject var savedScansVM = SavedScansViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if savedScansVM.isFilteredFoodsEmpty() {
                    Text("No Foods to Display")
                } else {
                    List {
                        ForEach(savedScansVM.getSectionedFoods(), id: \.day) { section in
                            Section(header: Text(section.day)) {
                                ForEach(section.foods, id: \.id) { food in
                                    Button(
                                        action: {
                                            self.savedScansVM.food = food
                                            self.savedScansVM.showFood = true
                                        },
                                        label: {
                                            HStack {
                                                Text(food.name)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                Spacer()
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Saved Scans")
            .navigationBarItems(trailing:
                Button(
                    action: {  },
                    label: {
                        Image(systemName: "info.circle").imageScale(.large)
                    }
                )
            )
        }
        .sheet(
            isPresented: $savedScansVM.showFood,
            onDismiss: { self.savedScansVM.dismissCallback() },
            content: {
                Result(showFood: self.$savedScansVM.showFood,
                       resultVM: ResultViewModel(food: self.savedScansVM.food),
                       dismissCallback: self.savedScansVM.dismissCallback
                )
            }
        )
    }
}

struct SavedScans_Previews: PreviewProvider {
    static var previews: some View {
        SavedScans()
    }
}
