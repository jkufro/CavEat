//
//  SavedScansViewModel.swift
//  CavEat
//
//  Created by Justin Kufro on 11/16/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation

class SavedScansViewModel: ObservableObject {
    @Published var allSavedFoods = DataManager.shared.loadFoods()
    @Published var searchTerm: String = ""
    @Published var showFood: Bool = false
    var food: Food = Food(apiId: "", upc: 0, name: "Blank Food", ingredients: [], nutritionFacts: [])
    let dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }

    func getFilteredFoods() -> [Food] {
        guard searchTerm != "" else { return allSavedFoods }
        return allSavedFoods.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
    }

    func getSectionedFoods() -> [SavedFoodSection] {
        allSavedFoods = DataManager.shared.loadFoods()
        let filteredFoods = getFilteredFoods()
        var sections = [Date: [Food]]()

        // split up into separate days
        for food in filteredFoods {
            guard let createdAt = food.createdAt else { continue }
            let day: Date = Calendar.current.startOfDay(for: createdAt)
            if sections[day] != nil {
                sections[day]!.append(food)
            } else {
                sections[day] =  [food]
            }
        }

        return sections.map { SavedFoodSection(day: dateFormatter.string(from: $0), foods: $1) }
    }

    func isFilteredFoodsEmpty() -> Bool {
        return getFilteredFoods().count == 0
    }

    func dismissCallback() {
        allSavedFoods = DataManager.shared.loadFoods()
    }

    func deleteFood(at offsets: IndexSet, day: String) {
        if let section = getSectionedFoods().first(where: { $0.day == day }) {
            if let index = offsets.first {
                if index < section.foods.count {
                    let foodToDelete = section.foods[index]
                    _ = DataManager.shared.deleteFood(food: foodToDelete)
                    allSavedFoods = DataManager.shared.loadFoods()
                }
            }
        }

    }
}
