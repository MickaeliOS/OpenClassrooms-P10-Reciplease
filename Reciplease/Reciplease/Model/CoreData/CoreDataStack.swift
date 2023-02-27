//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Mickaël Horn on 02/02/2023.
//

import Foundation
import CoreData

class CoreDataStack {
    // MARK: - SINGLETON
    static let sharedInstance = CoreDataStack()
    private init() {}
    
    // MARK: - PROPERTIES
    private let persistentContainerName = "Reciplease"
    
    // MARK: - PUBLIC
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }

    // MARK: - PRIVATE
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for: \(storeDescription.description)")
            }
        }
        
        return container
    }()
}
