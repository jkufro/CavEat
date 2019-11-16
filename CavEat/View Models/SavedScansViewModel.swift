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

    func getSectionedFoods() -> [(day: String, foods: [Food])] {
        var sections = [Date: [Food]]()
        let filteredFoods = getFilteredFoods()

        // split up into separate days
        for food in filteredFoods {
            guard let createdAt = food.createdAt else { continue }
            let day:Date = Calendar.current.startOfDay(for: createdAt)
            // let dateComponents = Calendar.current.dateComponents([.day, .year, .month], from: createdAt)
            if var existingFoodList = sections[day] {
                existingFoodList.append(food)
            } else {
                sections[day] =  [food]
            }
        }

        // build ordered list of tuples
        var orderedSections = [(day: String, foods: [Food])]()
        for (day, foods) in sections {
            let dayString = dateFormatter.string(from: day)
            orderedSections.append((
                day: dayString,
                foods: foods.sorted {
                    guard let thisDate = $0.createdAt, let otherDate = $1.createdAt else { return false }
                    return thisDate > otherDate
                }
            ))
        }

        return orderedSections
    }

    func isFilteredFoodsEmpty() -> Bool {
        return getFilteredFoods().count == 0
    }

    func dismissCallback() {
        allSavedFoods = DataManager.shared.loadFoods()
    }
}
