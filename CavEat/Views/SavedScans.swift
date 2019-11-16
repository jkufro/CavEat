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
                SearchBar(text: $savedScansVM.searchTerm)
                if savedScansVM.isFilteredFoodsEmpty() {
                    Text("No Foods to Display")
                    Spacer()
                } else {
                    List {
                        ForEach(savedScansVM.getSectionedFoods(), id: \.day) { section in
                            Section(header: Text(section.day)) {
                                ForEach(section.foods) { food in
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
                                }.onDelete { self.savedScansVM.deleteFood(at: $0, day: section.day) }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Saved Scans")
            .navigationBarItems(trailing: self.savedScansVM.isFilteredFoodsEmpty() ? AnyView(EmptyView()) : AnyView(EditButton()))
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
