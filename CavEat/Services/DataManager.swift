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
  
  func saveFood(food: Food) -> Bool {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    if let entity = NSEntityDescription.entity(forEntityName: "CD_food", in: context) {
        let newFood = NSManagedObject(entity: entity, insertInto: context)
        newFood.setValue(food.api_id, forKey: "api_id")
        newFood.setValue(food.name, forKey: "name")
        newFood.setValue(food.upc, forKey: "upc")
        // Loop over ingredients and nutritionFacts and add to array
        // Should refactor these into helpers
        let ingredients = newFood.mutableSetValue(forKey: #keyPath(CD_food.ingredients))
        for i in food.ingredients {
          if let ingEntity = NSEntityDescription.entity(forEntityName: "CD_ingredient", in: context) {
            let newIng = NSManagedObject(entity: ingEntity, insertInto: context)
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
          if let nfEntity = NSEntityDescription.entity(forEntityName: "CD_nutritionFact", in: context) {
            let newNF = NSManagedObject(entity: nfEntity, insertInto: context)
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
        try context.save() return true
    } catch {
        print("Failed to save food")
        return false
    }
  }
  
  func loadFoods() -> [Food] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
    request.returnsObjectsAsFaults = false
    var foods = [Food]()
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        if let api_id = data.value(forKey: "api_id") as? String,
          let upc = data.value(forKey: "upc") as? Int64,
          let name = data.value(forKey: "name") as? String,
          let ingredients = data.value(forKey: "ingredients") as? [Ingredient],
          let nutritionFacts = data.value(forKey: "nutritionFacts") as? [NutritionFact]{
          let food = Food(api_id: api_id, upc: upc, name: name, ingredients: ingredients, nutritionFacts: nutritionFacts)
          foods.append(food)
        }
      }
    } catch {
      print("Failed to load foods")
    }
    return foods
  }
  
  // Delete food, is it gonna be in a tableView? Should I override the tableView function like in contacts? How do I test any of this?

  func saveSetting(setting: NutrientSetting) -> Bool {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    if let entity = NSEntityDescription.entity(forEntityName: "CD_nutrientSetting", in: context) {
        let newSetting = NSManagedObject(entity: entity, insertInto: context)
        newSetting.setValue(setting.name, forKey: "name")
        newSetting.setValue(setting.unit, forKey: "unit")
        newSetting.setValue(setting.dailyValue, forKey: "dailyValue")
    }
    do {
        try context.save() return true
    } catch {
        print("Failed saving setting")
        return false
    }
  }

  func loadSettings() -> [NutrientSetting] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_nutrientSetting")
    request.returnsObjectsAsFaults = false
    var settings = [NutrientSetting]()
    do {
      let result = try context.fetch(request)
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
