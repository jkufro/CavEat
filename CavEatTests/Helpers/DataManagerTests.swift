//
//  DataManager.swift
//  CavEatTests
//
//  Created by Darien Weems on 11/14/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import CoreData
import XCTest
@testable import CavEat

class DataManagerTests: XCTestCase {
  lazy var dataHelper = DataManager(context: mockPersistantContainer())
  
  // Ingredients
  var milk = Ingredient(id: "1", name: "Milk", composition: nil, description: "From a cow.", source: nil, isWarning: false)
  var cocoa = Ingredient(id: "2", name: "Cocoa", composition: nil, description: "From a cocoa bean.", source: nil, isWarning: false)
  
  // Nutrition Facts
  var dietaryFiberNF: NutritionFact = NutritionFact(id: "2", name: "Dietary Fiber", description: "dietary fiber desc", source: "https://medlineplus.gov/dietaryfiber.html", amount: 25, unit: "g", isLimiting: false)
  var energy: NutritionFact = NutritionFact(id: "3", name: "Energy", description: nil, source: nil, amount: 200, unit: "kcal", isLimiting: false)
  
  // Nutrient Settings
  var addedSugars: NutrientSetting = NutrientSetting(id: UUID(uuidString: "093A8D5E-AB17-4D51-9E4B-EB14A87ADBB8")!, name: "Added Sugars", unit: "g", dailyValue: 32)
  var dietaryFiberNS: NutrientSetting = NutrientSetting(id: UUID(uuidString: "C97F7160-4F88-452D-B834-94BDB6332480")!, name: "Dietary Fiber", unit: "g", dailyValue: 25)
  // Foods
  lazy var candy = Food(api_id: "1", upc: Int64(1), name: "Snickers", ingredients: [cocoa], nutritionFacts: [energy, dietaryFiberNF])
  lazy var chocMilk = Food(api_id: "2", upc: Int64(2), name: "TruMoo", ingredients: [cocoa, milk], nutritionFacts: [energy, dietaryFiberNF])
  
  // MARK: - Actual Tests
  func test_saveFood() {
    XCTAssertTrue(dataHelper.saveFood(food: candy))
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
    request.returnsObjectsAsFaults = false
    let result = try! dataHelper.context.viewContext.fetch(request)
    XCTAssertEqual(1, result.count)
    let data = result[0] as! NSManagedObject
    XCTAssertEqual(data.value(forKey: "name") as? String, "Snickers")
  }
  
  func test_loadFoods() {
    dataHelper.saveFood(food: candy)
    dataHelper.saveFood(food: chocMilk)
    // This snippet is essentially the same as what's in DataManager.loadFoods and it passes
//    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
//    request.returnsObjectsAsFaults = false
//    let result = try! dataHelper.context.viewContext.fetch(request)
//    XCTAssertEqual(2, result.count)
    
    let foods = dataHelper.loadFoods()
    XCTAssertEqual(2, foods.count)
    XCTAssertEqual(foods[0].name, "Snickers")
    XCTAssertEqual(foods[1].name, "TruMoo")
  }
  
  func test_deleteFood() {
    dataHelper.saveFood(food: candy)
    dataHelper.saveFood(food: chocMilk)
    let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
    request1.returnsObjectsAsFaults = false
    let result1 = try! dataHelper.context.viewContext.fetch(request1)
    XCTAssertEqual(2, result1.count)
    
    XCTAssertTrue(dataHelper.deleteFood(food: candy))
    let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_food")
    request2.returnsObjectsAsFaults = false
    let result2 = try! dataHelper.context.viewContext.fetch(request2)
    XCTAssertEqual(1, result2.count)
    let data = result2[0] as! NSManagedObject
    XCTAssertEqual(data.value(forKey: "name") as? String, "Snickers")
  }
  
  func test_saveSettings() {
    XCTAssertTrue(dataHelper.saveSetting(setting: addedSugars))
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_nutrientSetting")
    request.returnsObjectsAsFaults = false
    let result = try! dataHelper.context.viewContext.fetch(request)
    XCTAssertEqual(1, result.count)
    let data = result[0] as! NSManagedObject
    XCTAssertEqual(data.value(forKey: "name") as? String, "Added Sugars")
    XCTAssertEqual(data.value(forKey: "dailyValue") as? Float, 32)
  }
  
  func test_loadSettings() {
    dataHelper.saveSetting(setting: addedSugars)
    dataHelper.saveSetting(setting: dietaryFiberNS)
    // This snippet is essentially the same as what's in DataManager.loadSettings and it passes
//    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_nutrientSetting")
//    request.returnsObjectsAsFaults = false
//    let result = try! dataHelper.context.viewContext.fetch(request)
//    XCTAssertEqual(2, result.count)
    
    let settings = dataHelper.loadSettings()
    XCTAssertEqual(2, settings.count)
    XCTAssertEqual(settings[0].name, "Added Sugars")
    XCTAssertEqual(settings[1].name, "Dietary Fiber")
  }
  
  // MARK: - Data Setup and Teardown
  
  override func setUp() {
    super.setUp()
    dataHelper = DataManager(context: mockPersistantContainer())
  }
  
  override func tearDown() {
    flushData()
    super.tearDown()
  }
  
  func flushData() {
      let models = ["CD_food", "CD_ingredient", "CD_nutrientSetting", "CD_nutritionFact"]
      for model in models {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: model)
        let objs = try! mockPersistantContainer().viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
          mockPersistantContainer().viewContext.delete(obj)
        }
        try! mockPersistantContainer().viewContext.save()
      }
  }

  // MARK: - Mock Persistant Container Code
  
  lazy var managedObjectModel: NSManagedObjectModel = {
      let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
      return managedObjectModel
  }()
  
  func mockPersistantContainer() -> NSPersistentContainer {
      let container = NSPersistentContainer(name: "PersistentDataManager", managedObjectModel: self.managedObjectModel)
      let description = NSPersistentStoreDescription()
      description.type = NSInMemoryStoreType
      description.shouldAddStoreAsynchronously = false // Make it simpler in test env
      
      container.persistentStoreDescriptions = [description]
      container.loadPersistentStores { (description, error) in
          // Check if the data store is in memory
          precondition( description.type == NSInMemoryStoreType )
                                      
          // Check if creating container wrong
          if let error = error {
              fatalError("Create an in-mem coordinator failed \(error)")
          }
      }
      return container
  }
  
}
