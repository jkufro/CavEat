//
//  InMemoryDataManagerHelper.swift
//  CavEatTests
//
//  Created by Justin Kufro on 11/15/19.
//  Copyright © 2019 Justin Kufro. All rights reserved.
//

import Foundation
import CoreData
import XCTest
@testable import CavEat

class InMemoryDataManagerHelper {
    static let shared = InMemoryDataManagerHelper()

    func getInMemoryDataManager() -> DataManager {
        return DataManager(context: mockPersistentContainer())
    }

    func flushData(dataManager: DataManager) {
        let models = ["CD_food", "CD_ingredient", "CD_nutrientSetting", "CD_nutritionFact"]
        for model in models {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: model)
            let objs = try! dataManager.context.viewContext.fetch(fetchRequest) // swiftlint:disable:this force_try
            for case let obj as NSManagedObject in objs {
                dataManager.context.viewContext.delete(obj)
            }
            try! dataManager.context.viewContext.save() // swiftlint:disable:this force_try
        }
    }

    // MARK: - Mock Persistent Container Code
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()

    func mockPersistentContainer() -> NSPersistentContainer {
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
