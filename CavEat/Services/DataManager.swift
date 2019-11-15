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
  static let shared = DataManager(context: nil)
  
    let context: NSPersistentContainer
    
    init(context: NSPersistentContainer?) {
      if let context = context {
        self.context = context
      } else {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer
      }
    }
  
    func saveFood(food: Food) -> Bool {
        if let entity = NSEntityDescription.entity(forEntityName: "CD_food", in: context.viewContext) {
            let newFood = NSManagedObject(entity: entity, insertInto: context.viewContext)
            if let id = food.id {
                newFood.setValue(id, forKey: "id")
            } else {
                newFood.setValue(UUID(), forKey: "id")
            }
            newFood.setValue(food.api_id, forKey: "api_id")
            newFood.setValue(food.name, forKey: "name")
            newFood.setValue(food.upc, forKey: "upc")
            // Loop over ingredients and nutritionFacts and add to array
            // Should refactor these into helpers
            let ingredients = newFood.mutableSetValue(forKey: #keyPath(CD_food.ingredients))
            for i in food.ingredients {
                if let ingEntity = NSEntityDescription.entity(forEntityName: "CD_ingredient", in: context.viewContext) {
                    let newIng = NSManagedObject(entity: ingEntity, insertInto: context.viewContext)
                    newIng.setValue(i.id, forKey: "id")
                    newIng.setValue(i.name, forKey: "name")
                    newIng.setValue(i.composition, forKey: "composition")
                    newIng.setValue(i.description, forKey: "ing_description")
                    newIng.setValue(i.source, forKey: "source")
                    newIng.setValue(i.isWarning, forKey: "isWarning")
                    ingredients.add(newIng)
                }
            }
            let nutritionFacts = newFood.mutableSetValue(forKey: #keyPath(CD_food.nutritionFacts))
            for n in food.nutritionFacts {
                if let nfEntity = NSEntityDescription.entity(forEntityName: "CD_nutritionFact", in: context.viewContext) {
                    let newNF = NSManagedObject(entity: nfEntity, insertInto: context.viewContext)
                    newNF.setValue(n.id, forKey: "id")
                    newNF.setValue(n.name, forKey: "name")
                    newNF.setValue(n.unit, forKey: "unit")
                    newNF.setValue(n.amount, forKey: "amount")
                    newNF.setValue(n.description, forKey: "nf_description")
                    newNF.setValue(n.source, forKey: "source")
                    newNF.setValue(n.isLimiting, forKey: "isLimiting")
                    nutritionFacts.add(newNF)
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

    func loadFoods() -> [Food] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
        request.returnsObjectsAsFaults = false
        var foods = [Food]()
        do {
            let result = try context.viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                if let id = data.value(forKey: "id") as? UUID,
                    let api_id = data.value(forKey: "api_id") as? String,
                    let upc = data.value(forKey: "upc") as? Int64,
                    let name = data.value(forKey: "name") as? String,
                    let ingredients = decodeIngredients(data.mutableSetValue(forKey: "ingredients") as? NSMutableSet),
                    let nutritionFacts = decodeNutritionFacts(data.mutableSetValue(forKey: "nutritionFacts") as? NSMutableSet)
                {
                    let food = Food(id: id, api_id: api_id, upc: upc, name: name, ingredients: ingredients, nutritionFacts: nutritionFacts)
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
                let isWarning = data.value(forKey: "isWarning") as? Bool
            {
                let comp = data.value(forKey: "composition") as? String
                let desc = data.value(forKey: "description") as? String
                let source = data.value(forKey: "source") as? String
                let ing = Ingredient(id: id, name: name, composition: comp, description: desc, source: source, isWarning: isWarning)
                ingredients.append(ing)
            }
        }
        return ingredients
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
                let isLimiting = data.value(forKey: "isLimiting") as? Bool
            {
                let desc = data.value(forKey: "description") as? String
                let source = data.value(forKey: "source") as? String
                let nf = NutritionFact(id: id, name: name, description: desc, source: source, amount: amount, unit: unit, isLimiting: isLimiting)
                  nutritionFacts.append(nf)
            }
        }
        return nutritionFacts
    }

    func deleteFood(food: Food) -> Bool {
        guard let id = food.id else { return false }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
        request.returnsObjectsAsFaults = false
        do {
          let result = try context.viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                
                if let dataId = data.value(forKey: "id") as? UUID {
            
                    if dataId == id {
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
      if let entity = NSEntityDescription.entity(forEntityName: "CD_nutrientSetting", in: context.viewContext) {
          let newSetting = NSManagedObject(entity: entity, insertInto: context.viewContext)
            newSetting.setValue(setting.id, forKey: "id")
            newSetting.setValue(setting.name, forKey: "name")
            newSetting.setValue(setting.unit, forKey: "unit")
            newSetting.setValue(setting.dailyValue, forKey: "dailyValue")
        }
        do {
            try context.viewContext.save()
            return true
        } catch {
            print("Failed saving setting")
            return false
        }
    }

    func loadSettings() -> [NutrientSetting] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_nutrientSetting")
        request.returnsObjectsAsFaults = false
        var settings = [NutrientSetting]()
        do {
            let result = try context.viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                if let id = data.value(forKey: "id") as? UUID,
                    let name = data.value(forKey: "name") as? String,
                    let unit = data.value(forKey: "unit") as? String,
                    let dailyValue = data.value(forKey: "dailyValue") as? Float {

                    let setting = NutrientSetting(id: id, name: name, unit: unit, dailyValue: dailyValue)
                    settings.append(setting)
                }
            }
        } catch {
            print("Failed to load settings")
        }
        return settings
    }
}
