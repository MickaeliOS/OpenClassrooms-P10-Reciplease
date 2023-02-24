//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Mickaël Horn on 24/02/2023.
//

import Foundation
import CoreData

class TestCoreDataStack: NSObject {
    var viewContext: NSManagedObjectContext {
        return TestCoreDataStack().persistentContainer.viewContext
    }
    
    private let persistentContainerName = "Reciplease"

    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        
        let container = NSPersistentContainer(name: persistentContainerName)
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
