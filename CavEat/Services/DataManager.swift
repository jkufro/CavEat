//
//  DataManager.swift
//  CavEat
//
//  Created by Darien Weems on 11/7/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    static var shared = DataManager(context: nil)

    let context: NSPersistentContainer

    init(context: NSPersistentContainer?) {
      if let context = context {
        self.context = context
      } else {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
        self.context = appDelegate.persistentContainer
      }
    }

    // swiftlint:disable function_body_length
    func saveFood(food: Food) -> Bool {
        if food.createdAt != nil { // update the food
            // fetch the specific food
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id = %@", food.id as CVarArg)
            do {
                let result = try context.viewContext.fetch(request)
                guard let foodDataList = result as? [NSManagedObject] else { return false }
                guard foodDataList.count > 0 else { return false }
                let foodData = foodDataList[0]
                // realistically we will only ever update the name
                foodData.setValue(food.name, forKey: "name")
            } catch {
                return false
            }
        } else { // create the food
            if let entity = NSEntityDescription.entity(forEntityName: "CD_food", in: context.viewContext) {
                let newFood = NSManagedObject(entity: entity, insertInto: context.viewContext)
                newFood.setValue(food.id, forKey: "id")
                newFood.setValue(food.apiId, forKey: "api_id")
                newFood.setValue(food.name, forKey: "name")
                newFood.setValue(food.upc, forKey: "upc")
                newFood.setValue(Date(), forKey: "created_at")
                // Loop over ingredients and nutritionFacts and add to array
                // Should refactor these into helpers
                let ingredients = newFood.mutableSetValue(forKey: #keyPath(CD_food.ingredients))
                var sortingOrder = 0
                for ingredient in food.ingredients {
                    if let ingEntity = NSEntityDescription.entity(forEntityName: "CD_ingredient", in: context.viewContext) {
                        let newIng = NSManagedObject(entity: ingEntity, insertInto: context.viewContext)
                        newIng.setValue(ingredient.id, forKey: "id")
                        newIng.setValue(ingredient.name, forKey: "name")
                        newIng.setValue(ingredient.composition, forKey: "composition")
                        newIng.setValue(ingredient.description, forKey: "ing_description")
                        newIng.setValue(ingredient.source, forKey: "source")
                        newIng.setValue(ingredient.isWarning, forKey: "is_warning")
                        newIng.setValue(ingredient.sortingOrder, forKey: "sorting_order")
                        ingredients.add(newIng)
                        sortingOrder += 1
                    }
                }
                let nutritionFacts = newFood.mutableSetValue(forKey: #keyPath(CD_food.nutritionFacts))
                sortingOrder = 0
                for nutritionFact in food.nutritionFacts {
                    if let nfEntity = NSEntityDescription.entity(forEntityName: "CD_nutritionFact", in: context.viewContext) {
                        let newNF = NSManagedObject(entity: nfEntity, insertInto: context.viewContext)
                        newNF.setValue(nutritionFact.id, forKey: "id")
                        newNF.setValue(nutritionFact.name, forKey: "name")
                        newNF.setValue(nutritionFact.unit, forKey: "unit")
                        newNF.setValue(nutritionFact.amount, forKey: "amount")
                        newNF.setValue(nutritionFact.description, forKey: "nf_description")
                        newNF.setValue(nutritionFact.source, forKey: "source")
                        newNF.setValue(nutritionFact.isLimiting, forKey: "is_limiting")
                        newNF.setValue(nutritionFact.sortingOrder, forKey: "sorting_order")
                        nutritionFacts.add(newNF)
                        sortingOrder += 1
                    }
                }
            }
        }
        do {
            try context.viewContext.save()
            return true
        } catch {
            print("Failed to save food")
            return false
        }
    }
    // swiftlint:enable function_body_length

    func loadFoods() -> [Food] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
        let sort = NSSortDescriptor(key: "created_at", ascending: false)
        request.sortDescriptors = [sort]
        request.returnsObjectsAsFaults = false
        var foods = [Food]()
        do {
            guard let result = try context.viewContext.fetch(request) as? [NSManagedObject] else { return foods }
            for data in result {
                if let id = data.value(forKey: "id") as? UUID,
                    let apiId = data.value(forKey: "api_id") as? String,
                    let upc = data.value(forKey: "upc") as? Int64,
                    let name = data.value(forKey: "name") as? String,
                    let createdAt = data.value(forKey: "created_at") as? Date,
                    let ingredients = decodeIngredients(data.mutableSetValue(forKey: "ingredients") as? NSMutableSet),
                    let nutritionFacts = decodeNutritionFacts(data.mutableSetValue(forKey: "nutritionFacts") as? NSMutableSet)
                { // swiftlint:disable:this opening_brace
                    let food = Food(id: id, apiId: apiId, upc: upc, name: name, ingredients: ingredients, nutritionFacts: nutritionFacts, createdAt: createdAt)
                        foods.append(food)
                }
            }
        } catch {
            print("Failed to load foods")
        }
        return foods
    }

    private func decodeIngredients(_ dataSet: NSMutableSet?) -> [Ingredient]? {
        var ingredients = [Ingredient]()
        guard let dataSet = dataSet else { return nil }
        for data in dataSet {
            guard let data = data as? NSManagedObject else { continue }
            if let id = data.value(forKey: "id") as? String,
                let name = data.value(forKey: "name") as? String,
                let isWarning = data.value(forKey: "is_warning") as? Bool,
                let sortingOrder = data.value(forKey: "sorting_order") as? Int
            { // swiftlint:disable:this opening_brace
                let comp = data.value(forKey: "composition") as? String
                let desc = data.value(forKey: "ing_description") as? String
                let source = data.value(forKey: "source") as? String
                let ingredient = Ingredient(id: id, name: name, composition: comp, description: desc, source: source, isWarning: isWarning, sortingOrder: sortingOrder)
                ingredients.append(ingredient)
            }
        }
        return ingredients.sorted()
    }

    private func decodeNutritionFacts(_ dataSet: NSMutableSet?) -> [NutritionFact]? {
        var nutritionFacts = [NutritionFact]()
        guard let dataSet = dataSet else { return nil }
        for data in dataSet {
            guard let data = data as? NSManagedObject else { continue }
            if let id = data.value(forKey: "id") as? String,
                let name = data.value(forKey: "name") as? String,
                let amount = data.value(forKey: "amount") as? Float,
                let unit = data.value(forKey: "unit") as? String,
                let isLimiting = data.value(forKey: "is_limiting") as? Bool,
                let sortingOrder = data.value(forKey: "sorting_order") as? Int
            { // swiftlint:disable:this opening_brace
                let desc = data.value(forKey: "nf_description") as? String
                let source = data.value(forKey: "source") as? String
                let nutritionFact = NutritionFact(id: id, name: name, description: desc, source: source, amount: amount, unit: unit, isLimiting: isLimiting, sortingOrder: sortingOrder)
                  nutritionFacts.append(nutritionFact)
            }
        }
        return nutritionFacts.sorted()
    }

    func deleteFood(food: Food) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
        request.returnsObjectsAsFaults = false
        do {
            guard let result = try context.viewContext.fetch(request) as? [NSManagedObject] else { return false }
            for data in result {
                if let dataId = data.value(forKey: "id") as? UUID {
                    if dataId == food.id {
                        context.viewContext.delete(data)
                        try context.viewContext.save()
                        return true
                    }
                }
            }
            return false
        } catch {
            return false
        }
    }

    func saveSetting(setting: NutrientSetting) -> Bool {
        // check if the settings already exists
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_nutrientSetting")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", setting.id as CVarArg)
        do {
            let result = try context.viewContext.fetch(request)
            guard let settingDataList  = result as? [NSManagedObject] else { return false }
            if settingDataList.count > 0 { // already exists
                let settingData = settingDataList[0]
                settingData.setValue(setting.dailyValue, forKey: "daily_value")
            } else { // needs to be created
                if let entity = NSEntityDescription.entity(forEntityName: "CD_nutrientSetting", in: context.viewContext) {
                    let newSetting = NSManagedObject(entity: entity, insertInto: context.viewContext)
                    newSetting.setValue(setting.id, forKey: "id")
                    newSetting.setValue(setting.name, forKey: "name")
                    newSetting.setValue(setting.unit, forKey: "unit")
                    newSetting.setValue(setting.dailyValue, forKey: "daily_value")
                    newSetting.setValue(setting.minValue, forKey: "min_value")
                    newSetting.setValue(setting.maxValue, forKey: "max_value")
                    newSetting.setValue(setting.valueStep, forKey: "value_step")
                    newSetting.setValue(setting.defaultValue, forKey: "default_value")
                    newSetting.setValue(setting.sortingOrder, forKey: "sorting_order")
                }
            }
            try context.viewContext.save()
            return true
        } catch {
            return false
        }
    }

    func loadSettings() -> [NutrientSetting] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_nutrientSetting")
        request.returnsObjectsAsFaults = false
        var settings = [NutrientSetting]()
        do {
            guard let result = try context.viewContext.fetch(request) as? [NSManagedObject] else { return settings }
            for data in result {
                if let id = data.value(forKey: "id") as? UUID,
                    let name = data.value(forKey: "name") as? String,
                    let unit = data.value(forKey: "unit") as? String,
                    let dailyValue = data.value(forKey: "daily_value") as? Float,
                    let minValue = data.value(forKey: "min_value") as? Float,
                    let maxValue = data.value(forKey: "max_value") as? Float,
                    let valueStep = data.value(forKey: "value_step") as? Float,
                    let defaultValue = data.value(forKey: "default_value") as? Float,
                    let sortingOrder = data.value(forKey: "sorting_order") as? Int
                { // swiftlint:disable:this opening_brace
                    let setting = NutrientSetting(id: id, name: name, unit: unit, dailyValue: dailyValue, minValue: minValue, maxValue: maxValue, valueStep: valueStep, defaultValue: defaultValue, sortingOrder: sortingOrder)
                    settings.append(setting)
                }
            }
        } catch {
            print("Failed to load settings")
        }
        return settings
    }
}
