//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Mickaël Horn on 24/02/2023.
//

import Foundation
import CoreData

class TestCoreDataStack: NSObject {
    // MARK: - PROPERTIES
    let persistentContainerName: String = "Reciplease"
    var viewContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null") // We're not writing to disk, but in memory
        
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
